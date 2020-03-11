//
//  TuSDKMediaTimeSliceEntity.h
//  TuSDKVideo
//
//  Created by sprint on 26/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaTimelineSlice.h"

/**
 媒体时间切片实体计算对象
 @since      v3.0
 */
@interface TuSDKMediaTimeSliceEntity : TuSDKMediaTimelineSlice

/**
 根据时间片段初始化实体计算对象

 @param slice 时间片段
 @return TuSDKMediaTimeSliceEntity
 */
- (instancetype)initWithSlice:(TuSDKMediaTimelineSlice *)slice;

/**
 根据时间片段初始化实体计算对象
 
 @param slice 时间片段
 @return TuSDKMediaTimeSliceEntity
 */
- (instancetype)initWithSlice:(TuSDKMediaTimelineSlice *)slice canSupportedReverseSlice:(BOOL)canSupportedReverseSlice;

/**
 原始切片信息
 @since      v3.0
 */
@property (nonatomic,readonly) TuSDKMediaTimelineSlice *origSlice;

/**
 前一个片段
 @since      v3.0
 */
@property (nonatomic,strong) TuSDKMediaTimeSliceEntity *previous;

/**
 前一个片段
 @since      v3.0
 */
@property (nonatomic,weak) TuSDKMediaTimeSliceEntity *next;

/**
 输出的真实开始时间
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputStartTime;

/**
 输出的真实结束时间
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputEndTime;

/**
 最终持续时间
 @since      v3.0
 */
@property (nonatomic,readonly) CMTime outputDuraiton;

/**
 最后一帧输出的时间戳。 设置的时间范围和实际分离的数据范围存在误差
 @since 3.0
 */
@property (nonatomic)CMTime realEndOutputSampleBufferTime;

/**
 检查输出时间在当前片段的相对位置
 
 @param outputTIme 输出时间
 @return NSComparisonResult
 NSOrderedAscending : outputTIme 在当前片段之前
 NSOrderedDescending: outputTIme 在当前片段之后
 NSOrderedSame :      outputTIme 在当前片段
 @param frameInterval 帧间隔
 @since      v3.0
 */
- (NSComparisonResult)overviewOutputTime:(CMTime)outputTime frameInterval:(CMTime)frameInterval;

/**
 检查输入时间是否在该时间切片内
 
 @param inputTime 输入时间
 @return NSComparisonResult
 NSOrderedAscending : inputTime 在当前片段之前
 NSOrderedDescending: inputTime 在当前片段之后
 NSOrderedSame :      inputTime 在当前片段
 @param frameInterval 帧间隔
 @since      v3.0
 */
- (NSComparisonResult)overviewInputTime:(CMTime)inputTime frameInterval:(CMTime)frameInterval;

/**
 检查输入时间是否在该时间切片内
 
 @param inputTime 输入时间
 @return NSComparisonResult
 NSOrderedAscending : inputTime 在当前片段之前
 NSOrderedDescending: inputTime 在当前片段之后
 NSOrderedSame :      inputTime 在当前片段
 @param frameInterval 帧间隔
 @since      v3.0
 */
- (BOOL)containsInputTime:(CMTime)inputTime;

/**
 计算输出时间所在的输入时间
 
 @param outputTime 输出时间
 @return 输入时间 CMTime
 @since      v3.0
 */
- (CMTime)calculateInputTimeWithOutputTime:(CMTime)outputTime;

/**
 根据输入时间计算输出时间
 
 @param inputTime 输入时间
 @return 输入时间 CMTime
 @since      v3.0
 */
- (CMTime)calculateOutputWithInputTime:(CMTime)inputTime;

/**
 按视频时间修正计算对象

 @param inputDuration 最大输入持续时间
 @since      v3.0
 */
- (void)fixSliceEntry:(CMTime)inputDuration;

@end
