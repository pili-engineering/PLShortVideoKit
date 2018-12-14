//
//  TuSDKICGestureRecognizerView.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TuSDKICGestureRecognizerView;
@protocol TuSDKICGestureRecognizerViewInterface;

/**
 *  多类型手势类型
 */
typedef NS_ENUM(NSInteger, lsqGestureTouchType)
{
    /**
     * 触摸开始
     */
    lsqGestureTouchEnd,
    /**
     * 触摸结束
     */
    lsqGestureTouchBegin,
    /**
     * 平移动作
     */
    lsqGestureTouchTrans,
    /**
     * 旋转动作
     */
    lsqGestureTouchRotation,
    /**
     * 缩放动作
     */
    lsqGestureTouchScale,
};

#pragma mark - TuSDKICGestureRecognizerViewDelegate
/**
 *  多类型手势视图委托
 */
@protocol TuSDKICGestureRecognizerViewDelegate <NSObject>
/**
 *  触摸视图状态改变
 *
 *  @param touchView 触摸视图
 *  @param change    改变状态 0:完成 1:开始 2:动作
 */
- (void)gestureRecognizerView:(UIView<TuSDKICGestureRecognizerViewInterface> *)touchView
              stateChange:(lsqGestureTouchType)change;
@end

#pragma mark - TuSDKICGestureRecognizerViewInterface
/**
 *  多类型手势视图接口
 */
@protocol TuSDKICGestureRecognizerViewInterface <UIGestureRecognizerDelegate>
/**
 *  触摸视图委托
 */
@property (nonatomic, weak) id<TuSDKICGestureRecognizerViewDelegate> delegate;

/**
 *  旋转角度相对百分比
 */
@property (nonatomic, readonly) CGPoint pointPrecent;
/**
 *  旋转角度相对百分比
 */
@property (nonatomic, readonly) CGFloat degreePrecent;
/**
 *  缩放相对百分比
 */
@property (nonatomic, readonly) CGFloat scalePrecent;
/**
 *  重置参数
 */
- (void)reset;
@end

#pragma mark - TuSDKICGestureRecognizerView
/**
 *  多类型手势视图
 */
@interface TuSDKICGestureRecognizerView : UIView<TuSDKICGestureRecognizerViewInterface>
/**
 *  触摸视图委托
 */
@property (nonatomic, weak) id<TuSDKICGestureRecognizerViewDelegate> delegate;

/**
 *  旋转角度相对百分比
 */
@property (nonatomic, readonly) CGPoint pointPrecent;
/**
 *  旋转角度相对百分比
 */
@property (nonatomic, readonly) CGFloat degreePrecent;
/**
 *  缩放相对百分比
 */
@property (nonatomic, readonly) CGFloat scalePrecent;
/**
 *  重置参数
 */
- (void)reset;
@end
