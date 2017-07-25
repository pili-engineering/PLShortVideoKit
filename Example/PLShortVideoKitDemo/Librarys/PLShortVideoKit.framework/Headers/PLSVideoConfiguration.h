//
//  PLSVideoConfiguration.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLSVideoConfiguration : NSObject

/**
 @brief 采集的视频数据的帧率，默认为 25
 
 @since      v1.0.0
 */
@property (assign, nonatomic) NSUInteger videoFrameRate;

/**
 @brief 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset1280x720
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSString *sessionPreset;

/**
 @brief 前置预览是否开启镜像，默认为 YES
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL previewMirrorFrontFacing;

/**
 @brief 后置预览是否开启镜像，默认为 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL previewMirrorRearFacing;

/**
 *  前置摄像头，录制的流是否开启镜像，默认 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL streamMirrorFrontFacing;

/**
 @brief 后置摄像头，录制的流是否开启镜像，默认 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL streamMirrorRearFacing;

/**
 @brief 开启 camera 时的采集摄像头位置，默认为 AVCaptureDevicePositionBack
 
 @since      v1.0.0
 */
@property (assign, nonatomic) AVCaptureDevicePosition position;

/**
 @brief 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait
 
 @since      v1.0.0
 */
@property (assign, nonatomic) AVCaptureVideoOrientation videoOrientation;

/**
 @property   videoSize
 @abstract   编码时的视频分辨率，默认 (480, 854)
 
 @discussion 需要注意的是，这个参数影响的是视频编码时的分辨率，而非摄像头采集到数据的预览大小，传递给编码器的图像尺寸与此尺寸不同时，会按照 AVVideoScalingModeResizeAspectFill
 对图像做剪切，从而确保图像不会出现压缩的现象。
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @property   averageVideoBitRate
 @abstract   平均视频编码码率。默认为 1024*1000
 
 @discussion 单位为 bps(Bits per Second)。该参数的视频编码实际过程中，并不是恒定的数值，所以只能设定平均视频编码码率。
 
 @since      v1.0.0
 */
@property (nonatomic, assign) NSUInteger averageVideoBitRate;

/*!
 @property   videoMaxKeyframeInterval
 @abstract   视频编码关键帧最大间隔（GOP）。
 
 @discussion h.264 编码时，两个关键帧之间间隔的最多的帧数，一般为 fps 的两倍或者三倍。默认为 2*fps
 
 @since      v1.0.0
 */
@property (nonatomic, assign) NSUInteger videoMaxKeyframeInterval;

/*!
 @property   videoProfileLevel
 @abstract   H.264 编码时使用的 Profile Level。
 
 @discussion 默认情况下使用 AVVideoProfileLevelH264HighAutoLevel，如果对于视频编码有额外的需求并且知晓该参数带来的影响可以自行更改。
 
 @warning    当你不清楚该参数更改对分辨率要求，码率等影响时，请不要随意更改。
 
 @since      v1.0.0
 */
@property (nonatomic, copy) NSString *videoProfileLevel;

/**
 @brief 创建一个默认配置的 PLSVideoConfiguration 实例.
 
 @return 创建的默认 PLSVideoConfiguration 对象
 
 @since      v1.0.0
 */
+ (instancetype)defaultConfiguration;

@end
