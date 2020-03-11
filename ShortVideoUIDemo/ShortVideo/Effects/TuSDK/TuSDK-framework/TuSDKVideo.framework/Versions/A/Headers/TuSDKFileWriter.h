//
//  TuSDKFileWriter.h
//  TuSDKEva
//
//  Created by KK on 2019/11/27.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "TuSDKVideoFileWriter.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TuSDKFileWriter

@protocol TuSDKFileWriterDelegate <NSObject, TuSDKVideoFileWriterDelegate>

@end


@interface TuSDKFileWriter : NSObject<SLGPUImageInput>

#pragma mark - config
// 是否有音频轨道
@property(readwrite, nonatomic) BOOL hasAudioTrack;

@property(readwrite, nonatomic) BOOL shouldPassthroughAudioSettings;
@property(readwrite, nonatomic) BOOL shouldInvalidateAudioSampleWhenDone;

// Audio FormatDescriptionRef
@property (nonatomic) CMAudioFormatDescriptionRef audioFormatDescriptionRef;

// 是否需要声音 默认：YES，有声音
@property(nonatomic, assign) BOOL enableSound;


/**
 设置是否验证时间戳 默认：true
 
 @since v3.0.1
 */
@property (nonatomic, assign) BOOL enableCheckSampleTime;


#pragma mark - waterMark
/**
 设置水印图片
 */
@property (nonatomic, retain) UIImage *waterMarkImage;

/**
 水印位置，默认 lsqWaterMarkBottomRight 若视频有位置相关旋转 应在设置videoOrientation后调用该setter方法；
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

/**
  记录当前的视频方向，用来调整水印
 */
@property(nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/**
 输出方向 (默认: kGPUImageNoRotation)
 */
@property (nonatomic) LSQGPUImageRotationMode outputRotation;

// 视频方向
@property(nonatomic, assign) CGAffineTransform transform;

#pragma mark - output
/**
 *  输出尺寸
 */
@property (nonatomic) CGSize outputSize;

/**
 *  裁剪区域
 */
@property(readwrite, nonatomic) CGRect cropRegion;

/**
 *  输出区域
 */
@property (nonatomic) CGRect outputRegion;

/// 输出路径
@property(nonatomic, readonly)NSURL *movieURL;


@property(nonatomic, weak) id<TuSDKFileWriterDelegate> delegate;


@property(nonatomic, copy) BOOL(^videoInputReadyCallback)(void);
@property(nonatomic, copy) BOOL(^audioInputReadyCallback)(void);

- (void)enableSynchronizationCallbacks;

#pragma mark - init
/**
 初始化

 @param newMovieURL 保存文件路径
 @param newSize 视频尺寸
 @return 实例对象
 */
- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize;

- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize fileType:(lsqFileType)newFileType videoQuality:(TuSDKVideoQuality *)videoQuality;

- (void)setHasAudioTrack:(BOOL)hasAudioTrack audioSettings:(NSDictionary *)audioOutputSettings;


#pragma mark - Recording
/**
 *  开始视频录制
 */
- (void)startRecording;

/**
 *  完成视频录制
 */
- (void)finishRecording;

/**
 *  终止录制
 */
- (void)cancelRecording;

// 添加音频轨道信息
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer outputTime:(CMTime)outputTime;


#pragma mark - encodec control
/** 是否异步编码 */
@property (nonatomic, assign) BOOL isAsyncEncodec;

/** 是否渲染完成 */
@property (nonatomic, assign) BOOL isRendecCompleted;

/** 渲染队列 */
@property (nonatomic, readonly) dispatch_queue_t audioQueue;

/** 渲染队列 */
@property (nonatomic, readonly) dispatch_queue_t renderQueue;

/** 编码队列 */
@property (nonatomic, readonly) dispatch_queue_t encodecQueue;

/// 启动编码
/// @param handler 编码完成回调
- (void)activeEncodecWithCompletionHandler:(void (^)(void))handler;

/** 是否是裁剪视频 */
@property (nonatomic, assign) BOOL isCutVideo;

/// 销毁FBO
- (void)destroyMovieOutput;
@end

NS_ASSUME_NONNULL_END
