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

/**
 *  视频编辑组件（TuSDKMovieEditor）配置项
 */
@interface TuSDKMovieEditorOptions : NSObject

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) NSURL *inputURL;

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) AVAsset *inputAsset;

/**
 *  裁剪范围 （开始时间~持续时间 单位:/s）
 */
@property (nonatomic) TuSDKTimeRange *cutTimeRange;

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
@property (nonatomic, copy) NSString *saveToAlbumName;

/**
 *  视频覆盖区域颜色 (默认：[UIColor blackColor])
 */
@property (nonatomic, retain) UIColor *regionViewColor;

/**
 *  导出视频的文件格式（默认:lsqFileTypeMPEG4）
 */
@property (nonatomic, assign) lsqFileType fileType;

/**
 *  设置编码时视频的画质
 */
@property (nonatomic, strong) TuSDKVideoQuality *encodeVideoQuality;

/**
 *  裁剪导出的视频质量 默认 AVAssetExportPresetHighestQuality
 */
@property (nonatomic, strong) NSString *exportPresetQuality;


/** 是否按照实际速度预览 默认：YES
 */
@property(readwrite, nonatomic) BOOL playAtActualSpeed;

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


+ (TuSDKMovieEditorOptions *) defaultOptions;

@end
