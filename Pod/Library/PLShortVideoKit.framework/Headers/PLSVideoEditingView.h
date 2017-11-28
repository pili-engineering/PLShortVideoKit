//
//  PLSVideoEditingView.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSEditingProtocol.h"
#import "PLSTypeDefines.h"

@interface PLSVideoEditingView : UIView <PLSEditingProtocol>

/**
 @brief 视频旋转方向
 
 @since      v1.7.0
 */
@property (assign, nonatomic) PLSPreviewOrientation videoLayerOrientation;

/**
 @brief 设置要被编辑的视频对象
 
 @since      v1.7.0
 */
- (void)setVideoAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange placeholderImage:(UIImage *)image;

/**
 @brief 导出被编辑的视频
 
 @since      v1.7.0
 */
- (void)exportAsynchronouslyWithTrimVideo:(void (^)(NSURL *trimURL, NSError *error))complete;

@end
