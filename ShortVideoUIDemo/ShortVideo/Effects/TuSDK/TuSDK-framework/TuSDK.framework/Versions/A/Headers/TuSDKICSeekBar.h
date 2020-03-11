//
//  TuSDKICSeekBar.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/11.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TuSDKICSeekBar;

/**
 *  百分比控制条委托
 */
@protocol TuSDKICSeekBarDelegate <NSObject>
/**
 *  进度改变
 *
 *  @param seekbar  百分比控制条
 *  @param progress 进度百分比
 */
- (void)onTuSDKICSeekBar:(TuSDKICSeekBar *)seekbar changedProgress:(CGFloat)progress;
@end

/**
 *  百分比控制条
 */
@interface TuSDKICSeekBar : UIView

/**
 *  拖动按钮视图
 */
@property (nonatomic, readonly) UIView *dragView;

/**
 *  进度条
 */
@property (nonatomic, readonly) UIView *aboveView;

/**
 *  底部背景条
 */
@property (nonatomic, readonly) UIView *belowView;

/**
 *  百分比控制条委托
 */
@property (nonatomic, weak) id<TuSDKICSeekBarDelegate> delegate;

/**
 *  百分比
 */
@property (nonatomic) CGFloat progress;
@end
