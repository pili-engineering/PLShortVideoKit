//
//  TuSDKMovieSpeedComposition.h
//  TuSDKVideo
//
//  Created by wen on 2018/2/6.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>
#import <AVFoundation/AVFoundation.h>

#import "TuSDKVideoSpeedData.h"
#import "TuSDKVideoResult.h"


/**
 TuSDKMovieSpeedComposition 视频变速合成状态
 */
typedef NS_ENUM(NSInteger,lsqMovieSpeedCompositionStatus)
{
    /**
     *  未知状态
     */
    lsqMovieSpeedCompositionStatusUnknown,
    
    /**
     * 正在合成
     */
    lsqMovieSpeedCompositionStatusComposing,
    
    /**
     * 操作完成
     */
    lsqMovieSpeedCompositionStatusCompleted,
    
    /**
     * 保存失败
     */
    lsqMovieSpeedCompositionStatusFailed,
    
    /**
     * 已取消
     */
    lsqMovieSpeedCompositionStatusCancelled,
};


@class TuSDKMovieSpeedComposition;

#pragma mark - protocol TuSDKMovieClipperDelegate

@protocol TuSDKMovieSpeedCompositionDelegate <NSObject>

@optional
// 状态通知代理
- (void)onMovieSpeedComposition:(TuSDKMovieSpeedComposition *)composition statusChanged:(lsqMovieSpeedCompositionStatus)status;
// 结果通知代理
- (void)onMovieSpeedComposition:(TuSDKMovieSpeedComposition *)composition result:(TuSDKVideoResult *)result;
// 视频处理进度通知代理
- (void)onMovieSpeedComposition:(TuSDKMovieSpeedComposition *)composition progress:(CGFloat)progress;

@end

/**
 视频快慢速编辑工具
 
 功能
 1、将一个视频的一个或多个多个片段进行快慢速编辑
 2、移除视频中的一个或多个片段
 
 */

@interface TuSDKMovieSpeedComposition : NSObject
/**
 初始化TuSDKMovieSpeedComposition
 
 @param moviePath 视频地址
 @return TuSDKMovieSpeedComposition
 */
-(instancetype) initWithMoviePath:(NSString *)moviePath;

// 状态
@property (nonatomic, readonly, assign) lsqMovieSpeedCompositionStatus status;
// 代理
@property (nonatomic, weak) id<TuSDKMovieSpeedCompositionDelegate> compositionDelegate;
// 输出的文件格式 lsqFileTypeQuickTimeMovie 或 lsqFileTypeMPEG4
@property (nonatomic, assign) lsqFileType outputFileType;
// 是否保留视频原音，默认 YES，保留视频原音
@property (nonatomic, assign) BOOL enableVideoSound;
// 视频的时间段数组  注：数组中应包含所有视频段，而不是只截取某段视频
@property (nonatomic, strong) NSArray<TuSDKVideoSpeedData *> * speedVideoArr;

/**
 * 开始变速合成
 */
- (void)startComposition;

/**
 * 开始变速合成视频 block回调
 *
 * @param handler 完成回调处理
 */
- (void)startCompositionWithCompletionHandler:(void (^)(NSString* outputFilePath, CGFloat progress, lsqMovieSpeedCompositionStatus status))handler;

/**
 * 取消操作
 */
- (void)cancelComposition;

/**
 * 开始裁剪音频
 */
- (void)startAudioCompositionWithCompletionHandler:(void (^)(NSString* outputFilePath, CGFloat progress, lsqMovieSpeedCompositionStatus status))handler;
@end


