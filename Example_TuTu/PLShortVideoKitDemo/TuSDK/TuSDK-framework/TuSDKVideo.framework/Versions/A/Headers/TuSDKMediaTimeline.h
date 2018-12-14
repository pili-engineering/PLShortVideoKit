//
//  TuSDKMediaTimeline.h
//  TuSDKVideo
//
//  Created by sprint on 14/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaTimelineSlice.h"

/**
 特效时间轴
 @since      v3.0
 */
@protocol TuSDKMediaTimeline <NSObject>

/**
 特效片段
 @since      v3.0
 */
@property (nonatomic,readonly) NSArray<TuSDKMediaTimelineSlice *> * _Nullable orginSlices;

/**
 媒体的真实时长
 @since      v3.0
 */
@property (nonatomic) CMTime inputDuration;

/**
 特效特效最终输出的持续时间
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime timelineOutputDuraiton;

/**
 在原有特效后追加新的特效
 
 @param timelineSlice 特效片段
 @since      v3.0
 */
- (BOOL)appendMediaTimeSlice:(TuSDKMediaTimelineSlice *_Nonnull)timelineSlice;

/**
 移除特效片段

 @param timelineSlice TuSDKMediaTimelineSlice
 @since      v3.0
 */
- (BOOL)removeMediaTimeSlice:(TuSDKMediaTimelineSlice *_Nonnull)timelineSlice;

/**
 移除所有特效片段
 @since v3.0
 */
- (void)removeAllMediaTimeSlices;

/**
 重置时间轴

 @return true/false
 @since      v3.0
 */
- (void)resetTimeline;

@end
