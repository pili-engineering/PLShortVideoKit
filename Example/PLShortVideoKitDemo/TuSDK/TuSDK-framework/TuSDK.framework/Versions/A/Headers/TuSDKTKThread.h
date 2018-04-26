//
//  TuSDKTKThread.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/6.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  快速线程开始方法
 *
 *  @return 方法执行结果
 */
typedef id (^TuSDKTKThreadStartBlock)();

/**
 *  快速线程结束方法
 *
 *  @param result 返回结果
 */
typedef void (^TuSDKTKThreadCompleteBlock)(id result);
/**
 *  快速线程方法
 */
@interface TuSDKTKThread : NSObject
/**
 *  创建快速线程方法
 *
 *  @param start     快速线程开始方法
 *  @param completed 快速线程结束方法
 *
 *  @return 快速线程方法
 */
+ (instancetype) initWithStart:(TuSDKTKThreadStartBlock)start completed:(TuSDKTKThreadCompleteBlock)completed;
@end
