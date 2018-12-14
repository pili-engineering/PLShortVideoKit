//
//  TuSDKVideoInfo.h
//  TuSDKVideo
//
//  Created by sprint on 02/07/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

@class TuSDKVideoTrackInfo;

@interface TuSDKVideoInfo : NSObject

/**
视频轨道信息
@since 视频轨道信息
@since 3.0
*/
@property (nonatomic,readonly)NSArray<TuSDKVideoTrackInfo *> *videoTrackInfoArray;

/**
 持续时间
 @since 3.0
 */
@property(nonatomic, readonly)CMTime duration;

/**
 是否为4k视频
 
 @since v3.0
 */
@property(nonatomic, readonly)BOOL is4K;

/**
 异步加载视频信息
 
 @param asset AVAsset
 @param handler 完成后回调
 @since 3.0
 */
-(void)loadAsynchronouslyForAssetInfo:(AVAsset *)asset completionHandler:(void (^)(void))handler;

/**
 同步加载视频信息
 
 @param asset AVAsset
 @since 3.0
 */
-(void)loadSynchronouslyForAssetInfo:(AVAsset *)asset;


@end

#pragma mark - TuSDKVideTrackInfo

/**
 * 视频轨道信息
 */
@interface TuSDKVideoTrackInfo : NSObject

/**
 TuSDKVideoTrackInfo
 
 @param audioTrack TuSDKVideoTrackInfo
 @return TuSDKAudioTrackInfo
 */
+(instancetype)trackInfoWithVideoAssetTrack:(AVAssetTrack *)videoTrack;

/**
 根据 AVAssetTrack 初始化 TuSDKVideoTrackInfo
 
 @param videoTrack AVAssetTrack
 @return TuSDKVideoTrackInfo
 */
-(instancetype)initWithVideoAssetTrack:(AVAssetTrack *)videoTrack;

/**
 The natural dimensions of the media data referenced by the track.
 */
@property (nonatomic,readonly) CGSize naturalSize;

/**
 The present dimensions of the media data referenced by the track.
 */
@property (nonatomic,readonly) CGSize presentSize;

/*!
 @property        nominalFrameRate
 @abstract        For tracks that carry a full frame per media sample, indicates the frame rate of the track in units of frames per second.
 @discussion        For field-based video tracks that carry one field per media sample, the value of this property is the field rate, not the frame rate.
 */
@property (nonatomic,readonly) CGFloat nominalFrameRate;

/* indicates the minimum duration of the track's frames; the value will be kCMTimeInvalid if the minimum frame duration is not known or cannot be calculated */
@property (nonatomic, readonly) CMTime minFrameDuration;

/**
   视频宽高是否需要交换
 */
@property(nonatomic, readonly) BOOL isTransposedSize;

/**
 The transform specified in the track’s storage container as the preferred transformation of the visual media data for display purposes.
 */
@property (nonatomic,readonly) CGAffineTransform preferredTransform;

/* indicates the estimated data rate of the media data referenced by the track, in units of bits per second */
@property (nonatomic, readonly) float estimatedDataRate;

/**
 rotation
 */
@property(nonatomic, readonly) LSQGPUImageRotationMode orientation;



@end
