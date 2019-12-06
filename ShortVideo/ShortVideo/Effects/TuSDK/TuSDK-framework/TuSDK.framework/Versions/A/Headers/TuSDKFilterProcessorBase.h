//
//  TuSDKFilterProcessorBase.h
//  TuSDK
//
//  Created by Yanlin on 3/22/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "SLGPUImage.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

/**
 A GPU Output that provides frames from external source
 */
@interface TuSDKFilterProcessorBase : SLGPUImageOutput
{
    LSQGPUImageRotationMode bufferRotation;
    CGSize _outputSize;
}

/**
   传入图像的方向是否为原始朝向，SDK 将依据该属性来调整人脸检测时图片的角度。如果没有对图片进行旋转，则为 YES
 */
@property (nonatomic, readonly) BOOL isOriginalOrientation;

/// This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
@property(readwrite, nonatomic) BOOL runBenchmark;

/// This determines the rotation applied to the output image, based on the source material
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

@property(nonatomic, assign) AVCaptureDevicePosition cameraPosition;

/// These properties determine whether or not the two camera orientations should be mirrored. By default, both are NO.
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;

/**
 画布背景色
 
 @since 3.0.8
 */
@property (nonatomic) UIColor *canvasColor;

/**
 设置输出方向
 */
@property (nonatomic) LSQGPUImageRotationMode outputRotation;

/**
 自定义输入方向
 @since 3.0.8
 */
@property (nonatomic) LSQGPUImageRotationMode internalRotation;

/**
 输入的视频宽高
 @since 3.0.8
 */
@property (nonatomic,readonly) CGSize inputSize;

/**
 输出宽高
 @since 3.0.8
 */
@property (nonatomic) CGSize outputSize;

/**
 输出比例与原视频比例不一致时是否自适应画布大小
 */
@property (nonatomic) BOOL aspectOutputRatioInSideCanvas;

/**
 *  初始化
 *
 *  支持： kCVPixelFormatType_420YpCbCr8BiPlanarFullRange | kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32BGRA
 *
 *  @param pixelFormatType          原始采样的pixelFormat Type
 *  @param isOriginalOrientation    传入图像的方向是否为原始朝向，SDK 将依据该属性来调整人脸检测时图片的角度。如果没有对图片进行旋转，则为 YES
 *
 *  @return instance
 */
- (id)initWithFormatType:(OSType)pixelFormatType isOriginalOrientation:(BOOL)isOriginalOrientation;

/**
 *  初始化 处理textureID时使用此方法初始化
 *
 *  @param sharegroup 共享组
 *  @return instance
 */
- (id)initWithSharegroup:(EAGLSharegroup *)sharegroup;

/**
 *  初始化
 *
 *  @param videoOutput 视频源
 *
 *  @return instance
 */
- (id)initWithVideoDataOutput:(AVCaptureVideoDataOutput *)videoOutput;

/**
 *  Process a video sample
 *
 *  @param sampleBuffer sampleBuffer Buffer to process
 */
- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 *  Process a pixelBuffer
 *
 *  @param cameraFrame pixelBuffer to process
 */
- (void)processPixelBuffer:(CVPixelBufferRef)cameraFrame frameTime:(CMTime)currentTime;

/**
 *  Process a pixelBuffer
 *
 *  @param texture textureID to process
 */
- (void)processTexture:(GLuint)texture textureSize:(CGSize)size;

/// @name Benchmarking

/** When benchmarking is enabled, this will keep a running average of the time from uploading, processing, and final recording or display
 */
- (CGFloat)averageFrameDurationDuringCapture;

- (void)resetBenchmarkAverage;

/**
 设置输出尺寸

 @param outputSize 输出尺寸
 @param aspectOutputRatioInSideCanvas 输出比例与原视频比例不一致时是否自适应画布大小
 */
- (void)setOutputSize:(CGSize)outputSize aspectOutputRatioInSideCanvas:(BOOL)aspectOutputRatioInSideCanvas;

@end
