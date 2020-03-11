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

/*!
 @class PLSRangeMovieExport
 @brief 视频切割导出类
 
 @since      v1.10.0
 */
@interface PLSRangeMovieExport : NSObject

/*!
 @property outURL
 @brief 导出视频存放url
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *outURL;

/*!
 @property outputFilePreset;
 @abstract 导出合并视频的宽高控制，默认为 PLSFilePresetHighestQuality.
 
           注意：该属性在 v1.16.0 版本中被弃用，建议使用 outputVideoSize 来设置导出视频的宽高。如果不想使用 outputVideoSize，仍然
           使用 outputFilePreset 作为导出视频的宽高控制，outputVideoSize 必须为 CGSizeZero
 
 @since      v1.11.0
 */
@property (assign, nonatomic) PLSFilePreset outputFilePreset __deprecated_msg("outputFilePreset deprecated in v1.16.0. Use `outputVideoSize` instead");

/*!
 @property outputVideoSize
 @abstract 导出视频的宽高,如果不设置，内部将使用 outputFilePreset 来计算导出视频的宽高
 
 @since      v1.16.0
 */
@property (assign, nonatomic) CGSize outputVideoSize;

/*!
 @property fillMode
 @abstract 当多个视频宽高比例不一样的时候，视频的填充模式
 
 @since      v1.16.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/*!
 @property bitrate
 @abstract 导出视频的码率，如果设置为 0，内部会根据 outputVideoSize 选择适当的码率值。默认：0
 
 @since      v1.16.0
 */
@property (assign, nonatomic) NSInteger bitrate;

/*!
 @property completionBlock
 @abstract 视频合并完成的 block
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/*!
 @property failureBlock
 @abstract 视频合并失败的 block
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/*!
 @property processingBlock
 @abstract 视频合并进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/*!
 @method initWithRangeMedia:
 @brief 初始化
 
 @param medias 待合并的视频文件
 
 @return PLSRangeMovieExport 实例
 @since      v1.10.0
 */
- (instancetype)initWithRangeMedia:(NSArray<PLSRangeMedia *> *)medias;

/*!
 @method startExport
 @brief 执行视频合并
 
 @since      v1.10.0
 */
- (void)startExport;

/*!
 @method stopExport
 @brief 停止视频合并
 
 @since      v1.10.0
 */
- (void)stopExport;

@end
