//
//  TuSDKTSAudioRecorder.h
//  TuSDKVideo
//
//  Created by wen on 26/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKAudioResult.h"
#import "TuSDKVideoImport.h"

/**
 TuSDKTSAudioRecorder 录音状态
 */
typedef NS_ENUM(NSInteger,lsqAudioRecordingStatus)
{
    /**
     *  未知状态
     */
    lsqAudioRecordingStatusUnknown,
    
    /**
     * 正在录音
     */
    lsqAudioRecordingStatusRecording,
    
    /**
     * 正在录音
     */
    lsqAudioRecordingStatusPause,
    
    /**
     * 录音完成
     */
    lsqAudioRecordingStatusCompleted,
    
    /**
     * 录音失败
     */
    lsqAudioRecordingStatusFailed,
    
    /**
     * 已取消
     */
    lsqAudioRecordingStatusCancelled
    
};

@class TuSDKTSAudioRecorder;

#pragma mark - protocol TuSDKTSAudioRecoderDelegate

@protocol TuSDKTSAudioRecoderDelegate <NSObject>

@optional
// 状态通知代理
- (void)onAudioRecoder:(TuSDKTSAudioRecorder *)recoder statusChanged:(lsqAudioRecordingStatus)status;
// 结果通知代理
- (void)onAudioRecoder:(TuSDKTSAudioRecorder *)recoder result:(TuSDKAudioResult *)result;
// 中断开始 例如：来电等
- (void)onAudioRecoderBeginInterruption:(TuSDKTSAudioRecorder *)recoder;
// 中断已结束
- (void)onAudioRecoderEndInterruption:(TuSDKTSAudioRecorder *)recoder;

@end


/**
 录音
 */
@interface TuSDKTSAudioRecorder : NSObject

// 状态
@property (nonatomic, readonly, assign) lsqAudioRecordingStatus status;
// 代理
@property (nonatomic, weak) id<TuSDKTSAudioRecoderDelegate> recordDelegate;

// 最大录制时长， 默认: -1 不限制录制时长
@property (nonatomic, assign) CGFloat maxRecordingTime;
// 已录制的时长
@property (nonatomic, readonly ,assign) CGFloat duration;
// 录制时的设置 若有需要可自定义设置 默认包括 录音格式：kAudioFormatLinearPCM   采样率：8000   声道：双声道   采样点位数：8  是否采用浮点数采样：YES
@property (nonatomic, assign) NSDictionary *recorderSettings;

/**
  开始录音
 */
- (BOOL)startRecording;

/**
  暂停录音
 */
- (void)pauseRecording;

/**
  结束录音 保留录制内容
 */
- (void)finishRecording;

/**
  取消录音 同时删除已录制内容
 */
- (BOOL)cancelRecording;


@end
