//
//  TuSDKPFStickerBarViewBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFStickerCategory.h"
/**
 *  贴纸栏视图基础类
 */
@interface TuSDKPFStickerBarViewBase : UIView
/**
 *  初始化视图
 */
- (void)lsqInitView;

/**
 *  加载分类数据
 *
 *  @param categories 分类数据
 */
- (void)loadCatategories: (NSArray *)categories;

/**
 *  刷新分类贴纸数据
 */
- (void)refreshCateDatas;

/**
 *  创建分类按钮
 *
 *  @param cate  贴纸分类
 *  @param left  左边距离
 *  @param width 宽度
 *  @param index 索引
 *
 *  @return 分类按钮
 */
- (UIButton *)buildButtonWithCategory:(TuSDKPFStickerCategory *)cate left:(CGFloat)left width:(CGFloat)width index:(NSUInteger)index;

/**
 *  选中分类按钮
 *
 *  @param index 索引
 */
- (void)selectCateButtonWithIndex:(NSUInteger)index;

/**
 *  选中分类索引
 *
 *  @param index 索引
 */
- (void)selectCateWithIndex:(NSInteger)index;

/**
 *  当前分类对象
 *
 *  @return 当前分类对象
 */
- (TuSDKPFStickerCategory *)currentCategory;

/**
 *  获取分类中的所有贴纸数据
 *
 *  @param cateId 分类ID
 *
 *  @return 分类中的所有贴纸数据
 */
- (NSArray *)stickerDatasWithId:(uint64_t)cateId;

/**
 *  获取所有贴纸数据
 *
 *  @return 所有贴纸数据
 */
- (NSArray *)stickerAllDatas;
@end
