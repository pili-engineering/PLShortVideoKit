//
//  TuSDKMediaTimeRange.h
//  TuSDKVideo
//
//  Created by sprint on 26/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

/**
 特效时间轴
 @since      v3.0
 */
@interface TuSDKMediaTimeRange : NSObject <NSCopying>

/**
 根据开始时间和结束时间初始化时间范围。
 当开始时间大于结束时间时为倒序读取模式

 @param start 开始时间
 @param end 结束时间
 @return TuSDKMediaTimeRange
 @since      v3.0
 */
- (instancetype)initWithStart:(CMTime)start end:(CMTime)end;

/**
 根据开始时间和结束时间初始化时间范围。
 当开始时间大于结束时间时为倒序读取模式
 
 @param start 开始时间
 @param duration 持续时间
 @return TuSDKMediaTimeRange
 @since      v3.0
 */
- (instancetype)initWithStart:(CMTime)start duration:(CMTime)duraiton;

/**
 开始时间
 @since      v3.0
 */
@property (nonatomic) CMTime start;

/**
 开始时间
 @since      v3.0
 */
@property (nonatomic) CMTime end;

/**
 持续时间
 @since      v3.0
 */
@property (nonatomic, readonly) CMTime duration;

/**
 CMTimeRange 值
 @since      v3.0
 */
@property (nonatomic, readonly) CMTimeRange cmTimeRange;

/**
 标识该时间区间是否为倒序
 @since      v3.0
 */
@property (nonatomic, readonly) BOOL isReverse;

/**
 标识该时间区间是否有效
 @since      v3.0
 */
@property (nonatomic, readonly) BOOL isValid;

@end
