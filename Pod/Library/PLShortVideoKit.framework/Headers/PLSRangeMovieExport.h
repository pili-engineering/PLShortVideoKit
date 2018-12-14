//
//  PLSRangeMovieExport.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSTypeDefines.h"

@class PLSRangeMedia;
@interface PLSRangeMovieExport : NSObject

/**
 @brief 导出视频存放url
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *outURL;

/**
 @abstract 导出合并视频的宽高控制，默认为 PLSFilePresetHighestQuality.
 
           注意：该属性在 v1.16.0 版本中被弃用，建议使用 outputVideoSize 来设置导出视频的宽高。如果不想使用 outputVideoSize，仍然
           使用 outputFilePreset 作为导出视频的宽高控制，outputVideoSize 必须为 CGSizeZero
 
 @since      v1.11.0
 */
@property (assign, nonatomic) PLSFilePreset outputFilePreset __deprecated_msg("outputFilePreset deprecated in v1.16.0. Use `outputVideoSize` instead");

/**
 @abstract 导出视频的宽高,如果不设置，内部将使用 outputFilePreset 来计算导出视频的宽高
 
 @since      v1.16.0
 */
@property (assign, nonatomic) CGSize outputVideoSize;

/**
 @abstract 当多个视频宽高比例不一样的时候，视频的填充模式
 
 @since      v1.16.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/**
 @abstract 导出视频的码率，如果设置为 0，内部会根据 outputVideoSize 选择适当的码率值。默认：0
 
 @since      v1.16.0
 */
@property (assign, nonatomic) NSInteger bitrate;

/**
 @abstract 视频合并完成的 block
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @abstract 视频合并失败的 block
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/**
 @abstract 视频合并进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/**
 @brief 初始化
 
 @since      v1.10.0
 */
- (instancetype)initWithRangeMedia:(NSArray<PLSRangeMedia *> *)medias;

/**
 @brief 执行视频合并
 
 @since      v1.10.0
 */
- (void)startExport;

/**
 @brief 停止视频合并
 
 @since      v1.10.0
 */
- (void)stopExport;

@end
