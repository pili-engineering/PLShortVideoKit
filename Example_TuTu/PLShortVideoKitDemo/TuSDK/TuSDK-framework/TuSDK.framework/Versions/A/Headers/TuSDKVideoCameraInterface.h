//
//  TuSDKVideoCameraExtendViewInterface.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/9.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKResult.h"
#import "TuSDKCPRegionHandler.h"
#import "TuSDKTSFaceHelper.h"
#import "TuSDKFilterAdapter.h"

/**
 *  视频相机状态
 */
typedef NS_ENUM(NSInteger, lsqCameraState)
{
    /**
     *  未知
     */
    lsqCameraStateUnknow = 0,
    /**
     *  正在启动
     */
    lsqCameraStateStarting = 1,
    /**
     *  启动完成
     */
    lsqCameraStateStarted = 2,
    /**
     * 正在拍摄
     */
    lsqCameraStateCapturing = 3,
    
    /**
     * 录制暂停
     */
    lsqCameraStatePaused = 4,
    
    /**
     * 拍摄完成
     */
    lsqCameraStateCaptured = 5
};

#pragma mark - TuSDKVideoCameraDelegate
@protocol TuSDKVideoCameraInterface;

/**
 *  相机事件委托
 */
@protocol TuSDKVideoCameraDelegate <NSObject>

@optional
/**
 *  相机状态改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param camera 相机对象
 *  @param state  相机运行状态
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera stateChanged:(lsqCameraState)state;

/**
 *  相机滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param camera    相机对象
 *  @param newFilter 新的滤镜对象
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera filterChanged:(TuSDKFilterWrap *)newFilter;

/**
 *  获取拍摄图片 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param camera 相机对象
 *  @param result 获取的结果
 *  @param error  错误信息
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera takedResult:(TuSDKResult *)result error:(NSError *)error;

/**
 *  原始帧采样缓冲数据
 *
 *  @param camera       camera对象
 *  @param sampleBuffer 帧采样缓冲
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera sampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end

#pragma mark - TuSDKVideoCameraSampleBufferDelegate
/**
 *  相机帧采样缓冲委托
 */
@protocol TuSDKVideoCameraSampleBufferDelegate<NSObject>
/**
 *  原始帧采样缓冲数据
 *
 *  @param sampleBuffer 帧采样缓冲
 *  @param rotation     原始图像方向
 *  @param previewSize  预览尺寸
 *  @param angle        设备角度
 */
- (void)onProcessVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer rotation:(UIImageOrientation)rotation previewSize:(CGSize)previewSize angle:(float)angle;

@optional
/**
 *  原始帧采样缓冲数据
 *
 *  @param pixelBuffer  帧采样缓冲
 *  @param rotation     原始图像方向
 *  @param angle        设备角度
 */
- (void)onProcessVideoPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(UIImageOrientation)rotation angle:(float)angle;
@end

@protocol TuSDKVideoCameraExtendViewInterface;
@protocol TuSDKStillCameraInterface;

#pragma mark - TuSDKVideoCameraInterface
/**
 *  视频相机接口
 */
@protocol TuSDKVideoCameraInterface <NSObject>
/**
 *  相机帧采样缓冲委托
 */
@property (nonatomic, weak) id<TuSDKVideoCameraSampleBufferDelegate> sampleBufferDelegate;

/**
 *  系统相机对象
 */
@property (readonly) AVCaptureDevice *inputCamera;

/**
 *  图像输出方向
 */
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

/**
 *  是否为前置摄像头
 */
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;

/**
 *  是否为后置摄像头
 */
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

/**
 *  水平镜像前置摄像头
 */
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera;

/**
 *  水平镜像后置摄像头
 */
@property(readwrite, nonatomic) BOOL horizontallyMirrorRearFacingCamera;

/**
 *  禁用前置摄像头水平镜像 (默认: NO，前置摄像头输出画面进行水平镜像)
 */
@property (nonatomic) BOOL disableMirrorFrontFacing;

/**
 *  相机状态
 */
@property (nonatomic, readonly) lsqCameraState state;

/**
 *  开启滤镜配置选项
 */
@property (nonatomic) BOOL enableFilterConfig;

/**
 *  是否开启长按拍摄 (默认: NO)
 */
@property (nonatomic) BOOL enableLongTouchCapture;

/**
 *  禁用持续自动对焦 (默认: NO)
 */
@property (nonatomic) BOOL disableContinueFoucs;

/**
 *  自动聚焦延时 (默认: 5秒)
 */
@property (nonatomic) NSTimeInterval autoFoucsDelay;

/**
 *  长按延时 (默认: 1.2秒)
 */
@property (nonatomic) NSTimeInterval longTouchDelay;

/**
 *  视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
 */
@property (nonatomic) CGFloat cameraViewRatio;

/**
 *  视频覆盖区域颜色 (默认：[UIColor blackColor])
 */
@property (nonatomic, retain) UIColor *regionViewColor;

/**
 *  是否显示辅助线 (默认: false)
 */
@property (nonatomic) BOOL displayGuideLine;

/**
 *  选区范围算法
 */
@property (nonatomic, retain) id<TuSDKCPRegionHandler> regionHandler;

/**
 *  照片输出分辨率
 */
@property (nonatomic) CGSize outputSize;

/**
 *  是否开启脸部追踪
 */
@property (nonatomic) BOOL enableFaceDetection;

/**
 *  是否开启焦距调节 (默认关闭)
 */
@property (nonatomic, assign) BOOL enableFocalDistance;

/**
 *  相机显示焦距 (默认为 1，最大不可超过硬件最大值，当小于 1 时，取 1)
 */
@property (nonatomic, assign) CGFloat focalDistanceScale;

/**
 *  相机支持的最大值 (只读属性)
 */
@property (nonatomic, readonly, assign) CGFloat supportMaxFocalDistanceScale;

/**
 *  视频相机前置或后置
 *
 *  @return cameraPosition 视频相机前置或后置
 */
- (AVCaptureDevicePosition)cameraPosition;

/**
 *  是否支持对焦
 *
 *  @param focusMode 对焦模式
 *
 *  @return BOOL 是否支持对焦
 */
- (BOOL)isSupportFocusWithMode:(AVCaptureFocusMode)focusMode;

/**
 *  是否支持曝光模式
 *
 *  @param focusMode 曝光模式
 *
 *  @return BOOL 是否支持曝光模式
 */
- (BOOL)isSupportExposureWithMode:(AVCaptureExposureMode)exposureMode;

/**
 *  绑定聚焦触摸视图
 *
 *  @param view 聚焦触摸视图
 */
- (void)bindFocusTouchView:(UIView<TuSDKVideoCameraExtendViewInterface> *)view;

/**
 *  是否存在闪关灯
 *
 *  @return BOOL 是否存在闪关灯
 */
- (BOOL)hasFlash;

/**
 *  设置闪光灯模式
 *  @see AVCaptureFlashMode
 *
 *  @param flashMode 设置闪光灯模式
 */
- (void)flashWithMode:(AVCaptureFlashMode)flashMode;

/**
 *  获取闪光灯模式
 *
 *  @return AVCaptureFlashMode
 */
- (AVCaptureFlashMode) getFlashModel;

/**
 *  改变视频视图显示比例 (使用动画)
 *
 *  @param regionRatio 范围比例
 */
- (void)changeCameraViewRatio:(CGFloat)cameraViewRatio;

/**
 *  切换前后摄像头
 */
- (void)rotateCamera;

/**
 *  恢复拍摄
 */
- (void)resumeCameraCapture;

/**
 *  暂停拍摄
 */
- (void)pauseCameraCapture;

/**
 *  停止拍摄
 */
- (void)stopCameraCapture;

/**
 *  开始获取照片
 */
- (void)captureImage;

/**
 *  尝试启动相机
 */
- (void)tryStartCameraCapture;

/**
 *  切换滤镜
 *
 *  @param code 滤镜代号
 *
 *  @return BOOL 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *)code;

/**
 *  销毁
 */
- (void)destory;
@end

#pragma mark - TuSDKStillCameraDelegate
/**
 *  相机事件委托
 */
@protocol TuSDKStillCameraDelegate <NSObject>
/**
 *  相机状态改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param camera 相机对象
 *  @param state  相机运行状态
 */
- (void)onStillCamera:(id<TuSDKStillCameraInterface>)camera stateChanged:(lsqCameraState)state;

/**
 *  获取拍摄图片 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param camera 相机对象
 *  @param result 获取的结果
 *  @param error  错误信息
 */
- (void)onStillCamera:(id<TuSDKStillCameraInterface>)camera takedResult:(TuSDKResult *)result error:(NSError *)error;

@optional
/**
 *  切换滤镜完成
 *
 *  @param camera 相机对象
 *  @param newFilter 当前的滤镜对象
 */
- (void)onStillCamera:(id<TuSDKStillCameraInterface>)camera filterChanged:(TuSDKFilterWrap *)newFilter;

@end
#pragma mark - TuSDKStillCameraDelegate
/**
 *  拍照相机接口
 */
@protocol TuSDKStillCameraInterface <TuSDKVideoCameraInterface>
/**
 *  相机事件委托
 */
@property (nonatomic, weak) id<TuSDKStillCameraDelegate> captureDelegate;
@end

#pragma mark - TuSDKVideoCameraExtendViewInterface
/**
 *  相机视频扩展视图接口
 */
@protocol TuSDKVideoCameraExtendViewInterface <NSObject>
/**
 *  相机对象
 */
@property (nonatomic, assign) id<TuSDKVideoCameraInterface> camera;
/**
 *  是否开启长按拍摄 (默认: NO)
 */
@property (nonatomic) BOOL enableLongTouchCapture;

/**
 *  禁用持续自动对焦 (默认: NO)
 */
@property (nonatomic) BOOL disableContinueFoucs;

/**
 *  是否禁止触摸聚焦 (默认: YES)
 */
@property (nonatomic) BOOL disableTapFocus;

/**
 *  自动聚焦延时 (默认: 5秒)
 */
@property (nonatomic) NSTimeInterval autoFoucsDelay;

/**
 *  长按延时 (默认: 1.2秒)
 */
@property (nonatomic) NSTimeInterval longTouchDelay;

/**
 *  显示区域百分比
 */
@property (nonatomic) CGRect regionPercent;

/**
 *  是否显示辅助线 (默认: false)
 */
@property (nonatomic) BOOL displayGuideLine;

/**
 *  相机状态改变
 *
 *  @param state 改变
 */
- (void)cameraStateChanged:(lsqCameraState)state;

/**
 *  当前聚焦状态
 *
 *  @param isFocusing 是否正在聚焦
 */
- (void)onAdjustingFocus:(BOOL)isFocusing;

/**
 *  通知滤镜配置视图
 *
 *  @param filter 滤镜包装对象
 */
- (void)notifyFilterConfigView:(TuSDKFilterWrap *)filter;

/**
 *  通知脸部追踪信息
 *
 *  @param faces 脸部追踪信息
 *  @param size  显示区域长宽
 */
- (void)notifyFaceDetection:(NSArray<TuSDKTSFaceFeature *> *)faces size:(CGSize)size;
@end
