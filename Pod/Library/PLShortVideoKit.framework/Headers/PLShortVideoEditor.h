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
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end


@interface PLShortVideoEditor : NSObject

@property (strong, nonatomic) PLSEditPlayer *player __deprecated_msg("Method deprecated in v1.5.0. Use `PLSEditPlayer`");
@property (strong, nonatomic) PLSEditPlayer *audioPlayer __deprecated_msg("Method deprecated in v1.5.0. Use `[PLSEditPlayer audioPlayer]`");

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
 @brief 使用 NSURL 初始化编辑实例
 
 @since      v1.1.0
 */
- (instancetype)initWithURL:(NSURL *)url __deprecated_msg("Method deprecated in v1.5.0.");

/**
 @brief 使用 AVAsset 初始化编辑实例
 
 @since      v1.1.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset __deprecated_msg("Method deprecated in v1.5.0.");

/**
 @brief 使用 AVAsset 初始化编辑实例
 *
 *  @param asset 原视频，即被编辑的视频素材
 *  @param videoSize 编辑时的预览分辨率，当取值为 CGSizeZero 时，预览分辨率为原视频的分辨率，当取值为(width, height)时，预览分辨率为(width, height)

 @since      v1.5.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset videoSize:(CGSize)videoSize;

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
 *  添加滤镜效果
 *
 *  @param colorImagePath 当前使用的滤镜的颜色表图的路径
 *  当 colorImagePath 为 nil 时，表示移除滤镜。
 
 @since      v1.5.0
 */
- (void)addFilter:(NSString *)colorImagePath;

/**
 *  添加 MV 图层
 *
 *  @param colorURL 彩色层视频的地址
 *  @param alphaURL 被彩色层当作透明层的视频的地址
 *  目前支持添加一层 MV 图层。当 colorURL = nil 和 alphaURL = nil 时，表示移除 MV 图层。
 
 @since      v1.5.0
 */
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL;

/**
 *  添加背景音乐
 *
 *  @param musicURL 当前使用的背景音乐的地址
 *  @param timeRange 当前使用的背景音乐的有效时间区域(start, duration)，如果想使用整段音乐，可以将其设置为 kCMTimeRangeZero 或者 (kCMTimeZero, duration)
 *  @param volume 当前使用的背景音乐的音量
 
 @since      v1.5.0
 */
- (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume;

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
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 
 @since      v1.5.0
 */
- (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

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


