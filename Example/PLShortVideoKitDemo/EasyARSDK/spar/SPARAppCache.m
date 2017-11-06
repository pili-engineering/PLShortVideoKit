//
//  SPARAppCache.m
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import "SPARAppCache.h"
#import "SPARApp.h"
#import "SPARTarget.h"
#import "SPARUtil.h"
#import "Downloader.h"

@interface SPARAppCache()
// ARID的缓存字典
@property (nonatomic, strong) NSMutableDictionary *appsByARID;
// UID的缓存字典
@property (nonatomic, strong) NSMutableDictionary *appsByTargetUID;
@end

@implementation SPARAppCache

static NSString *kCacheIndex = @"cache_index";
static NSString *kPackageURL = @"packageURL";
static NSString *kTimestamp = @"timestamp";


/**
 返回 support 路径下的缓存路径
 */
+ (NSString *)getCacheIndexPath {
    NSString *supportDir = [SPARUtil getSupportDirectory];
    [SPARUtil ensureDirectory:supportDir];
    return [supportDir stringByAppendingPathComponent:kCacheIndex];
}


/**
 初始化缓存对象
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadCacheInfo];
    }
    return self;
}



/**
 更新 appsByTargetUID 缓存字典里的数据

 @param app - `SPARApp`对象
 */
- (void)updateAppTargetIndex:(SPARApp *)app {
    SPARTarget *target = app.target;
    if (target) {
        self.appsByTargetUID[target.uid] = app;
    }
}


/**
 将缓存中的二进制数据分别赋值给 ARID和UID 的缓存字典
 */
- (void)loadCacheInfo {
    self.appsByARID = [NSMutableDictionary new];
    NSData *jsonData = [NSData dataWithContentsOfFile:[SPARAppCache getCacheIndexPath]];
    if (jsonData) {
        NSError *error;
        NSDictionary *saveDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        if (saveDict) {
            for (NSString *arid in saveDict) {
                self.appsByARID[arid] = [SPARApp SPARAppFromDict:saveDict[arid]];
            }
        }
    }

    self.appsByTargetUID = [NSMutableDictionary new];
    for (NSString *arid in self.appsByARID) {
        SPARApp *app = self.appsByARID[arid];
        [self updateAppTargetIndex:app];
    }
}


/**
 保存缓存信息，将缓存数据写入缓存路径中
 */
- (void)saveCacheInfo {
    NSMutableDictionary *saveDict = [NSMutableDictionary new];
    for (NSString *arid in self.appsByARID) {
        SPARApp *app = self.appsByARID[arid];
        saveDict[arid] = [app toDict];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:saveDict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    [jsonData writeToFile:[SPARAppCache getCacheIndexPath] atomically:YES];
}


#pragma mark -TODO 完善注释

/**
 返回url对应的文件路径：targets/targets.url 或者是 package/packageURL/目录下的文件路径

 @param url - url索引
 @return package/packageURL/目录下的文件路径或者是 targets/targets.url 的全路径
 */
- (NSString *)getLocalPathForURL:(NSString *)url {
    for (NSString *arid in self.appsByARID) {
        SPARApp *app = self.appsByARID[arid];
        SPARTarget *target = app.target;
        if (target && [url isEqualToString:target.url]) return [app getLocalPathForTargetURL];
        NSString *res = [app getLocalPathForPackageFileURL:url];
        if (res) return res;
    }
    return nil;
}



/**
 返回`SPARApp`对象：通过 arid 从缓存字典中获取`SPARApp`对象

 @param arid - arid
 @return `SPARApp`对象
 */
- (SPARApp *)getAppByARID:(NSString *)arid {
    return self.appsByARID[arid];
}


/**
 通过 targetUID 从 appsByTargetUID 中获取 SPARApp 对象
  */
- (SPARApp *)getAppByTargetUID:(NSString *)targetUID {
    return self.appsByTargetUID[targetUID];
}


/**
 通过 targetDesc 获取 SPARApp 对象
 */
- (SPARApp *)getAppByTargetDesc:(NSString *)targetDesc {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[targetDesc dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:kNilOptions
                                                           error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    NSString *targetUID = json[@"images"][0][@"uid"];
    return [self getAppByTargetUID:targetUID];
}


/**
 返回 SPARApp 对象的 时间戳
  */
- (NSInteger)getAppLastUpdateTime:(NSString *)arid {
    SPARApp *app = [self getAppByARID:arid];
    if (!app) return 0;
    return app.timestamp;
}


/**
 更新缓存中的数据
 */
- (void)updateApp:(SPARApp *)app {
    NSString *arid = app.ARID;
    self.appsByARID[arid] = app;
    [self updateAppTargetIndex:app];
    [self saveCacheInfo];
}


/**
 清除缓存
 */
- (void)clearCache {
    [self.appsByARID removeAllObjects];
    [self.appsByTargetUID removeAllObjects];
    [self saveCacheInfo];
    [SPARUtil deleteQuietly:[SPARAppCache getCacheIndexPath]];
}

@end
