//
//  HorizontalListView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/28.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalListItemView.h"

@class HorizontalListView;

typedef void(^HorizontalListItemViewConfigBlock)(HorizontalListView *listView, NSUInteger index, HorizontalListItemView *itemView);

@interface HorizontalListView : UIView <HorizontalListItemViewDelegate>

/**
 是否可滚动
 */
@property (nonatomic, assign) BOOL scrollEnabled;

/**
 左右缩进
 */
@property (nonatomic, assign) CGFloat sideMargin;

/**
 列表项尺寸
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 列表项自动尺寸，根据列表项的内容来计算宽高
 */
@property (nonatomic, assign) BOOL autoItemSize;

/**
 列表项间隔
 */
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL disableAutoSelect;

- (void)removeAllSubViews;

+ (Class)listItemViewClass;

- (void)commonInit;

- (void)insertItemView:(HorizontalListItemView *)itemView atIndex:(NSInteger)index;

- (void)addItemViewsWithCount:(NSInteger)itemCount config:(HorizontalListItemViewConfigBlock)configHandler;

- (NSInteger)indexOfItemView:(HorizontalListItemView *)itemView;

- (HorizontalListItemView *)itemViewAtIndex:(NSInteger)index;

#pragma mark - HorizontalListItemViewDelegate

- (void)itemViewDidTap:(HorizontalListItemView *)itemView;

- (void)itemViewDidTouchDown:(HorizontalListItemView *)itemView;

- (void)itemViewDidTouchUp:(HorizontalListItemView *)itemView;

@end
