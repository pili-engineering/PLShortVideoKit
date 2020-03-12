//
//  QNTextPageControl.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/7/15.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNTextPageControl.h"

@interface QNTextPageControl ()

/**
 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 标题标签组
 */
@property (nonatomic, strong) NSArray<UILabel *> *titleLabels;

@end

@implementation QNTextPageControl

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    _titleSpacing = 20;
    _titleFont = [UIFont systemFontOfSize:14];
    _normalColor = [UIColor colorWithWhite:1 alpha:0.7];
    _selectedColor = [UIColor colorWithWhite:1 alpha:1];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    // 左滑、右滑手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHander:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHander:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGFloat bottomMargin = 5;
    CGFloat radius = 2;
    CGContextAddArc(context, CGRectGetMidX(rect), rect.size.height-bottomMargin-radius, radius, 0, M_PI*2, 0);
    CGContextDrawPath(context, kCGPathFill);
}

#pragma mark - layout

- (void)layoutSubviews {
    _contentView.center = CGPointMake(_contentView.center.x, CGRectGetMidY(self.bounds));
    [self updateLayoutWithTargetLabel:_titleLabels[_selectedIndex]];
}

/**
 创建富文本
 
 @param string 字符串
 @param font 字体
 @return 富文本
 */
- (NSAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attributes =
    @{
      NSFontAttributeName: font,
      NSForegroundColorAttributeName: _normalColor,
      NSFontAttributeName: _titleFont
      };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    return attributedString.copy;
}

/**
 更新目标标签位置
 
 @param label 目标标签
 */
- (void)updateLayoutWithTargetLabel:(UILabel *)label {
    CGRect targetRect = [_contentView convertRect:label.frame toView:self];
    CGFloat offsetX = self.center.x - CGRectGetMidX(targetRect);
    
    CGRect contentFrame = _contentView.frame;
    contentFrame.origin.x += offsetX;
    self.contentView.frame = contentFrame;
}

#pragma mark - property

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    NSMutableArray *titleLabels = [NSMutableArray array];
    
    NSMutableArray<NSAttributedString *> *texts = [NSMutableArray array];
    CGFloat textMaxHeight = 0;
    for (NSString *title in _titles) {
        NSAttributedString *text = [self attributedStringWithString:title font:_titleFont];
        if (text.size.height > textMaxHeight) textMaxHeight = text.size.height;
        [texts addObject:text];
    }
    
    CGFloat offsetX = 0;
    for (int i = 0; i < texts.count; i++) {
        NSAttributedString *text = texts[i];
        
        CGRect titleFrame = CGRectMake(offsetX + _titleSpacing/2, (textMaxHeight - text.size.height)/2, text.size.width, text.size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:titleFrame];
        [_contentView addSubview:label];
        [titleLabels addObject:label];
        label.attributedText = text;
        
        label.layer.shadowColor = [UIColor blackColor].CGColor;
        label.layer.shadowOffset = CGSizeMake(0, 0);
        label.layer.shadowRadius = ABS(1.0);
        label.layer.shadowOpacity = 0.6;
        
        offsetX += text.size.width + _titleSpacing;
        textMaxHeight = text.size.height;
        
        if (i == 0) {
            label.textColor = self.selectedColor;
        } else{
            label.textColor = self.normalColor;
        }
    }
    _contentView.frame = CGRectMake(0, 0, offsetX, textMaxHeight);
    _titleLabels = titleLabels;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (selectedIndex < 0 || selectedIndex >= _titleLabels.count) return;
    
    BOOL valueChange = _selectedIndex != selectedIndex;
    if (!valueChange) return;
    UILabel *labelShouldDeselect = _titleLabels[_selectedIndex];
    UILabel *labelShouldSelect = _titleLabels[selectedIndex];
    
    _selectedIndex = selectedIndex;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    void (^animationsHandler)(void) = ^{
        labelShouldDeselect.textColor = self.normalColor;
        labelShouldSelect.textColor = self.selectedColor;
        [self updateLayoutWithTargetLabel:labelShouldSelect];
    };
    if (animated) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:kAnimationDuration animations:animationsHandler completion:NULL];
    } else {
        animationsHandler();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textPageControl:didSelectedWithIndex:)]) {
        [self.delegate textPageControl:self didSelectedWithIndex:selectedIndex];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

#pragma mark - gesture recognizer

/**
 左滑、右滑手势事件
 
 @param swipe 滑动手势
 */
- (void)swipeHander:(UISwipeGestureRecognizer *)swipe {
    NSInteger targetIndex = self.selectedIndex;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        targetIndex += 1;
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        targetIndex -= 1;
    }
    if (targetIndex < 0 || targetIndex >= _titleLabels.count) return;
    [self setSelectedIndex:targetIndex animated:YES];
}

#pragma mark - touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (touches.count > 1) return;
    CGPoint location = [touches.anyObject locationInView:_contentView];
    [_titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(label.frame, location)) {
            [self setSelectedIndex:idx animated:YES];
            *stop = YES;
        }
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
