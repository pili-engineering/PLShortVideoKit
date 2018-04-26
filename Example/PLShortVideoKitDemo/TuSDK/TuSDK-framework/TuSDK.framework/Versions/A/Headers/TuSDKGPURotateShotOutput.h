//
//  TuSDKGPURotateShotOutput.h
//  TuSDK
//
//  Created by Clear Hu on 2018/1/11.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"

@class TuSDKGPURotateShotOutput;

#pragma mark - TuSDKGPURotateShotOutputDelegate
/** 同步截取屏幕协议 */
@protocol TuSDKGPURotateShotOutputDelegate <NSObject>
/**
 * 帧渲染完成
 *
 * @param output
 *            异步线程输出 (适用于实时获取视频)
 * @return 是否继续渲染
 */
- (BOOL)onFrameRendered:(TuSDKGPURotateShotOutput *)output;
@end

/**
 旋转截屏
 用于目标检测旋转追踪数据获取
 */
@interface TuSDKGPURotateShotOutput : TuSDKFilter
/** 同步截取屏幕协议 */
@property (nonatomic, assign) id<TuSDKGPURotateShotOutputDelegate> shotDelegate;
/** 设备角度 */
@property (nonatomic) CGFloat deviceAngle;
/** 设备弧度 */
@property (nonatomic) CGFloat deviceRadian;
/** 准备渲染 只能在委托回调中执行*/
- (void)rendered;

//- (UIImage *)renderedImage;
@end
