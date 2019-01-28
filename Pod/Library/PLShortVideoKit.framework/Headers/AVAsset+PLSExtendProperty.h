//
//  AVAsset+PLSExtendProperty.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2018/3/28.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (PLSExtendProperty)

/**
 @brief 视频的真实分辨率
 
 @since      v1.11.0
 */
@property (assign, nonatomic, readonly) CGSize pls_videoSize;

/**
 @brief 视频是否为竖屏视频
 
 @since      v1.11.0
 */
@property (assign, nonatomic, readonly) BOOL pls_portrait;

/**
 @brief 视频是否为正方形视频
 
 @since      v1.11.0
 */
@property (assign, nonatomic, readonly) BOOL pls_squareVideo;

/**
 @brief 视频的码率
 
 @since      v1.11.0
 */
@property (assign, nonatomic, readonly) float pls_bitrate;

/**
 @brief 视频的帧率
 
 @since      v1.15.0
 */
@property (assign, nonatomic, readonly) float pls_normalFrameRate;

/**
 @brief 如果 AVAsset 包含音频通道，则返回第一个音频通道的声道数
 
 @since      v1.16.1
 */
@property (assign, nonatomic, readonly) UInt32 pls_channel;

/**
 @brief 如果 AVAsset 包含音频通道，则返回第一个音频通道的采样率
 
 @since      v1.16.1
 */
@property (assign, nonatomic, readonly) Float64 pls_sampleRate;

@end
