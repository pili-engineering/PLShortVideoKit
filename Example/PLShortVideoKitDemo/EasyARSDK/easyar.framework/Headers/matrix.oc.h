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
@interface easyar_Matrix34F : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end

/// <summary>
/// record
/// </summary>
@interface easyar_Matrix44F : NSObject

@property (nonatomic) NSArray<NSNumber *> * data;

+ (instancetype)create:(NSArray<NSNumber *> *)data;

@end
