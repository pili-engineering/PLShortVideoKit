//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Target : easyar_RefBase

- (int)runtimeID;
- (NSString *)uid;
- (NSString *)name;
- (NSString *)meta;
- (void)setMeta:(NSString *)data;

@end

@interface easyar_TargetInstance : easyar_RefBase

+ (easyar_TargetInstance *) create;
- (easyar_TargetStatus)status;
- (easyar_Target *)target;
- (easyar_Matrix34F *)pose;
- (easyar_Matrix44F *)poseGL;

@end
