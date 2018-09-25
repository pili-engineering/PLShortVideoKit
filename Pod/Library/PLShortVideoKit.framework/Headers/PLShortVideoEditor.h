//
//  PLShortVideoEditor.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/7/10.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSEditPlayer.h"

@class PLShortVideoEditor;

@protocol PLShortVideoEditorDelegate <NSObject>

@optional

/**
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA
 
 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef
 
 @since      v1.5.0
 */
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer __deprecated_msg("Method deprecated in v1.9.0. Use `shortVideoEditor: didGetOriginPixelBuffer: timestamp:`");

/**
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA
 @param timestamp 视频帧的时间戳
 
 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef
 
 @since      v1.9.0
 */
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp;

/**
 @brief 当前视频的播放时刻达到了视频开头
 @param asset 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLShortVideoEditor 的属性 @property (assign, nonatomic) CMTimeRange timeRange
 
 @since      v1.9.0
 */
- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReadyToPlayForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange;

/**
 @brief 当前视频的播放时刻达到了视频结尾
 @param asset 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLShortVideoEditor 的属性 @property (assign, nonatomic) CMTimeRange timeRange

 @since      v1.9.0
 */
- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReachEndForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange;

@end


@interface PLShortVideoEditor : NSObject

/**
 @brief 编辑完成时的 block 回调
 
 @since      v1.1.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @brief delegate
 
 @since      v1.5.0
 */
@property (weak, nonatomic) id<PLShortVideoEditorDelegate> delegate;

/**
 @brief 编辑时的预览视图
 
 @since      v1.5.0
 */
@property (strong, nonatomic, readonly) UIView *previewView;

/**
 @brief 预览视图的填充方式
 
 @since      v1.1.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/**
 @brief 循环播放。设置为 YE，表示单曲循环。默认为 NO
 
 @since      v1.5.0
 */
@property (assign, nonatomic) BOOL loopEnabled;

/**
 @brief  处于编辑状态时为 YES
 
 @since      v1.9.0
 */
@property (assign, nonatomic, readonly) BOOL isEditing;

/**
 @brief 播放文件的 timeRange 范围内 [start, duration] 片段
 
 @since      v1.5.0
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/**
 @brief 通过该参数可以设置视频的预览分辨率
 
 @since      v1.5.0
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @brief 原视频的音量
 
 @since      v1.5.0
 */
@property (assign, nonatomic, readwrite) CGFloat volume;

/**
 @brief 背景音乐的音量
 
 @since      v1.5.0
 */
@property (nonatomic, readonly) CGFloat musicVolume;

/**
 @brief 延迟背景音乐的播放，单位为毫秒，默认值为 0
        建议使用 视频帧间隔*(视频帧率/2) * 1000 毫秒
        比如：视频帧率为30帧/秒，延迟时间为 （1.0/30)*(30/2)*1000 = 500毫秒，
        即 delayTimeForMusicToPlay = 500
 
 @since      v1.8.0
 */
@property (assign, nonatomic) CGFloat delayTimeForMusicToPlay;

/**
 @brief 使用 NSURL 初始化编辑实例
 
 @since      v1.1.0
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 @brief 使用 AVAsset 初始化编辑实例
 
 @since      v1.1.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/**
 @brief 使用 AVAsset 初始化编辑实例
 *
 *  @param asset 原视频，即被编辑的视频素材
 *  @param videoSize 编辑时的预览分辨率，当取值为 CGSizeZero 时，预览分辨率为原视频的分辨率，当取值为(width, height)时，预览分辨率为(width, height)

 @since      v1.5.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset videoSize:(CGSize)videoSize;

/**
 @brief 使用 AVPlayerItem 初始化编辑实例
 *
 *  @param playerItem 原视频，即被编辑的视频素材
 *  @param videoSize 编辑时的预览分辨率，当取值为 CGSizeZero 时，预览分辨率为原视频的分辨率，当取值为(width, height)时，预览分辨率为(width, height)
 
 @since      v1.11.0
 */
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem videoSize:(CGSize)videoSize;

/**
 @brief 加载编辑信息，实时预览编辑效果
 
 @since      v1.1.0
 */
- (void)startEditing;

/**
 @brief 停止实时预览编辑效果
 
 @since      v1.1.0
 */
- (void)stopEditing;

/**
 @brief 替换当前的 AVAsset 对象
 
 @since      v1.5.0
 */
- (void)replaceCurrentAssetWithAsset:(AVAsset *)asset;

/**
 @brief 当前播放时刻
 
 @since      v1.9.0
 */
- (CMTime)currentTime;

/**
 @brief seek 到视频的 time 时刻
 
 @since      v1.9.0
 */
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

/**
 *  添加滤镜效果
 *
 *  @param colorImagePath 当前使用的滤镜的颜色表图的路径
 *  当 colorImagePath 为 nil 时，表示移除滤镜。
 
 @since      v1.5.0
 */
- (void)addFilter:(NSString *)colorImagePath;

/**
 *  添加 MV 图层方法 1, 相当于 addMVLayerWithColor:colorURL alpha:alphaURL timeRange:kCMTimeRangeZero loopEnable:NO
 *
 *  @param colorURL 彩色层视频的地址
 *  @param alphaURL 被彩色层当作透明层的视频的地址
 *  目前支持添加一层 MV 图层。当 colorURL = nil 和 alphaURL = nil 时，表示移除 MV 图层。
 
 @since      v1.5.0
 */
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL;

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
 *  添加背景音乐
 *
 *  @param musicURL 当前使用的背景音乐的地址
 *  @param timeRange 当前使用的背景音乐的有效时间区域(start, duration)，如果想使用整段音乐，可以将其设置为 kCMTimeRangeZero 或者 (kCMTimeZero, duration)
 *  @param volume 当前使用的背景音乐的音量
 *  warning: 默认循环播放当前背景音乐
 
 @since      v1.5.0
 */
- (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume;

/**
 *  添加背景音乐
 *
 *  @param musicURL 当前使用的背景音乐的地址
 *  @param timeRange 当前使用的背景音乐的有效时间区域(start, duration)，如果想使用整段音乐，可以将其设置为 kCMTimeRangeZero 或者 (kCMTimeZero, duration)
 *  @param volume 当前使用的背景音乐的音量
 *  @param loopEnable 当前使用的背景音乐是否循环播放
 
 @since      v1.11.0
 */
- (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume loopEnable:(BOOL)loopEnable;

/**
 *  更新背景音乐
 *
 *  @param timeRange 使用 kCMTimeRangeZero 时，表示不更新背景音乐的播放时间区域
 *  @param volume 使用 nil 时，表示不更新背景音乐的音量
 *  只更新 timeRange 时，[xxxObj updateMusic:timeRange volume:nil]
 *  只更新 volume    时，[xxxObj updateMusic:kCMTimeRangeZero volume:volume]
 
 @since      v1.5.0
 */
- (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume;

/**
 *  更新多个背景音效
 *
 *  @param multiMusicsSettings 多个背景音效的设置信息。每个元素都为字典，信息由 PLSAudioSettingsKey 配置
 
 @since      v1.11.0
 */
- (void)updateMultiMusics:(NSArray <NSDictionary *>*)multiMusicsSettings;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 
 @since      v1.5.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 *  @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 
 @since      v1.14.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position size:(CGSize)size;

/**
 *  移除水印
 
 @since      v1.5.0
 */
- (void)clearWaterMark;

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


