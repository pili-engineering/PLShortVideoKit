//
//  TuSDKMediaAssetExtractorVideoSync.h
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
 视频分离器同步器
 @since v3.0
 */
@interface TuSDKMediaAssetExtractorVideoSync : NSObject <TuSDKMediaExtractorSync>

/**
 初始化 TuSDKMediaAssetExtractorVideoSync
 
 @param videoExtractor 视频分离器
 @return TuSDKMediaAssetExtractorVideoSync
 */
- (instancetype)initExtractor:(id<TuSDKMediaTimelineExtractor>)videoExtractor;

/**
 视频数据分离器
 @since      v3.0
 */
@property (nonatomic,readonly) id<TuSDKMediaTimelineExtractor> videoExtractor;

/**
 当前已播放时长
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputTime;

@end
