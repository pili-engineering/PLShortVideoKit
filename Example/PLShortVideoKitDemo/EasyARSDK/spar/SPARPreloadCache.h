//
//  SPARPreloadCache.h
//  EasyAR3D
//
//  Created by Qinsi on 10/24/16.
//
//  Preload方式的缓存类

#import <Foundation/Foundation.h>

@interface SPARPreloadCache : NSObject

- (NSDictionary *)getPreloadJSON:(NSString *)preloadID;
- (void)updatePreloadJSON:(NSDictionary *)preloadJSON withID:(NSString *)preloadID;
- (void)clearCache;

@end
