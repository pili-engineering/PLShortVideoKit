/**
 * Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
 * EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
 * and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
 */

#import <Foundation/Foundation.h>

@interface SPARPackage : NSObject

- (NSString *)getPackageURL;
- (NSString *)getManifestURL;

@end


@interface SPARPackage()

- (instancetype)initWithURL:(NSString *)url;
- (void)deploy:(bool) force completionHandler:(void (^)(NSError *error)) completeHandler
progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler;
- (NSString *)getLocalPathForURL:(NSString *)url;
- (void)destroy;

+ (SPARPackage *)SPARPackageFromDict:(NSDictionary *)dict;
- (NSDictionary *)toDict;

@end
