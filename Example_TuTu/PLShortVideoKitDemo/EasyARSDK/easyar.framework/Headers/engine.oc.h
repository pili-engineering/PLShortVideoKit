//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Engine : NSObject

+ (bool)initialize:(NSString *)key;
+ (void)onPause;
+ (void)onResume;
+ (void)setRotation:(int)rotation;
+ (NSString *)versionString;
+ (NSString *)name;

@end
