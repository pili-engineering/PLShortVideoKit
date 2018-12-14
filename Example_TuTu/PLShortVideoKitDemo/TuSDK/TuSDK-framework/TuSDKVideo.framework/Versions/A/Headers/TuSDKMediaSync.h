//
//  TuSDKMediaSync.h
//  TuSDKVideo
//
//  Created by sprint on 25/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 媒体同步接口
 @since      v3.0
 */
@protocol TuSDKMediaSync <NSObject>

/**
 当前已播放时长
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputTime;

/**
 最终输出持续时间
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputDuraiton;

/**
 重置媒体同步器
 @since      v3.0
 */
- (void)reset;

@end
