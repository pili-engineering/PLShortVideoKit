//
//  TuSDKVideoOutputWriter.h
//  TuSDK
//
//  Created by Yanlin on 2/3/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

//#import <GPUImage/GPUImage.h>
#import "TuSDKVideoImport.h"
#import "TuSDKVideoResult.h"

@protocol TuSDKVideoCameraFaceDetectionDelegate;

/** 贴纸可以同时使用的的最大数量*/
#define LSQ_SMART_STICKER_MAX_NUM 5

/** 输出帧格式类型*/
typedef NS_ENUM(NSInteger, lsqFrameFormatType)
{
    /** 输出 BGRA 格式 (kCVPixelFormatType_32BGRA)*/
    lsqFormatTypeBGRA,
    /** 输出 YUV 格式 (NV12，YYYYYYYY UVUV) */
    lsqFormatTypeNV12,
    /** 输出 YUV 格式 (NV21， YYYYYYYY VUVU) 注：无法用于预览，仅供推流时使用 */
    lsqFormatTypeNV21,
    /** 输出 YUV 格式 (I420: YYYYYYYY UU VV ) */
    lsqFormatTypeI420,
    /** 输出 YUV 格式 (YV12: YYYYYYYY VV UU ) */
    lsqFormatTypeYV12,
    /** 输出基于 BGRA 格式的原始数据 */
    lsqFormatTypeRawData,
};

/** 人脸信息检测结果类型 */
typedef NS_ENUM(NSUInteger,lsqVideoCameraFaceDetectionResultType) {
    /** No face is detected */
    lsqVideoCameraFaceDetectionResultTypeNoFaceDetected,
    /** Succeed */
    lsqVideoCameraFaceDetectionResultTypeFaceDetected
};


#pragma mark - GPUImageVideoCamera (lsqExt)

@interface SLGPUImageVideoCamera (lsqExt)

- (void)updateTargetsForVideoCameraUsingCacheTextureAtWidth:(int)bufferWidth height:(int)bufferHeight time:(CMTime)currentTime;
@end

#pragma mark - TuSDKVideoCameraBase

/**
 *  视频相机基类
 */
@interface TuSDKVideoCameraBase : SLGPUImageVideoCamera<TuSDKVideoCameraInterface>
{
    @protected
    // 输出尺寸
    CGSize _outputSize;
    // 视频视图
    TuSDKICFilterVideoViewWrap *_cameraView;
    // 相机聚焦触摸视图
    UIView<TuSDKVideoCameraExtendViewInterface> *_focusTouchView;
    // 相机辅助视图
    TuSDKICGuideRegionView *_guideView;
    // process benchmark
    BOOL _enableProcessBenchmark;
    
    NSUInteger _numberOfFramesProcessed;
    CFAbsoluteTime _lastFrameTime;
    CFAbsoluteTime _totalFrameTimeDuringProcess;
    
    // 设备当前朝向
    UIDeviceOrientation _deviceOrient;
    // 设备图像方向
    UIImageOrientation _imageOrient;
    // 设备视频方向
    AVCaptureVideoOrientation _videoOrientation;
    // 物理感应器方向所对应的视频transform
    CGAffineTransform _videoInputTransform;
}

/**
 *  相机帧采样缓冲委托
 */
@property (nonatomic, weak) id<TuSDKVideoCameraSampleBufferDelegate> sampleBufferDelegate;

/**
 * 人脸检测结果委托
 * @since v3.0.1
 */
@property (nonatomic, weak) id<TuSDKVideoCameraFaceDetectionDelegate> faceDetectionDelegate;

/**
 *  相机状态
 */
@property (nonatomic, readonly) lsqCameraState state;

/**
 人脸检测结果
 @since v3.0.1
 */
@property (nonatomic, readonly) lsqVideoCameraFaceDetectionResultType faceDetectionResultType;

/**
 *  采集尺寸
 */
@property (nonatomic, readonly) CGSize captureSize;

/**
 *  选区范围算法
 */
@property (nonatomic, retain) id<TuSDKCPRegionHandler> regionHandler;

/**
 *  是否正在切换滤镜
 */
@property (nonatomic, readonly) BOOL isFilterChanging;

/**
 *  开启滤镜配置选项
 */
@property (nonatomic) BOOL enableFilterConfig;

/**
 *  禁止触摸聚焦功能 (默认: YES)
 */
@property (nonatomic) BOOL disableTapFocus;

/**
 *  是否开启长按拍摄 (默认: NO)
 *  禁用对焦功能
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
 *
 *  1:1 正方形 | 2:3 | 3:4 | 9:16
 */
@property (nonatomic) CGFloat cameraViewRatio;

/**
 *  视频覆盖区域颜色 (默认：[UIColor blackColor])
 */
@property (nonatomic, retain) UIColor *regionViewColor;

/**
 *  默认是否显示辅助线 (默认: false)
 */
@property (nonatomic) BOOL displayGuideLine;

/**
 *  输出画面分辨率，默认原始采样尺寸输出。
 *  如果设置了输出尺寸，则对画面进行等比例缩放，必要时进行裁剪，保证输出尺寸和预设尺寸一致。
 */
@property (nonatomic) CGSize outputSize;

/**
 *  禁用前置摄像头水平镜像 (默认: NO，前置摄像头输出画面进行水平镜像)
 */
@property (nonatomic) BOOL disableMirrorFrontFacing;

/**
 *  是否开启人脸检测 默认：NO
 *
 *  @since v3.0.1
 */
@property (nonatomic) BOOL enableFaceDetection;

/**
 *  是否开启动态贴纸 (默认: NO)
 */
@property (nonatomic) BOOL enableLiveSticker;

/**
 是否开启人脸聚焦
 @since v3.0.1
 */
@property (nonatomic) BOOL enableFaceFocus;

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
 *  是否开启性能测试
 */
@property (nonatomic) BOOL enableProcessBenchmark;

#pragma mark - waterMark
/**
 设置水印图片，最大边长不宜超过 500
 */
@property (nonatomic, retain) UIImage *waterMarkImage;

/**
 水印位置，默认 lsqWaterMarkBottomRight
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

/**
 *  初始化
 *
 *  @param sessionPreset  相机分辨率类型
 *  @param cameraPosition 相机设备标识 （前置或后置）
 *  @param view 相机显示容器视图
 *
 *  @return 相机对象
 */
- (instancetype)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition cameraView:(UIView *)view;

/**
 *  初始化相机
 */
-(void)initCamera;

/**
 重新设置音频会话分类
 */
- (void)resetAudioSessionCategory;

/**
 *  更新相机视图布局
 */
- (void)updateCameraLayout;

/**
 *  更新相机视图bounds
 */
- (void)updateCameraViewBounds:(CGRect)bounds;

/**
 *  获取聚焦视图
 *
 *  @return 聚焦视图
 */
- (UIView<TuSDKVideoCameraExtendViewInterface> *)getFocusTouchView;

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 *
 *  @return 是否支持对焦
 */
- (BOOL)focusWithMode:(AVCaptureFocusMode)focusMode;

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 *  @param point     聚焦坐标
 *
 *  @return 是否支持对焦
 */
- (BOOL)focusWithMode:(AVCaptureFocusMode)focusMode point:(CGPoint)point;

/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 *
 *  @return 是否支持曝光模式
 */
- (BOOL)exposureWithMode:(AVCaptureExposureMode)exposureMode;

/**
 *  当前聚焦状态
 *
 *  @param isFocusing 是否正在聚焦
 */
- (void)onAdjustingFocus:(BOOL)isFocusing;

/**
 *  通知相机状态发生改变
 *
 *  @param newState 新的状态
 */
- (void)notifyCameraStateChanged:(lsqCameraState)newState;

/**
 *  相机状态发生改变
 *
 *  @param newState 新的状态
 */
- (void)onCameraStateChanged:(lsqCameraState)newState;

/**
 *  更新滤镜输出配置
 */
- (void)updateOutputFilter;

/**
 *  标记需要重新计算裁剪的画面大小
 */
- (void)markRecalculateCaptureSize;

/**
 通知拍照结果
 
 @param result 拍摄照片
 */
- (void)notifyCaptureResult:(UIImage *)result;

/**
 获取图片
 
 @return  得到的图片对象
 */
- (UIImage *)syncCaptureImage;

#pragma mark - live sticker

/**
 *  显示一组动态贴纸。当显示一组贴纸时，会清除画布上的其它贴纸
 *
 *  @param groupSticker 动态贴纸对象
 */
- (void)showGroupSticker:(TuSDKPFStickerGroup *)groupSticker;

/**
 *  动态贴纸组是否已在使用
 *
 *  @param groupSticker 动态贴纸组对象
 *  @return 　是否使用
 */
- (BOOL)isGroupStickerUsed:(TuSDKPFStickerGroup *)groupSticker;

/**
 *  清除动态贴纸
 */
- (void)removeAllLiveSticker;

/** 设置检测框最小倍数 [取值范围: 0.1 < x < 0.5, 默认: 0.2] 值越大性能越高距离越近 */
- (void) setDetectScale: (CGFloat) scale;
#pragma mark - benchmark
/**
 *  打印性能日志
 */
- (void)runProcessBenchmark;

#pragma mark - destory

/**
 *  销毁
 */
- (void)destory;

@end

/**
 * 人脸检测事件委托
 * @since v3.0.1
 */
@protocol TuSDKVideoCameraFaceDetectionDelegate <NSObject>

@optional
/**
 *  人脸检测事件委托 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param videoCamera 相机对象
 *  @param type 人脸检测结果
 *  @param count 检测到的人脸数量
 */
- (void)onVideoCamera:(TuSDKVideoCameraBase *)videoCamera faceDetectionResultType:(lsqVideoCameraFaceDetectionResultType)type faceCount:(NSUInteger)count;

@end
