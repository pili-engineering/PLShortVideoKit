//
//  PLSMVEffect.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/9/4.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@class PLSMVEffect;

/*!
 @protocol PLSMVEffectDelegate
 @brief MV 协议
 */
@protocol PLSMVEffectDelegate <NSObject>
@optional

/*!
 @method mvEffectPlayToEnd:
 @brief MV 播放完成回调
 
 @param mvEffect PLSMVEffect 实例
 */
- (void)mvEffectPlayToEnd:(PLSMVEffect *)mvEffect;
@end

/*!
 @class PLSMVEffect
 @brief MV 特效类
 */
@interface PLSMVEffect : NSObject

/*!
 @property playAtActualSpeed
 @brief 是否按照时间戳播放
 */
@property (readwrite, nonatomic) BOOL playAtActualSpeed;

/*!
 @property filter
 @brief MV 处理 filter
 */
@property (strong, nonatomic) id filter;

/*!
 @property delegate
 @brief 回调代理
 */
@property (weak, nonatomic) id<PLSMVEffectDelegate> delegate;


/*!
 @method initWithColor:alpha:
 @abstract 初始化 MV 特效方法 1
 @discussion 将按照 [self initWithColor:colorURL alpha:alphaURL timeRange:kCMTimeRangeZero loopEnable:NO movieDuration:kCMTimeZero] 调用 初始化方法 2
 
 @return PLSMVEffect 实例
 */
- (instancetype)initWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL;

/*!
 @method initWithColor:alpha:timeRange:loopEnable:movieDuration:
 @abstract 初始化 MV 特效方法 2

 @param      colorURL 彩色层视频的地址
 @param      alphaURL 被彩色层当作透明层的视频的地址
 @param      timeRange  选取 MV 文件的时间段, 如果选取整个 MV，直接传入 kCMTimeRangeZero 即可
 @param      loopEnable 当 MV 时长(timeRange.duration)小于视频时长(movieDuration)的时候，是否循环播放 MV
 @param      movieDuration 编辑视频的时长(MV 附着的视频时长)

 @return    PLSMVEffect 实例
 @since      v1.14.0
 */
- (instancetype)initWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL timeRange:(CMTimeRange)timeRange loopEnable:(BOOL)loopEnable movieDuration:(CMTime)movieDuration;

/*!
 @method startProcessing
 @brief 开始 MV 播放
 */
- (void)startProcessing;

/*!
 @method pauseProcessing
 @brief 暂停 MV 播放
 */
- (void)pauseProcessing;

/*!
 @method cancelProcessing
 @brief 取消 MV 播放
 */
- (void)cancelProcessing;

@end
