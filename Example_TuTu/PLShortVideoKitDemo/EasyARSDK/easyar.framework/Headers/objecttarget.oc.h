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

@interface easyar_ObjectTarget : easyar_Target

+ (easyar_ObjectTarget *) create;
- (bool)setup:(NSString *)path storageType:(int)storageType name:(NSString *)name;
+ (NSArray<easyar_ObjectTarget *> *)setupAll:(NSString *)path storageType:(int)storageType;
- (float)scale;
- (NSArray<easyar_Vec3F *> *)boundingBox;
- (NSArray<easyar_Vec3F *> *)boundingBoxGL;
- (bool)setScale:(float)scale;
- (int)runtimeID;
- (NSString *)uid;
- (NSString *)name;
- (NSString *)meta;
- (void)setMeta:(NSString *)data;

@end
