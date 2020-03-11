//
//  ParametersAdjustView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/28.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParameterAdjustItemView : UIView

@property (nonatomic, strong, readonly) UILabel *nameLabel;

@property (nonatomic, strong, readonly) UISlider *slider;

@property (nonatomic, strong, readonly) UILabel *valueLabel;

/**
 显示值偏移
 */
@property (nonatomic, assign) double displayValueOffset;

- (void)replaceSubView:(UIView *)targetView withView:(__kindof UIView *)replacementView;

- (void)updateValueText;

@end

// bread
typedef void(^ParametersAdjustViewConfigBlock)(NSUInteger index, ParameterAdjustItemView *itemView, void (^parameterItemConfig)(NSString *name, double percent));

typedef void(^ParametersValueChangeBlock)(NSUInteger index, double percent);

@interface ParametersAdjustView : UIView

@property (nonatomic, strong, readonly) NSArray<ParameterAdjustItemView *> *itemViews;

@property (nonatomic, assign, readonly) CGFloat contentHeight;

- (void)setupWithParameterCount:(NSInteger)parameterCount config:(ParametersAdjustViewConfigBlock)configHandler valueChange:(ParametersValueChangeBlock)valueChangeHandler;

@end
