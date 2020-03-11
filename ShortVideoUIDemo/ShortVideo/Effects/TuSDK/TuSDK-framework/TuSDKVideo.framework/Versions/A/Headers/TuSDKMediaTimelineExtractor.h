//
//  TuSDKMediaTimelineExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 22/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaExtractor.h"
#import "TuSDKMediaTimeline.h"
#import "TuSDKMediaTimeSliceEntity.h"

/**
 媒体数据时间轴分离器
 
 @since v3.0
 */
@protocol TuSDKMediaTimelineExtractor <TuSDKMediaExtractor,TuSDKMediaTimeline>

/*!
 @property mediaSync
 分离同步器
 @since      v3.0
 */
@property (nonatomic, weak) id<TuSDKMediaExtractorSync> _Nullable mediaSync;

/**
 当前正在分离的媒体数据片段
 @since      v3.0
 */
- (TuSDKMediaTimeSliceEntity *_Nullable) extractingSlice;

/**
 当前正在输出的媒体数据片段
 @since      v3.0
 */
- (TuSDKMediaTimeSliceEntity *_Nullable) outputSlice;

/**
 验证当前分离器是否支持倒序输出
 
 @return true/false
 @since      v3.0
 */
- (BOOL)canSupportedReverseSlice;

@end
