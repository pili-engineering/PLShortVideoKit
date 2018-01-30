//
//  TuSDKFilterProcessorBase.h
//  TuSDK
//
//  Created by Yanlin on 3/22/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "GPUImageImport.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

/**
 A GPU Output that provides frames from external source
 */
@interface TuSDKFilterProcessorBase : GPUImageOutput
{
    GPUImageRotationMode outputRotation, internalRotation , bufferRotation;
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

/// @name Benchmarking

/** When benchmarking is enabled, this will keep a running average of the time from uploading, processing, and final recording or display
 */
- (CGFloat)averageFrameDurationDuringCapture;

- (void)resetBenchmarkAverage;

@end
