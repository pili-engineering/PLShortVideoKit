//
//  TuSDKTSMovieSplicer.h
//  TuSDKVideo
//
//  Created by wen on 19/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMoiveFragment.h"
#import "TuSDKVideoResult.h"


/**
 TuSDKTSMovieSplicer 视频拼接状态
 */
typedef NS_ENUM(NSInteger,lsqMovieSplicerSessionStatus)
{
    /**
     *  未知状态
     */
    lsqMovieSplicerSessionStatusUnknown,
    
    /**
     * 正在合并
     */
    lsqMovieSplicerSessionStatusMerging,
    
    /**
     * 合并完成
     */
    lsqMovieSplicerSessionStatusCompleted,
    
    /**
     * 保存失败
     */
    lsqMovieSplicerSessionStatusFailed,
    
    /**
     * 已取消
     */
    lsqMovieSplicerSessionStatusCancelled
    
};

@class TuSDKTSMovieSplicer;

#pragma mark - protocol TuSDKMovieSplicerDelegate

@protocol TuSDKMovieSplicerDelegate <NSObject>

@optional
// 状态通知代理
- (void)onMovieSplicer:(TuSDKTSMovieSplicer *)editor statusChanged:(lsqMovieSplicerSessionStatus)status;
// 结果通知代理
- (void)onMovieSplicer:(TuSDKTSMovieSplicer *)editor result:(TuSDKVideoResult *)result;

@end

#pragma mark - class TuSDKTSMovieSplicer

/**
 视频拼接工具

 功能 (建议拼接的视频的方向与分辨率尽量一致)
 1、将多个视频的片段进行拼接
 
 */
@interface TuSDKTSMovieSplicer : NSObject
// 代理设置
@property (nonatomic, weak) id<TuSDKMovieSplicerDelegate> splicerDelegate;

// 需要进行合并的视频，合并顺序按照数组顺序
@property (nonatomic, strong) NSArray<TuSDKMoiveFragment *> *movies;
// 操作状态
@property (nonatomic, readonly, assign) lsqMovieSplicerSessionStatus status;
// 是否保留视频原音，默认 YES，保留视频原音
@property (nonatomic, assign) BOOL enableVideoSound;


// 初始化视频合并工具对象
+ (instancetype)createSplicer;

/**
 * 开始合并视频操作
 */
- (void)startSplicing;

/**
 * 开始合并视频操作 block回调
 */
- (void)startSplicingWithCompletionHandler:(void (^)(NSString *filePath, lsqMovieSplicerSessionStatus status))handler;

/**
 * 取消合并操作
 */
- (void)cancelSplicing;

@end
