//
//  TuSDKMediaAssetAudioExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 22/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaTimelineAssetExtractor.h"

/**
 音频数据时间轴分离器
 @since v3.0
 */
@interface TuSDKMediaTimelineAssetAudioExtractor : TuSDKMediaTimelineAssetExtractor

/**
 初始化数据分离器
 
 @param asset 音频资产
 @param outputSettings 输出设置
 An NSDictionary of output settings to be used for sample output.  See AVAudioSettings.h for available output settings for audio tracks  for available output settings for audio tracks and also for more information about how to construct an output settings dictionary.
 @return TuSDKMediaTimelineAssetAudioExtractor
 @since v3.0
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nonnull)asset outputSettings:(TuSDKMediaAssetExtractorSettings*_Nullable)outputSettings;

@end
