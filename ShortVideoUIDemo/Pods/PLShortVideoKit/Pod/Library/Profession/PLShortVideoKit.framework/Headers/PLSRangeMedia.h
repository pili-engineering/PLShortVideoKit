//
//  PLSRangeMedia.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/2.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*!
 @class PLSRangeMedia
 @brief 视频切割信息实例
 
 @since      v1.10.0
 */
@interface PLSRangeMedia : NSObject

/*!
 @property startTime
 @brief 选取的开始时间
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CMTime startTime;

/*!
 @property endTime
 @brief 选取的结束时间
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CMTime endTime;

/*!
 @property asset
 @brief 视频可以是AVAseet格式，也可以用url，二选一
 
 @since      v1.10.0
 */
@property (nonatomic, strong) AVAsset *asset;

/*!
 @property url
 @brief 视频的url，也可以用AVAsset，二选一
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *url;

/*!
 @property isTransition
 @brief 是不是转场视频
 
 @since      v1.10.0
 */
@property (nonatomic, assign) BOOL isTransition;

@end
