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
@end


