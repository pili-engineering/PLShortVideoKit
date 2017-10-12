//
//  PLSReverserEffect.h
//  PLShortVideoKit
//
//  Created by 何昊宇 on 2017/9/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 @brief 时光倒流处理核心类
 
 @since      v1.5.0
 */
@interface PLSReverserEffect : NSObject

/**
 @abstract 时光倒流完成的 Block
 
 @since      v1.5.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @abstract 时光倒流失败的 Block
 
 @since      v1.5.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError *error);

/**
 @abstract 时光倒流进度的 Block，可在该 Block 中刷新倒序进度条 UI
 
 @since      v1.5.0
 */
@property (copy, nonatomic) void(^processingBlock)(float progress);

/**
 @brief PLSReverserEffect 处于执行时光倒流状态时为 YES
 
 @since      v1.5.0
 */
@property (readonly, nonatomic) BOOL isReversing;

/**
 @brief 初始化
 
 @since      v1.5.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/**
 @abstract 执行时光倒流
  
 @since      v1.5.0
 */
- (void)startReversing;

/**
 @abstract 取消时光倒流
 
 @since      v1.5.0
 */
- (void)cancelReversing;

@end
