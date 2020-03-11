//
//  TuSDKMediaAudioMuteComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/14.
//  Copyright © 2019 TuSDK. All rights reserved.
//
#import "TuSDKMediaAudioComposition.h"


NS_ASSUME_NONNULL_BEGIN
/**
 静音数据轨道
 
 @since v3.4.1
 */
@interface TuSDKMediaAudioMuteComposition : NSObject <TuSDKMediaAudioComposition>

/**
 初始化音频流描述信息

 @param streamBasicDescription 流描述信息
 @return 音频流描述信息
 @since v3.4.1
 */
- (instancetype)initWithAudioStreamDescription:(AudioStreamBasicDescription)streamBasicDescription;

/**
 初始化音频流描述信息

 @param sampleRate 输出采样率  默认: 44100 Hz
 @param channels 输出声道数量  默认: 2 立体声
 @param bitsPerChannel 输出位宽 默认：16
 @return TuSDKMediaAudioMuteComposition
 @since v3.4.1
 */
- (instancetype)initWithOutputSampleRate:(Float64)sampleRate channels:(UInt32)channels bitsPerChannel:(UInt32)bitsPerChannel;

/**
 最大输出持续时间 默认: CMTimeMakeWithSeconds(1, USEC_PER_SEC)
 
 @return 输出持续时间
 @since v3.4.1
 */
@property (nonatomic)CMTime maxOutputDuration;


@end

NS_ASSUME_NONNULL_END
