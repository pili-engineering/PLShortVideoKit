//
//  PLSMixMediaItem.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/6/7.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSTypeDefines.h"

@interface PLSMixMediaItem : NSObject

/**
 @brief     合并文件的地址
 
 @since      v1.11.0
 */
@property (nonatomic, strong) NSURL *__nonnull mediaURL;

/**
 @brief 是否使用音频. (默认: YES)
 
 @since      v1.11.0
 */
@property (nonatomic, assign) BOOL enableAudio;

/**
 @brief      音量大小 (0 ~ 1.0, 默认: 1.0)
 
 @since      v1.11.0
 */
@property (nonatomic, assign) float volume;

/**
 @brief   视频在最终合并的视频中的位置， 需要注意的是，这个参数影响的是视频编码时的分辨率，而非素材视频数据的预览大小，传递给编码器的图像尺寸与此尺寸不同时，默认会按照 AVVideoScalingModeResizeAspectFill 对图像做剪切，从而确保图像不会出现变形
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CGRect videoFrame;

/**
 @brief   相对于 Z 轴的层数。如果多个 PLSMixMediaItem 的 videoFrame 发生重合，那么 zIndex 大的将覆盖在 zIndex 小的上面
 
 @since      v1.11.0
 */
@property (assign, nonatomic) int zIndex;

/**
 @brief   当视频的宽高比和 videoFrame 的宽高比不一致的时候，视频的contentMode （默认: PLSVideoFillModePreserveAspectRatioAndFill）
 
 @since      v1.11.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/**
 @brief   如果本文件时长小于设置合并的文件时长，是否将本文件以 loop 的形式添加到设置的合并文件时长。默认：YES
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL loop;

/**
 @brief   设置本文件的开始播放时间。比如想要实现多个视频合并之后，播放模式是一个视频播放完成之后，另外一个视频接着播放，
          那么可以将 loop 设置为 NO，并且将 PLSMultiVideoMixer 的属性 duration 设置为为所有文件的时长之和，
          即可以通过设置 startTime 的值来实现. 默认:kCMTimeZero
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CMTime startTime;

/**
 @brief   本文件的时长。 只读属性，为实现多个视频合并播放模式“一个接着一个顺序播放”设置 startTime 提供方便
 
 @since      v1.11.0
 */
@property (readonly, nonatomic) CMTime duration;

/**
 @brief     视频宽高。如果有视频通道，返回视频的宽高。如果没有，返回 CGSizeZero. 注意：这个 videoSize 是视频真实宽高经过 CGAffineTransform 处理之后宽高
 
 @since      v1.11.0
 */
@property (readonly, nonatomic) CGSize videoSize;

@end
