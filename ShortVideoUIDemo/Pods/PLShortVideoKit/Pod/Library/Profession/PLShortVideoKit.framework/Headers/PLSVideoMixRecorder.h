//
//  PLSVideoMixRecorder.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/4/18.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "PLSVideoMixConfiguration.h"
#import "PLSAudioMixConfiguration.h"
#import "PLSTypeDefines.h"

@class PLSVideoMixRecorder;

/*!
 @protocol PLSVideoMixRecordererDelegate
 @brief 分屏视频录制协议
 
 @since      v1.11.0
 */
@protocol PLSVideoMixRecordererDelegate <NSObject>

@optional
#pragma mark -- 摄像头／麦克风权限变化的回调
/*!
 @method videoMixRecorder:didGetCameraAuthorizationStatus:
 @abstract 摄像头授权状态发生变化的回调
 
 @param recorder PLSVideoMixRecorder 实例
 @param status 相机授权状态
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status;

/*!
 @method videoMixRecorder:didGetMicrophoneAuthorizationStatus:
 @abstract 麦克风授权状态发生变化的回调
 
 @param recorder PLSVideoMixRecorder 实例
 @param status 麦克风授权状态
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status;

#pragma mark -- 素材文件音视频信息回调
/*!
 @method videoMixRecorder:didGetSampleVideoInfo:videoHeight:frameRate:duration:
 @abstract 素材文件的视频信息
 
 @param recorder PLSVideoMixRecorder 实例
 @param videoWidth 素材文件的宽
 @param videoHeight 素材文件的高
 @param frameRate 素材文件的帧率
 @param duration 素材文件的时长
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetSampleVideoInfo:(int)videoWidth videoHeight:(int)videoHeight frameRate:(float)frameRate duration:(CMTime)duration;

#pragma mark -- 摄像头对焦位置的回调
/*!
 @method videoMixRecorder:didFocusAtPoint:
 @abstract 摄像头对焦位置的回调
 
 @param recorder PLSVideoMixRecorder 实例
 @param point 相机的当前焦点
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didFocusAtPoint:(CGPoint)point;

#pragma mark -- 摄像头／麦克风采集数据的回调
/*!
 @method videoMixRecorder:cameraSourceDidGetPixelBuffer:
 @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
 
 @param recorder PLSVideoMixRecorder 实例
 @param pixelBuffer 相机采集到的视频帧
 
 @since      v1.11.0
 */
- (CVPixelBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/*!
 @method videoMixRecorder:microphoneSourceDidGetAudioBufferList:
 @abstract 获取到麦克风原数据时的回调，需要注意的是这个回调在 microphone 数据的输出线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题。如果需要修改音频数据，可以直接对 audioBufferList 进行修改
 
 @param recorder PLSVideoMixRecorder 实例
 @param audioBufferList 麦克风采集到的音频帧
 
 @since      v1.13.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder microphoneSourceDidGetAudioBufferList:(AudioBufferList *__nonnull)audioBufferList;

/*!
 @method videoMixRecorder:microphoneSourceDidGetSampleBuffer:
 @abstract 获取到麦克风原数据时的回调，需要注意的是这个回调在 microphone 数据的输出线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 
 @param recorder PLSVideoMixRecorder 实例
 @param sampleBuffer 麦克风采集到的音频帧

 @since      v1.11.0
 */
- (CMSampleBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder microphoneSourceDidGetSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer __deprecated_msg("Method deprecated in v1.13.0. Use `videoMixRecorder: microphoneSourceDidGetAudioBufferList:`");

#pragma mark -- 素材视频／音频数据的回调
/*!
 @method videoMixRecorder:sampleSourceDidGetPixelBuffer:
 @abstract 获取到素材文件原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 素材解码 的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
 
 @param recorder PLSVideoMixRecorder 实例
 @param pixelBuffer 获取到的素材文件的视频帧
 
 @since      v1.11.0
 */
- (CVPixelBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/*!
 @method videoMixRecorder:sampleSourceDidGetAudioBufferList:
 @abstract 获取到素材音频数据时的回调，需要注意的是这个回调在 素材解码 数据的输出线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题。如果需要修改音频数据，可以直接对 audioBufferList 进行修改
 
 @param recorder PLSVideoMixRecorder 实例
 @param audioBufferList 获取到的素材文件的音频帧
 
 @since      v1.13.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetAudioBufferList:(AudioBufferList *__nonnull)audioBufferList;

/*!
 @method videoMixRecorder:sampleSourceDidGetSampleBuffer:
 @abstract 获取到素材音频数据时的回调，需要注意的是这个回调在 素材解码 数据的输出线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 
 @param recorder PLSVideoMixRecorder 实例
 @param sampleBuffer 获取到的素材文件的音频帧
 
 @since      v1.11.0
 */
- (CMSampleBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer __deprecated_msg("Method deprecated in v1.13.0. Use `videoMixRecorder: sampleSourceDidGetAudioBufferList:`");

#pragma mark -- 合并之后的视频／音频数据的回调
/*!
 @method videoMixRecorder:didGetMergePixelBuffer:
 @abstract 合并之后数据的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 合并 的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
 
 @param recorder PLSVideoMixRecorder 实例
 @param pixelBuffer 素材视频帧和相机采集视频帧合并之后的视频帧
 
 @since      v1.11.0
 */
- (CVPixelBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergePixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/*!
 @method videoMixRecorder:didGetMergeAudioBufferList:
 @abstract 合并之后数据的回调, 便于开发者对音频数据做处理，需要注意的是这个回调在 合并 的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
           如果需要修改音频数据，可以直接对 audioBufferList 进行修改
 
 @param recorder PLSVideoMixRecorder 实例
 @param audioBufferList 素材音频数据和麦克风音频数据混音之后的音频帧

 @since      v1.13.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergeAudioBufferList:(AudioBufferList * __nonnull)audioBufferList;

/*!
 @method videoMixRecorder:didGetMergeAudioSampleBuffer:
 @abstract 合并之后数据的回调, 便于开发者对音频数据做处理，需要注意的是这个回调在 合并 的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
 
 @param recorder PLSVideoMixRecorder 实例
 @param sampleBuffer 素材音频数据和麦克风音频数据混音之后的音频帧

 @since      v1.11.1
 */
- (CMSampleBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergeAudioSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer __deprecated_msg("Method deprecated in v1.13.0. Use `videoMixRecorder: didGetMergeAudioBufferList:`");


#pragma mark -- 视频录制动作的回调

/*!
 @method videoMixRecorder:didDeleteFileAtURL:fileDuration:totalDuration:
 @abstract 删除了某段视频回调
 
 @param recorder PLSVideoMixRecorder 实例
 @param fileURL 当前删除的文件存放地址
 @param fileDuration 当前删除的文件时长
 @param totalDuration 删除当前文件之后剩余录制文件的总时长

 @since      v1.15.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didDeleteFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

/*!
 @method videoMixRecorder:didStartRecordingToOutputFileAtURL:
 @abstract 开始录制一段视频时
 
 @param recorder PLSVideoMixRecorder 实例
 @param fileURL 录制文件的存放地址
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didStartRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL;

/*!
 @method videoMixRecorder:didRecordingToOutputFileAtURL:fileDuration:totalDuration:
 @abstract 正在录制的过程中。在完成该段视频录制前会一直回调，可用来更新所有视频段加起来的总时长 totalDuration UI。
 
 @param recorder PLSVideoMixRecorder 实例
 @param fileURL 当前正在录制的文件存放地址
 @param fileDuration 当前正在录制的文件时长
 @param totalDuration 所有录制文件的总时长
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

/*!
 @method videoMixRecorder:didFinishRecordingToOutputFileAtURL:fileDuration:totalDuration:
 @abstract 完成一段视频的录制时
 
 @param recorder PLSVideoMixRecorder 实例
 @param fileURL 当前录制完成的文件存放地址
 @param fileDuration 当前录制完成的文件时长
 @param totalDuration 所有录制文件的总时长
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didFinishRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

/*!
 @method videoMixRecorder:didFinishSampleMediaDecoding:
 @abstract 素材视频解码结束。素材视频解码结束之后，代表合拍即将结束。合拍结束会调用 @selector(videoMixRecorder:didFinishRecordingToOutputFileAtURL:fileDuration:totalDuration);
 
 @param recorder PLSVideoMixRecorder 实例
 @param    sampleMediaDuration 素材视频的时长
 
 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didFinishSampleMediaDecoding:(CMTime)sampleMediaDuration;

/*!
 @method videoMixRecorder:errorOccur:
 @abstract 发生错误回调
 
 @param recorder PLSVideoMixRecorder 实例
 @param error 错误信息

 @since      v1.11.0
 */
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder errorOccur:(NSError *__nonnull)error;

@end

#pragma mark - basic

/*!
 @class PLSVideoMixRecorder
 @abstract 分屏视频录制的核心类。
 
 @discussion 一个 PLSVideoMixRecorder 实例会包含了对视频源、音频源的控制，并且对流的操作及流状态的返回都是通过它来完成的。
 */
@interface PLSVideoMixRecorder : NSObject

/*!
 @method assetRepresentingAllFiles
 @brief 获取代表当前会话的所有视频段文件的 asset
 
 @return 返回代表当前会话的所有视频段文件的 asset
 @since      v1.11.0
 */
- (AVAsset *__nonnull)assetRepresentingAllFiles;

/*!
 @property videoConfiguration
 @brief 视频配置，只读
 
 @since      v1.11.0
 */
@property (strong, nonatomic, readonly) PLSVideoMixConfiguration *__nonnull videoConfiguration;

/*!
 @property audioConfiguration
 @brief 音频配置，只读
 
 @since      v1.11.0
 */
@property (strong, nonatomic, readonly) PLSAudioMixConfiguration *__nonnull audioConfiguration;

/*!
 @property previewView
 @brief camera 预览视图
 
 @since      v1.11.0
 */
@property (strong, nonatomic, readonly) UIView *__nullable previewView;

/*!
 @property delegate
 @brief 代理对象
 
 @since      v1.11.0
 */
@property (weak, nonatomic) id<PLSVideoMixRecordererDelegate> __nullable delegate;

/*!
 @property   delegateQueue
 @abstract   触发代理对象回调时所在的任务队列。
 
 @discussion 默认情况下该值为 nil，此时代理方法都会通过 main queue 异步执行回调。如果你期望可以所有的回调在自己创建或者其他非主线程调用，
 可以设置改 delegateQueue 属性。
 
 @see        PLSVideoMixRecorderDelegate
 @see        delegate
 
 @since      v1.11.0
 */
@property (strong, nonatomic) dispatch_queue_t __nullable delegateQueue;

/*!
 @property fillMode
 @brief previewView 中视频的填充方式，默认使用 PLVideoFillModePreserveAspectRatioAndFill
 
 @since      v1.11.0
 */
@property (readwrite, nonatomic) PLSVideoFillModeType fillMode;

/*!
 @property isRecording
 @brief PLSVideoMixRecorder 处于录制状态时为 true
 
 @since      v1.11.0
 */
@property (readonly, nonatomic) BOOL isRecording;

/*!
 @property outputFileType
 @brief 视频的文件类型，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.11.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/*!
 @method initWithVideoConfiguration:audioConfiguration:
 @abstract   初始化方法

 @param videoConfiguration 不能为空
 @param audioConfiguration 不能为空
 
 @return PLSVideoMixRecorder 实例
 @since      v1.11.0
 */
- (nonnull instancetype)initWithVideoConfiguration:(PLSVideoMixConfiguration *__nonnull)videoConfiguration audioConfiguration:(PLSAudioMixConfiguration *__nonnull)audioConfiguration;

/*!
 @property mergeVideoURL
 @brief  素材视频地址，必须设置。 正在录制的时候，不可设置。 如果设置之前已经存在录制文件，需要调用 resetRecording 方法将状态重置为初始状态
 
 @since      v1.11.0
 */
@property (strong, nonatomic) NSURL   *__nonnull mergeVideoURL;

/*!
 @property backgroundMonitorEnable
 @abstract  默认为 YES，即 SDK 内部根据监听到的 Application 前后台状态自动停止和开始录制视频
 
 @warning   设置为 YES 时，即 Application 进入后台，若当前为拍摄视频状态，SDK 内部会自动停止视频的录制，恢复到前台，SDK 内部自动启动视频的录制；设置为 NO 时，即 Application 进入后台，若当前为拍摄视频状态，SDK 内部会停止视频的录制，恢复到前台，SDK 内部不会自动启动视频的录制。为什么设置为 NO，SDK 内部仍然要在 Application 进入后台时停止视频录制呢？原因是，开发者将该属性设置为 NO 后，可能在应用层忘记处理 Application 进入后台时要调用 stopRecording 来停止视频的录制，进而出现 crash。所以，不管该属性是 YES 还是 NO，当 Application进入后台，SDK 内部都会调用 stopRecording 自动停止视频的录制。
 
 @since      v1.12.0
 */
@property (assign, nonatomic) BOOL backgroundMonitorEnable;

/*!
 @method startRecording
 @brief 开始录制视频，录制的视频的存放地址由 SDK 内部自动生成
 
 @warning 获取所有录制的视频段的地址，可以使用 - (NSArray<NSURL *> *__nullable)getAllFilesURL
 
 @since      v1.11.0
 */
- (void)startRecording;

/*!
 @method startRecording:
 @brief 开始录制视频
 @param fileURL 录制的视频的存放地址，该参数可以在外部设置，录制的视频会保存到该位置
 
 @warning 生成 URL 需使用 [NSURL fileURLWithPath:fileName] 方式，让 URL 的 scheme 合法（file://，http://，https:// 等）。获取所有录制的视频段的地址，可以使用 - (NSArray<NSURL *> *__nullable)getAllFilesURL
 
 @since      v1.11.0
 */
- (void)startRecording:(NSURL *_Nonnull)fileURL;

/*!
 @method stopRecording
 @brief 停止录制视频
 
 @since      v1.11.0
 */
- (void)stopRecording;

/*!
 @method cancelRecording
 @brief 取消录制会停止视频录制并删除已经录制的视频段文件
 
 @since      v1.11.0
 */
- (void)cancelRecording;

/*!
 @method resetRecording
 @brief 删除所有已经录制的视频、素材视频将seek到起始位置、在录制的时候、调用该方法会被忽略
 
 @since      v1.11.0
 */
- (void)resetRecording;

/*!
 @method deleteLastFile
 @brief 删除上一个录制的视频段
 
 @since      v1.15.0
 */
- (void)deleteLastFile;

/*!
 @method getAllFilesURL
 @brief 获取所有录制的视频段的地址
 
 @return  返回所有录制的视频段的地址
 @since      v1.11.0
 */
- (NSArray<NSURL *> *__nullable)getAllFilesURL;

/*!
 @method getFilesCount
 @brief 获取录制的视频段的总数目
 
 @return 返回录制的视频段的总数目
 @since      v1.11.0
 */
- (NSInteger)getFilesCount;

/*!
 @method getTotalDuration
 @brief 获取所有录制的视频段加起来的总时长
 
 @return 返回所有录制的视频段加起来的总时长
 @since      v1.11.0
 */
- (CGFloat)getTotalDuration;

@end

#pragma mark - Category (AudioSource)

/*!
 @category PLSVideoMixRecorder (AudioSource)
 @brief 录制音频参数
 */
@interface PLSVideoMixRecorder (AudioSource)

/*!
 @property disableMicrophone
 @brief 是否禁用麦克风音频采集，正在录制的时候，设置不可用.
        该属性等同于: PLSAudioMixConfiguration 的属性 disableMicrophone
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL disableMicrophone;

/*!
 @property disableSample
 @brief 是否禁用素材视频的音频数据，正在录制的时候，设置不可用.
        该属性等同于: PLSAudioMixConfiguration 的属性 disableSample
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL disableSample;

/*!
 @property microphoneVolume
 @brief 混音处理的时候，麦克风采集的音量大小.
        该属性等同于: PLSAudioMixConfiguration 的属性 microphoneVolume
 @since      v1.11.0
 */
@property (assign, nonatomic) float microphoneVolume;

/*!
 @property sampleVolume
 @brief 混音处理的时候，素材视频的音量大小.
        该属性等同于: PLSAudioMixConfiguration 的属性 sampleVolume
 @since      v1.11.0
 */
@property (assign, nonatomic) float sampleVolume;

/*!
 @property acousticEchoCancellationEnable
 @brief 麦克风采集是否启动回音消除，正在录制的时候，设置不可用.
        该属性等同于: PLSAudioMixConfiguration 的属性 acousticEchoCancellationEnable
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL acousticEchoCancellationEnable;

@end

#pragma mark - Category (CameraSource)

/*!
 @category PLSVideoMixRecorder(CameraSource)
 
 @brief 与摄像头相关的接口
 
 @since      v1.11.0
 */
@interface PLSVideoMixRecorder (CameraSource)

/*!
 @property captureDevicePosition
 @brief default as AVCaptureDevicePositionBack
 
 @since      v1.11.0
 */
@property (assign, nonatomic) AVCaptureDevicePosition   captureDevicePosition;

/*!
 @property torchOn
 @abstract default as NO.
 
 @since      v1.11.0
 */
@property (assign, nonatomic, getter=isTorchOn) BOOL torchOn;

/*!
 @property  innerFocusViewShowEnable
 @abstract  手动对焦的视图动画。该属性默认开启。
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL innerFocusViewShowEnable;

/*!
 @property  continuousAutofocusEnable
 @abstract  连续自动对焦。该属性默认开启。
 
 @since      v1.11.0
 */
@property (assign, nonatomic, getter=isContinuousAutofocusEnable) BOOL continuousAutofocusEnable;

/*!
 @property  touchToFocusEnable
 @abstract  手动点击屏幕进行对焦。该属性默认开启。
 
 @since      v1.11.0
 */
@property (assign, nonatomic, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/*!
 @property  smoothAutoFocusEnabled
 @abstract  该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。该属性默认开启。
 */
@property (assign, nonatomic, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;

/*!
 @property focusPointOfInterest
 @abstract default as (0.5, 0.5), (0,0) is top-left, (1,1) is bottom-right.
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CGPoint   focusPointOfInterest;

/*!
 @property videoZoomFactor
 @abstract 默认为 1.0，设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败
 
 @since      v1.11.0
 */
@property (assign, nonatomic) CGFloat videoZoomFactor;

/*!
 @property videoFormats
 @brief videoFormats
 
 @since      v1.11.0
 */
@property (strong, nonatomic, readonly) NSArray<AVCaptureDeviceFormat *> *__nonnull videoFormats;

/*!
 @property videoActiveFormat
 @brief videoActiveFormat
 
 @since      v1.11.0
 */
@property (strong, nonatomic) AVCaptureDeviceFormat *__nonnull videoActiveFormat;

/*!
 @property sessionPreset
 @brief 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset1280x720
 
 @since      v1.11.0
 */
@property (strong, nonatomic) NSString *__nonnull sessionPreset;

/*!
 @property videoFrameRate
 @brief 采集的视频数据的帧率，默认为 25
 
 @since      v1.11.0
 */
@property (assign, nonatomic) NSUInteger videoFrameRate;

/*!
 @property previewMirrorFrontFacing
 @brief 前置预览是否开启镜像，默认为 YES
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL previewMirrorFrontFacing;

/*!
 @property previewMirrorRearFacing
 @brief 后置预览是否开启镜像，默认为 NO
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL previewMirrorRearFacing;

/*!
 @property streamMirrorFrontFacing
 @brief 前置摄像头，编码写入文件时是否开启镜像，默认 NO
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL streamMirrorFrontFacing;

/*!
 @property streamMirrorRearFacing
 @brief 后置摄像头，编码写入文件时是否开启镜像，默认 NO
 
 @since      v1.11.0
 */
@property (assign, nonatomic) BOOL streamMirrorRearFacing;

/*!
 @property renderQueue
 @brief 预览的渲染队列
 
 @since      v1.11.0
 */
@property (strong, nonatomic, readonly) dispatch_queue_t __nonnull renderQueue;

/*!
 @property renderContext
 @brief 预览的渲染 OpenGL context
 
 @since      v1.11.0
 */
@property (strong, nonatomic, readonly) EAGLContext *__nonnull renderContext;

/*!
 @method toggleCamera
 @brief  切换前置／后置摄像头
 */
- (void)toggleCamera;

/*!
 @method toggleCamera:
 @brief 切换前置／后置摄像头
 
 @param completeBlock 切换相机完成回调
 
 @since 2.0.0
 */
- (void)toggleCamera:(void(^)(BOOL isFinish))completeBlock;

/*!
 @method startCaptureSession
 @brief 开启音视频采集
 
 @since      v1.11.0
 */
- (void)startCaptureSession;

/*!
 @method stopCaptureSession
 @brief 停止音视频采集
 
 @since      v1.11.0
 */
- (void)stopCaptureSession;

/*!
 @method setMergeMediaStartTime:
 @brief  设置素材视频的起始时间点, 正在录制过程中设置无效
 
 @param toTime 素材视频的起始时间点
 
 @since      v1.11.0
 */
- (void)setMergeMediaStartTime:(CMTime)toTime;

/*!
 @method setBeautifyModeOn:
 @brief  是否开启美颜
 
 @param beautifyModeOn 美颜开关
 
 @since      v1.11.0
 */
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/*!
 @method setBeautify:
 @brief 设置对应 Beauty 的程度参数.
 
 @param beautify 范围从 0 ~ 1，0 为不美颜
 
 @since      v1.11.0
 */
-(void)setBeautify:(CGFloat)beautify;

/*!
 @method setWhiten:
 @brief  设置美白程度（注意：如果美颜不开启，设置美白程度参数无效）
 
 @param whiten 范围是从 0 ~ 1，0 为不美白
 
 @since      v1.11.0
 */
-(void)setWhiten:(CGFloat)whiten;

/*!
 @method setRedden:
 @brief 设置红润的程度参数.（注意：如果美颜不开启，设置美白程度参数无效）
 
 @param redden 范围是从 0 ~ 1，0 为不红润
 
 @since      v1.11.0
 */

-(void)setRedden:(CGFloat)redden;

/*!
 @method setWaterMarkWithImage:position:
 @brief 开启水印
 
 @param waterMarkImage 水印的图片
 @param position       水印的位置
 
 @since      v1.11.0
 */
-(void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position;


/*!
 @method clearWaterMark
 @brief  移除水印
 
 @since      v1.11.0
 */
-(void)clearWaterMark;

@end
