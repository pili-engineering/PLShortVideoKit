//
//  TuSDKPFCameraViewControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/7.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPResultViewController.h"
#import "TuSDKVideoCameraInterface.h"

/**
 *  默认相机视图控制器基础类
 */
@interface TuSDKPFCameraViewControllerBase : TuSDKCPResultViewController<TuSDKStillCameraDelegate>
{
    @protected
    // 是否显示所有设置的比例(默认剔除和屏幕相同比例)
    BOOL _isShowAllSetRatio;
}
/**
 *  视频视图显示比例类型 (默认:lsqRatioDefault, 如果设置cameraViewRatio > 0, 将忽略ratioType)
 */
@property (nonatomic) lsqRatioType ratioType;
/**
 *  视图显示比例类型列表 ( 优先级 ratioTypeList > ratioType, 默认：lsqTuSDKRatioDefaultTypes)
 *
 *  设置 NSNumber 型数组来控制显示的按钮顺序， 例如:
 *	@[@(lsqRatioOrgin), @(lsqRatio_1_1), @(lsqRatio_2_3), @(lsqRatio_3_4)]
 *
 */
@property (nonatomic) NSArray<NSNumber *> *ratioTypeList;

/**
 *  视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
 */
@property (nonatomic) CGFloat cameraViewRatio;
/**
 *  相机对象
 */
@property (nonatomic, readonly) id<TuSDKStillCameraInterface> camera;

/** 相机视图 */
@property (nonatomic, readonly) UIView *cameraView;

/**
 *  摄像头前后方向 (默认为后置优先)
 */
@property (nonatomic) AVCaptureDevicePosition avPostion;

/**
 *  摄像头分辨率模式 (默认：AVCaptureSessionPresetHigh)
 *  @see AVCaptureSession for acceptable values
 */
@property (nonatomic, copy) NSString *sessionPreset;

/**
 *  开始启动相机
 */
- (void)startCamera;

/**
 *  销毁相机
 */
- (void)destoryCamera;

/**
 *  获取当前比例
 *
 *  @return currentRatio 当前比例
 */
- (CGFloat)getCurrentRatio;

/**
 *  获取当前可用比例列表
 */
- (NSArray<NSNumber *> *)getRatioTypes;

/**
 *  设置当前比例类型
 *
 *  @param ratioType 比例类型
 */
- (void)setCurrentRatioType:(lsqRatioType)ratioType;

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode)flashMode;


/**
 *  手动设置相机比例
 *
 *  @param sender
 */
- (void)onCameraRatioChange:(id)sender;

/**
 *  设置辅助线显示状态
 *
 *  @param isShow 是否显示辅助线
 */
- (void)setGuideLineViewState:(BOOL)isShow;

/**
 *  是音量键拍摄
 *
 *  @param isEnableCaptureWithVolumeKeys 是否开启音量键拍摄
 */
- (void)setEnableCaptureWithVolumeKeys:(BOOL)isEnableCaptureWithVolumeKeys;

/**
 *  获取辅助线显示状态
 */
- (BOOL)getGuideLineViewState;

/**
 *  按音量键拍摄
 */
- (void)onCapturePhotoWithVolume;
@end
