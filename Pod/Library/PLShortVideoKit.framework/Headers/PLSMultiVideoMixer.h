//
//  PLSMultiVideoMixer.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/6/7.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSVideoConfiguration.h"
#import "PLSAudioConfiguration.h"
#import "PLSMixMediaItem.h"

/**
 * @abstract 将多个 视频 或者 纯视频 或者 纯音频 合并为一个文件
 *
 * @discussion PLSMultiVideoMixer 没有对合并视频的路数做限制，但由于受手机硬件限制，在没有 AVPlayer 播放的时候，最大可以合并 16 路视频，
 *           在有 AVplayer 播放的时候，最大可以合并 8 路视频。因此导出视频之前，尽量将不需要的 AVPlayer 释放掉。
 */
@interface PLSMultiVideoMixer : NSObject

/**
 @brief     导出视频存放url. 必须设置，否则无法导出视频
 
 @since      v1.11.0
 */
@property (nonatomic, strong) NSURL * _Nonnull outputURL;

/**
 @brief     编码的视频大小，PLSMixMediaItem 的属性 videoFrame 就是基于 CGRect {0, 0, videoSize.width, videoSize.height}
            最大支持 1080p
 
 @since      v1.11.0
 */
@property (nonatomic, assign) CGSize videoSize;

/**
 @brief     合并文件的时长，默认等于所有参与合并文件时长最长的
 
 @since      v1.11.0
 */
@property (nonatomic, assign) CMTime duration;

/**
 @brief     编码的帧率，如果为 0 或者不设置. 则使用合并的第一个视频文件的 frameRate。最大支持 60 帧
 
 @since      v1.11.0
 */
@property (nonatomic, assign) float frameRate;


/**
 @brief 导出视频成功的 block
 
 @since      v1.11.0
 */
@property (copy, nonatomic) void(^ _Nullable completionBlock)(NSURL * _Nonnull url);

/**
 @brief 导出视频失败的 block
 
 @since      v1.11.0
 */
@property (copy, nonatomic) void(^ _Nullable failureBlock)(NSError* _Nonnull error);

/**
 @brife 导出视频进度的 block，可在该 block 中刷新进度条 UI
 
 @since      v1.11.0
 */
@property (copy, nonatomic) void(^ _Nullable processingBlock)(float progress);

/**
 @abstract   添加合并视频文件, 可以是纯音频或者纯视频文件. 如果多次添加同一个 media，会被忽略
 
 @param media 不能为空
 
 @since      v1.11.0
 */
-(void)addMedia:(PLSMixMediaItem *_Nonnull)media;

/**
 @abstract   获取所有添加的 PLSMixMediaItem 实例
 
 @since      v1.11.0
 */
- (NSArray<PLSMixMediaItem *> * _Nullable )getAllMedia;

/**
 @abstract   删除合并视频文件
 
 @param media 不能为空
 
 @since      v1.11.0
 */
-(void)removeMedia:(PLSMixMediaItem *_Nonnull)media;

/**
 @abstract   删除所有合并视频文件
 
 @since      v1.11.0
 */
-(void)removeAllMedia;

/**
 @abstract   可以获取 AVPlayerItem 用于预览效果。每次添加、删除合并文件之后、重新调用此方法，获取最新的。注意：每次调用，返回的 AVPlayerItem 都是新的实例
 
 @param      error 如果调用此方法发生错误，error 不等于 nil 的话、错误信息将放在 *error 中返回
 
 @return     如果已经添加合并文件，返回实时 AVPlayerItem 实例
 
 @since      v1.11.0
 */
-(nullable AVPlayerItem *)getPlayerItem:(NSError **_Nullable)error;

/**
 @abstract   预览的时候用于动态调整 PLSMixMediaItem 的音量大小
 
 @param      playerItem  getPlayerItem: 返回的 AVPlayerItem 实例
 @param      media 要调整音量的 PLSMixMediaItem 实例
 
 @return     成功返回 YES，失败返回 NO
 
 @since      v1.11.0
 */
- (BOOL)setMediaVolume:(AVPlayerItem *_Nonnull)playerItem media:(PLSMixMediaItem *_Nonnull)media;

/**
 @abstract   开始导出文件
 
 @since      v1.11.0
 */
- (void)startExport;

/**
 @abstract   取消导出文件
 
 @since      v1.11.0
 */
- (void)cancelExport;

@end
