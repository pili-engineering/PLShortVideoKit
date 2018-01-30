//
//  TuSDKTSBundle.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/2.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTSImage+Extend.h"
#import "TuSDKTSAVAudioPlayer+Extend.h"
#import "TuSDKICView+Extend.h"

/**
 *  SDK资源文件包 (TuSDK.bundle)
 */
extern NSString * const lsqSdkBundle;

/**
 *  滤镜材质包 (TuSDK.bundle/textures)
 */
extern NSString * const lsqFilterTextures;

/**
 *  默认UI资源包 (TuSDK.bundle/ui_default)
 */
extern NSString * const lsqSdkUIDefault;

/**
 *  SDK其他资源包 (TuSDK.bundle/others)
 */
extern NSString * const lsqSdkOthers;

/**
 *  SDK本地贴纸包 (TuSDK.bundle/stickers)
 */
extern NSString * const lsqLocalStickers;

/**
 *  相机聚焦音效 (camera_focus_beep.mp3)
 */
extern NSString * const lsqCameraFocusBeepAudio;

/**
 * 内部滤镜配置 (lsq_internal_filters.filter)
 */
extern NSString * const lsqInternalFiltersConfig;

/**
 *  SDK资源包帮助类
 */
@interface TuSDKTSBundle : NSObject

/**
 *  SDK资源包路径
 *
 *  @return SDK资源包路径
 */
+ (NSString *)sdkBundle;

/**
 *  SDK资源包目录或文件路径
 *
 *  @param path 目录或文件路径
 *
 *  @return SDK资源包目录或文件路径
 */
+ (NSString *)sdkBundleWithPath:(NSString *)path;

/**
 *  SDK资源包文件路径
 *
 *  @param path 目录
 *  @param file 文件名
 *
 *  @return SDK资源包文件路径
 */
+ (NSString *)sdkBundleWithPath:(NSString *)path file:(NSString *)file;

/**
 *  SDK资源包材质文件路径
 *
 *  @param file 文件名称
 *
 *  @return SDK资源包材质文件路径
 */
+ (NSString *)sdkBundleTexture:(NSString *)file;

/**
 *  SDK资源包材质图片路径
 *
 *  @param imageName 图片名称
 *
 *  @return SDK资源包材质图片路径
 */
+ (NSString *)sdkBundleTextureImageName:(NSString *)imageName;

/**
 *  SDK资源包其他文件路径
 *
 *  @param file 文件名称
 *
 *  @return SDK资源包材质文件路径
 */
+ (NSString *)sdkBundleOther:(NSString *)file;

/**
 *  SDK资源包贴纸文件路径
 *
 *  @param file 文件名称
 *
 *  @return SDK资源包贴纸文件路径
 */
+ (NSString *)sdkBundleSticker:(NSString *)file;

/**
 *  SDK资源包笔刷文件路径
 *
 *  @param file 文件名称
 *
 *  @return SDK资源包笔刷文件路径
 */
+ (NSString *)sdkBundleBrush:(NSString *)file;
@end

#pragma mark - ImageBundleExtend
/**
 *  图片帮助类
 */
@interface UIImage(ImageBundleExtend)
/**
 *  从材质资源库初始化
 *
 *  @param name 图片名称
 *
 *  @return 返回图片对象
 */
+ (UIImage *) imageLSQBundleNamed:(NSString *)name;
@end

#pragma mark - AVAudioPlayerBundleExtend
/**
 *  音频设备扩展
 */
@interface AVAudioPlayer(AVAudioPlayerBundleExtend)
/**
 *  播放 lsqSdkOthers 相机对焦音效
 *
 *  @return 音频播放对象
 */
+ (instancetype)playerLsqBundleCameraFocusBeep;

/**
 *  播放 lsqSdkOthers 内的音频文件
 *
 *  @param audioName 音频文件名
 *
 *  @return 音频播放对象
 */
+ (instancetype)playerLsqBundlePathWithName:(NSString *)audioName;
@end

#pragma mark - UIImageViewBundleExtend
/**
 *  UIImageView帮助类
 */
@interface UIImageView(UIImageViewBundleExtend)
/**
 *  初始化图片 从UI扩展包加载 (TuSDK.bundle/ui_default)
 *
 *  @param frame      坐标长宽
 *  @param imageNamed 图片名称
 *
 *  @return 图片对象
 */
+ (instancetype)initWithFrame:(CGRect)frame imageLSQBundleNamed:(NSString *)imageNamed;
@end

#pragma mark - UIButtonBundleExtend
/**
 *  按钮帮助类
 */
@interface UIButton(UIButtonBundleExtend)
/**
 *  初始化图片 从UI扩展包加载 (TuSDK.bundle/ui_default)
 *
 *  @param frame      坐标长宽
 *  @param imageNamed 图片名称
 *
 *  @return 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame imageLSQBundleNamed:(NSString *)imageNamed;

/**
 *  初始化图片 从UI扩展包加载 (TuSDK.bundle/ui_default)
 *
 *  @param frame      坐标长宽
 *  @param imageNamed 背景图片名称
 *
 *  @return 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame backgroundImageLSQBundleNamed:(NSString *)imageNamed;

/**
 *  设置默认状态图片 从UI扩展包加载 (TuSDK.bundle/ui_default)
 *
 *  @param name 图片名称
 */
- (void)setStateNormalLSQBundleImageName:(NSString *)name;

/**
 *  设置默认状态背景图片名称
 *
 *  @param imageName 背景图片名称  从UI扩展包加载 (TuSDK.bundle/ui_default)
 */
- (void)setStateNormalBackgroundImageLSQBundleNamed:(NSString *)imageName;
@end