//
//  SPARApp.m
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import "SPARApp.h"
#import "SPARTarget.h"
#import "SPARPackage.h"
#import "Downloader.h"
#import "SPARUtil.h"

@implementation SPARApp

static NSString *kKeyARID = @"arid";
static NSString *kKeyPackageURL = @"packageURL";
static NSString *kKeyTimestamp = @"timestamp";
static NSString *kKeyImages = @"images";
static NSString *kKeySize = @"size";
static NSString *kKeyTarget = @"target";


/**
 字典转模型，实例化对象
 */
+ (SPARApp *)SPARAppFromDict:(NSDictionary *)dict {
    NSString *arid = dict[kKeyARID];
    NSString *url = dict[kKeyPackageURL];
    NSInteger timestamp = [dict[kKeyTimestamp] integerValue];
    SPARApp *res = [[SPARApp alloc] initWithARID:arid URL:url timestamp:timestamp];
    NSDictionary *targetDict = dict[kKeyTarget];
    if (targetDict) {
        res.target = [SPARTarget SPARTargetFromDict:targetDict];
    }
    return res;
}

/**
 模型转字典，通过对象返回一个对象的模型字典
 */
- (NSDictionary *)toDict {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:@{
             kKeyARID: self.ARID,
             kKeyPackageURL: self.package.getPackageURL,
             kKeyTimestamp: [NSNumber numberWithInteger:self.timestamp],
             }];
    if (self.target) {
        res[kKeyTarget] = [self.target toDict];
    }
    return res;
}

/**
 构造函数
 */
- (instancetype)initWithARID:(NSString *)arid URL:(NSString *)url timestamp:(NSInteger) timestamp {
    self = [super init];
    if (self) {
        self.ARID = arid;
        self.package = [[SPARPackage alloc] initWithURL:url];
        self.timestamp = timestamp;
    }
    return self;
}


/**
 SPARApp对象属性`Target`不为空且`Target`中的url也不能为空

 @return Yes:有目标；No：没有目标
 */
- (bool)hasTarget {
    return self.target != nil && self.target.url != nil;
}


/**
 返回target的url

 @return target.url
 */
- (NSString *)getTargetURL {
    if (![self hasTarget]) return nil;
    return self.target.url;
}


/**
 将字典 @{@"iamges":target.desc} 以字符串格式返回
 */
- (NSString *)getTargetDesc {
    if (![self hasTarget]) return nil;
    NSDictionary *desc = @{
                           kKeyImages: [NSArray arrayWithObjects:self.target.desc, nil],
                           };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:desc options:kNilOptions error:&error];
    if (!jsonData) return @"{}";
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 返回Support目录下 targets/targets.url 的全路径
 */
- (NSString *)getLocalPathForTargetURL {
    if (![self hasTarget]) return nil;
    NSString *downloadPath = [Downloader getDownloadPath:[Downloader targetsPath]];
    NSString *downloadFileName = [Downloader getLocalNameForURL:self.target.url];
    return [downloadPath stringByAppendingPathComponent:downloadFileName];
}



/**
 返回url对应的package/packageURL目录下的文件路径

 @param url - url索引
 @return packageURL目录下的文件路径
 */
- (NSString *)getLocalPathForPackageFileURL:(NSString *)url {
    return [self.package getLocalPathForURL:url];
}



/**
 准备下载target.url资源,将文件放到Support目录下`targets/targets.url`的目录下
 
 @param force - Yes:不用判断文件是否存在，准备下载; NO:判断文件是否存在，当不存在再准备下载
 @param completeHandler - 下载过程中或者下载完成会将错误信息作为参数传给block
 @param progressHandler - 可以拿到下载的taskName和下载进度，设置UI的进度
 */
- (void)prepareTarget:(bool)force completionHandler:(void (^)(NSError *error)) completeHandler
      progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler {
    if (![self hasTarget]) {
        completeHandler([NSError errorWithDomain:@"No target" code:-1 userInfo:nil]);
        return;
    }
    NSString *dst = [self getLocalPathForTargetURL];
    if ([SPARUtil pathExists:dst] && !force) {
        completeHandler(nil);
        return;
    }
    [[Downloader new] download:self.target.url to:dst force:force completionHandler:completeHandler progressHandler:progressHandler];
}


#pragma mark -TODO deployPackage
/**
 将通过packageURL下载的文件，放到下载目录下的package/packageURL/zip的路径下，解压的文件放在在Support目录下package/packageURL目录下

 @param force - 是否强制加载
 @param completeHandler - 下载过程出错或者在解压完成时调用，可以拿到出错信息；完成后可以进行loadManifest操作
 @param progressHandler - 根据taskName得到下载进度和解压进度
 */
- (void)deployPackage:(bool)force completionHandler:(void (^)(NSError *error)) completeHandler
      progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler {
    [self.package deploy:force completionHandler:completeHandler progressHandler:progressHandler];
}


/**
 返回Support目录下 package/packageURL/manifest.json 并遵守文件协议的全路径
 */
- (NSString *)getManifestURL {
    return [self.package getManifestURL];
}


/**
 删除文件
 */
- (void)destroy {
    if ([self hasTarget]) {
        [SPARUtil deleteQuietly:[self getLocalPathForTargetURL]];
    }
    [self.package destroy];
}

@end
