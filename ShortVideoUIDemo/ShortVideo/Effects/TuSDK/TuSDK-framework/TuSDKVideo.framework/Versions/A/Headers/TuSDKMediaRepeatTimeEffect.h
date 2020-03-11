//
//  TuSDKMediaRepeatTimeEffect.h
//  TuSDKVideo
//
//  Created by sprint on 27/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaTimeEffect.h"

/**
 反复特效
 
 @since v3.0
 */
@interface TuSDKMediaRepeatTimeEffect : NSObject <TuSDKMediaTimeEffect>

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
 反复次数 > 0  默认 : 1
 
 @since v3.0
 */
@property (nonatomic) NSUInteger repeatCount;


@end
