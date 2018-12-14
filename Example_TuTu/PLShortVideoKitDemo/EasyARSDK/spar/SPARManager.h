/**
 * Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
 * EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
 * and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
 */

//  管理SPARApp的类


#import <Foundation/Foundation.h>

@class SPARApp;

@interface SPARManager : NSObject

+ (instancetype)sharedManager;

- (void)setServerAddress:(NSString *)addr;
- (void)setServerAccessTokens:(NSString *)key secret:(NSString *)secret;
- (void)loadApp:(NSString *)arid
completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;
- (void)loadApp:(NSString *)arid force:(bool)force
completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;
- (void)preloadApps:(NSString *)preloadID
  completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;
- (void)preloadApps:(NSString *)preloadID force:(bool)force
  completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;
- (void)clearCache;
- (SPARApp *)getAppByTargetDesc:(NSString *)targetDesc;
- (NSString *)getLocalPathForURL:(NSString *)url;

@end


@interface SPARManager ()

- (void)loadApp:(NSString *)arid key:(NSString *)key secret:(NSString *)secret force:(bool)force
completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;
- (void)preloadApps:(NSString *)preloadID key:(NSString *)key secret:(NSString *)secret force:(bool)force
  completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;

- (void)preloadLocalApps:(NSString *)preloadID force:(bool)force
       completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
         progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;

@end
