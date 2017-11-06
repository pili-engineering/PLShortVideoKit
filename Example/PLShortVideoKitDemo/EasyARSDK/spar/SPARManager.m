//
//  SPARManager.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
// 

#import "SPARManager.h"
#import "SPARApp.h"
#import "Auth.h"
#import "JSONLoader.h"
#import "SPARAppCache.h"
#import "SPARPreloadCache.h"
#import "SPARUtil.h"
#import "SPARTarget.h"
#import "Downloader.h"

@interface SPARManager()
@property (nonatomic, strong) NSString *serverAddr;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, strong) SPARAppCache *cache;
@property (nonatomic, strong) SPARPreloadCache *preloadCache;
@end

@implementation SPARManager

static NSString *kStatusCode = @"statusCode";
static NSString *kResult = @"result";
static NSString *kMessage = @"message";
static NSString *kInfo = @"info";
static NSString *kTimestamp = @"timestamp";
static NSString *kScene = @"scene";
static NSString *kPackage = @"package";

static NSString *kApps = @"apps";
static NSString *kARID = @"arid";
static NSString *kPackageURL = @"packageURL";
static NSString *kTargetType = @"targetType";
static NSString *kTargetDesc = @"targetDesc";

static NSString *kPackagePath = @"/mobile/info/";
static NSString *kPreloadPath = @"/mobile/preload/";


/**
 初始化创建用单例对象
 */
+ (instancetype)sharedManager {
    static SPARManager *inst = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [SPARManager new];
    });
    return inst;
}


/**
 初始化对象，并给缓存属性初始化
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [SPARAppCache new];
        self.preloadCache = [SPARPreloadCache new];
    }
    return self;
}


/**
 设置服务器地址

 @param addr - 服务器地址字符串
 */
- (void)setServerAddress:(NSString *)addr {
    self.serverAddr = addr;
}


/**
 设置服务器的 accessToken 和 秘钥

 @param key - accessToken
 @param secret - 秘钥
 */
- (void)setServerAccessTokens:(NSString *)key secret:(NSString *)secret {
    self.appKey = key;
    self.appSecret = secret;
}


/**
 根据URL返回文件的路径
 */
- (NSString *)getLocalPathForURL:(NSString *)url {
    return [self.cache getLocalPathForURL:url];
}


/**
 清除缓存
 */
- (void)clearCache {
    [self.cache clearCache];
    [self.preloadCache clearCache];
    [SPARUtil deleteQuietly:[Downloader getDownloadPath:[Downloader packagesPath]]];
    [SPARUtil deleteQuietly:[Downloader getDownloadPath:[Downloader targetsPath]]];
}



/**
 使用arid方式加载资源

 @param arid - ARID
 @param completionHandler - 完成后通过SPARApp对象得到manifestURL，然后进行loadManifest操作
 @param progressHandler - 能拿到下载进度，设置UI的进度
 */
- (void)loadApp:(NSString *)arid
completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self loadApp:arid force:NO completionHandler:completionHandler progressHandler:progressHandler];
}



/**
 使用arid方式加载资源

 @param arid - ARID
 @param force - 是否强制加载
 @param completionHandler - 完成后通过SPARApp对象得到manifestURL，然后进行loadManifest操作
 @param progressHandler - 能拿到下载进度，设置UI的进度
 */
- (void)loadApp:(NSString *)arid force:(bool)force
          completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self loadApp:arid key:self.appKey secret:self.appSecret force:force
            completionHandler:completionHandler progressHandler:progressHandler];
}



/**
 通过ARID的方式,从缓存中加载资源，将缓存中拿到的SPARApp对象作为block的传入参数

 @param arid - arid
 @param force - 是否强制加载，一般为No，如果为Yes则返回，No加载不成功!
 @param completionHandler - 完成后通过SPARApp对象得到manifestURL，然后进行loadManifest操作
 @return Yes:从缓存中加载成功！; No:从缓存中加载失败！
 */
- (bool)tryFromCache:(NSString *)arid force:(bool)force
      completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler {
    SPARApp *app = [self.cache getAppByARID:arid];
    if (app && !force) {
        completionHandler(app, nil);
        return YES;
    }
    return NO;
}


/**
 使用arid方式加载资源，将`SPARApp`对象作为block的传入参数
 
 @param arid - arid
 @param key - APPKey
 @param secret - 秘钥
 @param force - 是否强制加载
 @param completionHandler - 完成后通过SPARApp对象得到manifestURL，然后进行loadManifest操作
 @param progressHandler - 可以得到taskName和下载进度和解压进度,设置UI的进度
 */
- (void)loadApp:(NSString *)arid key:(NSString *)key secret:(NSString *)secret force:(bool)force
          completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {

    NSDictionary *params = [Auth signParam:[NSDictionary new] withKey:key andSecret:secret];
    NSString *endPoint = [self.serverAddr stringByAppendingFormat:@"%@%@", kPackagePath, arid];
    NSString *urlStr = [SPARUtil addQueryParam:params toURL:endPoint];
    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err) {
        if (err) {
            if (![self tryFromCache:arid force:force completionHandler:completionHandler]) {
                completionHandler(nil, err);
            }
            return;
        }
        NSInteger statusCode = [jso[kStatusCode] integerValue];
        if (statusCode != 0) {
            NSString *msg = jso[kResult][kMessage];
            if (!msg) msg = @"non zero status code";
            completionHandler(nil, [NSError errorWithDomain:msg code:statusCode userInfo:nil]);
            return;
        }
        NSDictionary *info = jso[kResult][kInfo];
        NSInteger timestamp = [info[kTimestamp] integerValue];
        NSString *pkgURL = info[kScene][kPackage];
        if (timestamp <= [self.cache getAppLastUpdateTime:arid] && !force) {
            completionHandler([self.cache getAppByARID:arid], nil);
            return;
        }
        SPARApp *app = [[SPARApp alloc] initWithARID:arid URL:pkgURL timestamp:timestamp];
        [app deployPackage:YES completionHandler:^(NSError *error) {
            if (error) {
                completionHandler(nil, error);
            } else {
                [self.cache updateApp:app];
                completionHandler(app, nil);
            }
        } progressHandler:progressHandler];
    } progressHandler:progressHandler];
}


/**
 preload方式加载数据
 
 @prarm preloadID - 预加载ID
 @param completionHandler - 可以拿到SPARApp对象数组，完成后对apps进行遍历，通过targets.desc找到和扫描图对应的targets.desc，找到后进行loadManifest操作
 @param progressHandler - 可以拿到taskName和下载进度，设置UI的进度
 */
- (void)preloadApps:(NSString *)preloadID
  completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self preloadApps:preloadID force:NO completionHandler:completionHandler progressHandler:progressHandler];
}


/**
 preload方式加载数据
 
 @param preloadID - 预加载ID
 @param force - 是否强制加载
 @param completionHandler - 可以拿到SPARApp对象数组，下载完成后对apps进行遍历，通过targets.desc找到和扫描图对应的targets.desc，找到后去loadManifest
 @param progressHandler - 可以拿到taskName和下载进度，设置UI的进度
 */
- (void)preloadApps:(NSString *)preloadID force:(bool)force
 completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
   progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self preloadApps:preloadID key:self.appKey secret:self.appSecret force:force
   completionHandler:completionHandler progressHandler:progressHandler];
}




/**
 preload加载资源，jso字典中的信息转换成模型数组

 @param jso - json字典
 @param force - 是否强制加载
 @param completionHandler - 可以拿到SPARApp对象数组，下载完成后对apps进行遍历，通过对象的targets.desc找到和扫描图对应的targets.desc，找到后去loadManifest
 @param progressHandler - 可以拿到下载的taskName和下载进度，设置UI的进度
 */
- (void)preloadAppsFromJSON:(NSDictionary *)jso force:(bool)force
          completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
//    NSLog(@"--jso--%@",jso);
    NSArray *jsa = jso[kResult][kApps];
    NSArray *apps = [self appsFromJSONArray:jsa];
    [self preloadAppsInList:apps force:force completionHandler:completionHandler progressHandler:progressHandler];
}



/**
 通过preloadID的方式,从缓存中加载资源
 
 @param preloadID - preloadID
 @param force - 是否强制加载，一般为No，如果为Yes则返回 No加载不成功!
 @param completionHandler - 可以拿到SPARApp对象数组，下载完成后对apps进行遍历，通过对象的targets.desc找到和扫描图对应的targets.desc，找到后去loadManifest
 @param progressHandler - 可以拿到下载的taskName和下载进度，设置UI的进度
 @return Yes:从缓存中加载成功！; No:从缓存中加载失败！
 */
- (bool)tryPreloadFromCache:(NSString *)preloadID force:(bool)force
          completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    NSDictionary *preloadJSON = [self.preloadCache getPreloadJSON:preloadID];
    if (preloadJSON && !force) {
        [self preloadAppsFromJSON:preloadJSON force:force
                completionHandler:completionHandler progressHandler:progressHandler];
        return true;
    }
    return false;
}


/**
 preload方式加载数据

 @param preloadID - 预加载ID
 @param key - APPKey
 @param secret - 秘钥
 @param force - 是否强制加载
 @param completionHandler - 通过preloadAppsFromJSON:force:completionHandler:progressHandler方法将SPARApp对象数组作为block的传入参数，下载完成后对apps进行遍历，通过targets.desc找到和扫描图对应的targets.desc，找到后去loadManifest
 @param progressHandler - 可以拿到下载的taskName和下载进度，设置UI的进度
 */
- (void)preloadApps:(NSString *)preloadID key:(NSString *)key secret:(NSString *)secret force:(bool)force
 completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
   progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {

    NSDictionary *params = [Auth signParam:[NSDictionary new] withKey:key andSecret:secret];
    NSString *endPoint = [self.serverAddr stringByAppendingFormat:@"%@%@", kPreloadPath, preloadID];
    NSString *urlStr = [SPARUtil addQueryParam:params toURL:endPoint];

    NSLog(@"-whj@_@---urlStr=%@",urlStr);
    // 向服务器发送请求
    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err) {
        // TODO: DRY
        if (err) {
            if (![self tryPreloadFromCache:preloadID force:force
                         completionHandler:completionHandler progressHandler:progressHandler]) {
                completionHandler(nil, err);
            }
            return;
        }

        NSInteger statusCode = [jso[kStatusCode] integerValue];
        if (statusCode != 0) {
            NSString *msg = jso[kResult][kMessage];
            if (!msg) msg = @"non zero status code";
            completionHandler(nil, [NSError errorWithDomain:msg code:statusCode userInfo:nil]);
            return;
        }
        
        NSLog(@"-whj@_@---jso=%@",jso);
        [self preloadAppsFromJSON:jso force:force completionHandler:^(NSArray *apps, NSError *error) {
            [self.preloadCache updatePreloadJSON:jso withID:preloadID];
            completionHandler(apps, error);
        } progressHandler:progressHandler];
    } progressHandler:progressHandler];
}




/**
 preload加载本地的资源信息,将SPARApp对象数组作为block的传入参数

 @param preloadID - preloadID
 @param force - 是否强制加载
 @param completionHandler - 可以拿到SPARApp对象数组，下载完成后对apps进行遍历，通过对象的targets.desc找到和扫描图对应的targets.desc，找到后去loadManifest
 @param progressHandler - 可以拿到下载的taskName和下载进度，设置UI的进度
 */
- (void)preloadLocalApps:(NSString *)preloadID force:(bool)force
  completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    
    
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"kfc" ofType:@"json"];
    NSString *txtContent = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
    NSData* data = [txtContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *jso = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (err) {
        if (![self tryPreloadFromCache:preloadID force:force
                     completionHandler:completionHandler progressHandler:progressHandler]) {
            completionHandler(nil, err);
        }
        return;
    }
    NSInteger statusCode = [jso[kStatusCode] integerValue];
    if (statusCode != 0) {
        NSString *msg = jso[kResult][kMessage];
        if (!msg) msg = @"non zero status code";
        completionHandler(nil, [NSError errorWithDomain:msg code:statusCode userInfo:nil]);
        return;
    }
    [self preloadAppsFromJSON:jso force:force completionHandler:^(NSArray *apps, NSError *error) {
        [self.preloadCache updatePreloadJSON:jso withID:preloadID];
        completionHandler(apps, error);
    } progressHandler:progressHandler];
    
    

}


/**
 将字典数组转换成模型数组
 
 @param jsa - 字典数组
 */
- (NSArray *)appsFromJSONArray:(NSArray *)jsa {
    NSMutableArray *res = [NSMutableArray new];
    for (NSDictionary *jso in jsa) {
        NSString *arid = jso[kARID];
        NSString *packageURL = jso[kScene][kPackage];
        NSInteger timestamp = [jso[kTimestamp] integerValue];
        NSString *targetType = jso[kTargetType];
        NSDictionary *targetDesc = jso[kTargetDesc];
        SPARApp *app = [[SPARApp alloc] initWithARID:arid URL:packageURL timestamp:timestamp];
        if (targetType && targetDesc) {
            SPARTarget *target = [[SPARTarget alloc] initWithType:targetType andDesc:targetDesc];
            app.target = target;
        }
        [res addObject:app];
    }
    return res;
}



/**
 遍历模型列表准备下载相应的资源，在下载完成后将模型数组作为block的传入参数

 @param apps - 模型数组
 @param force - 是否强制加载
 @param completionHandler - 可以拿到SPARApp对象数组，下载完成后对apps进行遍历，通过对象的targets.desc找到和扫描图对应的targets.desc，找到后去loadManifest
 @param progressHandler - 可以拿到下载的taskName和下载进度，设置UI的进度
 */
- (void)preloadAppsInList:(NSArray *)apps force:(bool)force
  completionHandler:(void (^)(NSArray *, NSError *))completionHandler
    progressHandler:(void (^)(NSString *, float))progressHandler {

    if (!apps || apps.count == 0) {
        completionHandler(nil, [NSError errorWithDomain:@"empty app list" code:-1 userInfo:nil]);
        return;
    }
    __block NSUInteger finished = 0;
    for (SPARApp *app in apps) {
        [self.cache updateApp:app];
        [app prepareTarget:force completionHandler:^(NSError *error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }
            finished++;
            if (finished == apps.count) {
                completionHandler(apps, nil);
            }
            //progressHandler(@"preload", finished / (float)apps.count);
        } progressHandler:progressHandler]; // TODO: allow nil handlers
    }
}



/**
 从缓存中获取 SPARApp 对象

 @param targetDesc - targetDesc目标描述
 @return `SPARApp`对象
 */
- (SPARApp *)getAppByTargetDesc:(NSString *)targetDesc {
    return [self.cache getAppByTargetDesc:targetDesc];
}

@end
