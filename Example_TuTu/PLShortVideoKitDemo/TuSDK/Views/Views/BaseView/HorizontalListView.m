//
//  HorizontalListView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/28.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "HorizontalListView.h"

@interface HorizontalListView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<HorizontalListItemView *> *itemViews;

@end

@implementation HorizontalListView

+ (Class)listItemViewClass {
    return [HorizontalListItemView class];
}

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
    _itemViews = [NSMutableArray array];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    _selectedIndex = -1;
    
    _sideMargin = 16;
    _itemSize = CGSizeMake(60, 60);
    _itemSpacing = 10;
}


- (void)removeAllSubViews;
{
    [_itemViews removeAllObjects];
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    _scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat contentWidth = _sideMargin;
    for (int i = 0; i < _itemViews.count; i++) {
        HorizontalListItemView *itemView = _itemViews[i];
        if (_autoItemSize) {
            CGSize contentSize = itemView.intrinsicContentSize;
            itemView.frame = CGRectMake(contentWidth, (size.height - contentSize.height) / 2, contentSize.width, contentSize.height);
        } else {
            itemView.frame = CGRectMake(contentWidth, (size.height - _itemSize.width) / 2, _itemSize.width, _itemSize.height);
        }
        contentWidth += _itemSpacing + CGRectGetWidth(itemView.frame);
    }
    contentWidth = contentWidth - _itemSpacing + _sideMargin;
    _scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
}

#pragma mark - property

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollView.scrollEnabled = scrollEnabled;
}
- (BOOL)scrollEnabled {
    return _scrollView.scrollEnabled;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    BOOL valueChanged = _selectedIndex != selectedIndex;
    if (!valueChanged) return;
    
    // 清理状态
    HorizontalListItemView *itemViewShouldDeselect = [self itemViewAtIndex:_selectedIndex];
    itemViewShouldDeselect.selected = NO;
    
    // 应用状态
    HorizontalListItemView *itemViewShouldSelect = [self itemViewAtIndex:selectedIndex];
    itemViewShouldSelect.selected = YES;
    
    // 让选中项可见
    CGRect rectShouldVisible = CGRectInset(itemViewShouldSelect.frame, -_itemSpacing, 0);
    [_scrollView scrollRectToVisible:rectShouldVisible animated:YES];
    
    _selectedIndex = selectedIndex;
    // bread
    //[self itemViewDidTap:itemViewShouldSelect];
}

#pragma mark - public

- (void)addItemViewsWithCount:(NSInteger)itemCount config:(HorizontalListItemViewConfigBlock)configHandler {
    for (int i = 0; i < itemCount; i++) {
        HorizontalListItemView *itemView = [[[self.class listItemViewClass] alloc] initWithFrame:CGRectZero];
        if (configHandler) configHandler(self, i, itemView);
        itemView.delegate = self;
        [_scrollView addSubview:itemView];
        [_itemViews addObject:itemView];
    }
}

- (void)insertItemView:(HorizontalListItemView *)itemView atIndex:(NSInteger)index {
    itemView.delegate = self;
    [_itemViews insertObject:itemView atIndex:index];
    [_scrollView addSubview:itemView];
}

- (NSInteger)indexOfItemView:(HorizontalListItemView *)itemView {
    return [self.itemViews indexOfObject:itemView];
}

- (HorizontalListItemView *)itemViewAtIndex:(NSInteger)index {
    if (index < 0 || index >= _itemViews.count) return nil;
    return _itemViews[index];
}

#pragma mark - HorizontalListItemViewDelegate

- (void)itemViewDidTap:(HorizontalListItemView *)itemView {
    if (_disableAutoSelect) return;
    self.selectedIndex = [_itemViews indexOfObject:itemView];
}

// bread
- (void)itemViewDidTouchDown:(HorizontalListItemView *)itemView {}

- (void)itemViewDidTouchUp:(HorizontalListItemView *)itemView {}

@end
