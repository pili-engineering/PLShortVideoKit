//
//  TuSDKTSCATransition+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/3.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - TuSDKTSCControllerTrans
/**
 *  控制器转场动画
 */
@interface TuSDKTSCControllerTrans : NSObject
/**
 *  转入动画
 */
@property (nonatomic, retain) CAAnimation *inTran;
/**
 *  转出动画
 */
@property (nonatomic, retain) CAAnimation *outTran;

/**
 *  控制器转场动画
 *
 *  @param inTran  转入动画
 *  @param outTran 转出动画
 *
 *  @return 控制器转场动画
 */
+ (instancetype)initWithTnTran:(CAAnimation *)inTran outTran:(CAAnimation *)outTran;
@end

#pragma mark - TuSDKTSCATransitionExtend
/**
 *  场景切换动画
 */
@interface CATransition(TuSDKTSCATransitionExtend)

/**
 *  获取场景Push方式切换动画
 *
 *  @return 场景Push方式切换动画
 */
+ (TuSDKTSCControllerTrans *)lsqSencePushTrans;

/**
 *  获取场景淡入淡出动画
 *
 *  @return 场景淡入淡出动画
 */
+ (TuSDKTSCControllerTrans *)lsqSenceFadeTrans;
/**
 *  获取场景Push方式切换向左移动动画
 *
 *  @return 获取场景Push方式切换向左移动动画
 */
+(id)lsqSencePushIn;

/**
 *  获取场景Pop切换向右移动动画
 *
 *  @return 获取场景Pop切换向右移动动画
 */
+(id)lsqSencePushOut;

/**
 *  场景淡入淡出动画
 *
 *  @return 场景淡入淡出动画
 */
+(id)lsqSenceFade;

/**
 *  获取场景Push方式翻转动画
 *
 *  @return 获取场景Push方式翻转动画
 */
+(id)lsqSenceOglFlip;
@end