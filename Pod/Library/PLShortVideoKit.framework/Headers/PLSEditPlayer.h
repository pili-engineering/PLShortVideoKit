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

@protocol PLSEditPlayerDelegate <NSObject>

@optional

/**
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA

 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef

 @since      v1.1.0
 */
- (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer __deprecated_msg("Method deprecated in v1.9.0. Use `player: didGetOriginPixelBuffer: timestamp:`");

/**
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA
 @param timestamp 视频帧的时间戳

 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef
 
 @since      v1.9.0
 */
- (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timestamp:(CMTime)timestamp;

/**
 @brief 当前视频的播放时刻达到了视频开头
 @param item 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLSEditPlayer 的属性 @property (assign, nonatomic) CMTimeRange timeRange
 
 @since      v1.9.0
 */
- (void)player:(PLSEditPlayer *__nonnull)player didReadyToPlayForItem:(AVPlayerItem *__nonnull)item timeRange:(CMTimeRange)timeRange;

/**
 @brief 当前视频的播放时刻达到了视频结尾
 @param item 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLSEditPlayer 的属性 @property (assign, nonatomic) CMTimeRange timeRange
 
 @since      v1.9.0
 */
- (void)player:(PLSEditPlayer *__nonnull)player didReachEndForItem:(AVPlayerItem *__nonnull)item timeRange:(CMTimeRange)timeRange;

@end


@interface PLSEditPlayer : AVPlayer

/**
 @brief delegate
 
 @since      v1.1.0
 */
@property (weak, nonatomic) __nullable id<PLSEditPlayerDelegate> delegate;

/**
 @brief 循环播放。设置为 YE，表示单曲循环。默认为 NO
 
 @since      v1.1.0
 */
@property (assign, nonatomic) BOOL loopEnabled;

/**
 @brief 播放器是否在播放状态
 
 @since      v1.1.0
 */
@property (readonly, nonatomic) BOOL isPlaying;

/**
 @brief 播放器的预览视图
 
 @since      v1.1.0
 */
@property (strong, nonatomic) UIView *__nullable preview;

/**
 @brief 播放器预览视图的填充方式
 
 @since      v1.1.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/**
 @brief 播放器的音量
 
 @since      v1.1.0
 */
@property (assign, nonatomic) float volume;

/**
 @brief 播放器播放文件的 timeRange 范围内 [start, duration] 片段
 
 @since      v1.1.0
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/**
 @brief 播放器播放视频的分辨率
 
 @since      v1.5.0
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @brief 初始化音频播放器
 
 @since      v1.3.0
 */
+ (PLSEditPlayer *_Nullable)audioPlayer;

/**
 @brief 通过 stringPath 加载 AVPlayerItem
 
 @since      v1.1.0
 */
- (void)setItemByStringPath:(NSString *__nullable)stringPath;

/**
 @brief 通过 url 加载 AVPlayerItem
 
 @since      v1.1.0
 */
- (void)setItemByUrl:(NSURL *__nullable)url;

/**
 @brief 通过 asset 加载 AVPlayerItem
 
 @since      v1.1.0
 */
- (void)setItemByAsset:(AVAsset *__nullable)asset;

/**
 @brief 接收 item 去播放
 
 @since      v1.1.0
 */
- (void)setItem:(AVPlayerItem *__nullable)item;

/**
 @brief 播放
 
 @since      v1.1.0
 */
- (void)play;

/**
 @brief 暂停
 
 @since      v1.1.0
 */
- (void)pause;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 
 @since      v1.1.0
 */
-(void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 *  @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 
 @since      v1.14.0
 */
-(void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position size:(CGSize)size;

/**
 *  移除水印
 
 @since      v1.1.0
 */
-(void)clearWaterMark;

/**
 *  添加滤镜效果
 *
 *  @param colorImagePath 当前使用的滤镜的颜色表图的路径
 
 @since      v1.5.0
 */
- (void)addFilter:(NSString *_Nullable)colorImagePath;

/**
 *  添加 MV 图层方法 1, 相当于 addMVLayerWithColor:colorURL alpha:alphaURL timeRange:kCMTimeRangeZero loopEnable:NO
 *
 *  @param colorURL 彩色层视频的地址
 *  @param alphaURL 被彩色层当作透明层的视频的地址
 
 @since      v1.5.0
 */
- (void)addMVLayerWithColor:(NSURL *_Nullable)colorURL alpha:(NSURL *_Nullable)alphaURL;

/**
 *  添加 MV 图层方法 2
 *
 *  @param colorURL 彩色层视频的地址
 *  @param alphaURL 被彩色层当作透明层的视频的地址
 *  @param timeRange  选取 MV 文件的时间段, 如果选取整个 MV，直接传入 kCMTimeRangeZero 即可
 *  @param loopEnable 当 MV 时长(timeRange.duration)小于视频时长时，是否循环播放 MV
 
 @since      v1.14.0
 */
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL timeRange:(CMTimeRange)timeRange loopEnable:(BOOL)loopEnable;

/**
 @brief 旋转视频的方向，能将竖屏视频旋转为横屏视频，横屏视频旋转为竖屏视频
 *
 *  return PLSPreviewOrientation 当前视频的方向
 
 @since      v1.7.0
 */
- (PLSPreviewOrientation)rotateVideoLayer;

/**
 @brief 重置视频的旋转方向，视频的方向被置为视频的原始方向
 
 @since      v1.7.0
 */
- (void)resetVideoLayerOrientation;

@end
