//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/drawable.oc.h"

@interface easyar_Frame : easyar_Drawable

+ (easyar_Frame *) create;
- (easyar_Vec2I *)size;
- (double)timestamp;
- (int)index;
- (NSArray<easyar_Image *> *)images;
- (NSArray<easyar_TargetInstance *> *)targetInstances;
- (NSString *)text;

@end
