//
//  QNTextPageControl.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/7/15.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 动画时长
static const NSTimeInterval kAnimationDuration = 0.25;

@class QNTextPageControl;

@protocol QNTextPageControlDelegate <NSObject>

- (void)textPageControl:(QNTextPageControl *)textPageControl didSelectedWithIndex:(NSInteger)selectedIndex;

@end

/**
 页面切换控件
 */
@interface QNTextPageControl : UIControl

@property (nonatomic, assign) id <QNTextPageControlDelegate>delegate;

/**
 标题数组
 */
@property (nonatomic, strong) NSArray *titles;

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 常态颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 选中颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 标题间隔
 */
@property (nonatomic, assign) CGFloat titleSpacing;

/**
 选中索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;
@end

NS_ASSUME_NONNULL_END
