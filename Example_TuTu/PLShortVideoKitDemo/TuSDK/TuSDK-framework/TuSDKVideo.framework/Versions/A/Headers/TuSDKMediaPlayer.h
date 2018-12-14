//
//  TuSDKMediaAssetPlayer.h
//  TuSDKVideo
//
//  Created by sprint on 31/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 * 多媒体播放器接口
 * @since  v3.0
 */
@protocol TuSDKMediaPlayer <NSObject>

/**
 * 播放器的音频播放量，从0.0到1.0的线性范围。
 * @since  v3.0
 */
@property(nonatomic) float volume;

/**
 加载播放器
 @since  v3.0
 */
- (void)load;

/**
 * 开始播放
 * @since  v3.0
 */
- (void)play;

/**
 * 暂停播放
 * @since  v3.0
 */
- (void)pause;

/**
 * 停止播放
 * @since  v3.0
 */
- (void)stop;

/**
 获取已播放持续时间
 
 @return 播放持续时间
 @since    v3.0
 */
- (CMTime)currentTime;

/**
 * 将当前回放时间设置为指定的时间
 * @since  v3.0
 */
- (void)seekToTime:(CMTime)outputTime;

/**
 验证当前播放器是否支持倒序播放
 
 @return true/false
 @since  v3.0
 */
- (BOOL)canSupportedReverse;

/**
 销毁播放器并释放持有的资源
 
 @since v3.0.1
 */
- (void)destory;

@end
