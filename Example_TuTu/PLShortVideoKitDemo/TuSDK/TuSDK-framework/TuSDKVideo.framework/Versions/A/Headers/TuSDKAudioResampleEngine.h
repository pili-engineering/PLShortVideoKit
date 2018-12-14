//
//  TuSDKAudioResampleEngine.h
//  TuSDKVideo
//
//  Created by tutu on 2018/7/30.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKAudioEngine.h"

@protocol TuSDKAudioResampleEngineDelegate;

@interface TuSDKAudioResampleEngine : NSObject <TuSDKAudioEngine>

/**
 * 改变音频播放速度
 * @since v3.0
 */
@property (nonatomic) float speed;

/**
 * TuSDKAudioResampleEngineDelegate
 * @since v3.0
 */
@property (nonatomic, weak) id<TuSDKAudioResampleEngineDelegate> delegate;

/**
 * 改变音频序列
 * @since v3.0
 */
@property (nonatomic) BOOL reverse;

/**
 * 音频的原始信息
 * @since v3.0
 */
@property (nonatomic, strong) TuSDKAudioTrackInfo *inputInfo;

/**
 * TuSDKAudioResampleEngine初始化
 * @param inputInfo 音频输入信息
 * @param outputInfo 音频输出信息
 * @return TuSDKAudioResampleEngine
 * @since v3.0
 */
- (instancetype)initWithInputAudioInfo:(TuSDKAudioTrackInfo *)inputInfo outputAudioInfo:(TuSDKAudioTrackInfo *)outputInfo;

@end

#pragma mark - TuSDKAudioResampleEngineDelegate

@protocol TuSDKAudioResampleEngineDelegate

/**
 * 输出音频数据
 * @param output CMSampleBufferRef
 * @since v3.0
 */
- (void)resampleEngine:(TuSDKAudioResampleEngine *)resampleEngine syncAudioResampleOutputBuffer:(CMSampleBufferRef)output autoRelease:(BOOL *)autoRelese;

@end
