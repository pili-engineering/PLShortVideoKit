//
//  PLSCameraSource.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "PLSSourceAccessProtocol.h"
#import "PLSTypeDefines.h"
#import "PLSVideoConfiguration.h"
#import "PLSUtilFunctions.h"

#pragma mark - CameraSourceYUVOutput Format

/*!
 @typedef    PLSCameraSourceYUVOutputFormat
 @abstract   PLSCameraSourceYUVOutput 的 YUV 类型。
 @since      v1.0.0
 */
typedef NS_OPTIONS(NSUInteger, PLSCameraSourceOutputFormat) {
    PLSCameraSourceOutputFormatNV12 = 0,
    PLSCameraSourceOutputFormatI420 = 1,
    PLSCameraSourceOutputFormat32BGRA = 2
};

@class PLSCameraSource;

/*!
 @protocol PLSCameraSourceDelegate
 @brief 相机采集协议.
 */
@protocol PLSCameraSourceDelegate <NSObject>

@optional

/*!
 @method cameraSource:didFocusAtPoint:
 @brief 焦点变化回调.

 @param source PLSCameraSource 实例
 @param point  当前的相机焦点
*/
- (void)cameraSource:(PLSCameraSource *)source didFocusAtPoint:(CGPoint)point;

/*!
 @method cameraSource:didGetOriginPixelBuffer:
 @brief 采集之后没有经过任何处理的视频帧回调.
 
 @param source          PLSCameraSource 实例
 @param pixelBuffer     视频帧
 
 @return 如果需要替换掉 pixelBuffer，则返回替换的视频帧,否则直接返回 pixelBuffer
 */
- (CVPixelBufferRef)cameraSource:(PLSCameraSource *)source
         didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer
                sampleTimingInfo:(CMSampleTimingInfo)sampleTimingInfo;

/*!
 @method cameraSource:didGetOriginSampleBuffer:
 @abstract 相机原始 sample buffer
 
 @param source PLSCameraSource 实例
 @param sampleBuffer 视频帧
 
 @since 3.2.1
 */
- (void)cameraSource:(PLSCameraSource *)source didGetOriginSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*!
 @method cameraSource:didGetResultPixelBuffer:sampleTimingInfo:
 @brief 经过美颜滤镜处理之后的视频帧回调
 
 @param source          PLSCameraSource 实例
 @param pixelBuffer     视频帧
 @param sampleTimingInfo 视频帧对应的时间戳
  */
- (void)cameraSource:(PLSCameraSource *)source didGetResultPixelBuffer:(CVPixelBufferRef)pixelBuffer sampleTimingInfo:(CMSampleTimingInfo)sampleTimingInfo;

/*!
 @method cameraSource:didGetPreviewPixelBuffer:sampleTimingInfo:
 @brief 预览的视频帧回调（合拍的时候录用到）.
 
 @param source          PLSCameraSource 实例
 @param pixelBuffer     视频帧
 @param sampleTimingInfo 视频帧对应的时间戳
 */
- (void)cameraSource:(PLSCameraSource *)source didGetPreviewPixelBuffer:(CVPixelBufferRef)pixelBuffer sampleTimingInfo:(CMSampleTimingInfo)sampleTimingInfo;

@end

/*!
 @class PLSCameraSource
 @brief 相机采集类
 */
@interface PLSCameraSource : NSObject
<
PLSSourceAccessProtocol
>

/*!
 @property delegate
 @brief 采集回调代理.
 */
@property (weak, nonatomic) id<PLSCameraSourceDelegate>   delegate;

/*!
 @property videoConfiguration
 @brief 视频参数配置.
 */
@property (strong, nonatomic)  PLSVideoConfiguration   *videoConfiguration;

/*!
 @property cameraPosition
 @brief 相机位置.
 */
@property (assign, nonatomic) AVCaptureDevicePosition  cameraPosition;

/*!
 @property torchOn
 @brief 闪光灯是否打开.
 */
@property (assign, nonatomic, getter=isTorchOn) BOOL torchOn;

/*!
 @property previewView
 @brief 预览 view.
 */
@property (strong, nonatomic) UIView *previewView;

/*!
 @property running
 @brief 相机采集是否处于运行状态.
 */
@property (assign, nonatomic, readonly, getter=isRunning) BOOL running;

/*!
 @property videoOrientation
 @brief 相机采集的方向.
 */
@property (assign, nonatomic) AVCaptureVideoOrientation videoOrientation;

/*!
 @property focusPointOfInterest
 @brief 相机焦点，默认: {0.5, 0.5}.
 */
@property (assign, nonatomic) CGPoint   focusPointOfInterest;

/*!
 @property continuousAutofocusEnable
 @brief 是否持续对焦，默认：YES.
 */
@property (assign, nonatomic, getter=isContinuousAutofocusEnable) BOOL  continuousAutofocusEnable;

/*!
 @property smoothAutoFocusEnabled
 @brief 是否平滑对焦，默认：NO.
 */
@property (assign, nonatomic, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;

/*!
 @property innerFocusViewShowEnable
 @brief 点击预览 view 发生对焦的时候，是否显示对焦动画.
 */
@property (assign, nonatomic) BOOL innerFocusViewShowEnable;

/*!
 @property renderQueue
 @brief 预览的渲染队列.
 */
@property (strong, nonatomic) dispatch_queue_t renderQueue;

/*!
 @property videoZoomFactor
 @brief 视频放大因子.
 */
@property (assign, nonatomic) CGFloat videoZoomFactor;

/*!
 @property videoActiveFormat
 @brief 采集设备参数.
 */
@property (strong, nonatomic) AVCaptureDeviceFormat *videoActiveFormat;

/*!
 @property videoFormats
 @brief 采集设备参数集.
 */
@property (strong, nonatomic, readonly) NSArray<AVCaptureDeviceFormat *> *videoFormats;

/*!
 @property beautifyModeOn
 @brief 是否开启美颜.
 */
@property (assign, nonatomic, getter=isBeautifyModeOn) BOOL beautifyModeOn;

/*!
 @property touchToFocusEnable
 @brief 是否启用手动点击对焦.
 */
@property (assign, nonatomic, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/*!
 @property fillMode
 @brief 视频填充模式.
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/*!
 @property previewOrientation
 @brief 视频预览方向.
 */
@property (assign, nonatomic) PLSPreviewOrientation previewOrientation;

/*!
 @property previewRenderType
 @brief 渲染类型(不建议设置).
 */
@property (assign, nonatomic) PLSPreviewRenderType previewRenderType;

/*!
 @property sessionPreset
 @brief 采集像素设置.
 */
@property (strong, nonatomic) NSString *sessionPreset;

/*!
 @property videoFrameRate
 @brief 采集帧率.
 */
@property (assign, nonatomic) NSUInteger videoFrameRate;

/*!
 @property previewMirrorFrontFacing
 @brief 使用前置摄像头的时候预览是否镜像，一般都设置为:YES.
 */
@property (assign, nonatomic) BOOL previewMirrorFrontFacing;

/*!
 @property previewMirrorRearFacing
 @brief 使用后置摄像头的时候预览是否镜像，一般都设置为：NO.
 */
@property (assign, nonatomic) BOOL previewMirrorRearFacing;

/*!
 @property streamMirrorFrontFacing
 @brief 使用前置摄像头的时候编码是否镜像（生成视频文件的时候，视频是否镜像），一般都设置为:NO.
 */
@property (assign, nonatomic) BOOL streamMirrorFrontFacing;

/*!
 @property streamMirrorRearFacing
 @brief 使用后置摄像头的时候编码是否镜像（生成视频文件的时候，视频是否镜像），一般都设置为:NO.
 */
@property (assign, nonatomic) BOOL streamMirrorRearFacing;

/*!
 @property outputFormat
 @brief 暂不支持设置，当前只支持 32BGRA.
 */
@property (assign, nonatomic) PLSCameraSourceOutputFormat outputFormat;

/*!
 @property adaptationRecording
 @brief 重力感应，自动横竖屏切换录制.
 */
@property (assign, nonatomic) BOOL adaptationRecording;

/*!
 @property flipVideoFrameEnable
 @brief 翻转视频.
 */
@property (assign, nonatomic) BOOL flipVideoFrameEnable;

/*!
 @property currentOrientation
 @brief 相机采集方向.
 */
@property (assign, nonatomic) AVCaptureVideoOrientation currentOrientation;

/*!
 @property captureDeviceInput
 @brief 相机采集输入设备.
 */
@property (readonly, nonatomic) AVCaptureDeviceInput *captureDeviceInput;

/*!
 @property captureSession
 @brief 相机采集 session.
 */
@property (readonly, nonatomic) AVCaptureSession *captureSession;

/*!
 @method hasCameraForPosition:
 @brief 检查相机设备是否存在.
 
 @param position 检查位置.
 */
+ (BOOL)hasCameraForPosition:(AVCaptureDevicePosition)position;

/*!
 @method initWithVideoConfiguration:
 @brief 初始化方法.
 
 @param configuration 视频参数.
 
 @return 实例
 */
- (instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *)configuration;

/*!
 @method initWithVideoConfiguration:eaglContext:
 @brief 初始化方法.
 
 @param configuration 视频参数.
 @param context OpenGL ES 的上下文，传: nil.
 
 @return 实例
 */
- (instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *)configuration eaglContext:(EAGLContext *)context;

/*!
 @method setupCaptureSession
 @brief 初始化相机采集.
 
 @return 成功返回: YES，失败返回: NO.
 */
- (BOOL)setupCaptureSession;

/*!
 @method toggleCamera
 @brief 切换相机.
 */
- (void)toggleCamera;

/*!
 @method toggleCamera:
 
 @param completeBlock 切换相机完成回调
 @brief 切换相机.
 */
- (void)toggleCamera:(void(^)(BOOL isFinish))completeBlock;

/*!
 @method startRunning
 @brief 开始采集.
 */
- (void)startRunning;

/*!
 @method stopRunning
 @brief 停止采集.
 */
- (void)stopRunning;

/*!
 @method reloadvideoConfiguration:
 @brief 重置视频参数.
 */
- (void)reloadvideoConfiguration:(PLSVideoConfiguration *)videoConfiguration;

/*!
 @method setBeautify:
 @brief 设置美颜级别.
 
 @param beautify 美颜级别(0 ~ 1.0).
 */
-(void)setBeautify:(float)beautify;

/*!
 @method setWhiten:
 @brief 设置美白级别.
 
 @param whiten 美白级别(0 ~ 1.0).
 */
-(void)setWhiten:(float)whiten;

/*!
 @method setRedden:
 @brief 设置红润级别.
 
 @param redden 红润级别(0 ~ 1.0).
 */
-(void)setRedden:(float)redden;

/*!
 @method setWaterMarkWithImage:position:
 @brief 设置水印.
 
 @param waterMarkImage 水印图片.
 @param position 水印左上角位置.
 */
-(void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;

/*!
 @method removeWaterMark
 @brief 移除水印.
 */
-(void)removeWaterMark;

/*!
 @method getScreenShotWithCompletionHandler:
 @brief 实时截帧.
 */
- (void)getScreenShotWithCompletionHandler:(void(^)(UIImage *image))handle;

@end
