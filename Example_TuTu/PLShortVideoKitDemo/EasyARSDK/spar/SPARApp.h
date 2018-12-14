/**
 * Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
 * EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
 * and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
 */

#import <Foundation/Foundation.h>

@class SPARPackage;

@interface SPARApp : NSObject
@property (nonatomic, strong) SPARPackage *package;

- (NSString *)getTargetURL;
- (NSString *)getTargetDesc;
- (void)deployPackage:(bool)force completionHandler:(void (^)(NSError *error)) completeHandler
      progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler;

@end


@class SPARTarget;

@interface SPARApp ()
@property (nonatomic, strong) NSString *ARID;
// 时间戳
@property (nonatomic) NSInteger timestamp;
@property (nonatomic, strong) SPARTarget *target;

- (instancetype)initWithARID:(NSString *)arid URL:(NSString *)url timestamp:(NSInteger) timestamp;
- (bool)hasTarget;
- (NSString *)getLocalPathForTargetURL;
- (NSString *)getLocalPathForPackageFileURL:(NSString *)url;
- (void)prepareTarget:(bool)force completionHandler:(void (^)(NSError *error)) completeHandler
      progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler;

+ (SPARApp *)SPARAppFromDict:(NSDictionary *)dict;
- (NSDictionary *)toDict;

@end
