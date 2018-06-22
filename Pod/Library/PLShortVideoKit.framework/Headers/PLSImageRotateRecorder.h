//
//  PLSImageRotateRecorder.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/5/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "PLSVideoConfiguration.h"
#import "PLSAudioConfiguration.h"
#import "PLSTypeDefines.h"

@class PLSImageRotateRecorder;
@protocol PLSImageRotateRecorderDelegate <NSObject>
@optional

#pragma mark -- 音视频采集数据的回调
/**
 @abstract 获取到旋转动画原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个是在视频采集的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
 
 @since      v1.0.0
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didGetRotatePixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/**
 @abstract 获取到麦克风原数据时的回调，需要注意的是这个回调在麦克风数据的输出线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 
 @since      v1.0.1
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didGetMicrophoneSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer;

#pragma mark -- 录制状态回调回调
/**
 @abstract   录制开始回调（由于启动录制是一个耗时的过程，因此放在一个单独的线程中，调用 startRecording：只是通知启动录制，真正的开始录制由此回调告知）
 
 @param     fileURL 录制文件保存的地址
 
 @since      v1.11.0
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didStartRecording:(NSURL *__nonnull)fileURL;

/**
 @abstract   录制时长回调，录制过程中，这个方法会不断的回调
 
 @param     fileURL         当前正在录制的文件
 @param     fileDuration    当前正在录制的文件已录制时长
 @param     totalDuration   所有已经录制文件的总时长
 @param     currentAngle    当前旋转图片所处的角度，单位: 弧度
 
 @since      v1.11.0
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CMTime)fileDuration totalDuration:(CMTime)totalDuration currentAngle:(float)currentAngle;

/**
 @abstract   录制结束回调（调用stopRecording，为了让所有音视频数据都写入到文件，会有一定的延时，因此这个回调是真正结束录制的通知）
 
 @param     fileURL         录制文件保存的地址
 @param     fileDuration    当前录制完成文件的时长
 @param     totalDuration   已经录制完成的所有文件总时长
 @param     currentAngle    当前旋转图片所处的角度，单位: 弧度
 
 @since      v1.11.0
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didFinishRecording:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration currentAngle:(float)currentAngle;

/**
 @abstract   删除一段视频之后的回调
 
 @param     fileURL         删除文件的地址
 @param     fileDuration    删除文件的时长
 @param     totalDuration   剩余文件的总时长
 @param     currentAngle    剩余文件中最后一个文件录制结束时对应的角度
 
 @since      v1.11.0
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didDeleteFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration currentAngle:(float)currentAngle;

/**
 @abstract   录制过程中发生错误回调
 
 @param     error 错误信息
 
 @since      v1.11.0
 */
- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder errorOccur:(NSError *__nullable)error;

@end


/**
 * @abstract    图片旋转动画录制类，将图片动画和麦克风采集音频录制为视频文件
 *
 * @discussion  PLSImageRotateRecorder 内部包含了旋转动画图片的获取、渲染 和 麦克风音频数据的采集
 */
@interface PLSImageRotateRecorder : NSObject

/**
 @abstract   初始化方法
 
 @param     videoConfiguration 视频参数设置。必须设置，不能为 nil, 否则初始化返回 nil
 @param     audioConfiguration 音频参数设置为。可以为 nil。为 nil 时，不采集音频
 @since      v1.11.0
 */
- (nullable instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *__nonnull)videoConfiguration
                                 audioConfiguration:(PLSAudioConfiguration *__nullable)audioConfiguration;

/**
 @brief 代理
 
 @since      v1.11.0
 */
@property (nonatomic, weak) id<PLSImageRotateRecorderDelegate> __nullable delegate;

/**
 @brief 触发代理对象回调时所在的任务队列。default main_queue
 
 @since      v1.11.0
 */
@property (nonatomic, assign) dispatch_queue_t __nullable callbackQueue;

/**
 @brief 预览 view
 
 @since      v1.11.0
 */
@property (nonatomic, readonly) UIView *__nonnull previewView;

/**
 @brief 背景图片，必须设置
 
 @since      v1.11.0
 */
@property (nonatomic, strong) UIImage * __nonnull backgroundImage;

/**
 @brief 旋转图片，必须设置
 
 @since      v1.11.0
 */
@property (nonatomic, strong) UIImage *__nonnull rotateImage;

/**
 @brief 设置旋转图片在视频中的大小和位置，必须设置。正在录制的时候不可设置, 相对于初始化 videoConfiguration.videoSize, 视频左上角为 {0，0}
 
 @since      v1.11.0
 */
@property (nonatomic, assign) CGRect rotateFrame;

/**
 @brief 旋转速度，多少秒转动一圈，正值为顺时针旋转、负值为逆时针旋转。建议设置范围: 5s ~ 20s. default: 10s
 
 @since      v1.11.0
 */
@property (nonatomic, assign) float rotateSpeed;

/**
 @brief 录制文件的类型。PLSFileTypeMPEG4(.mp4) 或者 PLSFileTypeQuickTimeMovie(.mov). default: PLSFileTypeMPEG4
 
 @since      v1.11.0
 */
@property (nonatomic, assign) PLSFileType fileType;

/**
 @brief 是否处于录制状态
 
 @since      v1.11.0
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 @abstract  重置录制角度。 stopRecording 之后，当前的角度会保持，下一次录制开始的时候，
            角度接着上一次 stopRecording 时的角度。调用此方法，可以将角度重置为指定角度
 
 @param     angle 要设置的角度，单位：弧度
 
 @since      v1.11.0
 */
- (void)resetRotateToAngle:(float)angle;

/**
 @abstract  获取所有已经录制完成的视频地址
 
 @since      v1.11.0
 */
- (NSArray<NSURL *> *__nullable)getAllRecordingFiles;

/**
 @brief 返回代表当前所有录制视频段文件的 asset
 
 @since      v1.11.0
 */
- (AVAsset *__nullable)assetRepresentingAllFiles;

/**
 @abstract  删除最后一次录制完成的文件
 
 @since      v1.11.0
 */
- (void)deleteLastRecordingFile;

/**
 @abstract  删除所有已经录制完成的视频地址
 
 @since      v1.11.0
 */
- (void)deleteAllRecordingFiles;

/**
 @abstract 开始录制
 
 @param     outURL 录制文件的保存位置。如果为 nil，则 SDK 内部会创建一个
 @since      v1.11.0
 */
- (void)startRecording:(NSURL *__nullable)outURL;

/**
 @abstract 停止录制。如果当前处理录制状态，调用之后，已经录制的文件通过回调 (imageRotateRecorder:didFinishRecording:)返回
 
 @since      v1.11.0
 */
- (void)stopRecording;

/**
 @abstract 取消录制会停止视频录制并删除录制的视频段文件
 
 @since      v1.11.0
 */
- (void)cancelRecording;

@end
