//
//  PLSImageVideoComposer.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/10/29.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSComposeMediaItem.h"
#import "PLSTypeDefines.h"

/**
 * @abstract 图片视频混排
 *
 * @discussion 可以将多张图片和多个视频拼接为一个视频，并且支持设置转场
 */
@interface PLSImageVideoComposer : NSObject

/**
 @abstract 合成视频完成的 block
 
 @since      v1.16.0
 */
@property (copy, nonatomic) void(^_Nullable completionBlock)(NSURL *url);

/**
 @abstract 合成视频失败的 block
 
 @since      v1.16.0
 */
@property (copy, nonatomic) void(^ _Nullable failureBlock)(NSError* error);

/**
 @abstract 合成视频进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.16.0
 */
@property (copy, nonatomic) void(^ _Nullable processingBlock)(float progress);

/**
 @brief 将视频导出到相册，默认为 NO
 
 @since      v1.16.0
 */
@property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;

/**
 @brief 合成视频的保存 URL。 如果不设置，内部将自动创建 URL
 
 @since      v1.16.0
 */
@property(strong, nonatomic) NSURL *_Nullable outputURL;

/**
 @brief 添加背景音乐
 
 @since      v1.16.0
 */
@property(strong, nonatomic) NSURL *_Nullable musicURL;

/**
 @brief 背景音乐音量, 默认：1.0，取值范围(0 ~ 1.0)
 
 @since      v1.16.0
 */
@property(assign, nonatomic) float musicVolume;

/**
 @brief 原视频的音量。默认：1.0，取值范围(0 ~ 1.0)
 
 @since      v1.16.0
 */
@property(assign, nonatomic) float movieVolume;

/**
 @brief 是否禁用转场, 默认：NO
 
 @since      v1.16.0
 */
@property(assign, nonatomic) BOOL disableTransition;

/**
 @brief 转场动画持续的时长，默认为 1.0，即 1 秒. 如果 transitionDuration 的值大于合并的视频中最短时长，则
        将使用合并的视频中最短视频的时长作为转场动画的时长.
        仅当 disableTransition 为 NO 的时候，transitionDuration 才生效
 @since      v1.16.0
 */
@property (assign, nonatomic) NSTimeInterval transitionDuration;

/**
 @abstract 转场类型，默认为渐入渐出。仅当 disableTransition 为 NO 的时候，transitionType 才生效
 
 @since      v1.16.0
 */
@property (assign, nonatomic) PLSTransitionType transitionType;

/**
@abstract 拼接策略. 仅当 disableTransition 为 YES 的时候，composerPriorityType 才生效

@since      v1.16.0
*/
@property (assign, nonatomic) PLSComposerPriorityType composerPriorityType;

/**
 @abstract 合成视频文件的分辨率，默认为 544x960
 
 @since      v1.16.0
 */
@property (assign, nonatomic) CGSize videoSize;

/**
 @abstract 合成视频文件的码率，默认为 1024*1000 bps
 
 @since      v1.16.0
 */
@property (assign, nonatomic) CGFloat bitrate;

/**
 @abstract 合成视频文件的帧率, 默认为 30 帧
 
 @since      v1.16.0
 */
@property (assign, nonatomic) NSUInteger videoFramerate;

/**
 @brief 合成视频文件的类型，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.16.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/**
 @brief 合并的文件数组，按照数组顺序拼接
 
 @since      v1.16.0
 */
@property (copy, nonatomic) NSMutableArray <PLSComposeMediaItem *> *_Nullable mediaArrays;

/**
 @brief 执行合成视频。调用之前，先确保将需要设置的参数都已经设置完毕，否则启动合成操作之后再设置参数将不会生效
        如果发生错误，将通过 failureBlock 将错误信息回调
 
 @since      v1.16.0
 */
- (void)startComposing;

/**
 @brief 取消执行合成视频
 
 @since      v1.16.0
 */
- (void)stopComposing;

@end

