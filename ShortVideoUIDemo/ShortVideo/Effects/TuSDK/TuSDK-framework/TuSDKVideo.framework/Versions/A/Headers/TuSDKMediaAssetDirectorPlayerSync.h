//
//  TuSDKMediaAssetDirectorPlayerSync.h
//  TuSDKVideo
//
//  Created by sprint on 28/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaAssetTimeline.h"
#import "TuSDKMediaSync.h"
#import "TuSDKMediaTimelineExtractor.h"
#import "TuSDKMediaExtractorSync.h"
#import "TuSDKMediaAssetExtractorAudioSync.h"
#import "TuSDKMediaAssetExtractorVideoSync.h"

/**
 媒体执行器同步器
 可以用于同步音视频数据
 @since      v3.0
 */
@interface TuSDKMediaAssetDirectorPlayerSync : NSObject <TuSDKMediaSync>

/**
 初始化 TuSDKMediaAssetDirectorPlayerSync

 @param videoExtractor 视频分离器
 @param audioExtractor 音频数据分离器
 @return TuSDKMediaAssetDirectorPlayerSync
 */
- (instancetype)initWithVideoExtractor:(id<TuSDKMediaTimelineExtractor>)videoExtractor audioExtractor:(id<TuSDKMediaTimelineExtractor>)audioExtractor;

/**
 视频数据分离器
 @since      v3.0
 */
@property (nonatomic,readonly) TuSDKMediaAssetExtractorVideoSync *videoExtractorSync;

/**
 音频数据分离器
 @since      v3.0
 */
@property (nonatomic,readonly) TuSDKMediaAssetExtractorAudioSync *audioExtractorSync;

/**
 当前音频已读取的时长
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime audioOutputDuration;

/**
 * 跳转到指定位置
 * @since  v3.0
 */
- (void)seekTo:(CMTime)outputTime;

@end

