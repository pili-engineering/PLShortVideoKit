//
//  TuSDKVideoSpeedData.h
//  TuSDKVideo
//
//  Created by wen on 2018/2/6.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKRecordVideoMode.h"


/**
 视频变速片段 Model
 */
@interface TuSDKVideoSpeedData : NSObject

// 开始时间
@property (nonatomic, assign) CMTime starTime;
// 结束时间
@property (nonatomic, assign) CMTime endTime;
// 该时间段速率  默认：lsqSpeedMode_Normal
@property (nonatomic, assign) lsqSpeedMode speedMode;
// 变速调整后对应的该片段时长
@property (nonatomic, assign, readonly) CMTime adjustedTime;
// 是否移除该段视频 默认：NO
@property (nonatomic, assign) BOOL isRemove;


/**
 初始化方法

 @param startTime 开始时间
 @param endTime 结束时间
 @param speedMode 速度模式
 @return TuSDKVideoSpeedData
 */
- (instancetype)initWithStartTime:(CMTime)startTime  endTime:(CMTime)endTime  speedMode:(lsqSpeedMode)speedMode;

@end

@interface TuSDKAudioPitchData : TuSDKVideoSpeedData

/**
 初始化方法
 
 @param startTime 开始时间
 @param endTime 结束时间
 @return TuSDKAudioPitchData
 */
- (instancetype)initWithStartTime:(CMTime)startTime  endTime:(CMTime)endTime;

@end
