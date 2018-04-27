//
//  TuSDKTimeRange.h
//  TuSDKVideo
//
//  Created by gh.li on 2017/4/5.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TuSDKTimeRange : NSObject

#pragma mark - MAKE

/**
 创建一个TuSDKTimeRange对象
 
 @param start 开始时间
 @param duration 持续时间
 @return TuSDKTimeRange
 */
+ (instancetype)makeTimeRangeWithStart:(CMTime) start duration:(CMTime) duration;

/**
 创建一个TuSDKTimeRange对象
 
 @param startSeconds 开始时间
 @param durationSeconds 持续时间
 @return TuSDKTimeRange
 */
+ (instancetype)makeTimeRangeWithStartSeconds:(Float64)startSeconds durationSeconds:(Float64)durationSeconds;

/**
 创建一个TuSDKTimeRange对象
 
 @param start 开始时间
 @param end 结束时间
 @return TuSDKTimeRange
 */
+ (instancetype)makeTimeRangeWithStart:(CMTime)start end:(CMTime)end;

/**
 创建一个TuSDKTimeRange对象
 
 @param startSeconds 开始时间
 @param endSeconds 结束时间
 @return TuSDKTimeRange
 */
+ (instancetype)makeTimeRangeWithStartSeconds:(Float64)startSeconds endSeconds:(Float64)endSeconds;


#pragma mark - Properties

/**
 开始时间
 */
@property (nonatomic,assign) CMTime start;

/**
 持续时间
 */
@property (nonatomic,assign) CMTime duration;

/**
 结束时间 只读类型 若需要修改结束时间,请通过修改duration进行
 */
@property (nonatomic,assign,readonly) CMTime end;

#pragma mark - Methods

/**
 开始时间(秒)
 
 @return 开始时间
 */
- (Float64)startSeconds;

/**
 持续时间(秒)
 
 @return 持续时间
 */
- (Float64)durationSeconds;


/**
 结束时间(秒)

 @return 结束时间
 */
- (Float64)endSeconds;

/**
 TuSDKTimeRange 转为 CMTimeRange
 
 @return CMTimeRange
 */
- (CMTimeRange)CMTimeRange;

/**
 时间范围是否有效
 
 @return true/false
 */
- (BOOL)isValid;

/**
 是否包含另一个timeRange
 
 @return true/false
 */
- (BOOL)containsTimeRange:(TuSDKTimeRange *)timeRange;

/**
 校验另一个 timeRange，得到一个新的包含在内的 timeRange
 
 @return 校验后的 timerange
 */
- (TuSDKTimeRange *)verifyOtherTimeRange:(TuSDKTimeRange *)timeRange;


@end
