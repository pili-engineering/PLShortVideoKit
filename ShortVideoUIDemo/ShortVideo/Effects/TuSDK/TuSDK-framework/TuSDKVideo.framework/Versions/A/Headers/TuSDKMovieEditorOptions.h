//
//  TuSDKMovieEditorSetting.h
//  TuSDKVideo
//
//  Created by gh.li on 17/3/8.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CMTimeRange.h>
#import "TuSDKTimeRange.h"
#import "TuSDKVideoQuality.h"
#import "TuSDKVideoResult.h"
#import "TuSDKMovieEditorMode.h"

@class TuSDKMovieEditorPictureEffectOptions;
@class TuSDKMovieEditorOutputSizeOptions;

/**
 *  视频编辑组件（TuSDKMovieEditor）配置项
 */
@interface TuSDKMovieEditorOptions : NSObject

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) NSURL * _Nullable inputURL;

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) AVAsset * _Nullable inputAsset;

/**
 *  裁剪范围 （开始时间~持续时间 单位:/s）
 */
@property (nonatomic) TuSDKTimeRange * _Nullable cutTimeRange;

/**
 *  最小裁剪持续时间 单位:/s  (默认不限制 开发者可根据需要自行配置)
 */
@property (nonatomic) NSUInteger minCutDuration;

/**
 *  最大裁剪持续时间 单位:/s  (默认不限制  开发者可根据需要自行配置）
 */
@property (nonatomic) NSUInteger maxCutDuration;

/**
 *  保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 *  保存到系统相册的相册名称
 */
@property (nonatomic, copy) NSString * _Nullable saveToAlbumName;

/**
 *  视频覆盖区域颜色 (默认：[UIColor blackColor])
 */
@property (nonatomic, retain) UIColor * _Nullable regionViewColor;

/**
 *  画布区域背景颜色 (默认：[UIColor blackColor])
 *  @since v3.2.1
 */
@property (nonatomic, retain) UIColor * _Nullable canvasColor;

/**
 *  导出视频的文件格式（默认:lsqFileTypeQuickTimeMovie）
 */
@property (nonatomic, assign) lsqFileType fileType;

/**
 * 导出视频的文件路径
 */
@property (nonatomic, strong) NSURL * _Nullable outputURL;

/**
 *  设置编码时视频的画质
 */
@property (nonatomic, strong) TuSDKVideoQuality * _Nullable encodeVideoQuality;

/** 是否按照实际速度预览 默认：YES
 */
@property(readwrite, nonatomic) BOOL playAtActualSpeed DEPRECATED_MSG_ATTRIBUTE("Not recommended, use time effects");

/**
 *  视频输出尺寸，默认居中裁剪
 */
@property (nonatomic,assign) CGSize outputSize DEPRECATED_MSG_ATTRIBUTE("Not recommended,please use outputSizeOptions");

/**
 *  预览时是否播放视频原音， 默认 NO：预览和保存后的视频，无声音
 */
@property (nonatomic,assign) BOOL enableVideoSound;

/**
 是否开启转码 默认：NO 开启后 SDK 将会根据视频信息优化视频。
 如果使用时间特效，该配置项建议启用。
 @since v3.0
 */
@property (nonatomic) BOOL enableTranscoding;


#pragma mark - waterMark

/**
 *  设置水印图片，最大边长不宜超过 500
 */
@property (nonatomic) UIImage * _Nullable waterMarkImage;

/**
 *  水印位置，默认 lsqWaterMarkBottomRight
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

/**
 画面特效配置项
 
 @since v3.0.1
 */
@property (nonatomic,readonly) TuSDKMovieEditorPictureEffectOptions * _Nullable pictureEffectOptions;

/**
 视频输出尺寸、比例配置项
 设置视频资产后可用
 
 @since v3.3.2
 */
@property (nonatomic,readonly) TuSDKMovieEditorOutputSizeOptions * _Nullable outputSizeOptions;


/**
 视频预览尺寸、比例配置项
 设置视频资产后可用
 
 @since v3.4.2
 */
@property (nonatomic,readonly) TuSDKMovieEditorOutputSizeOptions * _Nullable prviewSizeOptions;

/**
 获取默认配置项

 @return TuSDKMovieEditorOptions
 */
+ (TuSDKMovieEditorOptions *_Nonnull) defaultOptions;

@end


#pragma mark - TuSDKMovieEditorPictureEffectOptions 画面特效配置

/**
 画面特效配置
 
 @since v3.0.1
 */
@interface TuSDKMovieEditorPictureEffectOptions : NSObject

/**
 设置画面特效参考时间线，通常在设置时间特效后该配置会发挥作用 默认： TuSDKMediaEffectReferOutputTimelineType

 @since v3.0.1
 */
@property (nonatomic) TuSDKMediaPictureEffectReferTimelineType referTimelineType;

@end


#pragma mark - TuSDKMovieEditorOutputSizeOptions 输出尺寸配置

/**
 视频输出尺寸配置项
 @since v3.2.1
 */
@interface TuSDKMovieEditorOutputSizeOptions : NSObject

/**
 初始化 TuSDKMovieEditorOutputSizeOptions

 @param inputSize 视频size
 @return 输入size
 */
- (instancetype _Nonnull )initWithInputSize:(CGSize)inputSize;

/**
 设置输出尺寸 默认：根据视频信息计算最佳输出尺寸
 
 @since v3.2.1
 */
@property (nonatomic) CGSize outputSize;

/**
 输出比例  默认：0 原视频比例  outputRatio 和 outputSize 二选一
 
 @since v3.2.1
 */
@property (nonatomic) CGFloat outputRatio;

/**
 设置是否裁剪视频 默认：YES
                YES : outputSize 如果与原视频尺寸不一致，也会保留完整视频不会裁剪。
                NO : 居中裁剪视频，输出与 outputSize 相同比例的视频。
 @since v3.2.1
 */
@property (nonatomic) BOOL aspectOutputRatioInSideCanvas;


@end
