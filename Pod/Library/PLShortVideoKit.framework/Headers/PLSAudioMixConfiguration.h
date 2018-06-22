//
//  PLSAudioMixConfiguration.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/5/7.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSAudioConfiguration.h"

/**
 * @abstract 双屏录制的音频设置类
 */
@interface PLSAudioMixConfiguration : PLSAudioConfiguration

/**
 @brief 是否禁用麦克风音频采集，defalut: NO
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL disableMicrophone;

/**
 @brief 是否禁用素材视频的音频数据，default: NO
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL disableSample;

/**
 @brief 混音处理的时候，microphone 的音量大小. 当 disableSample 和 disableMicrophone 同时为 NO 时，该参数才有意义. default 0.5 (可用范围0.0~1.0)
 
 @since      v1.11.0
 */
@property (assign, nonatomic) float microphoneVolume;

/**
 @brief 混音处理的时候，素材视频的音频大小. 当 disableSample 和 disableMicrophone 同时为 NO 时，该参数才有意义. default 0.5 (可用范围0.0~1.0)
 
 @since      v1.11.0
 */
@property (assign, nonatomic) float sampleVolume;

/**
 @brief 回声消除开关，默认为 YES
 
 @discussion 启用回音消除，从扬声器播放的声音将会被消除掉，如果是带上耳机的、则没有必要启用回音消除，启用回音消除会让播放声音变得很大
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL acousticEchoCancellationEnable;

/**
 @brief 创建一个默认配置的 PLSAudioMixConfiguration 实例.
 
 @return 创建的默认 PLSAudioMixConfiguration 对象
 
 @since      v1.11.0
 */
+ (instancetype)defaultConfiguration;


@end
