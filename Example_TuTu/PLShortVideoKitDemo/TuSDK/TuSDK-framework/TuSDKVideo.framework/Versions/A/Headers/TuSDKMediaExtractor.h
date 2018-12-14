//
//  TuSDKMediaExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 12/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaSettings.h"
#import "TuSDKMediaStatus.h"

@protocol TuSDKMediaExtractorSync;

/**
 媒体数据读取器接口
 @since      v3.0
 */
@protocol TuSDKMediaExtractor <NSObject>

/*!
 @property asset
 
 @discussion
 输入 _Nullable 的视频源
 @since      v3.0
 */
@property (nonatomic,readonly)AVAsset * _Nonnull asset;

/*!
 获取设置信息
 @since      v3.0
 */
@property (nonatomic)TuSDKMediaAssetExtractorSettings * _Nullable outputSettings;

/**
 分离的轨道数据类型
 @since      v3.0
 */
@property (nonatomic,readonly) AVMediaType _Nonnull outputTrackMediaType;

/*!
 @property status
 解码器当前状态
 @since      v3.0
 */
@property (nonatomic,readonly) TuSDKMediaAssetExtractorStatus status;

/*!
 @property processQueue
 @abstract
 
 @discussion
 Decoding run queue
 @since      v3.0
 */
@property (nonatomic) dispatch_queue_t _Nullable processQueue;

/**
 媒体的真实时长
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime inputDuration;

/**
 分离数据的总时长
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputDuration;

/**
 获取当前视频帧原始时间
 @return 视频帧时间
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputPresentationTime;

/**
 获取实时帧间隔时间
 
 @return 视频帧间隔
 @since      v3.0
 */
@property (nonatomic,readonly)CMTime frameInterval;

/**
 The value of the extractorFrameDuration property is set to a value short enough to accommodate the greatest nominal frame rate value among the asset’s video tracks, as indicated by the nominalFrameRate property of each track. If all of the asset tracks have a nominal frame rate of 0, a frame rate of 30 frames per second is used, with the frame duration set accordingly.
 extractorFrameDuration属性的值被设置为一个足够短的值，以容纳资产的视频轨道中最大的名义帧速率值，这是由每条轨道的名义上的属性所指示的。如果所有资产跟踪的名义帧速率为0，则使用每秒30帧的帧速率，并相应地设置帧持续时间。
 @since v3.0
 */
@property (nonatomic) CMTime extractorFrameDuration;

/*!
 @property videoComposition
 @abstract
 The composition of video used by the receiver.
 
 @discussion
 The value of this property is an AVVideoComposition that can be used to specify the visual arrangement of video frames read from each source track over the timeline of the source asset.
 
 This property cannot be set after reading has started.
 */
@property (nonatomic, copy, nullable) AVVideoComposition *videoComposition;

/**
 开始读取
 @since      v3.0
 */
- (void)start;

/**
 停止读取
 @since      v3.0
 */
- (void)stop;

/**
 暂停输出
 @since      v3.0
 */
- (void)pause;

/**
 读取当前已解码的媒体数据
 
 @return 已解码的媒体数据
 @since      v3.0
 */
- (const CMSampleBufferRef _Nullable )peekSampleBuffer;

/**
 移动视频到下一帧
 @return true/false
 @since      v3.0
 */
- (BOOL)advance;

/**
 移动读取光标

 @param time 光标读取时间
 @since      v3.0
 */
- (void)seekTo:(CMTime)time;

/**
 销毁分离器
 @since v3.0
 */
- (void)destory;

@end
