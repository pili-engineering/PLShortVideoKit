//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

/// <summary>
/// record
/// </summary>
@interface easyar_Vec4F : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end

/// <summary>
/// record
/// </summary>
@interface easyar_Vec3F : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end

/// <summary>
/// record
/// </summary>
@interface easyar_Vec2F : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end

/// <summary>
/// record
/// </summary>
@interface easyar_Vec4I : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end

/// <summary>
/// record
/// </summary>
@interface easyar_Vec2I : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end
