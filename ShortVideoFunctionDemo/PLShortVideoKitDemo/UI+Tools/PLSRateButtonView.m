//
//  PLSRateButtonView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/8/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSRateButtonView.h"

#define KINDICATORHEIGHT 2.f

#define COLOR_RGB(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define BUTTON_BACKGROUNDCOLOR COLOR_RGB(30, 30, 30, 0.8)
#define SELECTED_COLOR COLOR_RGB(60, 157, 191, 1)

@interface PLSRateButtonView ()
//@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, assign) CGFloat totalWidth;


@end

@implementation PLSRateButtonView

- (NSMutableArray *)totalTitleArray
{
    if (_totalLabelArray == nil) {
        _totalLabelArray = [NSMutableArray array];
    }
    return _totalLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BUTTON_BACKGROUNDCOLOR;
//        self.showsHorizontalScrollIndicator = NO;
//        self.bounces = NO;
        self.layer.cornerRadius = 6;
        self.totalWidth = frame.size.width;
        self.index = defaultIndex;
    }
    return self;
}

- (void)setStaticTitleArray:(NSArray *)staticTitleArray
{
    _staticTitleArray = staticTitleArray;
    CGFloat scrollViewWith = _totalWidth;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelWidth = scrollViewWith/staticTitleArray.count;
    CGFloat labelHeight = self.frame.size.height - KINDICATORHEIGHT;
    self.totalLabelArray = [NSMutableArray array];
    for (int i = 0; i < staticTitleArray.count; i++) {
        UILabel *staticLabel = [[UILabel alloc]init];
        staticLabel.userInteractionEnabled = YES;
        staticLabel.textAlignment = NSTextAlignmentCenter;
        staticLabel.text = staticTitleArray[i];
        staticLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12];

        staticLabel.tag = i+1;
        staticLabel.textColor = [UIColor whiteColor];
        
        staticLabel.highlightedTextColor = SELECTED_COLOR;
        labelX = i * labelWidth;
        staticLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        [self.totalLabelArray addObject:staticLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(staticLabelClick:)];
        [staticLabel addGestureRecognizer:tap];
        
        if (i == self.index) {
            staticLabel.highlighted = YES;
            staticLabel.textColor = SELECTED_COLOR;
            staticLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
            _selectedLabel = staticLabel;
        }
        [self addSubview:staticLabel];
    }
    
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = SELECTED_COLOR;
    
    CGFloat XSpace = 0;
    XSpace = self.space + labelWidth * self.index;
    _indicatorView.frame = CGRectMake(XSpace, labelHeight - KINDICATORHEIGHT * 2, labelWidth - self.space*2, KINDICATORHEIGHT);
    [self addSubview:_indicatorView];
}

- (void)staticLabelClick:(UITapGestureRecognizer *)tap
{
    UILabel *titleLabel = (UILabel *)tap.view;
    [self staticLabelSelectedColor:titleLabel];
    
    NSInteger index = titleLabel.tag - 1;
    if (self.rateDelegate != nil && [self.rateDelegate respondsToSelector:@selector(rateButtonView:didSelectedTitleIndex:)]) {
        [self.rateDelegate rateButtonView:self didSelectedTitleIndex:index];
        for (UILabel *titleLab in self.totalLabelArray) {
            if (titleLab.tag == index + 1) {
                [self staticLabelSelectedColor:titleLab];
            }
        }
    }
}

- (void)staticLabelSelectedColor:(UILabel *)titleLabel
{
    _selectedLabel.highlighted = NO;
    _selectedLabel.textColor = [UIColor whiteColor];
    _selectedLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12];
    
    titleLabel.highlighted = YES;
    titleLabel.textColor = SELECTED_COLOR;
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];

    _selectedLabel = titleLabel;
    [UIView animateWithDuration:0.20 animations:^{
        CGFloat XSpace = 0;
        XSpace = self.space + _totalWidth/_staticTitleArray.count * (titleLabel.tag - 1);
        _indicatorView.frame = CGRectMake(XSpace, self.frame.size.height - KINDICATORHEIGHT * 3, _totalWidth/_staticTitleArray.count - self.space*2, KINDICATORHEIGHT);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
