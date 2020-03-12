//
//  TuSDKMediaCompositionSampleBuffer.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/6.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一帧数据缓存，可自动管理 CMSampleBufferRef 的生命周期
 @since v3.4.1
 */
@interface TuSDKMediaCompositionSampleBuffer : NSObject

/**
 初始化 TuSDKMediaCompositionSampleBuffer

 @param bufferRef CMSampleBufferRef
 @return TuSDKMediaCompositionSampleBuffer
 @since v3.4.1
 */
-(instancetype)initWithSampleBuffer:(CMSampleBufferRef)bufferRef;

/**
 数据缓存
 @since v3.4.1
 */
@property (nonatomic,readonly)CMSampleBufferRef sampleBufferRef;

/**
 当前输出时间 默认 CMSampleBufferGetOutputPresentationTimeStamp
 @since v3.4.1
 */
@property (nonatomic)CMTime outputTime;

/**
 释放持有的数据缓存
 @since v3.4.1
 */
-(void)destory;

@end

NS_ASSUME_NONNULL_END
