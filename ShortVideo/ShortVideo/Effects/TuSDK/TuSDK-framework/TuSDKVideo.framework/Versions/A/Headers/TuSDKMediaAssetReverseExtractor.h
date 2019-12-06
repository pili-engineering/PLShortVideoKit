//
//  TuSDKMediaAssetReverseExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 30/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaReverseExtractor.h"

/**
 多媒体数据倒序分离器。
 支持将数据倒序输出。
 
 @since v3.0
 */
@interface TuSDKMediaAssetReverseExtractor : NSObject <TuSDKMediaReverseExtractor>

/**
 初始化数据分离器
 
 @param asset 媒体资产
 @param outputSettings 输出设置
 An NSDictionary of output settings to be used for sample output.  See AVAudioSettings.h for available output settings for audio tracks or AVVideoSettings.h for available output settings for video tracks and also for more information about how to construct an output settings dictionary.
 @return TuSDKMediaAssetExtractor
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nonnull)asset outputTrackMediaType:(AVMediaType _Nonnull )mediaType outputSettings:(TuSDKMediaAssetExtractorSettings*_Nullable)outputSettings;

/**
 设置当前时间裁剪区间
 
 @since      v3.0
 */
@property (nonatomic) CMTimeRange timeRange;

/**
 是否将基准时间重置为 kCMTimeZero 默认：NO
 
 @since v3.0
 */
@property (nonatomic) BOOL resetOutputPresentationTimeToZero;

@end
