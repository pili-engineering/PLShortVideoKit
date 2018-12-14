//
//  TuSDK.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/25.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//  https://tutucloud.com/docs/ios/api/
//

#import <Foundation/Foundation.h>
#import "SLGPUImage.h"

#import "TuSDKTSALAssets+Extend.h"
#import "TuSDKTSALAssetsGrouped+CreateTimeDesc.h"
#import "TuSDKTSAnimation.h"
#import "TuSDKTSAsset.h"
#import "TuSDKTSAVAudioPlayer+Extend.h"
#import "TuSDKTSAVCaptureDevice+Extend.h"
#import "TuSDKTSBundle.h"
#import "TuSDKTSDate+Extend.h"
#import "TuSDKTSDevice+Extend.h"
#import "TuSDKTSDeviceSettings.h"
#import "TuSDKTSFaceHelper.h"
#import "TuSDKTSFileManager.h"
#import "TuSDKTSImage+Extend.h"
#import "TuSDKTSLog.h"
#import "TuSDKTSMath.h"
#import "TuSDKTSMotion.h"
#import "TuSDKTSNSArray+Extend.h"
#import "TuSDKTSNSData+Extend.h"
#import "TuSDKTSNSDictionary+Extend.h"
#import "TuSDKTSNSUserDefaults+Extend.h"
#import "TuSDKTSScreen+Extend.h"
#import "TuSDKTSString+Extend.h"
#import "TuSDKTSUIColor+Extend.h"
#import "TuSDKGPURotateShotOutput.h"

#import "TuSDKICAlertView.h"
#import "TuSDKICEmptyView.h"
#import "TuSDKICFilterImageViewWrap.h"
#import "TuSDKICFocusRangeView.h"
#import "TuSDKICGestureRecognizerView.h"
#import "TuSDKICMaskRegionView.h"
#import "TuSDKICPagerView.h"
#import "TuSDKICView+Extend.h"
#import "TuSDKICNavigationController.h"
#import "TuSDKICSeekBar.h"
#import "TuSDKICTableView.h"
#import "TuSDKICTableViewCell.h"
#import "TuSDKICTouchImageView.h"
#import "TuSDKICMessageHubInterface.h"
#import "TuSDKICGifView.h"
#import "TuSDKICGuideRegionView.h"

#import "TuSDKCPAlbumComponentBase.h"
#import "TuSDKCPAlbumMultipleComponentBase.h"
#import "TuSDKCPComponent.h"
#import "TuSDKCPEditActionType.h"
#import "TuSDKCPFilterOnlineControllerInterface.h"
#import "TuSDKCPFilterResultController.h"
#import "TuSDKCPFilterStickerView.h"
#import "TuSDKCPFocusTouchViewBase.h"
#import "TuSDKCPGroupFilterBarBase.h"
#import "TuSDKCPGroupFilterBaseView.h"
#import "TuSDKCPStackFilterTableView.h"
#import "TuSDKCPStackFilterBarBase.h"
#import "TuSDKCPGroupFilterItemCellBase.h"
#import "TuSDKCPImageResultOptions.h"
#import "TuSDKCPOnlineController.h"
#import "TuSDKCPParameterConfigViewInterface.h"
#import "TuSDKCPPhotoEditComponentBase.h"
#import "TuSDKCPPhotoEditMultipleComponentBase.h"
#import "TuSDKCPResultOptions.h"
#import "TuSDKCPOptions.h"

#import "TuSDKPFAlbumViewControllerBase.h"
#import "TuSDKPFAlbumMultipleViewControllerBase.h"
#import "TuSDKPFPhotoPreviewControllerBase.h"
#import "TuSDKPFCameraViewControllerBase.h"
#import "TuSDKPFCameraPreviewControllerBase.h"
#import "TuSDKPFEditAdjustControllerBase.h"
#import "TuSDKPFEditApertureControllerBase.h"
#import "TuSDKPFEditCuterControllerBase.h"
#import "TuSDKPFEditEntryControllerBase.h"
#import "TuSDKPFEditFilterControllerBase.h"
#import "TuSDKPFEditHolyLightControllerBase.h"
#import "TuSDKPFEditMultipleControllerBase.h"
#import "TuSDKPFEditSharpnessControllerBase.h"
#import "TuSDKPFEditSkinControllerBase.h"
#import "TuSDKPFEditVignetteControllerBase.h"
#import "TuSDKPFEditStickerControllerBase.h"
#import "TuSDKPFEditTurnAndCutViewControllerBase.h"
#import "TuSDKPFFilterOnlineControllerBase.h"
#import "TuSDKPFPhotosViewControllerBase.h"
#import "TuSDKPFStickerLocalControllerBase.h"
#import "TuSDKPFStickerOnlineControllerBase.h"
#import "TuSDKPFEditSmudgeControllerBase.h"
#import "TuSDKPFEditWipeAndFilterControllerBase.h"
#import "TuSDKPFEditTabBarControllerBase.h"
#import "TuSDKPFEditHDRControllerBase.h"
#import "TuSDKPFEditTextControllerBase.h"

#import "TuSDKPFCameraFilterGroupViewBase.h"
#import "TuSDKPFEditFilterGroupViewBase.h"
#import "TuSDKPFFilterConfigView.h"
#import "TuSDKPFStickerBarViewBase.h"
#import "TuSDKPFStickerLocalGridViewBase.h"
#import "TuSDKPFStickerView.h"
#import "TuSDKPFTextView.h"
#import "TuSDKPFStickerGroup.h"
#import "TuSDKPFSmudgeViewBase.h"
#import "TuSDKPFBrushBarViewBase.h"

#import "TuSDKTKThread.h"
#import "TuSDKVideoCameraInterface.h"

#import "TuSDKAOCellGridViewAlgorithmic.h"
#import "TuSDKRatioType.h"
#import "TuSDKResult.h"
#import "TuSDKAOValid.h"

#import "TuSDKFaceAligment.h"
#import "TuSDKFilterLocalPackage.h"
#import "TuSDKFilterManager.h"
#import "TuSDKPFStickerLocalPackage.h"
#import "TuSDKPFBrushLocalPackage.h"
#import "TuSDKLiveStickerManager.h"
#import "TuSDKSkinFilterAPI.h"
#import "TuSDKFilterWrap.h"
#import "TuSDKFilterProcessorBase.h"
#import "TuSDKTKStatistics.h"

#import "TuSDKOnlineStickerFetcher.h"
#import "TuSDKOnlineStickerDownloader.h"

#import "TuSDKTextStickerImage.h"


#import "TuSDKNKNetworkEngine.h"
#import "UIImageView+TuSDKNetworkAdditions.h"

/**
 *  SDK版本
 */
extern NSString * const lsqSDKVersion;

/**
 *  SDK版本代号
 */
extern NSUInteger const lsqSDKCode;

/**
 * SDK配置文件 (lsq_tusdk_configs.json)
 */
extern NSString * const lsqSdkConfigs;

/**
 *  临时文件目录 (APP/Cache/%lsqTemp%)
 */
extern NSString * const lsqTempDir;

/**
 *  资源文件下载目录 (APP/Document/%lsqDownload%)
 */
extern NSString * const lsqDownloadDir;

/**
 *  滤镜预览效果图文件名 (APP/Document/%lsqFilterSamples%)
 */
extern NSString * const lsqFilterSampleDir;

/**
 *  滤镜预览效果图文件后缀 (lfs)
 */
extern NSString * const lsqFilterSampleExtension;

/**
 *  TuSDK 核心
 *  @see-https://tutucloud.com/docs/ios/api/Classes/TuSDK.html
 *
 *  内部集成滤镜列表(17):
 *  Normal, Artistic, Brilliant, Cheerful, Clear, Fade, Forest, Gloss,
 *  Harmony, Instant, Lightup, Morning, Newborn, Noir, Relaxed, Rough, Thick, Vintage
 *
 *  需要将 TuSDKFilterTextures.bundle 放入应用项目内
 */

@interface TuSDK : NSObject

/**
 *  SDK界面样式 (默认:lsqSdkUIDefault)
 */
@property (nonatomic, copy) NSString *style;

/**
 *  用户标识
 */
@property (nonatomic, copy) NSString *userIdentify;

/**
 *  进度信息提示
 */
@property (nonatomic, retain) id<TuSDKICMessageHubInterface> messageHub;

/**
 *  使用 SSL 发送网络请求 (默认: YES)
 */
@property (nonatomic) BOOL useSSL;

/**
 *  TuSDK 核心
 *
 *  @return TuSDK 核心
 */
+ (TuSDK *)shared;

/**
 *  初始化SDK
 *
 *  @param appkey 应用秘钥 (请前往 https://tutucloud.com 申请秘钥)
 */
+ (void)initSdkWithAppKey:(NSString *)appkey;

/**
 *  初始化SDK
 *
 *  @param appkey 应用秘钥 (请前往 https://tutucloud.com 申请秘钥)
 *  @param devType 开发模式(需要与lsq_tusdk_configs.json中masters.key匹配， 如果找不到devType将默认读取master字段)
 */
+ (void)initSdkWithAppKey:(NSString *)appkey devType:(NSString *)devType;

/**
 *  设置日志输出级别
 *
 *  @param level 日志输出级别 (默认：lsqLogLevelFATAL 不输出)
 */
+ (void)setLogLevel:(lsqLogLevel)level;

/**
 *  应用临时目录
 *
 *  @return appTempPath 应用临时目录
 */
+ (NSString *)appTempPath;

/**
 *  应用下载目录
 *
 *  @return appDownloadPath 应用下载目录
 */
+ (NSString *)appDownloadPath;

/**
 *  滤镜代号列表
 *
 *  @return filterCodes 滤镜代号列表
 */
+ (NSArray *)filterCodes;

/**
 *  滤镜管理器
 *  @see-https://tutucloud.com/docs/ios/api/Classes/TuSDKFilterManager.html
 *
 *  @return filterManager 滤镜管理器
 */
+ (TuSDKFilterManager *)filterManager;

/**
 *  贴纸管理器
 *  @see-https://tutucloud.com/docs/ios/api/Classes/TuSDKPFStickerLocalPackage.html
 *
 *  @return stickerManager 贴纸管理器
 */
+ (TuSDKPFStickerLocalPackage *)stickerManager;

/**
 *  检查滤镜管理器是否初始化
 *
 *  @param delegate   滤镜控管理器委托
 */
+ (void)checkManagerWithDelegate:(id<TuSDKFilterManagerDelegate>)delegate;

/**
 *  相机对象
 *  @see-https://tutucloud.com/docs/ios/api/Classes/TuSDKStillCamera.html
 *
 *  @param sessionPreset  相机分辨率类型 
 *  @see AVCaptureSessionPresetPhoto
 *  @param cameraPosition 相机设备标识 （前置或后置）
 *  @param cameraView     相机显示容器视图
 *
 *  @return 相机对象
 */
+ (id<TuSDKStillCameraInterface>)cameraWithSessionPreset:(NSString *)sessionPreset
                                          cameraPosition:(AVCaptureDevicePosition)cameraPosition
                                              cameraView:(UIView *)view;
@end
