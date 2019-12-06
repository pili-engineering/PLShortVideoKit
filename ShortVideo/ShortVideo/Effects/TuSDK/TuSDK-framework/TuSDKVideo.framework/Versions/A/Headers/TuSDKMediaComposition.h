//
//  TuSDKMediaComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/4/24.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaCompositionSampleBuffer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 合成项
 @since v3.4.1
 */
@protocol TuSDKMediaComposition <NSObject>

@required
/**
 读取一帧 CMSampleBuffer 如果返回 NULL 读取结束
 
 @return CMSampleBuffer
 @since v3.4.1
 */
- (TuSDKMediaCompositionSampleBuffer *)readNextSampleBuffer;

/**
 目前输出持续时间
 
 @return 输出持续时间
 @since v3.4.1
 */
@property (nonatomic,readonly)CMTime outputTime;

/**
 合成物输出持续时间
 
 @return 输出持续时间
 @since v3.4.1
 */
@property (nonatomic,readonly)CMTime outputDuraiton;

/**
 基准时间 默认：kCMTimeZero
 
 @return 输出持续时间
 @since v3.4.1
 */
@property (nonatomic)CMTime baseTime;

/**
 当前是否输出完成
 
 @since v3.4.1
 */
@property (nonatomic)BOOL outputDone;

/**
 重置复位状态
 @since v3.4.1
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
