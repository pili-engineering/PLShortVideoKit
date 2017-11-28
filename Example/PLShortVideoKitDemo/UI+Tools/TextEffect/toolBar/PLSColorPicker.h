//
//  PLSColorPicker.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (isEqualToColor)

- (BOOL)isEqualToColor:(UIColor *)color;

@end


@class PLSColorPicker;

@protocol PLSColorPickerDelegate <NSObject>

@optional
- (void)colorPicker:(PLSColorPicker *)colorPicker didSelectColor:(UIColor *)color;

@end


@interface PLSColorPicker : UIView

/** 显示选择颜色，默认colors第一个颜色。(如果有colors有相同颜色，取顺序最先的) */
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) NSUInteger index;
/** 是否需要动画（默认开启） */
@property (assign, nonatomic) BOOL animation;
@property (nonatomic, setter=setMagnifierMaskImage:) UIImage *magnifierMaskImage;
/** 代理 */
@property (weak, nonatomic) id<PLSColorPickerDelegate>delegate;
/** 当前颜色 */
@property (copy, nonatomic) void(^pickColorEndBlock)(UIColor *color);
/** 数组颜色 */
@property (readonly, nonatomic) NSArray <UIColor *>*colors;
/**
 初始化方法
 
 @param frame frame
 @param colors 颜色集合
 @return PLSColorPicker
 */
- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray <UIColor *>*)colors;

@end
