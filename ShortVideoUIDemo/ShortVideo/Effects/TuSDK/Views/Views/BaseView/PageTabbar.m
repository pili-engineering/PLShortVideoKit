//
//  PageTabbar.m
//  PageSlider
//
//  Created by bqlin on 2018/7/9.
//  Copyright © 2018年 bqlin. All rights reserved.
//

#import "PageTabbar.h"

@interface PageTabbarItemView : UIView

@property (nonatomic, strong) UIView *contentView;
// bread
//- (void)selectingWithProgress:(double)progress;

+ (UILabel *)titleLabel;

@end

@implementation PageTabbarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
       // bread
        // for test
        //self.layer.borderWidth = 1;
    }
    return self;
}

- (void)layoutSubviews {
    CGSize contentSize = _contentView.intrinsicContentSize;
    _contentView.frame = (CGRect){CGPointZero, contentSize};
    _contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = CGSizeZero;
    if (_contentView) {
        contentSize = _contentView.intrinsicContentSize;
    }
    return contentSize;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.contentMode = UIViewContentModeCenter;
    [self addSubview:contentView];
}

+ (UILabel *)titleLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end


@interface PageTabbar ()

@property (nonatomic, strong) NSArray<PageTabbarItemView *> *itemViews;

@property (nonatomic, strong) UIView *trackerView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign, getter=isSwitching) BOOL switching;

@end

@implementation PageTabbar

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
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    _itemsSpacing = _itemWidth = -1;
    _trackerSize = CGSizeMake(48, 2);
    _itemSelectedColor = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    _itemNormalColor = [UIColor whiteColor];
    _itemTitleFont = [UIFont systemFontOfSize:15];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [_scrollView addSubview:_contentView];
    _trackerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_trackerView];
    _trackerView.backgroundColor = _itemSelectedColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_contentView addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    _scrollView.frame = self.bounds;
    
    const CGSize size = self.bounds.size;
    const NSInteger count = _itemViews.count;
    const CGFloat itemsSpacing = _itemsSpacing >= 0 ? _itemsSpacing : 0;
    CGFloat baseX = 0;
    CGFloat firstItemWith = 0;
    CGFloat lastItemWidth = 0;
    
    // 配置 itemView frame
    for (int i = 0; i < count; i++) {
        UIView *itemView = _itemViews[i];
        const CGFloat itemWidth = _itemWidth > 0 ? _itemWidth : itemView.intrinsicContentSize.width;
        itemView.frame = CGRectMake(baseX , 0, itemWidth, size.height);
        baseX += itemWidth + itemsSpacing;
        if (i == 0) {
            firstItemWith = itemWidth;
        }
        if (i == count - 1) {
            lastItemWidth = itemWidth;
        }
    }
    
    // 配置 contentSize
    CGFloat contentWith = baseX - itemsSpacing;
    const CGFloat trackerWidth = _trackerSize.width;
    CGFloat leftOffset = _itemsSpacing;
    CGFloat rightOffset = _itemsSpacing;
    if (trackerWidth > firstItemWith) {
        leftOffset = (trackerWidth - firstItemWith) / 2;
    }
    if (trackerWidth > lastItemWidth) {
        rightOffset = (trackerWidth - lastItemWidth) / 2;
    }
    _scrollView.contentSize = CGSizeMake(contentWith + leftOffset + rightOffset, size.height);
    _contentView.frame = CGRectMake(leftOffset, 0, contentWith, size.height);
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:{
            
        } break;
        case UIControlContentHorizontalAlignmentRight:{
            
        } break;
        case UIControlContentHorizontalAlignmentCenter:{
            if (contentWith < size.width) { // 居中内容
                _contentView.center = CGPointMake(size.width / 2, size.height / 2);
                _scrollView.contentSize = size;
            }
        } break;
        case UIControlContentHorizontalAlignmentFill:{
            
        } break;
        default:{} break;
    }
    
    // 配置 tracker
    CGFloat trackerCenterX = _itemViews[_selectedIndex].center.x;
    _trackerView.frame = CGRectMake(trackerCenterX - _trackerSize.width / 2, size.height - _trackerSize.height, _trackerSize.width, _trackerSize.height);
}

#pragma mark - property

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    for (PageTabbarItemView *itemView in _itemViews) {
        UILabel *label = (UILabel *)itemView.contentView;
        label.font = itemTitleFont;
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _itemSelectedColor = itemSelectedColor;
    _trackerView.backgroundColor = itemSelectedColor;
}

- (void)setItemTitles:(NSArray *)itemTitles {
    _itemTitles = itemTitles;
    NSMutableArray *itemViews = [NSMutableArray array];
    for (NSString *title in itemTitles) {
        PageTabbarItemView *itemView = [[PageTabbarItemView alloc] initWithFrame:CGRectZero];
        UILabel *titleLabel = [PageTabbarItemView titleLabel];
        [_contentView addSubview:itemView];
        [itemViews addObject:itemView];
        titleLabel.text = title;
        if ([itemTitles indexOfObject:title] == _selectedIndex) {
            titleLabel.textColor = _itemSelectedColor;
        } else {
            titleLabel.textColor = _itemNormalColor;
        }
        titleLabel.font = _itemTitleFont;
        itemView.contentView = titleLabel;
    }
    _itemViews = itemViews.copy;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (selectedIndex < 0 || selectedIndex >= _itemViews.count) return;
    if (_disableAnimation) animated = NO;
    
    NSInteger fromIndex = _selectedIndex;
    BOOL valueChanged = _selectedIndex != selectedIndex;
    if (!valueChanged) return;
    
    if ([self.delegate respondsToSelector:@selector(tabbar:canSwitchFromIndex:toIndex:)]) {
        BOOL canSwitch = [self.delegate tabbar:self canSwitchFromIndex:fromIndex toIndex:selectedIndex];
        if (!canSwitch) return;
    }
    
    UILabel *labelShouldDeselect = nil;
    UILabel *labelShouldSelect = nil;
    if ([_itemViews[_selectedIndex].contentView isKindOfClass:[UILabel class]]) {
        labelShouldDeselect = (UILabel *)_itemViews[_selectedIndex].contentView;
        labelShouldSelect = (UILabel *)_itemViews[selectedIndex].contentView;
    }
    
    _selectedIndex = selectedIndex;
    if (valueChanged) [self sendActionsForControlEvents:UIControlEventValueChanged];
    if ([self.delegate respondsToSelector:@selector(tabbar:didSwitchFromIndex:toIndex:)]) {
        [self.delegate tabbar:self didSwitchFromIndex:fromIndex toIndex:selectedIndex];
    }
    
    void (^animations)(void) = ^{
        labelShouldDeselect.textColor = self.itemNormalColor;
        labelShouldSelect.textColor = self.itemSelectedColor;
        
        self.trackerView.center = self.itemViews[selectedIndex].center;
        CGRect trackerFrame = self.trackerView.frame;
        trackerFrame.size = self.trackerSize;
        trackerFrame.origin.y = CGRectGetHeight(self.contentView.bounds) - self.trackerSize.height;
        self.trackerView.frame = trackerFrame;
        
        CGRect rectToShow = self.itemViews[selectedIndex].frame;
        if (CGRectGetWidth(rectToShow) < CGRectGetWidth(self.trackerView.bounds)) {
            rectToShow = [self.trackerView.superview convertRect:self.trackerView.frame toView:self.scrollView];
        }
        [self.scrollView scrollRectToVisible:rectToShow animated:YES];
    };
    if (animated) {
        _switching = YES;
        [UIView animateWithDuration:kPageSwitchAnimationDuration animations:animations completion:^(BOOL finished) {
            self.switching = NO;
        }];
    } else {
        animations();
    }
}

#pragma mark - action

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_switching) return;
    NSInteger selectedIndex = -1;
    CGPoint location = [sender locationInView:_contentView];
    if (!CGRectContainsPoint(_contentView.bounds, location)) return;
    for (int i = 0; i < _itemViews.count; i++) {
        PageTabbarItemView *itemView = _itemViews[i];
        if (CGRectContainsPoint(itemView.frame, location)) {
            selectedIndex = i;
        }
    }
    if (selectedIndex < 0) return;
    [self setSelectedIndex:selectedIndex animated:YES];
}

@end
