//
//  PLSMicrophoneSource.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSAudioConfiguration.h"
#import "PLSSourceAccessProtocol.h"

@class PLSMicrophoneSource;

/*!
 @protocol PLSMicrophoneSourceDelegate
 @brief 音频采集协议.
 */
@protocol PLSMicrophoneSourceDelegate <NSObject>

/*!
 @method microphoneSource:didGetOriginSampleBuffer:
 @brief 采集到音频没有经过任何处理的回调.
 
 @param source 实例.
 @param sampleBuffer 音频帧.
 */
- (CMSampleBufferRef)microphoneSource:(PLSMicrophoneSource *)source didGetOriginSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*!
 @method microphoneSource:didGetResultSampleBuffer:
 @brief 音频编码之前的回调
 
 @param source 实例.
 @param sampleBuffer 音频帧.
 */
- (void)microphoneSource:(PLSMicrophoneSource *)source didGetResultSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

/*!
 @class PLSMicrophoneSource
 @brief 音频采集类，AVCaptureSession 实现.
 
 @discussion PLSMicrophoneSource 只能采集音频格式是 44100cHz、1ch、16bits 的音频数据，如果需要采集不同类型的音频格式，可以查看 PLSOutputAudioUnit
 
 @see PLSOutputAudioUnit
 */
@interface PLSMicrophoneSource : NSObject
<
PLSSourceAccessProtocol
>

/*!
 @property captureSession
 @brief 采集 session.
 */
@property (strong, nonatomic) AVCaptureSession *captureSession;

/*!
 @property delegate
 @brief 回调代理.
 */
@property (weak, nonatomic) id<PLSMicrophoneSourceDelegate> delegate;

/*!
 @property audioConfiguration
 @brief 音频编码参数配置.
 
 @warning 采集的音频格式是 44100Hz，1ch，16bits 并且不能修改音频采集格式
 */
@property (strong, nonatomic) PLSAudioConfiguration *audioConfiguration;

/*!
 @property running
 @brief 音频采集是否正在运行.
 */
@property (assign, nonatomic, readonly, getter=isRunning) BOOL running;

/*!
 @method initWithAudioConfiguration:
 @brief 初始化方法.
 
 @param audioConfiguration 音频编码参数.
 
 @return 实例.
 */
- (instancetype)initWithAudioConfiguration:(PLSAudioConfiguration *)audioConfiguration;

/*!
 @method setupCaptureSession
 @brief 音频采集初始化.
 
 @return 成功返回 YES，失败返回 NO.
 */
- (BOOL)setupCaptureSession;

/*!
 @method startRunning
 @brief 启动采集
 */
- (void)startRunning;

/*!
 @method stopRunning
 @brief 停止采集
 */
- (void)stopRunning;

@end
