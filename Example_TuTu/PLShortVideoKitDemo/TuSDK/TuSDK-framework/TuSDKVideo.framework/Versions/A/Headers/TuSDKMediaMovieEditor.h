//
//  TuSDKMediaMovieEditor.h
//  TuSDKVideo
//
//  Created by sprint on 19/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TuSDKMediaMovieEditor <NSObject>

#pragma mark - 加载

/**
 加载视频
 
 @since v3.0.1
 */
- (void)loadVideo;


#pragma mark - 预览

/**
 启动预览
 
 @since v3.0.1
 */
- (void)startPreview;

/**
 停止预览
 
 @since v3.0.1
 */
- (void)stopPreview;

/**
 停止并重新开始预览
 如果你需要 stopPreView 紧接着使用 startPreView 再次启动预览，你首选的方案应为 rePreview，rePreview会根据内部状态在合适的时间启动预览
 
 @since v3.0.1
 */
- (void)rePreview;

/**
 暂停预览
 
 @since v3.0.1
 */
- (void)pausePreView;

/**
 是否正在预览视频
 @return true/false
 
 @since v3.0.1
 */
- (BOOL)isPreviewing;

/**
 在指定的时间范围内设置当前回放时间。
 
 @param outputTime 输出时间
 
 @since v3.0.1
 */
- (void)seekToTime:(CMTime)outputTime;


#pragma mark - 录制

/**
 开始录制视频
 
 @since v3.0.1
 */
- (void)startRecording;

/**
 取消录制视频
 
 @since v3.0.1
 */
- (void)cancelRecording;

/**
 当前编辑器是否正在录制中
 
 @return true/false
 
 @since v3.0.1
 */
- (Boolean)isRecording;


#pragma mark - 销毁

/**
 销毁视频编辑器
 @since v3.0.1
 */
- (void)destroy;

@end
