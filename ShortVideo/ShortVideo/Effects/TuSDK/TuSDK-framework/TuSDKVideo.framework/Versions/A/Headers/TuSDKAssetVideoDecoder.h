//
//  TuSDKAssetVideoDecoder.h
//  TuSDKVideo
//
//  Created by sprint on 03/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMediaDecoder.h"
#import "TuSDKMediaAssetInfo.h"

/** TuSDKAssetVideoDecoderVideoSettings  */
typedef NSDictionary<NSString *, id> TuSDKAssetVideoDecoderVideoSettings;

@class TuSDKAssetVideoDecoder;

/*!
 @enum TuSDKAssetVideoDecoderStatus
 @abstract
 These constants are returned by the AVAssetReader status property to indicate whether it can successfully read samples from its asset.
 
 @constant     TuSDKAssetVideoDecoderStatusUnknown
 Indicates that the status of the asset decoder is not currently known.
 @constant     TuSDKAssetVideoDecoderStatusReading
 Indicates that the asset reader is successfully reading samples from its asset.
 @constant     TuSDKAssetVideoDecoderStatusCompleted
 Indicates that the asset reader has successfully read all of the samples in its time range.
 @constant     TuSDKAssetVideoDecoderStatusFailed
 Indicates that the asset reader can no longer read samples from its asset because of an error.
 @constant     TuSDKAssetVideoDecoderStatusCancelled
 Indicates that the asset reader can no longer read samples because decoder was canceled with the cancelReading method.
 */
typedef NS_ENUM(NSInteger, TuSDKAssetVideoDecoderStatus) {
    TuSDKAssetVideoDecoderStatusUnknown = 0,
    TuSDKAssetVideoDecoderStatusReading,
    TuSDKAssetVideoDecoderStatusCompleted,
    TuSDKAssetVideoDecoderStatusCancelled,
    TuSDKAssetVideoDecoderStatusFailed
};

#pragma mark - TuSDKAssetVideoDecoderDelegate

/**
 TuSDKAssetVideoDecoderDelegate
 */
@protocol TuSDKAssetVideoDecoderDelegate

@required
/**
 The current decoder state changes the event.

 @param decoder TuSDKAssetVideoDecoder
 @param status TuSDKAssetVideoDecoderStatus
 */
- (void)assetVideoDecoder:(TuSDKAssetVideoDecoder *_Nullable)decoder statusChanged:(TuSDKAssetVideoDecoderStatus)status;

@end

#pragma mark - TuSDKAssetVideoDecoder

/**
 * TuSDKAssetVideoDecoder
 */
@interface TuSDKAssetVideoDecoder : NSObject <TuSDKMediaDecoder>

/**
 初始化视频解码器
 
 @param asset 音频地址
 @param outputSettings 输出设置
 An NSDictionary of output settings to be used for sample output.  See AVAudioSettings.h for available output settings for audio tracks or AVVideoSettings.h for available output settings for video tracks and also for more information about how to construct an output settings dictionary.
 @return TuSDKAssetAudioDecoder
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nullable)asset outputSettings:(TuSDKAssetVideoDecoderVideoSettings*_Nullable)outputSettings;

/**
 processQueue
 */
@property (nonatomic) dispatch_queue_t _Nullable processQueue;

/**
 delegate
 */
@property (nonatomic,weak) id<TuSDKAssetVideoDecoderDelegate> _Nullable delegate;

/*!
 @property status
 解码器当前状态
 */
@property (nonatomic,readonly) TuSDKAssetVideoDecoderStatus status;

/*!
  @property asset
 
  @discussion
  输入的视频源
 */
@property (nonatomic,readonly)AVAsset * _Nonnull asset;

/**
 * 设置裁剪时间
 */
@property (nonatomic) CMTimeRange timeRange;

/*!
 @property movieInfo
 
 @discussion
 获取视频信息
 */
@property (nonatomic,readonly)TuSDKMediaAssetInfo * _Nullable movieInfo;

/*!
  @property outputSettings
 
  @discussion
  获取设置信息
 */
@property (nonatomic,readonly)TuSDKAssetVideoDecoderVideoSettings * _Nullable outputSettings;

/*!
 @property outputSampleBufferInputTargets

 @discussion
  视频数据输出
 */
@property (nonatomic,readonly)NSMutableArray<id<TuSDKSampleBufferInput>> * _Nullable outputSampleBufferInputTargets;

@end


