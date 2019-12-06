//
//  TuSDKMediaMovieAssetExportSession.h
//  TuSDKVideo
//
//  Created by sprint on 04/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaAssetExportSession.h"
#import "TuSDKMediaAssetExtractor.h"
#import "TuSDKFileWriter.h"
#import "TuSDKMediaFormatAssistant.h"
#import "TuSDKMediaSettings.h"
#import "TuSDKMediaAssetInfo.h"
#import "TuSDKMediaStatus.h"

@class TuSDKMediaMovieAssetExportSessionSettings;

/**
 音视频数据导出会话
 @since v3.0
 */
@interface TuSDKMediaMovieAssetExportSession : NSObject <TuSDKMediaAssetExportSession>
{
 @protected
    // 用以分离视频轨道数据
     id<TuSDKMediaExtractor> _videoTrackExtractor;
    // 用以分离音频轨道数据
     id<TuSDKMediaExtractor> _audioTrackExtractor;
    // 视频导出设置
    TuSDKMediaMovieAssetExportSessionSettings *_exportEncodeOutputSettings;
}

/**
 初始化视频导出会话
 
 @param inputAsset 输入的视频资源
 @param exportEncodeOutputSettings 输出设置
 @return TuSDKMediaAVAssetExportSession
 */
- (instancetype _Nullable)initWithInputAsset:(AVAsset *_Nonnull)inputAsset videoDecodeOutputSettings:(TuSDKMediaDecoderOutputSettings *_Nullable)videoDecodeOutputSettings audioDecodeOutputSettings:(TuSDKMediaDecoderOutputSettings *_Nullable)audioDecodeOutputSettings  exportOutputSettings:(nullable TuSDKMediaMovieAssetExportSessionSettings *)exportEncodeOutputSettings;


/**
 输出的资产
 @since v3.0
 */
@property (nonatomic,readonly) AVAsset * _Nonnull inputAsset;

/**
 获取视频信息，视频加载完成后可用
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaAssetInfo * _Nullable inputAssetInfo;

/**
 视频数据分离器
 @since      v3.0
 */
@property (nonatomic,readonly)__kindof id<TuSDKMediaExtractor> _Nullable videoTrackExtractor;

/**
 音频数据分离器
 @since      v3.0
 */
@property (nonatomic,readonly)__kindof id<TuSDKMediaExtractor> _Nullable audioTrackExtractor;

/**
 视频解码输出配置
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaDecoderOutputSettings * _Nullable videoDecodeOutputSettings;

/**
 音频解码输出配置
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaDecoderOutputSettings * _Nullable audioDecodeOutputSettings;

/**
 当前状态
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaExportSessionStatus status;

/**
 设置视频输出的画面方向
 @since v3.0
 */
@property (nonatomic) LSQGPUImageRotationMode outputRotation;


/**
 设置视频输出的地址
 @since v3.4.2
 */
@property (nonatomic, strong) NSURL * _Nullable outputURL;


/**
 验证是否可以输出视频原音
 
 @return true/false
 @since 3.0
 */
- (BOOL)canExportAssetSound;

/**
 导出完成

 @param fileURL 输出的文件路径
 @param error 错误信息
 @since v3.0
 */
- (void)exportSessionDidResult:(NSURL *_Nullable)fileURL error:(NSError *_Nullable)error;

/**
 通知当前Session状态

 @param status 状态
 */
- (void)notifyStatus:(TuSDKMediaExportSessionStatus)status;

@end



#pragma mark - Processing

@interface TuSDKMediaMovieAssetExportSession (Processing)

/**
 输入的画面方向
 @since 3.0
 */
- (LSQGPUImageRotationMode) inputRotation;

/**
 * 输入的采样数据类型
 * 支持： kCVPixelFormatType_420YpCbCr8BiPlanarFullRange | kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32BGRA
 *  @since 3.0
 */
- (OSType) inputPixelFormatType;

/**
 处理分离的视频数据  默认：直接将数据写入到文件中 将会调用 writeVideoSampleBuffer 方法
 
 @param sampleBufferRef 视频数据
 @since v3.0
 */
- (void)processVideoSampleBuffer:(CMSampleBufferRef _Nullable )sampleBufferRef;

/**
 处理分离的视频数据  默认：直接将数据写入到文件中 将会调用 writeVideoSampleBuffer 方法
 
 @param pixelBufferRef 视频数据
 @param outputTime 输出时间
 @since v3.0
 */
- (void)processVideoPixelBuffer:(CVPixelBufferRef _Nullable )pixelBufferRef outputTime:(CMTime)outputTime;

/**
 处理分离的音频数据 默认：直接将数据写入到文件中，将会调用 writeAudioSampleBuffer 方法
 
 @param sampleBufferRef 音频数据
 @since v3.0
 */
- (void)processAudioSampleBuffer:(CMSampleBufferRef _Nullable )sampleBufferRef;

/**
 写入视频数据到文件中

 @param sampleBufferRef 视频数据
 @param outputTime 输出时间
 @since v3.0
 */
- (void)writeVideoSampleBuffer:(CMSampleBufferRef _Nonnull )sampleBufferRef outputTime:(CMTime)outputTime;

/**
 写入视频数据到文件中
 
 @param sampleBufferRef 音频数据
 @since v3.0
 */
- (void)writeAudioSampleBuffer:(CMSampleBufferRef _Nonnull )sampleBufferRef;

@end



#pragma mark - TuSDKMediaAVAssetExportSessionSettings

@interface TuSDKMediaMovieAssetExportSessionSettings : NSObject

#pragma mark 文件生成

/**
 导出的地址
 @since v3.0
 */
@property (nonatomic) NSURL * _Nullable outputURL;


/**
 是否有音频混合
 @since v3.4.2
 */
@property (nonatomic, assign) BOOL isMixAudio;

/**
 导出过程中临时文件的地址
 @since v3.4.2
 */
@property (nonatomic) NSURL * _Nullable tempOutputURL;

/**
 输出的视频size
 @since v3.0
 */
@property (nonatomic) CGSize outputSize;

/**
 设定输出 outputSize 时比例不一致时是否自适应画布大小 默认：NO
 
 @since v3.3.1
 */
@property (nonatomic) BOOL aspectOutputRatioInSideCanvas;

/**
 设置画面显示区域 默认：（CGRectMake(0,0,1,1) 完整画面） aspectOutputRatioInSideCanvas
 aspectOutputRatioInSideCanvas 为 NO 时可用
 @since v3.0
 */
@property (nonatomic) CGRect outputRegion;

/**
 输出的文件类型, 默认：lsqFileTypeQuickTimeMovie
 @since v3.0
 */
@property (nonatomic) lsqFileType outputFileType;

/**
 输出的视频画质
 @since v3.0
 */
@property (nonatomic) TuSDKVideoQuality * _Nullable outputVideoQuality;

/**
 是否根据音频数据设置音频配置
 @since v3.0
 */
@property(readwrite, nonatomic) BOOL shouldPassthroughAudioSettings;

/*!
 @property transform
 @abstract
 The transform specified in the output file as the preferred transformation of the visual media data for display purposes.
 
 @discussion
 If no value is specified, the identity transform is used.
 
 This property cannot be set after writing on the receiver's AVAssetWriter has started.
 */
@property (nonatomic) CGAffineTransform outputTransform;


/**
 指定是否导出视频原音 默认：YES
 @since v3.0
 */
@property (nonatomic,assign)BOOL enableExportAssetSound;


/*!
 @property videoComposition
 @abstract
 The composition of video used by the receiver.
 
 @discussion
 The value of this property is an AVVideoComposition that can be used to specify the visual arrangement of video frames read from each source track over the timeline of the source asset.
 
 This property cannot be set after reading has started.
 */
@property (nonatomic,nullable) AVVideoComposition *videoComposition;


#pragma mark 相册

/**
 设置水印图片
 @since v3.0
 */
@property (nonatomic, retain) UIImage * _Nullable waterMarkImage;

/**
 水印位置，默认 lsqWaterMarkBottomRight 若视频有位置相关旋转 应在设置videoOrientation后调用该setter方法
 @since v3.0
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

@end
