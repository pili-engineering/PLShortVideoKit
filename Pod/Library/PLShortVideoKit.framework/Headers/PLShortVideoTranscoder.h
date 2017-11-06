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

@end


