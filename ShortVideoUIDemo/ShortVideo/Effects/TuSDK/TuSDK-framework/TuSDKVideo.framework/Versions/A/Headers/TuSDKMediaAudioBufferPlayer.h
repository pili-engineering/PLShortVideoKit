//
//  TuSDKMediaAudioBufferPlayer.h
//  TuSDKVideo
//
//  Created by sprint on 20/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaPlayer.h"

/**
 音频PCM格式播放器
 @since  v3.0
 */
@protocol TuSDKMediaAudioBufferPlayer <NSObject,TuSDKMediaPlayer>

/**
 写入音频数据

 @param audioBuffer PCM 音频数据
 @since  v3.0
 */
- (void)writeAudioBuffer:(CMSampleBufferRef)audioBuffer;

/**
 写入音频数据
 
 @param audioBuffer PCM 音频数据
 @since  v3.0
 */
- (void)writeAudioBuffer:(CMSampleBufferRef)audioBuffer inputTime:(CMTime)inputTime;

/**
 清除数据
 @since  v3.0
 */
- (void)flush;

@end
