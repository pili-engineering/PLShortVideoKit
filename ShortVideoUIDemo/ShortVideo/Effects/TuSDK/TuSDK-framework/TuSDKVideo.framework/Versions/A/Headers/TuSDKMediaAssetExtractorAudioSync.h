//
//  TuSDKMediaAssetExtractorAudioSync.h
//  TuSDKVideo
//
//  Created by sprint on 21/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaExtractorSync.h"
#import "TuSDKMediaTimelineAssetExtractor.h"
#import "TuSDKMediaAssetTimeline.h"

/**
 音频分离器同步器
 @since v3.0
 */
@interface TuSDKMediaAssetExtractorAudioSync : NSObject <TuSDKMediaExtractorSync>

/**
 初始化 TuSDKMediaAssetExtractorAudioSync
 
 @param audioExtractor 音频数据分离器
 @return TuSDKMediaAssetExtractorAudioSync
 */
- (instancetype)initExtractor:(id<TuSDKMediaTimelineExtractor>)audioExtractor;

/**
 视频数据分离器
 @since      v3.0
 */
@property (nonatomic,readonly) id<TuSDKMediaTimelineExtractor> audioExtractor;

/**
 当前已播放时长
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputTime;

@end
