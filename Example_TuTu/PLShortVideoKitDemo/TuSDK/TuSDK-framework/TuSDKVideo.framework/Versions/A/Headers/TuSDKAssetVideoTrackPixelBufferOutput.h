//
//  TuSDKAssetVideoTrackPixelBufferOutput.h
//  TuSDKVideo
//
//  Created by sprint on 01/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

/** TuSDKAssetVideoTrackPixelBufferOutputSettings  */
typedef NSDictionary<NSString *, id> TuSDKAssetVideoTrackPixelBufferOutputSettings;

/**
 读取视频轨道像素数据
 */
@interface TuSDKAssetVideoTrackPixelBufferOutput : NSObject

/**
 初始化 TuSDKAssetVideoTrackPixelBufferOutput

 @param asset 资产文件
 @param outputSettings 输出设置
 @return TuSDKAssetVideoTrackPixelBufferOutput
 */
-(instancetype _Nullable )initWithAsset:(AVAsset *_Nonnull)asset outputSettings:(TuSDKAssetVideoTrackPixelBufferOutputSettings* _Nullable)outputSettings;

/*!
 @property videoComposition
 @abstract Indicates the video composition settings to be applied during playback.
 @since v3.0.1
 */
@property (nonatomic, copy, nullable) AVVideoComposition *videoComposition;

/*!
 @method            hasNewPixelBufferForItemTime:
 @abstract        Query if any new video output is available for an item time.
 @discussion
 This method returns YES if there is available video output, appropriate for display, at the specified item time not marked as acquired. If you require multiple objects to acquire video output from the same AVPlayerItem, you should instantiate more than one AVPlayerItemVideoOutput and add each via addOutput:. Each AVPlayerItemVideoOutput maintains a separate record of client acquisition.
 @param            itemTime
 The item time to query.
 @result            A BOOL indicating if there is newer output.
 */

- (BOOL)hasNewPixelBufferForItemTime:(CMTime)itemTime;

/*!
 @method            copyPixelBufferForItemTime:itemTimeForDisplay:
 @abstract        Retrieves an image that is appropriate for display at the specified item time, and marks the image as acquired.
 @discussion
 The client is responsible for calling CVBufferRelease on the returned CVPixelBuffer when finished with it.
 
 Typically you would call this method in response to a CVDisplayLink callback or CADisplayLink delegate invocation and if hasNewPixelBufferForItemTime: also returns YES.
 
 The buffer reference retrieved from copyPixelBufferForItemTime:itemTimeForDisplay: may itself be NULL. A reference to a NULL pixel buffer communicates that nothing should be displayed for the supplied item time.
 @param            itemTime
 A CMTime that expresses a desired item time.
 @param            itemTimeForDisplay
 A CMTime pointer whose value will contain the true display deadline for the copied pixel buffer. Can be NULL.
 */

- (void)copyPixelBufferForItemTime:(CMTime)seekTime itemTimeForDisplay:(nullable CMTime *)outItemTimeForDisplay completionHandler:(void (^_Nullable)(CVPixelBufferRef _Nullable ))completionHandler;


/*!
 @method            copyPixelBufferForItemTime:itemTimeForDisplay:
 @abstract        Retrieves an image that is appropriate for display at the specified item time, and marks the image as acquired.
 @discussion
 The client is responsible for calling CVBufferRelease on the returned CVPixelBuffer when finished with it.
 
 Typically you would call this method in response to a CVDisplayLink callback or CADisplayLink delegate invocation and if hasNewPixelBufferForItemTime: also returns YES.
 
 The buffer reference retrieved from copyPixelBufferForItemTime:itemTimeForDisplay: may itself be NULL. A reference to a NULL pixel buffer communicates that nothing should be displayed for the supplied item time.
 @param            itemTime
 A CMTime that expresses a desired item time.
 @param            itemTimeForDisplay
 A CMTime pointer whose value will contain the true display deadline for the copied pixel buffer. Can be NULL.
 */

- (CVPixelBufferRef)copyPixelBufferForItemTime:(CMTime)seekTime itemTimeForDisplay:(nullable CMTime *)outItemTimeForDisplay;


@end
