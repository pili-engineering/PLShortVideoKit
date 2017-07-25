//
//  PLSFileSection.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PLSFileSection : NSObject

/**
 @abstract 视频段的地址
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSURL *fileURL;

/**
 @abstract 视频段的时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat duration;

/**
 @abstract 视频段的起始时间点
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat startTime;

/**
 @abstract 视频段的结束时间点
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat endTime;

/**
 @abstract 视频段的方向
 
 @since      v1.0.2
 */
@property (assign, nonatomic) UIInterfaceOrientation orientation;

/**
 @abstract 视频段播放/合成时要旋转的角度
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat degree;

/**
 @abstract 视频段的原始分辨率，存在角度，跟 videoSize 不同
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGSize naturalSize;

/**
 @abstract 视频段的实际分辨率
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @abstract 视频段的帧率
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat frameRate;

@end
