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
 @abstract 视频拼接进度的 block，可在该 block 中刷新转码进度条 UI
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/**
 @brief 将视频导出到相册，默认为 NO
 
 @since      v1.4.0
 */
@property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;

/**
 @abstract 拼接后视频的质量，默认为 PLSFilePresetHighestQuality
 
 @since      v1.4.0
 */
@property (assign, nonatomic) PLSFilePreset outputFilePreset;

/**
 @abstract 拼接后视频的分辨率，默认为第1个视频的分辨率
 
 @since      v1.4.0
 */
@property (assign, nonatomic) CGSize videoSize;

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
