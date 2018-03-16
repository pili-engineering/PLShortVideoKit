//
//  PLSRangeMedia.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/2.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PLSRangeMedia : NSObject

/**
 @brief 选取的开始时间
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CMTime startTime;

/**
 @brief 选取的结束时间
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CMTime endTime;

/**
 @brief 视频可以是AVAseet格式，也可以用url，二选一
 
 @since      v1.10.0
 */
@property (nonatomic, strong) AVAsset *asset;

/**
 @brief 视频的url，也可以用AVAsset，二选一
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *url;

/**
 @brief 是不是转场视频
 
 @since      v1.10.0
 */
@property (nonatomic, assign) BOOL isTransition;

@end
