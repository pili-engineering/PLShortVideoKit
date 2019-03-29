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

/*!
 @class PLSMovieComposer
 @abstract 多个视频拼接类
 
 @since      v1.4.0
 */
__deprecated_msg("Class PLSMovieComposer is deprecated in v1.16.0, use PLSImageVideoComposer with disableTransition instead")
@interface PLSMovieComposer : NSObject

/*!
 @property completionBlock
 @abstract 视频拼接完成的 block
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/*!
 @property failureBlock
 @abstract 视频拼接失败的 block
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/*!
 @property processingBlock
 @abstract 视频拼接进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.4.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/*!
 @property isExportMovieToPhotosAlbum
 @brief 将视频导出到相册，默认为 NO
 
 @since      v1.4.0
 */
@property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;

/*!
 @property outputFileType
 @abstract 拼接后视频的格式，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.6.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/*!
 @property videoSize
 @abstract 拼接后视频的分辨率，默认为第1个视频的分辨率
 
 @since      v1.4.0
 */
@property (assign, nonatomic) CGSize videoSize;

/*!
 @property videoFrameRate
 @abstract 拼接后视频数据的帧率，默认为 25
 
 @since      v1.6.0
 */
@property (assign, nonatomic) int videoFrameRate;

/*!
 @property bitrate
 @abstract 拼接后视频的码率，默认码率为 1024*1000 bps
 
 @since      v1.6.0
 */
@property (assign, nonatomic) float bitrate;

/*!
 @property composerPriorityType
 @abstract 拼接策略，默认：PLSComposerPriorityTypeSync
 
 @since      v1.14.0
 */
@property (assign, nonatomic) PLSComposerPriorityType composerPriorityType;

/*!
 @method initWithAssets:
 @brief 初始化
 
 @param assets 待合并的视频 AVAsset 资源
 
 @return PLSMovieComposer 实例
 @since      v1.4.0
 */
- (instancetype)initWithAssets:(NSArray<AVAsset *> *)assets;

/*!
 @method initWithUrls:
 @brief 初始化
 
 @param urls 待合并的视频存放地址
 
 @return PLSMovieComposer 实例
 @since      v1.4.0
 */
- (instancetype)initWithUrls:(NSArray<NSURL *> *)urls;

/*!
 @method startComposing
 @brief 执行视频拼接
 
 @since      v1.4.0
 */
- (void)startComposing;

/*!
 @method stopComposing
 @brief 停止视频拼接s
 
 @since      v1.4.0
 */
- (void)stopComposing;

@end
