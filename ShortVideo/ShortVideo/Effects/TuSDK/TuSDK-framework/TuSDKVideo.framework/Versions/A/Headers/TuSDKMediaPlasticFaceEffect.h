//
//  TuSDKMediaPlasticFaceEffect.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/10.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"

NS_ASSUME_NONNULL_BEGIN

/**
 微整形特效
 @sicne v3.2.0
 */
@interface TuSDKMediaPlasticFaceEffect : TuSDKMediaEffectCore

/**
 根据触发时间区间初始化微整形特效

 @param timeRange 触发时间区间
 @return 微整形特效实例对象
 @since v3.2.0
 */
- (instancetype)initWithTimeRange:(TuSDKTimeRange * _Nullable)timeRange;

/**
 大眼
 @since v3.2.0
 */
@property(readwrite,nonatomic)CGFloat eyeSize;

/**
 瘦脸
 @since v3.2.0
 */
@property(readwrite,nonatomic)CGFloat chinSize;

/**
 瘦鼻
 @since v3.2.0
 */
@property(readwrite,nonatomic)float noseSize;

/**
 嘴宽
 @since v3.2.0
 */
@property(readwrite,nonatomic)float mouthWidth;

/**
 细眉
 @since v3.2.0
 */
@property(readwrite,nonatomic)float archEyebrow;

/**
 眼距
 @since v3.2.0
 */
@property(readwrite,nonatomic)float eyeDis;

/**
 眼角
 @since v3.2.0
 */
@property(readwrite,nonatomic)float eyeAngle;

/**
 下巴
 @since v3.2.0
 */
@property(readwrite,nonatomic)float jawSize;

@end

NS_ASSUME_NONNULL_END
