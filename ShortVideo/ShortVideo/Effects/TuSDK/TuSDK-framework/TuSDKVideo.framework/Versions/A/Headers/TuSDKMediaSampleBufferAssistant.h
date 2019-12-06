//
//  TuSDKMediaSampleBufferAssistant.h
//  TuSDKVideo
//
//  Created by sprint on 27/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/**
 CMSampleBufferRef 助手
 
 @since v3.0
 */
@interface TuSDKMediaSampleBufferAssistant : NSObject

/**
 获取CMSampleBufferRef音频数据地址
 @param buffer 原始数据buffer
 @return 数据地址
 @since v3.0
 */
+ (int8_t *)processSampleBuffer:(CMSampleBufferRef)buffer;

/**
 重新封包生成CMSampleBufferRef
 @param audioData 音频数据地址
 @param len 音频数据长度
 @param timing 音频数据时间信息
 @param asbd 音频数据格式描述信息
 @return 音频数据
 @since v3.0
 */
+ (CMSampleBufferRef)createAudioSample:(int8_t *)audioData length:(UInt32)len timing:(CMSampleTimingInfo)timing audioStreamBasicDescription:(AudioStreamBasicDescription)asbd;

/**
 重新封包生成CMSampleBufferRef
 @param audioData 音频数据地址
 @param len 音频数据长度
 @param time 音频数据时间
 @param asbd 音频数据格式描述信息
 @return 音频数据
 @since v3.0
 */
+ (CMSampleBufferRef)createAudioSample:(int8_t *)audioData length:(UInt32)len time:(long long)time audioStreamBasicDescription:(AudioStreamBasicDescription)asbd;

/**
 重设PTS后获取新的sampleBuffer
 @param sample 原始sampleBuffer
 @param speed 变速比率
 @return 新的sampleBuffer
 @since v3.0
 */
+ (CMSampleBufferRef)adjustPTS:(CMSampleBufferRef)sample bySpeed:(CGFloat)speed;

/**
 重设PTS后获取新的sampleBuffer
 @param sample 原始sampleBuffer
 @param offset 时间间隔
 @return 新的sampleBuffer
 @since v3.0
 */
+ (CMSampleBufferRef)adjustPTS:(CMSampleBufferRef)sample byOffset:(CMTime)offset;


+ (CMSampleBufferRef)copySampleBuffer:(CMSampleBufferRef)sampleBuffer outputTime:(CMTime)outputTime;

/**
 深拷贝sampleBuffer
 @param sampleBuffer CMSampleBufferRef
 @return CMSampleBufferRef
 @since v3.0
 */
+ (CMSampleBufferRef)sampleBufferCreateCopyWithDeep:(CMSampleBufferRef)sampleBuffer;

/**
 拷贝sampleBuffer
 @param sampleBuffer CMSampleBufferRef
 @return CMSampleBufferRef
 @since v3.0
 */
+ (CMSampleBufferRef)sampleBufferCreateCopy:(CMSampleBufferRef)sampleBuffer;

@end
