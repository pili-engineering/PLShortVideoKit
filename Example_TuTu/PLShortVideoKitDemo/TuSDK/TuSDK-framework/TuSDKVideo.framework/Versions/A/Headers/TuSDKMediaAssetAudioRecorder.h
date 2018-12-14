//
//  TuSDKAudioRecordConvert.h
//  TuSDKVideo
//
//  Created by tutu on 2018/7/26.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TuSDKAudioPitchEngine.h"
#import "TuSDKTSAudioRecorder.h"
#import "TuSDKMediaAudioRecorder.h"

@protocol TuSDKMediaAssetAudioRecorderDelegate;

/**
 音频录制
 支持变声及快慢速调节
 @since v3.0
 */
@interface TuSDKMediaAssetAudioRecorder : NSObject <TuSDKMediaAudioRecorder>

/**
 录音代理
 @since v3.0
 */
@property (nonatomic, weak) id<TuSDKMediaAssetAudioRecorderDelegate> delegate;

/**
 录音音调类型, 设置音调后速度设置失效
 @since v3.0
 */
@property (nonatomic, assign) TuSDKSoundPitchType pitchType;

/**
 录音速度, 设置速度后音调设置失效
 @since v3.0
 */
@property (nonatomic, assign) float speed;

/**
 最大录制时长， 默认: -1 不限制录制时长
 @since v3.0
 */
@property (nonatomic, assign) CGFloat maxRecordingTime;

/**
 删除最后一个音频片段
 @since v3.0
 */
- (void)popAudioFragment;

@end

#pragma mark - TuSDKMediaAssetAudioRecorderDelegate

/**
 TuSDKMediaAssetAudioRecorder 委托
 @since v3.0
 */
@protocol TuSDKMediaAssetAudioRecorderDelegate <NSObject>

/**
 录制完成
 @param mediaAssetAudioRecorde 录制对象
 @param filePath 录制结果
 @since v3.0
 */
- (void)mediaAssetAudioRecorder:(TuSDKMediaAssetAudioRecorder *)mediaAssetAudioRecorde filePath:(NSString *)filePath;

/**
 录制状态通知
 @param recoder 录制对象
 @param status 录制状态
 @since v3.0
 */
- (void)mediaAssetAudioRecorder:(TuSDKMediaAssetAudioRecorder *)recoder statusChanged:(lsqAudioRecordingStatus)status;

/**
 录制时间回调
 @param recoder 录制对象
 @param duration 已录制时长
 @since v3.0
 */
- (void)mediaAssetAudioRecorder:(TuSDKMediaAssetAudioRecorder *)recoder durationChanged:(CGFloat)duration;

@end
