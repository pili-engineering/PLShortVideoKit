//
//  TuSDKPixelBufferInput.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/** CMSampleBufferRef input */
@protocol TuSDKSampleBufferInput

/**
 处理媒体数据
 
 @param sampleBufferRef CMSampleBufferRef
 @param type AVMediaTypeVideo / AVMediaTypeAudio
 @param outputTime 当前媒体数据输出时间
 */
- (void)processSampleBufferRef:(CMSampleBufferRef)sampleBufferRef mediaType:(AVMediaType)type outputTime:(CMTime)outputTime;

/**
 新的视频数据可用

 @param pixelBufferRef 视频帧数据
 @param outputTime 当前媒体数据输出时间
 */
- (void)processProcessPixelBuffer:(CVPixelBufferRef)pixelBufferRef outputTime:(CMTime)outputTime;

@end
