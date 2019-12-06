//
//  PageTabbar.h
//  PageSlider
//
//  Created by bqlin on 2018/7/9.
//  Copyright © 2018年 bqlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// 标签栏动画时长
static const double kPageSwitchAnimationDuration = 0.25;

@protocol PageTabbarDelegate;

/**
 页面切换标签栏
 */
@interface PageTabbar : UIControl

/**
 标签栏各项标题
 */
@property (nonatomic, strong) NSArray *itemTitles;

/**
 标签项字体
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 标签项宽度，默认 -1，设置 -1 则根据标签项内容自适应宽度
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 标签栏各项间的间隔
 */
@property (nonatomic, assign) CGFloat itemsSpacing;

/**
 标签项正常显示状态的颜色
 */
@property (nonatomic, strong) UIColor *itemNormalColor;

/**
 标签项选中状态的颜色
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;

/**
 标签栏标记游标尺寸
 */
@property (nonatomic, assign) CGSize trackerSize;

/**
 禁用动画
 */
@property (nonatomic, assign) BOOL disableAnimation;

/**
 选中索引，设置其值可更新 UI
 */
@property (nonatomic, assign) NSInteger selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

@property (nonatomic, weak) IBOutlet id<PageTabbarDelegate> delegate;

@end

@protocol PageTabbarDelegate <NSObject>
@optional

/**
 标签项选中回调

 @param tabbar 标签栏对象
 @param fromIndex 起始索引
 @param toIndex 目标索引
 */
- (void)tabbar:(PageTabbar *)tabbar didSwitchFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 起始的标签项是否可切换到目标标签项

 @param tabbar 标签栏对象
 @param fromIndex 起始索引
 @param toIndex 目标索引
 @return 是否可切换
 */
- (BOOL)tabbar:(PageTabbar *)tabbar canSwitchFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end
