//
//  TuSDKMovieClipper.h
//  TuSDKVideo
//
//  Created by gh.li on 2017/4/5.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>
#import <AVFoundation/AVFoundation.h>


#import "TuSDKTimeRange.h"
#import "TuSDKVideoResult.h"


/**
 TuSDKMovieClipper 视频裁剪状态
 */
typedef NS_ENUM(NSInteger,lsqMovieClipperSessionStatus)
{
    /**
     *  未知状态
     */
    lsqMovieClipperSessionStatusUnknown,
        
    /**
     * 正在裁剪
     */
    lsqMovieClipperSessionStatusClipping,
    
    /**
     * 裁剪完成
     */
    lsqMovieClipperSessionStatusCompleted,
    
    /**
     * 保存失败
     */
    lsqMovieClipperSessionStatusFailed,
    
    /**
     * 已取消
     */
    lsqMovieClipperSessionStatusCancelled
    
};

@class TuSDKMovieClipper;

#pragma mark - protocol TuSDKMovieClipperDelegate

@protocol TuSDKMovieClipperDelegate <NSObject>

@optional
// 状态通知代理
- (void)onMovieClipper:(TuSDKMovieClipper *)editor statusChanged:(lsqMovieClipperSessionStatus)status;
// 结果通知代理
- (void)onMovieClipper:(TuSDKMovieClipper *)editor result:(TuSDKVideoResult *)result;

@end

#pragma mark - TuSDKMovieClipper

/**
 视频裁剪器

 1、移除一个视频中的某个时间段的内容
 2、移除一个视频中的多个时间段的内容
 3、消除一个视频的音轨

 */
@interface TuSDKMovieClipper : NSObject

/**
 初始化TuSDKMovieClipper
 
 @param moviePath 视频地址
 @return TuSDKMovieClipper
 */
-(instancetype) initWithMoviePath:(NSString *)moviePath;

// 状态
@property (nonatomic, readonly, assign) lsqMovieClipperSessionStatus status;
// 代理
@property (nonatomic, weak) id<TuSDKMovieClipperDelegate> clipDelegate;

// 输出的文件格式 lsqFileTypeQuickTimeMovie 或 lsqFileTypeMPEG4
 @property (nonatomic, assign) lsqFileType outputFileType;
// 是否保留视频原音，默认 YES，保留视频原音
@property (nonatomic, assign) BOOL enableVideoSound;
// 要删除的时间段数组
@property (nonatomic, strong) NSArray<TuSDKTimeRange *> * dropTimeRangeArr;

/**
 * 开始裁剪视频
 */
- (void)startClipping;

/**
 * 开始裁剪视频 block回调
 *
 * @param handler 完成回调处理
 */
- (void)startClippingWithCompletionHandler:(void (^)(NSString* outputFilePath, lsqMovieClipperSessionStatus status))handler;

/**
 * 取消裁剪操作
 */
- (void)cancelClipper;

@end


