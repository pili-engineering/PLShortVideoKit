//
//  PLShortVideoTranscoder.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/6/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

/*!
 * @abstract 视频转码
 * @discussion 对视频进行转码处理
 */
@interface PLShortVideoTranscoder : NSObject

/**
 @brief 将视频导出到相册，默认为 NO
 
 @since      v1.4.0
 */
@property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;

/**
 @abstract 视频转码后的地址
 
 @warning 生成 URL 需使用 [NSURL fileURLWithPath:fileName] 方式，让 URL 的 scheme 合法（file://，http://，https:// 等）。
 
 @since      v1.0.5
 */
@property (strong, nonatomic) NSURL *outputURL;

/**
 @abstract 视频转码后的格式，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.0.5
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/**
 @abstract 转码后视频的质量，默认为 PLSFilePresetHighestQuality
 
 @since      v1.0.5
 */
@property (assign, nonatomic) PLSFilePreset outputFilePreset;

/**
 @abstract 转码后视频的码率，默认为 6000 * 1000 bps，对应 PLSFilePresetHighestQuality
 @warn 只设置 outputFilePreset，不设置 bitrate，内部 bitrate 默认值如下：
 PLSFilePresetLowQuality,      默认对应 700 * 1000 bps
 PLSFilePresetMediumQuality,   默认对应 3000 * 1000 bps
 PLSFilePresetHighestQuality,  默认对应 6000 * 1000 bps
 PLSFilePreset640x480,         默认对应 2000 * 1000 bps
 PLSFilePreset960x540,         默认对应 3000 * 1000 bps
 PLSFilePreset1280x720,        默认对应 4000 * 1000 bps
 PLSFilePreset1920x1080,       默认对应 6000 * 1000  bps
 如果 bitrate 的值大于原始视频的视频码率，则重置 bitrate 的值为原始视频的视频码率。
 
 @since      v1.11.0
 */
@property (assign, nonatomic) float bitrate;

/**
 @abstract 转码的进度
 
 @since      v1.0.5
 */
@property (assign, nonatomic, readonly) float progress;

/**
 @abstract 设置需要转码的视频时间段，默认为视频的总时长
 
 @since      v1.0.5
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/**
 @abstract 调整视频方向，默认为 NO。设置为 YES，可调整视频方向，生成的视频不需要通过视频角度信息和分辨率来获取实际分辨率。
           比如 iPhone 相机拍摄的视频 (1920x1080, 90度, 纵向)，播放器播放预览分辨率为 1080x1920。
 
 @since      v1.1.1
 */
@property (assign, nonatomic) BOOL isAdjustVideoOrientation;

/**
 @abstract 视频旋转方向，默认为 PLSPreviewOrientationPortrait。
           PLSPreviewOrientationPortrait           = 0, 正立 0度
           PLSPreviewOrientationPortraitUpsideDown = 1, 180度
           PLSPreviewOrientationLandscapeRight     = 2, 270度
           PLSPreviewOrientationLandscapeLeft      = 3, 90度

 @since      v1.8.0
 */
@property (assign, nonatomic) PLSPreviewOrientation rotateOrientation;

/**
 @abstract 视频剪裁区域，默认为 CGRectZero，不剪裁. 如果不为 emptyRect，会覆盖 @property outputFilePreset,
           有效范围 [CGRectZero ~ {0, 0, videoOriginWidth, videoOriginHeight}]
 
 @since      v1.13.0
 */
@property (assign, nonatomic) CGRect videoSelectedRect;

/**
 @abstract 导出视频的宽高，仅当 videoSelectedRect 不是 emptyRect 时，destVideoSize 才有效。默认为 CGSizeZero, 此时导出
           视频的宽高为 videoSelectedRect.size. 每次设置 destVideoSize 的值的时候，bitrate 都会自动调整到合适的值。如果想
           自定义输出码率，设置 destVideoSize 之后，需要再次设置 bitrate 的值
 
 @since      v1.13.0
 */
@property (assign, nonatomic) CGSize destVideoSize;

/**
 @abstract 导出视频的帧率，默认 0，有效范围 [0 ~ 原视频帧率]，当为 0 的时候，导出视频帧率等于原视频帧率，
           当设置的帧率大于原视频帧率时，会被自动调整为原视频帧率
 
 @since      v1.13.0
 */
@property (assign, nonatomic) float videoFrameRate;

/**
 @abstract 视频转码完成的 block
 
 @since      v1.0.5
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @abstract 视频转码失败的 block
 
 @since      v1.0.5
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/**
 @abstract 视频转码进度的 block，可在该 block 中刷新转码进度条 UI
 
 @since      v1.0.5
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/**
 *  使用 AVAsset 初始化转码对象
 *
 *  @param asset 送去转码的视频
 
 @since      v1.0.5
 */
- (id)initWithAsset:(AVAsset *)asset;

/**
 *  使用 NSURL 初始化转码对象
 *
 *  @param url 送去转码的视频
 
 @since      v1.0.5
 */
- (id)initWithURL:(NSURL *)url;

/**
 *  在初始化转码对象 PLShortVideoTranscoder 并设置好转码参数后，执行该方法启动转码流程
 *
 
 @since      v1.0.5
 */
- (void)startTranscoding;

/**
 *  取消转码流程
 *
 
 @since      v1.0.5
 */
- (void)cancelTranscoding;

/**
 *  返回 AVAsset 在 bounds 大小的 view 中播放，有视频部分的 frame
 *
 
 @since      v1.13.0
 */
+ (CGRect)videoDisplay:(AVAsset *)asset bounds:(CGRect)bounds rotate:(PLSPreviewOrientation)previewOrientation;

@end


