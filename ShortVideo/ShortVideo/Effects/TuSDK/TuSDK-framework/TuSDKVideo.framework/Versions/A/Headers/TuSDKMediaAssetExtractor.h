//
//  TuSDKMediaAssetExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 24/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaExtractor.h"
#import "TuSDKMediaAssetExtractorPitch.h"

/**
 多媒体数据分离器
 
 @since v3.0
 */
@interface TuSDKMediaAssetExtractor : NSObject <TuSDKMediaExtractor>

/**
 初始化数据分离器
 
 @param asset 媒体资产
 @param outputSettings 输出设置
 An NSDictionary of output settings to be used for sample output.  See AVAudioSettings.h for available output settings for audio tracks or AVVideoSettings.h for available output settings for video tracks and also for more information about how to construct an output settings dictionary.
 @return TuSDKMediaAssetExtractor
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nonnull)asset outputTrackMediaType:(AVMediaType _Nonnull )mediaType outputSettings:(TuSDKMediaAssetExtractorSettings*_Nullable)outputSettings;

/**
 解码器当前状态
 
 @since      v3.0
 */
@property (nonatomic) CMTimeRange timeRange;

/**
 设置输出的时间偏移量。默认为 ：kCMTimeInvalid
 
 @since v3.0
 */
@property (nonatomic) CMTime outputPresentationTimeOffset;

/**
 The value of the extractorFrameDuration property is set to a value short enough to accommodate the greatest nominal frame rate value among the asset’s video tracks, as indicated by the nominalFrameRate property of each track. If all of the asset tracks have a nominal frame rate of 0, a frame rate of 30 frames per second is used, with the frame duration set accordingly.
 extractorFrameDuration属性的值被设置为一个足够短的值，以容纳资产的视频轨道中最大的名义帧速率值，这是由每条轨道的名义上的属性所指示的。如果所有资产跟踪的名义帧速率为0，则使用每秒30帧的帧速率，并相应地设置帧持续时间。
 @since v3.0
 */
@property (nonatomic) CMTime extractorFrameDuration;


/**
 外部分离器补丁
 @since v3.4.2
 */
@property (nonatomic) TuSDKMediaAssetExtractorPitch * _Nullable pitch;

@end
