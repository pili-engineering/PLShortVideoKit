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
 @abstract 导出合并视频的质量，默认为 PLSFilePresetHighestQuality
 
 @since      v1.11.0
 */
@property (assign, nonatomic) PLSFilePreset outputFilePreset;

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
