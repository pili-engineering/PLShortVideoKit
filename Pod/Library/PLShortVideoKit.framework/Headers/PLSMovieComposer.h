//
//  PLSMovieComposer.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/8/23.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

@interface PLSMovieComposer : NSObject

/**
 @abstract 视频拼接完成的 block
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @abstract 视频拼接失败的 block
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/**
 @abstract 视频拼接进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/**
 @brief 将视频导出到相册，默认为 NO
 
 @since      v1.4.0
 */
@property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;

/**
 @abstract 拼接后视频的格式，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.6.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/**
 @abstract 拼接后视频的分辨率，默认为第1个视频的分辨率
 
 @since      v1.4.0
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @abstract 拼接后视频数据的帧率，默认为 25
 
 @since      v1.6.0
 */
@property (assign, nonatomic) int videoFrameRate;

/**
 @abstract 拼接后视频的码率，默认码率为 1024*1000 bps
 
 @since      v1.6.0
 */
@property (assign, nonatomic) float bitrate;

/**
 @abstract 拼接策略，默认：PLSComposerPriorityTypeSync
 
 @since      v1.14.0
 */
@property (assign, nonatomic) PLSComposerPriorityType composerPriorityType;

/**
 @brief 初始化
 
 @since      v1.4.0
 */
- (instancetype)initWithAssets:(NSArray<AVAsset *> *)assets;

/**
 @brief 初始化
 
 @since      v1.4.0
 */
- (instancetype)initWithUrls:(NSArray<NSURL *> *)urls;

/**
 @brief 执行视频拼接
 
 @since      v1.4.0
 */
- (void)startComposing;

/**
 @brief 停止视频拼接
 
 @since      v1.4.0
 */
- (void)stopComposing;

@end
