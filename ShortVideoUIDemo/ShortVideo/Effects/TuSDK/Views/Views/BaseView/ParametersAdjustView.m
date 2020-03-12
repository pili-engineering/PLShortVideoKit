//
//  ParametersAdjustView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/28.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "ParametersAdjustView.h"
#import "CustomSlider.h"
#import "DemoAppearance.h"

static const CGFloat kItemHeight = 18;

static const CGFloat kItemNameWidth = 30;

static const CGFloat kItemValueWidth = 35;

static const CGFloat kItemLineSpacing = 11;

@interface ParameterAdjustItemView ()

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) CustomSlider *slider;

@property (nonatomic, strong) UILabel *valueLabel;
// bread
@property (nonatomic, copy) void (^valueChangeAction)(ParameterAdjustItemView *itemView, double percentValue);

@end

@implementation ParameterAdjustItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    // 参数名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_nameLabel];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [DemoAppearance setupDefaultShadowOnLayer:_nameLabel.layer];
    
    // 数值label
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_valueLabel];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.font = [UIFont systemFontOfSize:12];
    _valueLabel.textAlignment = NSTextAlignmentLeft;
    _valueLabel.adjustsFontSizeToFitWidth = YES;
    [DemoAppearance setupDefaultShadowOnLayer:_valueLabel.layer];
    
    // 滑动条
    _slider = [[CustomSlider alloc] initWithFrame:CGRectZero];
    [self addSubview:_slider];
    [DemoAppearance setupDefaultShadowOnLayer:_slider.layer];
    [_slider addTarget:self action:@selector(sliderValueChangeAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    _nameLabel.frame = CGRectMake(0, 0, kItemNameWidth, size.height);
    _valueLabel.frame = CGRectMake(size.width - kItemValueWidth, 0, kItemValueWidth, size.height);
    const CGFloat margin = 12;
    const CGFloat seekBarX = CGRectGetMaxX(_nameLabel.frame) + margin;
    _slider.frame = CGRectMake(seekBarX, 0, CGRectGetMinX(_valueLabel.frame) - margin - seekBarX, size.height);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.bounds.size.width, kItemHeight);
}

#pragma mark - public

- (void)replaceSubView:(UIView *)targetView withView:(__kindof UIView *)replacementView {
    [targetView removeFromSuperview];
    if (targetView == _slider) {
        _slider = replacementView;
    } else if (targetView == _nameLabel) {
        _nameLabel = replacementView;
    } else if (targetView == _valueLabel) {
        _valueLabel = replacementView;
    } else {
        return;
    }
    [self addSubview:replacementView];
    [self setNeedsLayout];
}

- (void)updateValueText {
    // 文字显示的范围是 0% ~ 100%
    double percentValue = (_slider.value - _slider.minimumValue) / (_slider.maximumValue - _slider.minimumValue) * 1.0;
    percentValue += _displayValueOffset;
    _valueLabel.text = [NSNumberFormatter localizedStringFromNumber:@(percentValue) numberStyle:NSNumberFormatterPercentStyle];
}

#pragma mark - action

- (void)sliderValueChangeAction:(CustomSlider *)slider {
    [self updateValueText];
    double value = slider.value;
    if (self.valueChangeAction) self.valueChangeAction(self, value);
}

@end


@interface ParametersAdjustView ()

@property (nonatomic, strong) NSArray<ParameterAdjustItemView *> *itemViews;
// bread
//@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation ParametersAdjustView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    CGFloat itemY = size.height - kItemHeight;
    for (NSInteger i = _itemViews.count - 1; i >= 0; i--) {
        ParameterAdjustItemView *itemView = _itemViews[i];
        itemView.frame = CGRectMake(0, itemY, size.width, kItemHeight);
        itemY -= kItemHeight + kItemLineSpacing;
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(-1, _contentHeight);
}

#pragma mark - property

- (void)setContentHeight:(CGFloat)contentHeight {
    _contentHeight = contentHeight;
    [self invalidateIntrinsicContentSize];
}

#pragma mark - public

- (void)setupWithParameterCount:(NSInteger)parameterCount config:(ParametersAdjustViewConfigBlock)configHandler valueChange:(ParametersValueChangeBlock)valueChangeHandler {
    NSMutableArray *itemViews = [NSMutableArray array];
    [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < parameterCount; i++) {
        if (!configHandler) continue;
        ParameterAdjustItemView *itemView = [[ParameterAdjustItemView alloc] initWithFrame:CGRectZero];
        configHandler(i, itemView, ^(NSString *parmName, double percentValue) {
            itemView.nameLabel.text = parmName;
            itemView.slider.value = percentValue;
            [itemView updateValueText];
            itemView.index = i;
            [itemViews addObject:itemView];
            [self addSubview:itemView];
            itemView.valueChangeAction = ^(ParameterAdjustItemView *itemView, double value) {
                if (valueChangeHandler) valueChangeHandler(itemView.index, value);
            };
        });
    }
    _itemViews = itemViews.copy;
    
    self.contentHeight = _itemViews.count * (kItemHeight + kItemLineSpacing) - kItemLineSpacing;
    [self setNeedsLayout];
}

@end
