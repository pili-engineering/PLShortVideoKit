//
//  StickerCategoryPageView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StickerCategoryPageView, StickerCollectionCell;

@protocol StickerCategoryPageViewDataSource <NSObject>

/**
 当前分类页面的贴纸个数

 @param pageView 贴纸分类展示视图
 @return 当前分类页面贴纸个数
 */
- (NSInteger)numberOfItemsInCategoryPageView:(StickerCategoryPageView *)pageView;

/**
 配置当前分类下每个贴纸单元格

 @param pageView 贴纸分类展示视图
 @param cell 贴纸按钮
 @param index 按钮索引
 */
- (void)stickerCategoryPageView:(StickerCategoryPageView *)pageView setupStickerCollectionCell:(StickerCollectionCell *)cell atIndex:(NSInteger)index;

@end

@protocol StickerCategoryPageViewDelegate <NSObject>
@optional

/**
 贴纸单元格单击选中回调

 @param pageView 贴纸分类展示视图
 @param cell 贴纸按钮
 @param index 按钮索引
 */
- (void)stickerCategoryPageView:(StickerCategoryPageView *)pageView didSelectCell:(StickerCollectionCell *)cell atIndex:(NSInteger)index;

/**
 贴纸单元格点击删除按钮

 @param pageView 贴纸分类展示视图
 @param index 按钮索引
 */
- (void)stickerCategoryPageView:(StickerCategoryPageView *)pageView didTapDeleteButtonAtIndex:(NSInteger)index;

@end

/**
 贴纸单元格
 */
@interface StickerCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *thumbnailView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong, readonly) UIImageView *downloadIconView;
@property (nonatomic, strong, readonly) UIButton *deleteButton;

@property (nonatomic, assign) BOOL online;

- (void)startLoading;
- (void)finishLoading;

@end

/**
 贴纸每个分类的页面视图
 */
@interface StickerCategoryPageView : UIView <UICollectionViewDataSource>

@property (nonatomic, strong, readonly) UICollectionView *stickerCollectionView;

@property (nonatomic, weak) id<StickerCategoryPageViewDataSource> dataSource;
@property (nonatomic, weak) id<StickerCategoryPageViewDelegate> delegate;

/**
 选中索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 当前页面索引
 */
@property (nonatomic, assign) NSInteger pageIndex;

- (void)dismissDeleteButtons;
- (void)deselect;

@end
