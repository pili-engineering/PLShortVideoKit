//
//  TuSDKMediaMovieEditorTranscoder.h
//  TuSDKVideo
//
//  Created by sprint on 06/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaMovieAssetExportSession.h"

@class TuSDKMediaMovieEditorTranscoderSettings;
@protocol TuSDKMediaEditorTranscoderDelegate;

/**
 视频转码器，一般用于视频编辑前的预处理操作。将高帧率高码率视频转为可用于视频编辑的视频。
 @since v3.0
 */
@interface TuSDKMediaMovieEditorTranscoder : TuSDKMediaMovieAssetExportSession


/**
 初始化视频导出会话
 
 @param inputAsset 输入的视频资源
 @param exportEncodeOutputSettings 输出设置
 @return TuSDKMediaMovieEditorTranscoder
 */
- (instancetype _Nullable)initWithInputAsset:(AVAsset *_Nonnull)inputAsset videoDecodeOutputSettings:(TuSDKMediaDecoderOutputSettings *_Nullable)videoDecodeOutputSettings audioDecodeOutputSettings:(TuSDKMediaDecoderOutputSettings *_Nullable)audioDecodeOutputSettings  exportOutputSettings:(nullable TuSDKMediaMovieEditorTranscoderSettings *)exportEncodeOutputSettings;


/**
 转码器事件委托
 @since v3.0
 */
@property (nonatomic,weak) id<TuSDKMediaEditorTranscoderDelegate> _Nullable delegate;


@end

#pragma mark - TuSDKMediaEdiorTranscoderDelegate

@protocol TuSDKMediaEditorTranscoderDelegate <NSObject>
@required

/**
 转码进度改变事件
 
 @param transcoder TuSDKMediaEdiorTranscoder
 @param percentage 进度百分比 (0 - 1)
 @since v3.0
 */
- (void)mediaEditorTranscoder:(TuSDKMediaMovieEditorTranscoder *_Nonnull)transcoder progressChanged:(CGFloat)percentage;

/**
 播放器状态改变事件
 
 @param transcoder 当前转码器
 @param status 当前播放器状态
 @since      v3.0
 */
- (void)mediaEditorTranscoder:(TuSDKMediaMovieEditorTranscoder *_Nonnull)transcoder statusChanged:(TuSDKMediaExportSessionStatus)status;

/**
 转码完成
 
 @param transcoder 转码器
 @param result TuSDKVideoResult
 @param error 错误信息
 @since      v3.0
 */
- (void)mediaEditorTranscoder:(TuSDKMediaMovieEditorTranscoder *_Nonnull)transcoder result:(TuSDKVideoResult *_Nullable)result error:(NSError *_Nullable)error;

@end


#pragma mark - TuSDKMediaAVAssetExportSessionSettings

@interface TuSDKMediaMovieEditorTranscoderSettings : TuSDKMediaMovieAssetExportSessionSettings

/**
 设置视频裁剪的时间区间
 
 @since v3.0
 */
@property (nonatomic)CMTimeRange timeRange;

@end
