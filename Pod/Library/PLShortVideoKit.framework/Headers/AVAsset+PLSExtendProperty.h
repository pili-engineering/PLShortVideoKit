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

@end
