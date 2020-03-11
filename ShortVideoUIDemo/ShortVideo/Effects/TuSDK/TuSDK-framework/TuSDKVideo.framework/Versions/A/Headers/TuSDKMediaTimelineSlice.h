//
//  TuSDKMediaTimelineSlice.h
//  TuSDKVideo
//
//  Created by sprint on 26/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaTimeRange.h"

/**
 时间切片信息
 
 @since v3.0
 */
@interface TuSDKMediaTimelineSlice : NSObject <NSCopying>

/**
 根据 TuSDKMediaTimeRange 初始化 TuSDKMediaTimelineSlice

 @param timeRange 时间区间
 @return TuSDKMediaTimelineSlice
 @since   v3.0
 */
- (instancetype) initWithTimeRange:(TuSDKMediaTimeRange *)timeRange;

/**
 根据开始时间和结束时间初始化时间范围。
 当开始时间大于结束时间时为倒序读取模式
 
 @param timeRange 时间区间
 @return TuSDKMediaTimeRange
 @since      v3.0
 */
- (instancetype)initWithCMTimeRange:(CMTimeRange)timeRange;

/**
 根据开始时间和结束时间初始化时间范围。
 当开始时间大于结束时间时为倒序读取模式
 
 @param start 开始时间
 @param end 结束时间
 @return TuSDKMediaTimeRange
 @since      v3.0
 */
- (instancetype)initWithStart:(CMTime)start end:(CMTime)end;

/**
 验证当前片段是否有效
 @since  v3.0
 */
@property (nonatomic,readonly) BOOL isValid;

/**
 特效生效时间
 @since  v3.0
 */
@property (nonatomic,readonly) TuSDKMediaTimeRange *timeRange;

/**
 是否为倒序。 如果 timeRange 为反向输出则为倒序。
 如 ：[[TuSDKMediaTimeRange alloc] initWithStart:CMTimeMakeWithSeconds(5.f, USEC_PER_SEC) end:CMTimeMakeWithSeconds(0.f, USEC_PER_SEC)]
 @since  v3.0
 */
@property (nonatomic,readonly) BOOL isReverse;

/**
 速率调整 取值范围：> 0 && <=4. 默认：1 ( > 1 快速播放  < 1 慢速播放)
 @since  v3.0
 */
@property (nonatomic) CGFloat speedRate;

@end
