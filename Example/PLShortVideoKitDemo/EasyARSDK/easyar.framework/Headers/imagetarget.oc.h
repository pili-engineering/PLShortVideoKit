//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/target.oc.h"

@interface easyar_ImageTarget : easyar_Target

+ (easyar_ImageTarget *) create;
- (bool)setup:(NSString *)path storageType:(int)storageType name:(NSString *)name;
+ (NSArray<easyar_ImageTarget *> *)setupAll:(NSString *)path storageType:(int)storageType;
- (easyar_Vec2F *)size;
- (bool)setSize:(easyar_Vec2F *)size;
- (NSArray<easyar_Image *> *)images;
- (int)runtimeID;
- (NSString *)uid;
- (NSString *)name;
- (NSString *)meta;
- (void)setMeta:(NSString *)data;

@end
