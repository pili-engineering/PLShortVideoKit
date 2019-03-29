//
//  PLSImageToMovieComposer.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/18.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSTypeDefines.h"

/*!
 @class PLSImageToMovieComposer
 @abstract 图片合成视频类
 
 @since      v1.7.0
 */
__deprecated_msg("Class PLSImageToMovieComposer is deprecated in v1.16.0, use PLSImageVideoComposer instead")
@interface PLSImageToMovieComposer : NSObject

/*!
 @property completionBlock
 @abstract 图片合成视频完成的 block
 
 @since      v1.7.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/*!
 @property failureBlock
 @abstract 图片合成视频失败的 block
 
 @since      v1.7.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/*!
 @property processingBlock
 @abstract 图片合成视频进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.7.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/*!
 @property videoSize
 @abstract 视频文件的分辨率，默认为 544x960
 
 @since      v1.7.0
 */
@property (assign, nonatomic) CGSize videoSize;

/*!
 @property videoFramerate
 @abstract 视频文件的帧率, 默认为 30 帧
 
 @since      v1.7.0
 */
@property (assign, nonatomic) NSUInteger videoFramerate;

/*!
 @property bitrate
 @abstract 视频文件的码率，默认为 1024*1000 bps
 
 @since      v1.7.0
 */
@property (assign, nonatomic) CGFloat bitrate;

/*!
 @property transitionType
 @abstract 转场动画类型，默认为渐入渐出
 
 @since      v1.7.0
 */
@property (assign, nonatomic) PLSTransitionType transitionType;

/*!
 @property transitionDuration
 @abstract 转场动画持续的时长，默认为1.0，即1秒
 
 @since      v1.8.0
 */
@property (assign, nonatomic) CGFloat transitionDuration;

/*!
 @property imageDuration
 @abstract 每张图片持续的时长，默认为2.0，即2秒
 
 @since      v1.8.0
 */
@property (assign, nonatomic) CGFloat imageDuration;

/*!
 @property outputFileType
 @brief 视频的文件类型，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.7.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/*!
 @method initWithImages:
 @brief 初始化
 
 @param images 用于生成视频文件的图片数组
 
 @return PLSImageToMovieComposer 实例
 @since      v1.7.0
 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images;

/*!
 @method initWithImageURLs:
 @brief 初始化
 
 @param urls 图片保存的路径数组
 
 @return PLSImageToMovieComposer 实例
 @since      v1.14.0
 */
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)urls;

/*!
 @method startComposing
 @brief 执行图片合成视频
 
 @since      v1.7.0
 */
- (void)startComposing;

/*!
 @method stopComposing
 @brief 停止图片合成视频
 
 @since      v1.7.0
 */
- (void)stopComposing;

@end
