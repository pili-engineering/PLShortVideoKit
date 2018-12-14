//
//  TuSDKTSMovieMixer.h
//  TuSDKVideo
//
//  Created by wen on 22/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>
#import <AVFoundation/AVFoundation.h>

#import "TuSDKTimeRange.h"
#import "TuSDKVideoResult.h"
#import "TuSDKTSAudio.h"


/**
 TuSDKTSMovieMixer 音视频混合状态
 */
typedef NS_ENUM(NSInteger,lsqMovieMixStatus)
{
    /**
     *  未知状态
     */
    lsqMovieMixStatusUnknown,
        
    /**
     * 正在混合
     */
    lsqMovieMixStatusMixing,
    
    /**
     * 操作完成
     */
    lsqMovieMixStatusCompleted,
    
    /**
     * 操作失败
     */
    lsqMovieMixStatusFailed,
    
    /**
     * 已取消
     */
    lsqMovieMixStatusCancelled
    
};

@class TuSDKTSMovieMixer;

#pragma mark - protocol TuSDKMovieSplicerDelegate

@protocol TuSDKTSMovieMixerDelegate <NSObject>

@optional
// 状态通知代理
- (void)onMovieMixer:(TuSDKTSMovieMixer *)editor statusChanged:(lsqMovieMixStatus)status;
// 结果通知代理
- (void)onMovieMixer:(TuSDKTSMovieMixer *)editor result:(TuSDKVideoResult *)result;

@end

/*
 音视频混合
 
 功能：
 1、将一个视频(可设定时间范围)，与一个音频(可设定时间范围)混合
 2、将一个视频(可设定时间范围)，与多个音频(可设定时间范围)混合
 3、消除一个视频的音轨
 4、将一个无音轨的视频，与一个(或多个)音频混合
 
 */

@interface TuSDKTSMovieMixer : NSObject

// 状态
@property (nonatomic, readonly, assign) lsqMovieMixStatus status;
// 代理
@property (nonatomic, weak) id<TuSDKTSMovieMixerDelegate> mixDelegate;

// 视频路径
@property (nonatomic, copy) NSString *moviePath;
// 输出的文件格式 lsqFileTypeQuickTimeMovie 或 lsqFileTypeMPEG4
@property (nonatomic, assign) lsqFileType outputFileType;
// 是否保留视频原音，默认 YES，保留视频原音
@property (nonatomic, assign) BOOL enableVideoSound;
// 视频原音混合时的音量设置 默认 1.0  注：只有当 enableVideoSound 为 YES 时生效
@property (nonatomic, assign) CGFloat videoSoundVolume;
// 混合的音频数组
@property (nonatomic, strong) NSArray<TuSDKTSAudio *> *mixAudios;
// 校验视频时间范围
@property (nonatomic, strong) TuSDKTimeRange *videoTimeRange;
// 音频是否可循环 默认 NO 不循环
@property (nonatomic, assign) BOOL enableCycleAdd;

/**
 初始化 TuSDKTSMovieMixer
 
 @param moviePath 视频地址
 @return TuSDKTSMovieMixer
 */
-(instancetype) initWithMoviePath:(NSString *)moviePath;

/**
 导出视频
 */
- (void)startMovieMix;

/**
 导出视频 block回调
 
 @param handler 完成回调处理
 */
- (void)startMovieMixWithCompletionHandler:(void (^)(NSString *filePath, lsqMovieMixStatus status))handler;

/**
 取消混合操作
 */
- (void)cancelMixing;

@end

