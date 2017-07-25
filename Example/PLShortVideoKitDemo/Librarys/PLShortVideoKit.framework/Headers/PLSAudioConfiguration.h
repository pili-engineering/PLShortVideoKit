//
//  PLSAudioConfiguration.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSTypeDefines.h"

@interface PLSAudioConfiguration : NSObject

/**
 @brief 采集音频数据的声道数，默认为 1
 
 @warning 并非所有采集设备都支持多声道数据的采集
 
 @since      v1.0.0
 */
@property (assign, nonatomic) NSUInteger numberOfChannels;

/**
 @brief 音频采样率 sampleRate 默认为 PLSAudioSampleRate_44100Hz
 
 @since      v1.0.0
 */
@property (assign, nonatomic) PLSAudioSampleRate sampleRate;

/**
 @brief 音频编码码率 bitRate 默认为 PLSAudioBitRate_128Kbps
 
 @since      v1.0.0
 */
@property (assign, nonatomic) PLSAudioBitRate bitRate;


/**
 @brief 创建一个默认配置的 PLSAudioConfiguration 实例.
  
 @return 创建的默认 PLSAudioConfiguration 对象
 
 @since      v1.0.0
 */
+ (instancetype)defaultConfiguration;

@end
