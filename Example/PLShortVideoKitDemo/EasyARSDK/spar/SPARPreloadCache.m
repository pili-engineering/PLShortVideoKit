//
//  SPARPreloadCache.m
//  EasyAR3D
//
//  Created by Qinsi on 10/24/16.
//
//

#import "SPARPreloadCache.h"
#import "SPARUtil.h"

@interface SPARPreloadCache()

/**
 存放缓存信息的字典
 */
@property (nonatomic, strong) NSMutableDictionary *preloads;
@end

@implementation SPARPreloadCache

static NSString *kPreloadCacheIndex = @"preload_cache_index";


/**
 返回下载目录下 preload_cache_index 的全路径
 */
+ (NSString *)getCacheIndexPath {
    NSString *supportDir = [SPARUtil getSupportDirectory];
    [SPARUtil ensureDirectory:supportDir];
    return [supportDir stringByAppendingPathComponent:kPreloadCacheIndex];
}


/**
 初始化，加载缓存信息
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadCacheInfo];
    }
    return self;
}


/**
 加载缓存信息，并将缓存中的数据添加到 self.preloads 字典中
 */
- (void)loadCacheInfo {
    self.preloads = [NSMutableDictionary new];
    NSDictionary *saveDict = [SPARUtil jsonFromFile:[SPARPreloadCache getCacheIndexPath]];
    if (saveDict) {
        for (NSString *preloadID in saveDict) {
            NSString *preloadInfo = saveDict[preloadID];
            if (preloadID) {
                NSDictionary *preloadJSON = [SPARUtil jsonFromString:preloadInfo];
                if (preloadJSON) {
                    self.preloads[preloadID] = preloadJSON;
                }
            }
        }
    }
}


/**
 将 self.preloads 缓存字典写入到 Preload 的缓存路径中
 */
- (void)saveCacheInfo {
    NSMutableDictionary *saveDict = [NSMutableDictionary new];
    for (NSString *preloadID in self.preloads) {
        NSDictionary *preloadJSON = self.preloads[preloadID];
        saveDict[preloadID] = [SPARUtil stringFromJson:preloadJSON];
    }
    [SPARUtil writeToFile:[SPARPreloadCache getCacheIndexPath] fromJson:saveDict];
}


/**
 通过 preloadID 返回对应的数据字典
 
 @param preloadID - 预加载ID
 */
- (NSDictionary *)getPreloadJSON:(NSString *)preloadID {
    return self.preloads[preloadID];
}


/**
 更新Preload缓存
 
 @param preloadJSON - 更新的数据
 @param preloadID - 预加载ID
 */
- (void)updatePreloadJSON:(NSDictionary *)preloadJSON withID:(NSString *)preloadID {
    self.preloads[preloadID] = preloadJSON;
    [self saveCacheInfo];
}


/**
 清除缓存
 */
- (void)clearCache {
    [self.preloads removeAllObjects];
    [self saveCacheInfo];
    [SPARUtil deleteQuietly:[SPARPreloadCache getCacheIndexPath]];
}

@end
