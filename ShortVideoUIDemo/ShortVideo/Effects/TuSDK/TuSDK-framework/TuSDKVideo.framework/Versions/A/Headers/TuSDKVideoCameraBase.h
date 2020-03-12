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
#import "TuSDKMediaEffect.h"
#import "TuSDKMediaVideoEffectTimeline.h"
#import "TuSDKMediaFilterEffect.h"
#import "TuSDKMediaComicEffect.h"
#import "TuSDKMediaStickerEffect.h"

@protocol TuSDKVideoCameraEffectDelegate;

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
@interface TuSDKVideoCameraBase : SLGPUImageStillCamera<TuSDKVideoCameraInterface>
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
@property (nonatomic, weak) id<TuSDKVideoCameraSampleBufferDelegate> _Nullable sampleBufferDelegate;

/**
 * 人脸检测结果委托
 * @since v3.0.1
 */
@property (nonatomic, weak) id<TuSDKVideoCameraFaceDetectionDelegate> _Nullable faceDetectionDelegate;

/**
 特效数据委托对象
 @since v3.2.0
 */
@property (nonatomic,weak)id<TuSDKVideoCameraEffectDelegate> _Nullable effectDelegate;

/**
 聚焦视图点击委托对象
 @since v3.5.1
 */
@property (nonatomic,weak)id<TuSDKCPFocusTouchViewDelegate> _Nullable focusTouchDelegate;

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
@property (nonatomic, retain) id<TuSDKCPRegionHandler> _Nullable regionHandler;

/**
 *  是否正在切换滤镜
 */
@property (nonatomic, readonly) BOOL isFilterChanging;

/**
 *  开启滤镜配置选项
 */
@property (nonatomic) BOOL enableFilterConfig;

/**
 *  禁止触摸聚焦功能 (默认: NO)
 */
@property (nonatomic) BOOL disableTapFocus;

/**
 *  禁止触摸曝光功能 (默认: NO)
 *  @since v3.4.2
 */
@property (nonatomic) BOOL disableTapExposure;


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
@property (nonatomic, retain) UIColor * _Nullable regionViewColor;

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
@property (nonatomic, retain) UIImage * _Nullable waterMarkImage;

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
- (instancetype _Nullable )initWithSessionPreset:(NSString *_Nonnull)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition cameraView:(UIView *_Nonnull)view;

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
- (UIView<TuSDKVideoCameraExtendViewInterface> *_Nonnull)getFocusTouchView;

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 *
 *  @return 是否支持对焦
 */
- (BOOL)focusWithMode:(AVCaptureFocusMode)focusMode;

/**
 获取当前摄像头的 activeFormat
 
 @return activeFormat
 @since v3.4.2
 */
- (AVCaptureDeviceFormat *_Nullable)getInputCameraDeviceFormat;

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
 *  设置曝光模式, 默认AVCaptureExposureModeContinuousAutoExposure
 *
 *  @param exposureMode 曝光模式
 *
 *  @return 是否支持曝光模式
 */
- (BOOL)exposureWithMode:(AVCaptureExposureMode)exposureMode;

/**
 *  设置曝光模式, 默认AVCaptureExposureModeContinuousAutoExposure
 *
 *  @param exposureMode 曝光模式
 *  @param point 曝光点，[(0,0),(1,1)]
 *
 *  @return 是否支持曝光模式
 *  @since 3.4.2
 */
- (BOOL)exposureWithMode:(AVCaptureExposureMode)exposureMode point:(CGPoint)point;

/**
 设置曝光感应度 ISO值 当exposureMode 为AVCaptureExposureModeCustom 才能生效

 @param duration 曝光时长，可以用AVCaptureExposureDurationCurrent
 @param ISO 曝光感应度 范围在[minISO maxISO]
 @return 是否设置成功
 @since v3.4.2
 */
- (BOOL)exposureModeCustomCustomWithDuration:(CMTime)duration ISO:(float)ISO;


/**
 设置曝光补偿 bias

 @param bias [-8 8]
 @return 是否设置成功
 @since v3.4.2
 */
- (BOOL)exposureWithBias:(float)bias;

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
- (void)notifyCaptureResult:(UIImage *_Nullable) result;

/**
 拍摄图片

 @param block 拍照完成数据回调
 @since v3.4.1
 */
- (BOOL)capturePhotoAsImageCompletionHandler:(void (^_Nonnull)(UIImage * _Nullable processedImage, NSError * _Nullable error))block;

/**
 *  切换滤镜 v3.2.0 新增 addMediaEffect：接口，可通过该方法添加所有支持的特效。
 *
 *  @param code 滤镜代号
 *
 *  @return 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *_Nullable)code DEPRECATED_MSG_ATTRIBUTE("Pelease use addMediaEffect:");

#pragma mark - live sticker

/**
 *  显示一组动态贴纸。当显示一组贴纸时，会清除画布上的其它贴纸
 *
 *  @param groupSticker 动态贴纸对象
 */
- (void)showGroupSticker:(TuSDKPFStickerGroup *_Nullable)groupSticker DEPRECATED_MSG_ATTRIBUTE("Pelease use addMediaEffect:");

/**
 *  动态贴纸组是否已在使用
 *
 *  @param groupSticker 动态贴纸组对象
 *  @return 　是否使用
 */
- (BOOL)isGroupStickerUsed:(TuSDKPFStickerGroup *_Nonnull)groupSticker DEPRECATED_MSG_ATTRIBUTE("Pelease use mediaEffectsWithType:");

/**
 *  清除动态贴纸
 */
- (void)removeAllLiveSticker DEPRECATED_MSG_ATTRIBUTE("Pelease use removeMediaEffectsWithType:");

/**
 设置检测框最小倍数 [取值范围: 0.1 < x < 0.5, 默认: 0.2] 值越大性能越高距离越近

 @param scale 缩放f比
 */
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
- (void)onVideoCamera:(TuSDKVideoCameraBase *_Nonnull)videoCamera faceDetectionResultType:(lsqVideoCameraFaceDetectionResultType)type faceCount:(NSUInteger)count;

@end

#pragma mark -  MediaEffectManager

/**
 * 特效管理
 */
@interface TuSDKVideoCameraBase  (MediaEffectManager) <TuSDKMediaEffectSyncDelegate>

/**
 添加一个多媒体特效。目前支持的特效包括：
 TuSDKMediaFilterEffect、TuSDKMediaStickerEffect、TuSDKMediaComicEffect、TuSDKMediaSkinFaceEffect、TuSDKMediaPlasticFaceEffect
 
 @param mediaEffect 特效数据
 @discussion 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 @return true 添加成功 false 添加失败不支持该特效或特效数据错误
 @since    v3.2.0
 */
- (BOOL)addMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除特效数据
 
 @since    v3.2.0
 @param mediaEffect TuSDKMediaEffectData
 */
- (void)removeMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除指定类型的特效信息
 
 @param effectType 特效类型
 @since    v3.2.0
 */
- (void)removeMediaEffectsWithType:(NSUInteger)effectType;

/**
 移除所有特效
 @since    v3.2.0
 */
- (void)removeAllMediaEffect;

/**
 获取指定类型的特效信息
 
 @param effectType 特效数据类型
 @return 特效列表
 @since    v3.2.0
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)mediaEffectsWithType:(NSUInteger)effectType;

@end

#pragma mark - TuSDKVideoCameraEffectDelegate

@protocol TuSDKVideoCameraEffectDelegate <NSObject>

@optional

/**
 当前正在应用的特效
 
 @param videoCamera 相机对象
 @param mediaEffectData 正在预览特效
 @since v3.2.0
 */
- (void)onVideoCamera:(TuSDKVideoCameraBase *_Nonnull)videoCamera didApplyingMediaEffect:(id<TuSDKMediaEffect>_Nonnull)mediaEffectData;


/**
 特效被移除通知
 
 @param videoCamera 相机对象
 @param mediaEffects 被移除的特效列表
 @since v3.2.0
 */
- (void)onVideoCamera:(TuSDKVideoCameraBase *_Nonnull)videoCamera didRemoveMediaEffects:(NSArray<id<TuSDKMediaEffect>> *_Nonnull) mediaEffects;

@end
