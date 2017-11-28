//
//  PLShortVideoRecorder.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "PLSVideoConfiguration.h"
#import "PLSAudioConfiguration.h"
#import "PLSTypeDefines.h"

@class PLShortVideoRecorder;
@protocol PLShortVideoRecorderDelegate <NSObject>

@optional
#pragma mark -- 摄像头／麦克风权限变化的回调
/**
 @abstract 摄像头授权状态发生变化的回调
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status;

/**
 @abstract 麦克风授权状态发生变化的回调
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status;

#pragma mark -- 摄像头对焦位置的回调
/**
 @abstract 摄像头对焦位置的回调

 @since      v1.6.0
 */
- (void)shortVideoRecorderDidFocusAtPoint:(CGPoint)point;

#pragma mark -- 摄像头／麦克风采集数据的回调
/**
 @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
 
 @since      v1.0.0
 */
- (CVPixelBufferRef __nonnull)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/**
 @abstract 获取到麦克风原数据时的回调，需要注意的是这个回调在 microphone 数据的输出线程，请不要做过于耗时的操作，否则可能阻塞该线程影响音频输出或其他未知问题
 
 @since      v1.0.1
 */
- (CMSampleBufferRef __nonnull)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder microphoneSourceDidGetSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer;

#pragma mark -- 视频录制动作的回调
/**
 @abstract 开始录制一段视频时
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didStartRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL;

/**
 @abstract 正在录制的过程中。在完成该段视频录制前会一直回调，可用来更新所有视频段加起来的总时长 totalDuration UI。
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

/**
 @abstract 删除了某一段视频
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didDeleteFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

/**
 @abstract 完成一段视频的录制时
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didFinishRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

/**
 @abstract 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，那么会立即执行该回调。该回调功能是用于页面跳转
 
 @since      v1.0.0
 */
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration;

@end

#pragma mark - basic

/**
 * @abstract 短视频录制的核心类。
 *
 * @discussion 一个 PLShortVideoRecorder 实例会包含了对视频源、音频源的控制，并且对流的操作及流状态的返回都是通过它来完成的。
 */
@interface PLShortVideoRecorder : NSObject

/**
 @brief 返回代表当前会话的所有视频段文件的 asset
 
 @since      v1.0.0
 */
- (AVAsset *__nonnull)assetRepresentingAllFiles;

/**
 @brief 视频录制的最大时长，单位为秒。默认为10秒
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat maxDuration;

/**
 @brief 视频录制的最短时间，单位为秒。默认为2秒
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat minDuration;

/**
 @brief 视频配置，只读
 
 @since      v1.0.0
 */
@property (strong, nonatomic, readonly) PLSVideoConfiguration *__nonnull videoConfiguration;

/**
 @brief 音频配置，只读
 
 @since      v1.0.0
 */
@property (strong, nonatomic, readonly) PLSAudioConfiguration *__nonnull audioConfiguration;

/**
 @brief 摄像头的预览视图
 
 @since      v1.0.0
 */
@property (strong, nonatomic, readonly) UIView *__nullable previewView;

/**
 @brief 根据设备的方向自动确定竖屏、横屏拍摄。默认为 NO，不启用自动确定
 
 @since      v1.3.0
 */
@property (assign, nonatomic) BOOL adaptationRecording;

/**
 @brief 当 adaptationRecording 为YES时，获取设备方向的回调 deviceOrientationBlock 才有效。
        拍摄时可根据 deviceOrientation 做 UI 效果来标明当前拍摄的方向是竖屏还是横屏。
        PLSPreviewOrientationPortrait           竖屏拍摄
        PLSPreviewOrientationPortraitUpsideDown 倒立拍摄
        PLSPreviewOrientationLandscapeRight     右横屏拍摄
        PLSPreviewOrientationLandscapeLeft      左横屏拍摄
 
 @since      v1.3.0
 */
@property (copy, nonatomic) void(^ _Nullable deviceOrientationBlock)(PLSPreviewOrientation deviceOrientation);

/**
 @brief 代理对象
 
 @since      v1.0.0
 */
@property (weak, nonatomic) id<PLShortVideoRecorderDelegate> __nullable delegate;

/**
 @property   delegateQueue
 @abstract   触发代理对象回调时所在的任务队列。
 
 @discussion 默认情况下该值为 nil，此时代理方法都会通过 main queue 异步执行回调。如果你期望可以所有的回调在自己创建或者其他非主线程调用，
 可以设置改 delegateQueue 属性。
 
 @see        PLShortVideoRecorderDelegate
 @see        delegate
 
 @since      v1.0.0
 */
@property (strong, nonatomic) dispatch_queue_t __nullable delegateQueue;

/**
 @brief previewView 中视频的填充方式，默认使用 PLVideoFillModePreserveAspectRatioAndFill
 
 @since      v1.0.0
 */
@property (readwrite, nonatomic) PLSVideoFillModeType fillMode;

/**
 @brief PLShortVideoRecorder 处于录制状态时为 true
 
 @since      v1.0.0
 */
@property (readonly, nonatomic) BOOL isRecording;

/**
 @brief 是否开启音视频采集
 
 @since      v1.2.0
 */
@property (assign, nonatomic, readonly) BOOL captureEnabled;

/**
 @brief 视频拍摄速率值，默认使用 PLSVideoRecoderRateNormal，isRecording 为 YES 时，设置该值无效
 
 @since      v1.4.0
 */
@property (readwrite, nonatomic) PLSVideoRecoderRateType recoderRate;

/**
 @brief 视频的文件类型，默认为 PLSFileTypeMPEG4(.mp4)
 
 @since      v1.6.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/**
 @abstract   初始化方法
 
 @since      v1.0.0
 
 @discussion videoConfiguration 设置为 nil 时，不采集视频。
             audioConfiguration 设置为 nil 时，不采集音频。
 */
- (nonnull instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *_Nullable)videoConfiguration audioConfiguration:(PLSAudioConfiguration *_Nullable)audioConfiguration;

/**
 @abstract   初始化方法
 
 @since      v1.2.0
 
 @discussion 是否使用 SDK 内部的音视频采集，默认为 YES，当设置为 NO 时，可通过以下两个接口导入音视频数据
    - (void)writePixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer timeStamp:(CMTime)timeStamp;
    - (void)writeAudioBuffer:(AudioBuffer *_Nonnull)audioBuffer asbd:(AudioStreamBasicDescription *_Nonnull)asbd timeStamp:(CMTime)timeStamp;
 */
- (nonnull instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *__nonnull)videoConfiguration audioConfiguration:(PLSAudioConfiguration *__nonnull)audioConfiguration captureEnabled:(BOOL)captureEnabled;

/**
 @abstract   写入视频数据，当 captureEnabled 为 NO 时，可通过该接口导入视频数据
 
 @warning 目前仅支持 kCVPixelFormatType_32BGRA 格式的 pixelBuffer

 @since      v1.2.0
 */
- (void)writePixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer timeStamp:(CMTime)timeStamp;

/**
 @abstract   写入音频数据，当 captureEnabled 为 NO 时，可通过该接口导入音频数据
 
 @since      v1.2.0
 */
- (void)writeSampleBuffer:(CMSampleBufferRef _Nonnull)sampleBuffer;

/**
 @abstract   插入视频，支持任意位置，通过该接口传入，成为 PLShortVideoRecorder 当前视频数组的下一个视频段
 
 @warning   PLShortVideoRecorder 初始化后调用，当视频时长加上视频数组中的所有视频段时长，超过视频设置的最大时长 maxDuration 时，则传值无效
 
 @since      v1.7.0
 */
- (void)insertVideo:(NSURL *_Nonnull)videoURL;

/**
 @brief 开始录制视频
 
 @since      v1.0.0
 */
- (void)startRecording;

/**
 @brief 停止录制视频
 
 @since      v1.0.0
 */
- (void)stopRecording;

/**
 @brief 取消录制会停止视频录制并删除已经录制的视频段文件
 
 @since      v1.0.0
*/
- (void)cancelRecording;

/**
 @brief 删除上一个录制的视频段
 
 @since      v1.0.0
 */
- (void)deleteLastFile;

/**
 @brief 删除所有录制的视频段
 
 @since      v1.0.0
 */
- (void)deleteAllFiles;

/**
 @brief 获取所有录制的视频段的地址
 
 @since      v1.0.0
 */
- (NSArray<NSURL *> *__nullable)getAllFilesURL;

/**
 @brief 获取录制的视频段的总数目
 
 @since      v1.0.0
 */
- (NSInteger)getFilesCount;

/**
 @brief 获取所有录制的视频段加起来的总时长
 
 @since      v1.0.0
 */
- (CGFloat)getTotalDuration;

@end

#pragma mark -- PLShortVideoRecorder (mixAudio)

@interface PLShortVideoRecorder (mixAudio)
/**
 @abstract   设置录制时的背景音乐
 
 @warning   PLShortVideoRecorder 初始化后调用，audioURL 为音频 URL
 
 @since      v1.7.0
 */
- (void)mixAudio:(NSURL *_Nullable)audioURL;

/**
 @brief   获取添加背景音乐录制完成后的 audioMix
 
 @warning   设置背景音乐后有效
 *
 *  @param musicVolume 背景音乐音量，范围 0 ～ 1
 *  @param videoVolume 原视频音量，范围 0 ～ 1
 *  @param completionHandler 获取 composition 及 audioMix
 *
 @since      v1.7.0
 */
- (void)mixWithMusicVolume:(float)musicVolume videoVolume:(float)videoVolume completionHandler:(void (^_Nonnull)(AVMutableComposition * _Nullable composition, AVAudioMix * _Nullable audioMix, NSError * _Nullable error))completionHandler;
@end

#pragma mark - Category (Info)

/**
 @category   PLShortVideoRecorder (Info)
 @abstract   SDK 信息相关
 
 @since      v1.0.0
 */
@interface PLShortVideoRecorder (Info)

/*!
 @method     versionInfo
 @abstract   PLShortVideoRecorder 的 SDK 版本。
 
 @since      v1.0.0
 */
+ (NSString *__nonnull)versionInfo;

@end

#pragma mark - Category (Dubber)

/**
 @category   PLShortVideoRecorder (Dubber)
 @abstract   视频配音
 
 @since      v1.6.0
 */
@interface PLShortVideoRecorder (Dubber)

/**
 @brief 纯音频录制时，将录制的纯音频 AVAsset *audio = [self.recorder assetRepresentingAllFiles] 与 asset 混合。
 
 @since      v1.6.0
 */
- (AVAsset *_Nullable)mixAsset:(AVAsset *_Nullable)asset timeRange:(CMTimeRange)timeRange;

@end

#pragma mark - Category (CameraSource)

/**
 * @category PLShortVideoRecorder(CameraSource)
 *
 * @discussion 与摄像头相关的接口
 
 @since      v1.0.0
 */
@interface PLShortVideoRecorder (CameraSource)

/**
 @brief default as AVCaptureDevicePositionBack
 
 @since      v1.0.0
 */
@property (assign, nonatomic) AVCaptureDevicePosition   captureDevicePosition;

/**
 @brief 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait
 
 @since      v1.0.0
 */
@property (assign, nonatomic) AVCaptureVideoOrientation videoOrientation;

/**
 @abstract default as NO.

 @since      v1.0.0
*/
@property (assign, nonatomic, getter=isTorchOn) BOOL torchOn;

/**
 @property  continuousAutofocusEnable
 @abstract  手动对焦的视图动画。该属性默认开启。
 
 @since      v1.6.0
 */
@property (assign, nonatomic) BOOL innerFocusViewShowEnable;

/**
 @property  continuousAutofocusEnable
 @abstract  连续自动对焦。该属性默认开启。
 
 @since      v1.0.0
 */
@property (assign, nonatomic, getter=isContinuousAutofocusEnable) BOOL continuousAutofocusEnable;

/**
 @property  touchToFocusEnable
 @abstract  手动点击屏幕进行对焦。该属性默认开启。
 
 @since      v1.0.0
 */
@property (assign, nonatomic, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/**
 @property  smoothAutoFocusEnabled
 @abstract  该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。该属性默认开启。
 */
@property (assign, nonatomic, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;

/**
 @abstract default as (0.5, 0.5), (0,0) is top-left, (1,1) is bottom-right.
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGPoint   focusPointOfInterest;

/**
 @abstract 默认为 1.0，设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat videoZoomFactor;

/**
 @brief videoFormats
 
 @since      v1.0.0
 */
@property (strong, nonatomic, readonly) NSArray<AVCaptureDeviceFormat *> *__nonnull videoFormats;

/**
 @brief videoActiveFormat
 
 @since      v1.0.0
 */
@property (strong, nonatomic) AVCaptureDeviceFormat *__nonnull videoActiveFormat;

/**
 @brief 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset1280x720
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSString *__nonnull sessionPreset;

/**
 @brief 采集的视频数据的帧率，默认为 25
 
 @since      v1.0.0
 */
@property (assign, nonatomic) NSUInteger videoFrameRate;

/**
 @brief 前置预览是否开启镜像，默认为 YES
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL previewMirrorFrontFacing;

/**
 @brief 后置预览是否开启镜像，默认为 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL previewMirrorRearFacing;

/**
 *  前置摄像头，编码写入文件时是否开启镜像，默认 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL streamMirrorFrontFacing;

/**
 *  后置摄像头，编码写入文件时是否开启镜像，默认 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL streamMirrorRearFacing;

/**
 *  预览的渲染队列
 
 @since      v1.0.0
 */
@property (strong, nonatomic, readonly) dispatch_queue_t __nonnull renderQueue;

/**
 *  预览的渲染 OpenGL context
 
 @since      v1.0.0
 */
@property (strong, nonatomic, readonly) EAGLContext *__nonnull renderContext;

/**
 *  切换前置／后置摄像头
 */
- (void)toggleCamera;

/**
 * 开启音视频采集
 *
 @since      v1.0.0
 */
- (void)startCaptureSession;

/**
 * 停止音视频采集
 *
 @since      v1.0.0
 */
- (void)stopCaptureSession;

/**
 *  是否开启美颜
 
 @since      v1.0.0
 */
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/**
 @brief 设置对应 Beauty 的程度参数.
 
 @param beautify 范围从 0 ~ 1，0 为不美颜
 
 @since      v1.0.0
 */
-(void)setBeautify:(CGFloat)beautify;

/**
 *  设置美白程度（注意：如果美颜不开启，设置美白程度参数无效）
 *
 *  @param whiten 范围是从 0 ~ 1，0 为不美白
 
 @since      v1.0.0
 */
-(void)setWhiten:(CGFloat)whiten;

/**
 *  设置红润的程度参数.（注意：如果美颜不开启，设置美白程度参数无效）
 *
 *  @param redden 范围是从 0 ~ 1，0 为不红润
 
 @since      v1.0.0
 */

-(void)setRedden:(CGFloat)redden;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 
 @since      v1.0.0
 */
-(void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position;

/**
 *  移除水印
 
 @since      v1.0.0
 */
-(void)clearWaterMark;

/**
 *  重新配置视频的参数
 
 @since      v1.0.0
 */
- (void)reloadvideoConfiguration:(PLSVideoConfiguration *__nonnull)videoConfiguration;

@end

