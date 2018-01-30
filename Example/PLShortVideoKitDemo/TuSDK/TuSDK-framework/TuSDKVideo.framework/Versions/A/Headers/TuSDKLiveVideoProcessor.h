//
//  TuSDKLiveVideoProcessor.h
//  TuSDKVideo
//
//  Created by Yanlin on 3/22/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoCameraBase.h"
#import "TuSDKVideoImport.h"

#pragma mark - TuSDKLiveVideoProcessorDelegate

@class TuSDKLiveVideoProcessor;
/**
 *  视频处理事件委托
 */
@protocol TuSDKLiveVideoProcessorDelegate <NSObject>

/**
 *  获取处理后的帧数据, pixelFormatType 为 lsqFormatTypeBGRA 或 lsqFormatTypeYUV420F 时调用
 *
 *  @param processor   视频处理对象
 *  @param pixelBuffer 帧数据, CVPixelBufferRef 类型, 默认为 kCVPixelFormatType_32BGRA 格式
 *  @param frameTime   帧时间戳
 */
- (void)onVideoProcessor:(TuSDKLiveVideoProcessor *)processor bufferData:(CVPixelBufferRef)pixelBuffer time:(CMTime)frameTime;

@optional
/**
 *  获取滤镜处理后的帧原始数据, pixelFormatType 为 lsqFormatTypeRawData 时调用
 *
 *  @param processor   视频处理对象
 *  @param bytes       帧数据
 *  @param bytesPerRow bytesPerRow
 *  @param imageSize   尺寸
 *  @param frameTime   帧时间戳
 */
- (void)onVideoProcessor:(TuSDKLiveVideoProcessor *)processor rawData:(unsigned char *)bytes bytesPerRow:(NSUInteger)bytesPerRow imageSize:(CGSize)imageSize time:(CMTime)frameTime;

/**
 *  滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param processor 视频处理对象
 *  @param newFilter 新的滤镜对象
 */
- (void)onVideoProcessor:(TuSDKLiveVideoProcessor *)processor filterChanged:(TuSDKFilterWrap *)newFilter;

@end


#pragma mark - TuSDKLiveVideoProcessor

/**
 *  视频直播实时处理，并支持显示预览
 */
@interface TuSDKLiveVideoProcessor : TuSDKFilterProcessorBase<TuSDKVideoCameraInterface>
{
    @protected
    
    /**
     *  输出画面分辨率，默认原始采样尺寸输出。
     *  如果设置了输出尺寸，则对画面进行等比例缩放，必要时进行裁剪，保证输出尺寸和预设尺寸一致。
     */
    CGSize _outputSize;
    
    /**
     *  输出 PixelBuffer 格式，可选: lsqFormatTypeBGRA | lsqFormatTypeYUV420F | lsqFormatTypeYUVI420 | lsqFormatTypeRawData
     *  默认:lsqFormatTypeBGRA
     */
    lsqFrameFormatType _pixelFormatType;
    
    /**
     *  禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
     */
    BOOL _disableMirrorFrontFacing;
}

/**
 *  初始化实时处理器
 *
 *  @param captureSesssion  视频捕获会话
 *  @param videoOutput      视频输出对象
 *  @param cameraView       预览视图
 *
 *  @return
 */
- (instancetype)initWithCaptureSession:(AVCaptureSession *)captureSesssion
                       VideoDataOutput:(AVCaptureVideoDataOutput *)videoOutput
                            cameraView:(UIView *)cameraView;

/**
 *  处理器事件委托
 */
@property (nonatomic, weak) id<TuSDKLiveVideoProcessorDelegate> delegate;

#pragma mark - TuSDKVideoCameraInterface

/**
 *  相机帧采样缓冲委托
 */
@property (nonatomic, weak) id<TuSDKVideoCameraSampleBufferDelegate> sampleBufferDelegate;

/**
 *  系统捕获会话
 */
@property (nonatomic, readonly) AVCaptureSession *captureSession;

/**
 *  系统相机对象
 */
@property (nonatomic) AVCaptureDevice *inputCamera;

/**
 *  是否为前置摄像头
 */
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;

/**
 *  是否为后置摄像头
 */
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

/**
 *  相机状态
 */
@property (nonatomic, readonly) lsqCameraState state;

/**
 *  开启滤镜配置选项
 */
@property (nonatomic) BOOL enableFilterConfig;

/**
 *  禁止聚焦功能 (默认: NO)
 */
@property (nonatomic) BOOL disableTapFocus;

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
 *  输出画面分辨率，默认原始采样尺寸输出。
 *  如果设置了输出尺寸，则对画面进行等比例缩放，必要时进行裁剪，保证输出尺寸和预设尺寸一致。
 */
@property (nonatomic) CGSize outputSize;

/**
 *  输出 PixelBuffer 格式，可选: lsqFormatTypeBGRA | lsqFormatTypeYUV420F | lsqFormatTypeRawData
 *  默认:lsqFormatTypeBGRA
 */
@property (nonatomic) lsqFrameFormatType pixelFormatType;

/**
 *  禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
 */
@property (nonatomic) BOOL disableMirrorFrontFacing;

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
 *  @return 视频相机前置或后置
 */
- (AVCaptureDevicePosition)cameraPosition;

/**
 *  绑定聚焦触摸视图
 *
 *  @param view 聚焦触摸视图
 */
- (void)bindFocusTouchView:(UIView<TuSDKVideoCameraExtendViewInterface> *)view;


/**
 *  切换滤镜
 *
 *  @param code 滤镜代号
 *
 *  @return 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *)code;

/**
 *  Process a pixelBuffer
 *
 *  @param pixelBuffer pixelBuffer to process
 */
- (void)processVideoPixelBuffer:(CVPixelBufferRef)pixelBuffer frameTime:(CMTime)currentTime;

/**
 *  开始处理
 */
- (void)startRunning;

/**
 *  停止处理
 */
- (void)stopRunning;

/**
 *  销毁对象
 */
- (void)destroy;

@end
