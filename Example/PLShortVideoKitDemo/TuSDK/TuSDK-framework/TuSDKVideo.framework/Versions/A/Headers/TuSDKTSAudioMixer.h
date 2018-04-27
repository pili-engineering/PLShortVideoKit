//
//  TuSDKTSAudioMixer.h
//  TuSDKVideo
//
//  Created by wen on 22/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTSAudio.h"
#import "TuSDKAudioResult.h"


/**
 TuSDKTSAudioMixer 音频混合状态
 */
typedef NS_ENUM(NSInteger,lsqAudioMixStatus)
{
    /**
     *  未知状态
     */
    lsqAudioMixStatusUnknown,
        
    /**
     * 正在混合
     */
    lsqAudioMixStatusMixing,
    
    /**
     * 操作完成
     */
    lsqAudioMixStatusCompleted,
    
    /**
     * 操作失败
     */
    lsqAudioMixStatusFailed,
    
    /**
     * 已取消
     */
    lsqAudioMixStatusCancelled
    
};

@class TuSDKTSAudioMixer;

#pragma mark - protocol TuSDKTSAudioMixerDelegate

/**
 多音频混合代理
 */
@protocol TuSDKTSAudioMixerDelegate <NSObject>

@optional
// 状态通知代理
- (void)onAudioMix:(TuSDKTSAudioMixer *)editor statusChanged:(lsqAudioMixStatus)status;
// 结果通知代理
- (void)onAudioMix:(TuSDKTSAudioMixer *)editor result:(TuSDKAudioResult *)result;

@end

#pragma mark - TuSDKTSAudioMixer

/**
 多音频混合

 功能：
 1、将一个音频(可设定时间范围)，与一个音频(可设定时间范围)混合
 2、将一个音频(可设定时间范围)，与多个音频(可设定时间范围)混合
 3、导出一个视频中的音轨

 */
@interface TuSDKTSAudioMixer : NSObject
// 状态
@property (nonatomic, readonly, assign) lsqAudioMixStatus status;
// 代理
@property (nonatomic, weak) id<TuSDKTSAudioMixerDelegate> mixDelegate;

// 主音频，即背景音频，在混合过程中，主音频不变
@property (nonatomic, strong) TuSDKTSAudio *mainAudio;
// 混合音频，即要添加在主音频上混合音频
@property (nonatomic, strong) NSArray<TuSDKTSAudio *> *mixAudios;
// 音频是否可循环 默认 NO 不循环
@property (nonatomic, assign) BOOL enableCycleAdd;

// 通过代理回调
- (void)startMixingAudio;

// 通过block回调 同时 若实现了代理，也会在代理中通知
- (void)startMixingAudioWithCompletion:(void (^)(NSURL* fileURL, lsqAudioMixStatus status))handler;

// 取消混合操作
- (void)cancelMixing;

@end


