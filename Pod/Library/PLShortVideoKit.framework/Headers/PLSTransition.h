//
//  PLSTransition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLSTransition : NSObject

/**
 @brief 动画时长，毫秒
 
 @since      v1.10.0
 */
@property (nonatomic, assign) double durationInMs;

/**
 @brief 动画开始时间，毫秒
 
 @since      v1.10.0
 */
@property (nonatomic, assign) double startTimeInMs;

/**
 @abstract 根据配置的参数，返回一个CAAnimation对象，预览view的尺寸和导出视频的尺寸不一样的时候，为了能让预览效果达到和导出视频一样效果，需要对动画的位置等做比例缩放
 @param scale 如果CAAnimation用于预览，sacel = 预览view的width / 导出视频的width
              如果CAAnimation用于生产最终视频，scale = 背景视频的width / 导出视频的width
 
 @since      v1.10.0
 */
- (CAAnimation *)animationWithScale:(CGFloat)scale;


@end
