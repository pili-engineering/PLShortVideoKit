//
//  TuSDKAssetVideoComposer.h
//  TuSDKVideo
//
//  视频合并转码压缩
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TuSDKVideoQuality.h"
#import "TuSDKVideoImport.h"
#import "TuSDKVideoResult.h"
#import "TuSDKGPUVideoPixelBufferForTexture.h"

@protocol TuSDKAssetVideoComposerDelegate;

#pragma mark - TuSDKAssetVideoComposerStatus

/** TuSDKAssetVideoComposerStatus 状态 */
typedef NS_ENUM(NSInteger, TuSDKAssetVideoComposerStatus){
    TuSDKAssetVideoComposerStatusUnknow = 0,
    TuSDKAssetVideoComposerStatusStarted,
    TuSDKAssetVideoComposerStatusCompleted,
    TuSDKAssetVideoComposerStatusCancelled,
    TuSDKAssetVideoComposerStatusFailed,
};

#pragma mark - TuSDKAssetVideoComposer

/**
 * 多视频拼接
 * 支持不同分辨率不同格式的视频进行拼接
 * @since 2.1.0
 */
@interface TuSDKAssetVideoComposer : TuSDKGPUVideoPixelBufferForTexture

/**
 根据 AVAsset 初始化解码器
 
 @param assets 视频数据源
 @return AVAsset
 */
- (instancetype _Nonnull)initWithAsset:(NSArray<AVAsset *> *_Nullable)assets;

/**
  当前转码器状态
 */
@property (nonatomic,readonly) TuSDKAssetVideoComposerStatus status;

/**
当前进度 （0 - 1）
 */
@property (nonatomic,assign,readonly) CGFloat progress;

/**
 输出的视频画质
 */
@property (nonatomic) TuSDKVideoQuality * _Nullable outputVideoQuality;

/**
 输出视频压缩比例 (0 - 1) 优先使用 outputVideoQuality
 @since 2.2.0
 */
@property (nonatomic, assign) CGFloat outputCompressionScale;

/**
 指定输出的文件类型
 */
@property (nonatomic) lsqFileType outputFileType;

/**
 * 合成事件委托
 */
@property (nonatomic,weak) id<TuSDKAssetVideoComposerDelegate> _Nullable delegate;

/**
 * 转码后输出的视频路径
 */
@property (nonatomic) NSURL * _Nullable outputFileURL;

/**
 *  保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 *  保存到系统相册的相册名称
 */
@property (nonatomic, copy) NSString * _Nullable saveToAlbumName;

/**
 添加需要转码的视频

 @param asset AVAsset
 */
- (void)addInputAsset:(AVAsset * _Nonnull )asset;

/**
 删除视频源

 @param asset AVAsset
 */
- (void)removeInputAsset:(AVAsset * _Nonnull )asset;

/**
 启动转码
 */
- (void)startComposing;

/**
 取消合成并且当前合成的视频将被丢弃
 */
- (void)cancelComposing;

@end


#pragma mark - TuSDKAssetVideoComposerDelegate

/**
 * TuSDKAssetVideoComposerDelegate
 */
@protocol TuSDKAssetVideoComposerDelegate <NSObject>

@required

/**
 视频合成完毕
 
 @param composer TuSDKAssetVideoComposer
 @param result TuSDKVideoResult
 */
- (void)assetVideoComposer:(TuSDKAssetVideoComposer *_Nonnull)composer saveResult:(TuSDKVideoResult *_Nullable)result;


@optional

/**
 合成进度
 
 @param composer TuSDKAssetVideoComposer
 @param progress 处理进度
 @param index 当前正在处理的视频索引
 */
- (void)assetVideoComposer:(TuSDKAssetVideoComposer *_Nonnull)composer processChanged:(float)progress assetIndex:(NSUInteger)index;

/**
 合成状态改变事件
 
 @param composer TuSDKAssetVideoComposer
 @param status lsqAssetVideoComposerStatus 当前状态
 */
- (void)assetVideoComposer:(TuSDKAssetVideoComposer *_Nonnull)composer statusChanged:(TuSDKAssetVideoComposerStatus)status;

@end
