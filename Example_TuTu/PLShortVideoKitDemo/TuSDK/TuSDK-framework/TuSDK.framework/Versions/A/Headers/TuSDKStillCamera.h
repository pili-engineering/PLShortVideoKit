//
//  TuSDKStillCamera.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/27.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import "SLGPUImage.h"
#import "TuSDKVideoCameraInterface.h"

/**
 *  相机对象
 */
@interface TuSDKStillCamera : SLGPUImageStillCamera<TuSDKStillCameraInterface>

/**
 *  相机帧采样缓冲委托
 */
@property (nonatomic, weak) id<TuSDKVideoCameraSampleBufferDelegate> sampleBufferDelegate;

/**
 *  相机事件委托
 */
@property (nonatomic, weak) id<TuSDKStillCameraDelegate> captureDelegate;

/**
 *  相机状态
 */
@property (nonatomic, readonly) lsqCameraState state;

/**
 *  选区范围算法
 */
@property (nonatomic, retain) id<TuSDKCPRegionHandler> regionHandler;

/**
 *  是否已注册聚焦事件
 */
@property (nonatomic) BOOL isResgisterFocusEvent;

/**
 *  是否正在切换滤镜
 */
@property (nonatomic, readonly) BOOL isFilterChanging;

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
 *  默认是否显示辅助线 (默认: false)
 */
@property (nonatomic) BOOL displayGuideLine;

/**
 *  照片输出分辨率 (设置后 cameraViewRatio 将失效)
 */
@property (nonatomic) CGSize outputSize;

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
 *  相机显示焦距 (默认为 1,最大不可超过硬件最大值)
 */
@property (nonatomic, assign) CGFloat focalDistanceScale;

/**
 *  相机支持的最大值 (只读属性)
 */
@property (nonatomic, readonly, assign) CGFloat supportMaxFocalDistanceScale;

/**
 *  初始化相机
 *
 *  @param sessionPreset  相机分辨率类型
 *  @param cameraPosition 相机设备标识 （前置或后置）
 *  @param cameraView     相机显示容器视图
 *
 *  @return 相机对象
 */
+ (instancetype)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition cameraView:(UIView *)view;

#pragma mark - Focus

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
 *  销毁
 */
- (void)destory;
@end
