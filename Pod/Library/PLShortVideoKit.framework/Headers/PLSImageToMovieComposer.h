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

@interface PLSImageToMovieComposer : NSObject

/**
 @abstract 图片合成视频完成的 block
 
 @since      v1.7.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @abstract 图片合成视频失败的 block
 
 @since      v1.7.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/**
 @abstract 图片合成视频进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.7.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/**
 @abstract 视频文件的分辨率，默认为 544x960
 
 @since      v1.7.0
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @abstract 视频文件的帧率, 默认为 30 帧
 
 @since      v1.7.0
 */
@property (assign, nonatomic) NSUInteger videoFramerate;

/**
 @abstract 视频文件的码率，默认为 1024*1000 bps
 
 @since      v1.7.0
 */
@property (assign, nonatomic) CGFloat bitrate;

/**
 @abstract 转场动画类型，默认为渐入渐出
 
 @since      v1.7.0
 */
@property (assign, nonatomic) PLSTransitionType transitionType;

/**
 @brief 视频的文件类型，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.7.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/**
 @brief 初始化
 *
 @param images 用于生成视频文件的图片数组
 
 @since      v1.7.0
 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images;

/**
 @brief 执行图片合成视频
 
 @since      v1.7.0
 */
- (void)startComposing;

/**
 @brief 停止图片合成视频
 
 @since      v1.7.0
 */
- (void)stopComposing;

@end
