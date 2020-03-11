//
//  PLSReverserEffect.h
//  PLShortVideoKit
//
//  Created by 何昊宇 on 2017/9/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*!
 @class PLSReverserEffect
 @brief 时光倒流处理核心类
 
 @since      v1.5.0
 */
@interface PLSReverserEffect : NSObject

/*!
 @property completionBlock
 @abstract 时光倒流完成的 Block
 
 @since      v1.5.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/*!
 @property failureBlock
 @abstract 时光倒流失败的 Block
 
 @since      v1.5.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError *error);

/*!
 @property processingBlock
 @abstract 时光倒流进度的 Block，可在该 Block 中刷新倒序进度条 UI
 
 @since      v1.5.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/*!
 @property isReversing
 @brief PLSReverserEffect 处于执行时光倒流状态时为 YES
 
 @since      v1.5.0
 */
@property (readonly, nonatomic) BOOL isReversing;

/*!
 @property audioRemoved
 @brief audioRemoved 是否去掉音频，默认为 YES，即去掉音频。当设置为 NO 时，维持原音频，即不对音频进行倒序处理。
 
 @since      v1.14.0
 */
@property (assign, nonatomic, getter=isAudioRemoved) BOOL audioRemoved;

/*!
 @method initWithAsset:
 @brief 初始化
 
 @param asset 原视频文件
 
 @since      v1.5.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/*!
 @method startReversing
 @abstract 执行时光倒流
  
 @since      v1.5.0
 */
- (void)startReversing;

/*!
 @method cancelReversing
 @abstract 取消时光倒流
 
 @since      v1.5.0
 */
- (void)cancelReversing;

@end
