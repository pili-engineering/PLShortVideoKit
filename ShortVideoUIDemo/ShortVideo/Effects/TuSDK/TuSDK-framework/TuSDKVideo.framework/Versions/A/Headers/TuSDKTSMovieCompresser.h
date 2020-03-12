//
//  TuSDKTSMovieCompresser.h
//  TuSDKVideo
//
//  Created by wen on 2018/3/21.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoResult.h"


/**
 TuSDKTSMovieCompresser 视频压缩状态
 */
typedef NS_ENUM(NSInteger,lsqMovieCompresserSessionStatus)
{
    /**
     *  未知状态
     */
    lsqMovieCompresserSessionStatusUnknown,
    
    /**
     * 正在压缩
     */
    lsqMovieCompresserSessionStatusCompressing,
    
    /**
     * 压缩完成
     */
    lsqMovieCompresserSessionStatusCompleted,
    
    /**
     * 保存失败
     */
    lsqMovieCompresserSessionStatusFailed,
    
    /**
     * 已取消
     */
    lsqMovieCompresserSessionStatusCancelled
    
};

@class TuSDKTSMovieCompresser;

#pragma mark - protocol TuSDKMovieCompresserDelegate

@protocol TuSDKMovieCompresserDelegate <NSObject>

@optional
// 状态通知代理
- (void)onMovieCompresser:(TuSDKTSMovieCompresser *)compresser statusChanged:(lsqMovieCompresserSessionStatus)status;
// 结果通知代理
- (void)onMovieCompresser:(TuSDKTSMovieCompresser *)compresser result:(TuSDKVideoResult *)result;

@end

/**
 视频压缩工具
 
 1、设置码率压缩视频
 2、设置码率的压缩比进行压缩
 3、消除视频的音轨
 
 */
@interface TuSDKTSMovieCompresser : NSObject

/**
 初始化TuSDKTSMovieCompresser
 
 @param moviePath 视频地址
 @return TuSDKTSMovieCompresser
 */
-(instancetype) initWithMoviePath:(NSString *)moviePath;

// 状态
@property (nonatomic, readonly, assign) lsqMovieCompresserSessionStatus status;
// 代理
@property (nonatomic, weak) id<TuSDKMovieCompresserDelegate> compressDelegate;

// 输出的文件格式 lsqFileTypeQuickTimeMovie 或 lsqFileTypeMPEG4
@property (nonatomic, assign) lsqFileType outputFileType;
// 是否保留视频原音，默认 YES，保留视频原音
@property (nonatomic, assign) BOOL enableVideoSound;

// 设置视频码率
@property (nonatomic, assign) NSUInteger videoBitRate;
// 视频码率缩小倍率 0 ~ 1 默认为 1 注：仅在不设置 videoBitRate 或 videoBitRate 为 0 时生效
@property (nonatomic, assign) CGFloat videoBitRateScale;



/**
 * 开始压缩视频
 */
- (void)startCompressing;

/**
 * 开始压缩视频 block回调
 *
 * @param handler 完成回调处理
 */
- (void)startCompressingWithCompletionHandler:(void (^)(NSString* outputFilePath, CGFloat progress, lsqMovieCompresserSessionStatus status))handler;

/**
 * 取消压缩操作
 */
- (void)cancelCompresser;

@end
