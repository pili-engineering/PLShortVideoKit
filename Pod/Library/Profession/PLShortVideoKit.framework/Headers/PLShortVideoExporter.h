//
//  PLShortVideoExporter.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/10/18.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PLShortVideoExporter;

/*!
 @protocol PLShortVideoExporterDelegate
 @brief 视频转码协议.
 */
@protocol PLShortVideoExporterDelegate <NSObject>

/*!
 @method shortVideoExporter:renderFrame:withPresentationTime:toBuffer:
 @brief 读取到原视频帧的回调.
 
 @discussion 如果没有替换原视频帧的需要，没有必要实现当前方法.
 
 @param exporter        PLShortVideoExporter 实例.
 @param pixelBuffer     原视频帧.
 @param presentationTime 原视频帧的时间戳.
 @param renderBuffer    将用于替换的视频数据放到 renderBuffer 中，内部使用 renderBuffer 来编码.
 */
- (void)shortVideoExporter:(PLShortVideoExporter *)exporter renderFrame:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime toBuffer:(CVPixelBufferRef)renderBuffer;

@end

/*!
 @class PLShortVideoExporter
 @brief 视频转码类.
 */
@interface PLShortVideoExporter : NSObject

/*!
 @property delegate
 @brief 回调代理.
 */
@property (weak, nonatomic) id<PLShortVideoExporterDelegate> delegate;

/*!
 @property asset
 @brief 待转码的 AVAsset 实例.
 */
@property (readonly, strong, nonatomic) AVAsset *asset;

/*!
 @property videoComposition
 @brief 视频编辑参数实例.
 */
@property (strong, nonatomic) AVVideoComposition *videoComposition;

/*!
 @property audioMix
 @brief 混音参数实例.
 */
@property (strong, nonatomic) AVAudioMix *audioMix;

/*!
 @property outputFileType
 @brief 输出文件类型 AVFileTypeMPEG4 or AVFileTypeQuickTimeMovie，必须设置.
 */
@property (strong, nonatomic) NSString *outputFileType;

/*!
 @property outputURL
 @brief 输出文件存放路径，必须设置.
 */
@property (strong, nonatomic) NSURL *outputURL;

/*!
 @property videoInputSettings
 @brief 读取原视频数据的参数，没有特殊需求设置为 nil 即可.
 */
@property (strong, nonatomic) NSDictionary *videoInputSettings;

/*!
 @property videoSettings
 @brief 视频编码参数设置，必须设置
 */
@property (strong, nonatomic) NSDictionary *videoSettings;

/*!
 @property audioSettings
 @brief 音频编码参数，必须设置
 */
@property (strong, nonatomic) NSDictionary *audioSettings;

/*!
 @property timeRange
 @brief 可以对原视频进行截取操作
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/*!
 @property shouldOptimizeForNetworkUse
 @brief 是否对输出文件做网络播放优化处理
 */
@property (assign, nonatomic) BOOL shouldOptimizeForNetworkUse;

/*!
 @property metadata
 @brief metadata 信息
 */
@property (strong, nonatomic) NSArray *metadata;

/*!
 @property error
 @brief 如果发生错误，通过该属性获取错误信息
 */
@property (readonly, strong, nonatomic) NSError *error;

/*!
 @property progress
 @brief 转码进度
 */
@property (readonly, assign, nonatomic) float progress;

/*!
 @property status
 @brief 转码状态
 */
@property (readonly, assign, nonatomic) AVAssetExportSessionStatus status;

/*!
 @property reader
 @brief 原视频数据的读取实例
 */
@property (strong, nonatomic, readonly) AVAssetReader *reader;

/*!
 @method exportSessionWithAsset:
 @brief 初始化方法
 
 @param asset 原视频 AVAsset 实例
 
 @return PLShortVideoExporter 实例
 */
+ (instancetype)exportSessionWithAsset:(AVAsset *)asset;

/*!
 @method initWithAsset:
 @brief 初始化方法
 
 @param asset 原视频 AVAsset 实例
 
 @return PLShortVideoExporter 实例
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/*!
 @method exportAsynchronouslyWithCompletionHandler:
 @brief 启动异步转码
 
 @param handler 转码完成的回调
 */
- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(void))handler;

/*!
 @method cancelExport
 @brief 取消转码
 */
- (void)cancelExport;

@end
