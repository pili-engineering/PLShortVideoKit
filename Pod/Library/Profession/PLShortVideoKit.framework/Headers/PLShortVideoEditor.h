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
/*!
 @protocol PLShortVideoEditorDelegate
 @brief 视频编辑协议
 */
@protocol PLShortVideoEditorDelegate <NSObject>

@optional

/*!
 @method shortVideoEditor:didGetOriginPixelBuffer:
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA
 
 @param editor PLShortVideoEditor 实例
 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef
 
 @since      v1.5.0
 */
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer __deprecated_msg("Method deprecated in v1.9.0. Use `shortVideoEditor: didGetOriginPixelBuffer: timestamp:`");

/*!
 @method shortVideoEditor:didGetOriginPixelBuffer:timestamp
 @brief 视频数据回调, pixelBuffer 类型为 kCVPixelFormatType_32BGRA
 
 @param editor PLShortVideoEditor 实例
 @param timestamp 视频帧的时间戳
 
 @return 返回 kCVPixelFormatType_32BGRA 类型的 CVPixelBufferRef
 
 @since      v1.9.0
 */
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp;

/*!
 @method shortVideoEditor:didReadyToPlayForAsset:timeRange
 @brief 当前视频的播放时刻达到了视频开头
 
 @param editor PLShortVideoEditor 实例
 @param asset 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLShortVideoEditor 的属性 @property (assign, nonatomic) CMTimeRange timeRange
 
 @since      v1.9.0
 */
- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReadyToPlayForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange;

/*!
 @method shortVideoEditor:didReachEndForAsset:timeRange
 @brief 当前视频的播放时刻达到了视频结尾
 
 @param editor PLShortVideoEditor 实例
 @param asset 当前视频
 @param timeRange 当前视频的有效视频区域，对应 PLShortVideoEditor 的属性 @property (assign, nonatomic) CMTimeRange timeRange

 @since      v1.9.0
 */
- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReachEndForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange;

@end

/*!
 @class PLShortVideoEditor
 @brief 视频编辑类
 
 @since      v1.1.0
 */
@interface PLShortVideoEditor : NSObject

/*!
 @property completionBlock
 @brief 编辑完成时的 block 回调
 
 @since      v1.1.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/*!
 @property delegate
 @brief <PLShortVideoEditorDelegate> 类型的代理
 
 @since      v1.5.0
 */
@property (weak, nonatomic) id<PLShortVideoEditorDelegate> delegate;

/*!
 @property previewView
 @brief 编辑时的预览视图
 
 @since      v1.5.0
 */
@property (strong, nonatomic, readonly) UIView *previewView;

/*!
 @property fillMode
 @brief 预览视图的填充方式
 
 @since      v1.1.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/*!
 @property loopEnabled
 @brief 循环播放。设置为 YES，表示单曲循环。默认为 NO
 
 @since      v1.5.0
 */
@property (assign, nonatomic) BOOL loopEnabled;

/*!
 @property isEditing
 @brief  处于编辑状态时为 YES
 
 @since      v1.9.0
 */
@property (assign, nonatomic, readonly) BOOL isEditing;

/*!
 @property timeRange
 @brief 播放文件的 timeRange 范围内 [start, duration] 片段
 
 @since      v1.5.0
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/*!
 @property videoSize
 @brief 通过该参数可以设置视频的预览分辨率
 
 @since      v1.5.0
 */
@property (assign, nonatomic) CGSize videoSize;

/*!
 @property volume
 @brief 原视频的音量
 
 @since      v1.5.0
 */
@property (assign, nonatomic, readwrite) CGFloat volume;

/*!
 @property musicVolume
 @brief 背景音乐的音量
 
 @since      v1.5.0
 */
@property (nonatomic, readonly) CGFloat musicVolume;

/*!
 @property delayTimeForMusicToPlay
 @brief 延迟背景音乐的播放，单位为毫秒，默认值为 0
        建议使用 视频帧间隔*(视频帧率/2) * 1000 毫秒
        比如：视频帧率为30帧/秒，延迟时间为 （1.0/30)*(30/2)*1000 = 500毫秒，
        即 delayTimeForMusicToPlay = 500
 
 @since      v1.8.0
 */
@property (assign, nonatomic) CGFloat delayTimeForMusicToPlay;

/*!
 @method initWithURL:
 @brief 使用 NSURL 初始化编辑实例
 
 @return PLShortVideoEditor 实例
 @since      v1.1.0
 */
- (instancetype)initWithURL:(NSURL *)url;

/*!
 @method initWithAsset:
 @brief 使用 AVAsset 初始化编辑实例
 
 @return PLShortVideoEditor 实例
 @since      v1.1.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/*!
 @method initWithAsset:videoSize
 @brief 使用 AVAsset 初始化编辑实例
 
 @param asset 原视频，即被编辑的视频素材
 @param videoSize 编辑时的预览分辨率，当取值为 CGSizeZero 时，预览分辨率为原视频的分辨率，当取值为(width, height)时，预览分辨率为(width, height)

 @return PLShortVideoEditor 实例
 @since      v1.5.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset videoSize:(CGSize)videoSize;

/*!
 @method initWithPlayerItem:videoSize
 @brief 使用 AVPlayerItem 初始化编辑实例
 
 @param playerItem 原视频，即被编辑的视频素材
 @param videoSize 编辑时的预览分辨率，当取值为 CGSizeZero 时，预览分辨率为原视频的分辨率，当取值为(width, height)时，预览分辨率为(width, height)
 
 @return PLShortVideoEditor 实例
 @since      v1.11.0
 */
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem videoSize:(CGSize)videoSize;

/*!
 @method startEditing
 @brief 加载编辑信息，实时预览编辑效果
 
 @since      v1.1.0
 */
- (void)startEditing;

/*!
 @method stopEditing
 @brief 停止实时预览编辑效果
 
 @since      v1.1.0
 */
- (void)stopEditing;

/*!
 @method replaceCurrentAssetWithAsset:
 @brief 替换当前的 AVAsset 对象
 
 @param asset 原视频，即被编辑的视频素材
 
 @since      v1.5.0
 */
- (void)replaceCurrentAssetWithAsset:(AVAsset *)asset;

/*!
 @method currentTime
 @brief 获取当前播放时刻
 
 @return 当前播放的时刻
 @since      v1.9.0
 */
- (CMTime)currentTime;

/*!
 @method seekToTime:completionHandler
 @brief seek 到视频的 time 时刻
 
 @param time seek 的时间点
 @param completionHandler seek 操作完成的回调
 
 @since      v1.9.0
 */
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

/*!
 @method addFilter:
 @brief 添加滤镜效果
 
 @param colorImagePath 当前使用的滤镜的颜色表图的路径，当 colorImagePath 为 nil 时，表示移除滤镜。
 
 @since      v1.5.0
 */
- (void)addFilter:(NSString *)colorImagePath;

/*!
 @method addMVLayerWithColor:alpha:
 @brief 添加 MV 图层方法 1, 相当于 addMVLayerWithColor:colorURL alpha:alphaURL timeRange:kCMTimeRangeZero loopEnable:NO
 
 @param colorURL 彩色层视频的地址
 @param alphaURL 被彩色层当作透明层的视频的地址
 
 @discussion 目前支持添加一层 MV 图层。当 colorURL = nil 和 alphaURL = nil 时，表示移除 MV 图层。
 
 @since      v1.5.0
 */
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL;

/*!
 @method addMVLayerWithColor:alpha:timeRange:loopEnable
 @brief 添加 MV 图层方法 2
 
 @param colorURL 彩色层视频的地址
 @param alphaURL 被彩色层当作透明层的视频的地址
 @param timeRange  选取 MV 文件的时间段, 如果选取整个 MV，直接传入 kCMTimeRangeZero 即可
 @param loopEnable 当 MV 时长(timeRange.duration)小于视频时长时，是否循环播放 MV
 
 @since      v1.14.0
 */
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL timeRange:(CMTimeRange)timeRange loopEnable:(BOOL)loopEnable;

/*!
 @method addMusic:timeRange:volume
 @brief 添加背景音乐 1
 
 @param musicURL 当前使用的背景音乐的地址
 @param timeRange 当前使用的背景音乐的有效时间区域(start, duration)，如果想使用整段音乐，可以将其设置为 kCMTimeRangeZero 或者 (kCMTimeZero, duration)
 @param volume 当前使用的背景音乐的音量
 
 @warning 默认循环播放当前背景音乐
 
 @since      v1.5.0
 */
- (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume;

/*!
 @method addMusic:timeRange:volume:loopEnable
 @brief 添加背景音乐 2
 
 @param musicURL 当前使用的背景音乐的地址
 @param timeRange 当前使用的背景音乐的有效时间区域(start, duration)，如果想使用整段音乐，可以将其设置为 kCMTimeRangeZero 或者 (kCMTimeZero, duration)
 @param volume 当前使用的背景音乐的音量
 @param loopEnable 当前使用的背景音乐是否循环播放
 
 @since      v1.11.0
 */
- (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume loopEnable:(BOOL)loopEnable;

/*!
 @method updateMusic:volume
 @brief 更新背景音乐
 
 @param timeRange 使用 kCMTimeRangeZero 时，表示不更新背景音乐的播放时间区域
 @param volume 使用 nil 时，表示不更新背景音乐的音量
 
 @discussion
    1. 只更新 timeRange 时，[xxxObj updateMusic:timeRange volume:nil]
    2. 只更新 volume    时，[xxxObj updateMusic:kCMTimeRangeZero volume:volume]
 
 @since      v1.5.0
 */
- (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume;

/*!
 @method updateMultiMusics:
 @brief 更新多个背景音效，相当于 updateMultiMusics:multiMusicsSettings keepMoviePlayerStatus:NO
 
 @param multiMusicsSettings 多个背景音效的设置信息。每个元素都为字典，信息由 PLSAudioSettingsKey 配置
 
 @since      v1.11.0
 */
- (void)updateMultiMusics:(NSArray <NSDictionary *>*)multiMusicsSettings;

/*!
 @method updateMultiMusics:keepMoviePlayerStatus
 @brief 更新多个背景音效 2
 
 @param multiMusicsSettings 多个背景音效的设置信息。每个元素都为字典，信息由 PLSAudioSettingsKey 配置
 @param keepStatus 添加多个背景音乐之后视频播放器是否保持当前状态，如果传 YES，视频播放器将不做任何处理。如果传入 NO,视频播放器将重新开始播放
 
 @since      v1.16.0
 */
- (void)updateMultiMusics:(NSArray <NSDictionary *>*)multiMusicsSettings keepMoviePlayerStatus:(BOOL)keepStatus;

/*!
 @method setWaterMarkWithImage:position
 @brief 开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 
 @since      v1.5.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/*!
 @method setWaterMarkWithImage:position:size
 @brief 开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 
 @since      v1.14.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position size:(CGSize)size;

/*!
 @method setWaterMarkWithImage:position:size:waterMarkType:alpha:rotateDegree
 @brief 开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 @param size           水印的大小，如果为 CGSizeZero，则使用水印图片的实际大小
 @param type           水印的类型
 @param alpha          水印的透明度 (0 ~ 1)
 @param degree         水印旋转角度 (单位：度)
 
 @since      v1.15.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position size:(CGSize)size waterMarkType:(PLSWaterMarkType)type alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;

/*!
 @method setGifWaterMarkWithData:position:size:alpha:rotateDegree
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
 @brief 移除水印
 
 @since      v1.5.0
 */
- (void)clearWaterMark;

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


