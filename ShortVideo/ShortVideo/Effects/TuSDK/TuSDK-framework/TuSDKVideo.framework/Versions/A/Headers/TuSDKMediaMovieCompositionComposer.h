//
//  TuSDKMediaMovieCompositionComposer.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/5.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKVideoFileWriter.h"
#import "TuSDKMediaVideoComposition.h"
#import "TuSDKMediaAudioComposition.h"
#import "TuSDKMediaFormatAssistant.h"
#import "TuSDKMediaStatus.h"
#import "TuSDKMediaTransitionEffect.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TuSDKMediaMovieCompositionComposerDelegate;
@class TuSDKMediaCompositionVideoComposerSettings;

@interface TuSDKMediaMovieCompositionComposer : NSObject

/**
 初始化合成器

 @param videoComposition 视频合成物
 @param audioComposition 音频合成物
 @return TuSDKMediaCompositionComposer
 
 @since v3.4.1
 */
- (instancetype)initWithVideoComposition:(id<TuSDKMediaVideoComposition> __nullable)videoComposition audioComposition:(id<TuSDKMediaAudioComposition> __nullable)audioComposition;

/**
 初始化合成器
 
 @param videoComposition 视频合成物
 @param audioComposition 音频合成物
 @param composorSettings 合成器配置
 @return TuSDKMediaCompositionComposer
 
 @since v3.4.1
 */
- (instancetype)initWithVideoComposition:(id<TuSDKMediaVideoComposition> __nullable)videoComposition audioComposition:(id<TuSDKMediaAudioComposition> __nullable)audioComposition composorSettings:(TuSDKMediaCompositionVideoComposerSettings * __nullable)composorSettings;

/**
 当前合成器状态
 @since v3.4.1
 */
@property (nonatomic,readonly)TuSDKMediaExportSessionStatus status;

/**
 设置事件委托
 @since v3.4.1
 */
@property (nonatomic)id<TuSDKMediaMovieCompositionComposerDelegate> delegate;

/**
 开始合成
 
 @since v3.4.1
 */
- (void)startExport;

/**
 取消合成
 
 @since v3.4.1
 */
- (void)cancelExport;

@end


#pragma mark -  MediaEffectManager

/**
 * 特效管理
 */
@interface TuSDKMediaMovieCompositionComposer  (MediaEffectManager)

/**
 添加一个多媒体特效。该方法不会自动设置触发时间.
 
 @param mediaEffect 特效数据
 @discussion 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 @since    v2.0
 */
- (BOOL)addMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除特效数据
 
 @since v3.4.1
 
 @param mediaEffect TuSDKMediaEffectData
 */
- (void)removeMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除指定类型的特效信息
 
 @since v3.4.1
 @param effectType 特效类型
 */
- (void)removeMediaEffectsWithType:(NSUInteger)effectType;

/**
 @since v3.4.1
 @discussion 移除所有特效
 */
- (void)removeAllMediaEffect;


/**
 获取指定类型的特效信息
 
 @since v3.4.1
 @param effectType 特效数据类型
 @return 特效列表
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)mediaEffectsWithType:(NSUInteger)effectType;

/**
 获取添加的所有特效
 
 @since v3.4.0
 @return 特效列表
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)allMediaEffects;

@end


/**
 TuSDKMediaMovieCompositionComposer 委托协议
 @since v3.4.1
 */
@protocol TuSDKMediaMovieCompositionComposerDelegate <NSObject>

@required

/**
 合成器进度改变事件

 @param compositionComposer 合成器
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since v3.4.1
 */
- (void)mediaMovieCompositionComposer:(TuSDKMediaMovieCompositionComposer *_Nonnull)compositionComposer progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 合成器状态改变事件

 @param compositionComposer  合成器
 @param status 当前播放器状态
 @since v3.4.1
 */
- (void)mediaMovieCompositionComposer:(TuSDKMediaMovieCompositionComposer *_Nonnull)compositionComposer statusChanged:(TuSDKMediaExportSessionStatus)status;

/**
 合成器合成完成事件

 @param compositionComposer  合成器
 @param result TuSDKVideoResult
 @param error 错误信息
 @since v3.4.1
 */
- (void)mediaMovieCompositionComposer:(TuSDKMediaMovieCompositionComposer *_Nonnull)compositionComposer result:(TuSDKVideoResult *_Nonnull)result error:(NSError *_Nonnull)error;


@end


#pragma mark - TuSDKMediaCompositionVideoComposer

@interface TuSDKMediaCompositionVideoComposerSettings : NSObject

#pragma mark 文件生成

/**
 导出的地址
 
 @since v3.4.1
 */
@property (nonatomic) NSURL * _Nullable outputURL;

/**
 输出的视频 size
 
 @since v3.4.1
 */
@property (nonatomic) CGSize outputSize;

/**
 设定输出 outputSize 时比例不一致时是否自适应画布大小 默认：NO
 
 @since v3.4.1
 */
@property (nonatomic) BOOL aspectOutputRatioInSideCanvas;

/**
 输出的文件类型 默认: lsqFileTypeMPEG4
 @since v3.4.1
 */
@property (nonatomic) lsqFileType outputFileType;

/**
 输出的视频画质 默认： TuSDKRecordVideoQuality_High1
 
 @since v3.4.1
 */
@property (nonatomic) TuSDKVideoQuality * _Nullable outputVideoQuality;

/**
 输出区域 默认：CGRect(0,0,1,1);
 
 @since v3.4.1
 */
@property (nonatomic) CGRect outputRegion;

/*!
 @property transform 默认: 无
 @abstract
 The transform specified in the output file as the preferred transformation of the visual media data for display purposes.
 
 @discussion
 If no value is specified, the identity transform is used.
 
 This property cannot be set after writing on the receiver's AVAssetWriter has started.
 @since v3.4.1
 */
@property (nonatomic) CGAffineTransform outputTransform;


#pragma mark 相册

/**
 设置水印图片
 @since v3.0
 */
@property (nonatomic, retain) UIImage * _Nullable waterMarkImage;

/**
 水印位置，默认 lsqWaterMarkBottomRight 若视频有位置相关旋转 应在设置videoOrientation后调用该setter方法
 @since v3.0
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

/**
 保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 @since v3.0
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 保存到系统相册的相册名称
 @since v3.0
 */
@property (nonatomic, copy) NSString * _Nullable saveToAlbumName;

@end


NS_ASSUME_NONNULL_END


