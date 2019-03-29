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

/*!
 @method setWaterMarkWithImage:position:
 @brief 开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 
 @since      v1.1.0
 */
- (void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position;

/*!
 @method setWaterMarkWithImage:position:size:
 @brief开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 
 @since      v1.14.0
 */
- (void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position size:(CGSize)size;

/*!
 @method setWaterMarkWithImage:position:size:waterMarkType:alpha:rotateDegree:
 @brief 开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 @param type           水印的类型
 @param alpha          水印的透明度 (0 ~ 1)
 @param degree         水印旋转角度 (单位：度)
 
 @since      v1.15.0
 */
- (void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position size:(CGSize)size waterMarkType:(PLSWaterMarkType)type alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;

/*!
 @method setGifWaterMarkWithData:position:size:alpha:rotateDegree:
 @brief 开启水印，此方法只能设置 gif 水印
 
 @param gifData        gif 图片数据
 @param position       水印的位置
 @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 @param alpha          水印的透明度 (0 ~ 1)
 @param degree         水印旋转角度 (单位：度)
 
 @since      v1.15.0
 */
- (void)setGifWaterMarkWithData:(NSData *)gifData position:(CGPoint)position size:(CGSize)size alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;

/*!
 @method clearWaterMark
 @brief  移除水印
 
 @since      v1.1.0
 */
- (void)clearWaterMark;

/*!
 @method addFilter:
 @brief 添加滤镜效果
 
 @param colorImagePath 当前使用的滤镜的颜色表图的路径
 
 @since      v1.5.0
 */
- (void)addFilter:(NSString *_Nullable)colorImagePath;

/*!
 @method addMVLayerWithColor:alpha:
 @brief  添加 MV 图层方法 1, 相当于 addMVLayerWithColor:colorURL alpha:alphaURL timeRange:kCMTimeRangeZero loopEnable:NO
 
 @param colorURL 彩色层视频的地址
 @param alphaURL 被彩色层当作透明层的视频的地址
 
 @since      v1.5.0
 */
- (void)addMVLayerWithColor:(NSURL *_Nullable)colorURL alpha:(NSURL *_Nullable)alphaURL;

/*!
 @method addMVLayerWithColor:alpha:timeRange:loopEnable:
 @brief  添加 MV 图层方法 2
 
 @param colorURL 彩色层视频的地址
 @param alphaURL 被彩色层当作透明层的视频的地址
 @param timeRange  选取 MV 文件的时间段, 如果选取整个 MV，直接传入 kCMTimeRangeZero 即可
 @param loopEnable 当 MV 时长(timeRange.duration)小于视频时长时，是否循环播放 MV
 
 @since      v1.14.0
 */
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL timeRange:(CMTimeRange)timeRange loopEnable:(BOOL)loopEnable;

/*!
 @method rotateVideoLayer
 @brief 旋转视频的方向，能将竖屏视频旋转为横屏视频，横屏视频旋转为竖屏视频
 
 @return PLSPreviewOrientation 当前视频的方向
 
 @since      v1.7.0
 */
- (PLSPreviewOrientation)rotateVideoLayer;

/*!
 @method resetVideoLayerOrientation
 @brief 重置视频的旋转方向，视频的方向被置为视频的原始方向
 
 @since      v1.7.0
 */
- (void)resetVideoLayerOrientation;

@end
