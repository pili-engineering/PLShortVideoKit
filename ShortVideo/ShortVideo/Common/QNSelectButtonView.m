//
//  QNSelectButtonView.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNSelectButtonView.h"

#define QN_KINDICATORHEIGHT 2.f

#define QN_BUTTON_BACKGROUNDCOLOR QN_RGBCOLOR_ALPHA(30, 30, 30, 0.8)
#define QN_SELECTED_COLOR QN_RGBCOLOR_ALPHA(60, 157, 191, 1)

@interface QNSelectButtonView ()
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, assign) CGFloat totalWidth;

@end

@implementation QNSelectButtonView

- (NSMutableArray *)totalTitleArray {
    if (_totalLabelArray == nil) {
        _totalLabelArray = [NSMutableArray array];
    }
    return _totalLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = QN_BUTTON_BACKGROUNDCOLOR;
        self.layer.cornerRadius = 6;
        self.totalWidth = frame.size.width;
        self.index = defaultIndex;
    }
    return self;
}

- (void)setStaticTitleArray:(NSArray *)staticTitleArray {
    _staticTitleArray = staticTitleArray;
    CGFloat scrollViewWith = _totalWidth;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelWidth = scrollViewWith/staticTitleArray.count;
    CGFloat labelHeight = self.frame.size.height - QN_KINDICATORHEIGHT;
    self.totalLabelArray = [NSMutableArray array];
    for (int i = 0; i < staticTitleArray.count; i++) {
        UILabel *staticLabel = [[UILabel alloc]init];
        staticLabel.userInteractionEnabled = YES;
        staticLabel.textAlignment = NSTextAlignmentCenter;
        staticLabel.text = staticTitleArray[i];
        staticLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12];

        staticLabel.tag = i+1;
        staticLabel.textColor = [UIColor whiteColor];
        
        staticLabel.highlightedTextColor = QN_SELECTED_COLOR;
        labelX = i * labelWidth;
        staticLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        [self.totalLabelArray addObject:staticLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(staticLabelClick:)];
        [staticLabel addGestureRecognizer:tap];
        
        if (i == self.index) {
            staticLabel.highlighted = YES;
            staticLabel.textColor = QN_SELECTED_COLOR;
            staticLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
            _selectedLabel = staticLabel;
        }
        [self addSubview:staticLabel];
    }
    
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = QN_SELECTED_COLOR;
    
    CGFloat XSpace = 0;
    XSpace = self.space + labelWidth * self.index;
    _indicatorView.frame = CGRectMake(XSpace, labelHeight - QN_KINDICATORHEIGHT * 2, labelWidth - self.space*2, QN_KINDICATORHEIGHT);
    [self addSubview:_indicatorView];
}

- (void)staticLabelClick:(UITapGestureRecognizer *)tap {
    UILabel *titleLabel = (UILabel *)tap.view;
    [self staticLabelSelectedColor:titleLabel];
    
    NSInteger index = titleLabel.tag - 1;
    if (self.rateDelegate != nil && [self.rateDelegate respondsToSelector:@selector(buttonView:didSelectedTitleIndex:)]) {
        [self.rateDelegate buttonView:self didSelectedTitleIndex:index];
        for (UILabel *titleLab in self.totalLabelArray) {
            if (titleLab.tag == index + 1) {
                [self staticLabelSelectedColor:titleLab];
            }
        }
    }
}

- (void)staticLabelSelectedColor:(UILabel *)titleLabel {
    _selectedLabel.highlighted = NO;
    _selectedLabel.textColor = [UIColor whiteColor];
    _selectedLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12];
    
    titleLabel.highlighted = YES;
    titleLabel.textColor = QN_SELECTED_COLOR;
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];

    _selectedLabel = titleLabel;
    
    __weak typeof(self)weakSelf = self;

    [UIView animateWithDuration:0.20 animations:^{
        CGFloat XSpace = 0;
        XSpace = weakSelf.space + weakSelf.totalWidth/weakSelf.staticTitleArray.count * (titleLabel.tag - 1);
        weakSelf.indicatorView.frame = CGRectMake(XSpace, weakSelf.frame.size.height - QN_KINDICATORHEIGHT * 3, weakSelf.totalWidth/weakSelf.staticTitleArray.count - weakSelf.space * 2, QN_KINDICATORHEIGHT);
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
