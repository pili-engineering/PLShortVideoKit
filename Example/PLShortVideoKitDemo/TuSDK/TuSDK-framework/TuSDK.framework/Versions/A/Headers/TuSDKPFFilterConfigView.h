//
//  TuSDKPFFilterConfigView.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/11.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKICSeekBar.h"
#import "TuSDKFilterWrap.h"
#import "TuSDKICSeekBar.h"

#pragma mark - TuSDKPFFilterSeekbar
@class TuSDKPFFilterSeekbar;
/**
 *  滤镜配置拖动栏委托
 */
@protocol TuSDKPFFilterSeekbarDelegate <NSObject>
/**
 *  配置数据改变
 *
 *  @param seekbar 滤镜配置拖动栏
 *  @param arg     滤镜参数
 */
- (void)onSeekbar:(TuSDKPFFilterSeekbar *)seekbar changedFilterArg:(TuSDKFilterArg *)arg;
@end

/**
 *  滤镜配置拖动栏
 */
@interface TuSDKPFFilterSeekbar : UIView<TuSDKICSeekBarDelegate>
/**
 *  滤镜配置拖动栏委托
 */
@property (nonatomic, weak) id<TuSDKPFFilterSeekbarDelegate> delegate;

/**
 *  百分比控制条
 */
@property (nonatomic, readonly) TuSDKICSeekBar *seekBar;

/**
 *  标题视图
 */
@property (nonatomic, readonly) UILabel *titleView;

/**
 *  计数视图
 */
@property (nonatomic, readonly) UILabel *numberView;

/**
 *  滤镜配置参数
 */
@property (nonatomic, retain) TuSDKFilterArg *filterArg;

/**
 *  重置参数
 */
- (void)reset;
@end

#pragma mark - TuSDKPFFilterConfigView
@class TuSDKPFFilterConfigView;

/**
 *  滤镜配置视图委托
 */
@protocol TuSDKPFFilterConfigViewDelegate <NSObject>
/**
 *  通知重新绘制
 *
 *  @param filterConfigView 滤镜配置视图
 */
- (void)onRequestRenderWithFilterConfigView:(TuSDKPFFilterConfigView *)filterConfigView;
@end

/**
 *  滤镜配置视图
 */
@interface TuSDKPFFilterConfigView : UIView<TuSDKPFFilterSeekbarDelegate>

/**
 *  滤镜配置视图委托
 */
@property (nonatomic, weak) id<TuSDKPFFilterConfigViewDelegate> delegate;

/**
 *  重置按钮
 */
@property (nonatomic, readonly) UIButton *resetButton;

/**
 *  显示状态按钮
 */
@property (nonatomic, readonly) UIButton *stateButton;

/**
 *  状态背景
 */
@property (nonatomic, readonly) UIView *stateBg;

/**
 *  配置包装
 */
@property (nonatomic, readonly) UIView *configWrap;

/**
 *  滤镜包装对象
 */
@property (nonatomic, retain) TuSDKFilterWrap *filterWrap;

/**
 *  设置隐藏为默认状态
 */
- (void)hiddenDefault;

/**
 *  创建滤镜配置拖动栏
 *
 *  @param top 顶部距离
 *
 *  @return 滤镜配置拖动栏
 */
- (TuSDKPFFilterSeekbar *)buildSeekbarWithTop:(CGFloat)top;
@end
