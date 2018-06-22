//
//  PLSVideoMixConfiguration.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/5/7.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSVideoConfiguration.h"
/**
 * @abstract 双屏录制的视频设置类, videoSize 的默认值为(720, 640). averageVideoBitRate 的默认值为 1024*2000
 */
@interface PLSVideoMixConfiguration : PLSVideoConfiguration

/**
 @property   cameraVideoFrame
 @abstract   相机采集视频占最终合并视频的frame，相对于videoSize。默认 (0, 0, 360, 640)
 
 @discussion 需要注意的是，这个参数影响的是视频编码时的分辨率，而非摄像头采集到数据的预览大小，传递给编码器的图像尺寸与此尺寸不同时，会按照 AVVideoScalingModeResizeAspectFill 对图像做剪切，从而确保图像不会出现压缩的现象。
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CGRect cameraVideoFrame;

/**
 @property   sampleVideoFrame
 @abstract   素材视频占最终合并视频的frame，相对于videoSize。 默认 (360, 0, 360, 640)
 
 @discussion 需要注意的是，这个参数影响的是视频编码时的分辨率，而非素材视频数据的预览大小，传递给编码器的图像尺寸与此尺寸不同时，会按照 AVVideoScalingModeResizeAspectFill 对图像做剪切，从而确保图像不会出现压缩的现象。
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CGRect sampleVideoFrame;

/**
 @brief 创建一个默认配置的 PLSVideoMixConfiguration 实例.
 
 @return 创建的默认 PLSVideoMixConfiguration 对象
 
 @since      v1.11.0
 */
+ (instancetype)defaultConfiguration;

@end
