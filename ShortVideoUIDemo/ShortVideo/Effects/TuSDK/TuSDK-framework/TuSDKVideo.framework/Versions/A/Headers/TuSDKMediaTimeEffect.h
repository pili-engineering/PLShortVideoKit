//
//  TuSDKMediaTimeEffectCore.h
//  TuSDKVideo
//
//  Created by sprint on 27/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaTimeRange.h"
#import "TuSDKMediaTimelineSlice.h"

/**
 时间特效基础类
 
 @since v3.0
 */
@protocol TuSDKMediaTimeEffect <NSObject>

/**
 时间特效
 
 @since v3.0
 */
@property (nonatomic,readonly) TuSDKMediaTimeRange *timeRange;

/**
 应用特效后被累加的视频时间.
 如果 dropOverTime 属性设置为 true,将从视频尾部丢弃 overTime 返回的视频时长。
 
 @since v3.0
 */
@property (nonatomic,readonly) CMTime overTime;

/**
 获取时间特效片段
 
 @return NSArray<TuSDKMediaTimelineSlice *>
 @since v3.0
 */
@property (nonatomic,readonly) NSArray<TuSDKMediaTimelineSlice *> *timeSlices;

/**
 应用某些时间特效后，视频总时长会被增加 ( overTime 属性可查询累加的视频时长  ），通过该属性可以明确告知 SDK 是否从尾部丢弃累加的 overTime 时长。
 true : 从原视频尾部丢弃特效累加的时长，视频总时长将不变。（ 注意：如果应用特效后总时长大于元视频时长该配置将忽略 ）
 false : 禁止丢弃尾部视频，总时长将增加。
 
 @since v3.0
 */
@property (nonatomic)BOOL dropOverTime;


@end
