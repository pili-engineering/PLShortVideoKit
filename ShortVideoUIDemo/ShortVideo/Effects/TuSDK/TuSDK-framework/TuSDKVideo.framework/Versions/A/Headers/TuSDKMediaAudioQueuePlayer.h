//
//  TuSDKMediaAudioQueuePlayer.h
//  TuSDKVideo
//
//  Created by sprint on 2018/6/4.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>
#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaAudioBufferPlayer.h"
#import "TuSDKAudioResampleEngine.h"
#import "TuSDKAudioPitchEngine.h"

@protocol TuSDKMediaAudioQueuePlayerSync;

//
//  TuSDKMediaAudioQueuePlayer.h
//  TuSDKVideo
//
//  Created by sprint on 31/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//  @since  v3.0
//
@interface TuSDKMediaAudioQueuePlayer : NSObject <TuSDKMediaAudioBufferPlayer,TuSDKAudioPitchEngineDelegate , TuSDKAudioResampleEngineDelegate>

/**
 音频格式信息
 @since  v3.0
 */
@property (nonatomic)const CMFormatDescriptionRef formatDescriptionRef;

/**
 是否自动播放
 @since  v3.0
 */
@property (nonatomic)BOOL autoPlay;

/**
 是否正在播放中
 @since  v3.0
 */
@property (nonatomic)BOOL isPlaying;

/**
 * 播放器的音频播放量，从0.0到1.0的线性范围。 默认：1.0
 * @since  v3.0
 */
@property(nonatomic) float volume;

/**
 速率调整 （0 - 2）
 @since      v3.0
 */
@property (nonatomic) CGFloat speedRate;

/**
 标记是否倒序播放 speedRate 和 reverse 二选一
 @since      v3.0
 */
@property (nonatomic) BOOL reverse;

@end


#pragma mark - AudioEngine

/**
 音频引擎
 @since v3.0
 */
@interface TuSDKMediaAudioQueuePlayer (AudioEngine)

/**
 变声变调对象

 @param inputFormatDescriptionRef 输入的格式信息
 @return TuSDKAudioPitchEngine
 @since v3.0
 */
- (TuSDKAudioPitchEngine *)prepareAudioPitchEngine:(CMFormatDescriptionRef)inputFormatDescriptionRef;

/**
 重采样对象 支持倒序

 @param inputFormatDescriptionRef 输入的格式信息
 @return TuSDKAudioResampleEngine
 @since v3.0
 */
- (TuSDKAudioResampleEngine *)prepareAudioResampleEngine:(CMFormatDescriptionRef)inputFormatDescriptionRef;

/**
 指示audio引擎输入完成
 @since v3.0
 */
- (void)makeAudioEngineWriteEnd;

@end

