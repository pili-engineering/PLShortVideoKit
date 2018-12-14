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
 *  导出视频的文件格式（默认:lsqFileTypeMPEG4）
 */
@property (nonatomic, assign) lsqFileType fileType;

/**
 *  设置编码时视频的画质
 */
@property (nonatomic, strong) TuSDKVideoQuality * _Nullable encodeVideoQuality;


/** 是否按照实际速度预览 默认：YES
 */
@property(readwrite, nonatomic) BOOL playAtActualSpeed DEPRECATED_MSG_ATTRIBUTE("Not recommended, use time effects");

/**
 *  视频裁剪区域，当为 CGRectZero 时，区域无效
 *  注：该参数对应的值均为比例值，即：若视频展示View的总高度800，此时截取时y从200开始，则cropRect的 originY = 偏移位置/总高度， 应为 0.25, 其余三个值相同
 */
@property (nonatomic,assign) CGRect cropRect;

/**
 *  视频输出尺寸
 *  注：当使用 cropRect 设置了裁剪范围后，该参数不再生效
 */
@property (nonatomic,assign) CGSize outputSize;

/**
 *  预览时是否播放视频原音， 默认 NO：预览和保存后的视频，无声音
 */
@property (nonatomic,assign) BOOL enableVideoSound;

/**
 是否开启转码 默认：YES 开启后 SDK 将会根据视频信息优化视频。
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
@property (nonatomic,readonly) TuSDKMovieEditorPictureEffectOptions *pictureEffectOptions;


+ (TuSDKMovieEditorOptions *_Nonnull) defaultOptions;

@end


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
