//
//  PLSFileSection.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @class PLSFileSection
 @abstract 视频录制文件类，每一段视频对应一个 PLSFileSection 实例
 
 @since      v1.0.0
 */
@interface PLSFileSection : NSObject

/*!
 @property fileURL
 @abstract 视频段的地址
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSURL *fileURL;

/*!
 @property duration
 @abstract 视频段的时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat duration;

/*!
 @property startTime
 @abstract 视频段的起始时间点
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat startTime;

/*!
 @property endTime
 @abstract 视频段的结束时间点
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat endTime;

/*!
 @property orientation
 @abstract 视频段的方向
 
 @since      v1.0.2
 */
@property (assign, nonatomic) UIInterfaceOrientation orientation;

/*!
 @property degree
 @abstract 视频段播放/合成时要旋转的角度
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat degree;

/*!
 @property naturalSize
 @abstract 视频段的原始分辨率，存在角度，跟 videoSize 不同
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGSize naturalSize;

/*!
 @property videoSize
 @abstract 视频段的实际分辨率
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGSize videoSize;

/*!
 @property frameRate
 @abstract 视频段的帧率
 
 @since      v1.0.2
 */
@property (assign, nonatomic) CGFloat frameRate;

/*!
 @property angle
 @abstract 图片旋转动画录制中，当前文件录制结束时对应的旋转图片旋转的角度
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CGFloat angle;

@end
