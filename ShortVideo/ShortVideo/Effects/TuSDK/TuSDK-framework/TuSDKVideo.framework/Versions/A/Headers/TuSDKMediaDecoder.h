//
//  TuSDKMediaDecoder.h
//  TuSDKVideo
//
//  Created by sprint on 03/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "TuSDKSampleBufferInput.h"

/**
 * 视频数据解码器
 */
@protocol TuSDKMediaDecoder

@required

/*!
 @method startDeocder
 
 @discussion
  启动解码器
 */
- (void)startDeocder;

/*!
 @method cancelDecoder
 
 @discussion
  停止解码器
 */
- (void)cancelDecoder;

/*!
 @method addDecompressSampleBufferTarget:
 @abstract
 Adds an output to the receiver.
 
 @param outputTarget
 The TuSDKSampleBufferInput object to be added.
 
 @discussion
  用于接收输出的解码数据
 */
- (void)addDecompressSampleBufferTarget:(_Nonnull id<TuSDKSampleBufferInput>)outputTarget;

/*!
 @method removeDecompressSampleBufferTarget:
 @abstract
 remove an output to the receiver.
 
 @param outputTarget
 The TuSDKSampleBufferInput object to be removed.
 
 @discussion
 移除接收数据target
 */
- (void)removeDecompressSampleBufferTarget:(_Nonnull id<TuSDKSampleBufferInput>)outputTarget;

@end
