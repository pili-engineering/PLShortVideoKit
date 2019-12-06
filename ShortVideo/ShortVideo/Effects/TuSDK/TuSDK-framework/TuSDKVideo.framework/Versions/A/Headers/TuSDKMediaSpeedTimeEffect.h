//
//  TuSDKMediaSpeedTimeEffect.h
//  TuSDKVideo
//
//  Created by sprint on 27/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaTimeEffect.h"

/**
 快慢速时间特效
 
 @since v3.0
 */
@interface TuSDKMediaSpeedTimeEffect : NSObject <TuSDKMediaTimeEffect>


/**
 根据开始时间和结束时间初始化时间范围。
 
 @param start 开始时间
 @param end 结束时间
 @return TuSDKMediaRepeatTimeEffect
 @since      v3.0
 */
- (instancetype)initWithStart:(CMTime)start end:(CMTime)end;

/**
 根据开始时间和结束时间初始化时间范围。
 
 @param timeRange 时间区间
 @return TuSDKMediaRepeatTimeEffect
 @since      v3.0.1
 */
- (instancetype)initWithTimeRange:(CMTimeRange)timeRange;

/**
 速率调整 取值范围：> 0 && <=4. 默认：1 ( > 1 快速播放  < 1 慢速播放)
 @since  v3.0
 */
@property (nonatomic) CGFloat speedRate;

@end
