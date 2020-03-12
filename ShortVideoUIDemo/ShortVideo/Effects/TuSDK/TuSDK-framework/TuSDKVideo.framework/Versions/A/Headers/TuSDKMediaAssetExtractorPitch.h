//
//  TuSDKMediaAssetExtractorPitch.h
//  TuSDKVideo
//
//  Created by sprint on 2019/8/7.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 低帧率视频补帧补丁
 @since v3.4.2
 */
@interface TuSDKMediaAssetExtractorPitch : NSObject

/**
 上一帧视频输出时间
 @since v3.4.2
 */
@property (nonatomic) CMTime preOutputPresentationTimeStamp;

/**
 最小帧间隔，使用此字段确定输出帧率
 @since v3.4.2
 */
@property (nonatomic) CMTime frameDuration;

/**
 原视频的平均帧间隔时长，用于对第一帧时长过长时的补帧
 @since v3.4.6
 */
@property (nonatomic) CMTime naturalFrameDuration;

/**
 是否需要该补丁
 @since v3.4.2
 */
@property (nonatomic,readonly) BOOL needPitch;

/**
 设置当前输出视频帧 会与 preOutputPresentationTimeStamp 比较确定是否需要补帧
 @since v3.4.2
 */
@property (nonatomic) CMSampleBufferRef outputSampleBuffer;

/**
 重置补丁
 @since v3.4.2
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
