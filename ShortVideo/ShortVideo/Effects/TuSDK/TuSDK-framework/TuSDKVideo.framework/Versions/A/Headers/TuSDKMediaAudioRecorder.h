//
//  TuSDKMediaAudioRecorder.h
//  TuSDKVideo
//
//  Created by tutu on 2018/8/2.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TuSDKMediaAudioRecorder <NSObject>

/**
 开始录音
 @since  v3.0
 */
- (void)startRecord;

/**
 停止录音
 @since  v3.0
 */
- (void)stopRecord;

/**
 暂停录音
 @since  v3.0
 */
- (void)pauseRecord;

/**
 继续录制
 @since  v3.0
 */
- (void)resumeRecord;

/**
 取消录制
 @since  v3.0
 */
- (void)cancleRecord;

@end
