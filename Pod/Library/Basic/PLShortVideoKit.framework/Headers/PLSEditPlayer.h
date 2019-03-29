//
//  PLSEditPlayer.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/7/10.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import "PLSTypeDefines.h"

@class PLSEditPlayer;

/*!
 @protocol PLSEditPlayerDelegate
 @brief 视频编辑播放器协议
 
 @since      v1.1.0
 */
@protocol PLSEditPlayerDelegate <NSObject>

@optional

/*!
 @method player:didGetOriginPixelBuffer:
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA

 @param player PLSEditPlayer 实例
 @param pixelBuffer CVPixelBufferRef 视频帧
 
 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef

 @since      v1.1.0
 */
- (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer __deprecated_msg("Method deprecated in v1.9.0. Use `player: didGetOriginPixelBuffer: timestamp:`");

/*!
 @method player:didGetOriginPixelBuffer:timestamp:
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA
 
 @param player PLSEditPlayer 实例
 @param pixelBuffer CVPixelBufferRef 视频帧
 @param timestamp 视频帧的时间戳
 
 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef
 
 @since      v1.9.0
 */
- (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timestamp:(CMTime)timestamp;

/*!
 @method player:didReadyToPlayForItem:timeRange
 @brief 当前视频的播放时刻达到了视频开头
 
 @param player PLSEditPlayer 实例
 @param item 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLSEditPlayer 的属性 @property (assign, nonatomic) CMTimeRange timeRange
 
 @since      v1.9.0
 */
- (void)player:(PLSEditPlayer *__nonnull)player didReadyToPlayForItem:(AVPlayerItem *__nonnull)item timeRange:(CMTimeRange)timeRange;

/*!
 @method player:didReachEndForItem:timeRange
 @brief 当前视频的播放时刻达到了视频结尾
 
 @param player PLSEditPlayer 实例
 @param item 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLSEditPlayer 的属性 @property (assign, nonatomic) CMTimeRange timeRange
 
 @since      v1.9.0
 */
- (void)player:(PLSEditPlayer *__nonnull)player didReachEndForItem:(AVPlayerItem *__nonnull)item timeRange:(CMTimeRange)timeRange;

@end

/*!
 @class PLSEditPlayer
 @brief 视频编辑播放器类
 
 @since      v1.1.0
 */
@interface PLSEditPlayer : AVPlayer

/*!
 @property delegate
 @brief id<PLSEditPlayerDelegate> 类型代理
 
 @since      v1.1.0
 */
@property (weak, nonatomic) __nullable id<PLSEditPlayerDelegate> delegate;

/*!
 @property loopEnabled
 @brief 循环播放。设置为 YE，表示单曲循环。默认为 NO
 
 @since      v1.1.0
 */
@property (assign, nonatomic) BOOL loopEnabled;

/*!
 @property isPlaying
 @brief 播放器是否在播放状态
 
 @since      v1.1.0
 */
@property (readonly, nonatomic) BOOL isPlaying;

/*!
 @property preview
 @brief 播放器的预览视图
 
 @since      v1.1.0
 */
@property (strong, nonatomic) UIView *__nullable preview;

/*!
 @property fillMode
 @brief 播放器预览视图的填充方式
 
 @since      v1.1.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/*!
 @property volume
 @brief 播放器的音量
 
 @since      v1.1.0
 */
@property (assign, nonatomic) float volume;

/*!
 @property timeRange
 @brief 播放器播放文件的 timeRange 范围内 [start, duration] 片段
 
 @since      v1.1.0
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/*!
 @property videoSize
 @brief 播放器播放视频的分辨率
 
 @since      v1.5.0
 */
@property (assign, nonatomic) CGSize videoSize;

/*!
 @method audioPlayer
 @brief 初始化音频播放器
 
 @return 音频播放器
 @since      v1.3.0
 */
+ (PLSEditPlayer *_Nullable)audioPlayer;

/*!
 @method setItemByStringPath:
 @brief 通过 stringPath 加载 AVPlayerItem
 
 @param stringPath 文件存放地址
 
 @since      v1.1.0
 */
- (void)setItemByStringPath:(NSString *__nullable)stringPath;

/*!
 @method setItemByUrl:
 @brief 通过 url 加载 AVPlayerItem
 
 @param url 文件存放地址
 
 @since      v1.1.0
 */
- (void)setItemByUrl:(NSURL *__nullable)url;

/*!
 @method setItemByAsset:
 @brief 通过 asset 加载 AVPlayerItem
 
 @param asset AVAsset 对象
 
 @since      v1.1.0
 */
- (void)setItemByAsset:(AVAsset *__nullable)asset;

/*!
 @method setItem:
 @brief 接收 item 去播放
 
 @param item AVPlayerItem 对象
 
 @since      v1.1.0
 */
- (void)setItem:(AVPlayerItem *__nullable)item;

/*!
 @method play
 @brief 播放
 
 @since      v1.1.0
 */
- (void)play;

/*!
 @method pause
 @brief 暂停
 
 @since      v1.1.0
 */
- (void)pause;

@end
