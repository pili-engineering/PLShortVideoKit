//
//  TuSDKMediaPacketEffect.h
//  TuSDKVideo
//
//  Created by sprint on 18/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffect.h"
#import "TuSDKMediaTimeEffect.h"

/**
 套餐特效，多个特效组合
 
 @since v3.0.1
 */
@protocol TuSDKMediaPacketEffect <NSObject>

@required
/**
 画面特效集合
 
 @return 特效集合
 @since v3.0.1
 */
- (NSArray<id<TuSDKMediaEffect>> *)pictureEffects;

/**
 时间特效
 
 @return 时间特效
 @since v3.0.1
 */
- (id<TuSDKMediaTimeEffect>)timeEffect;

/**
 准备特效

 @param outputDuration 视频总总时长
 @since v3.0.1
 */
- (void)prepareWithOutputDuration:(CMTime)outputDuration;

@end
