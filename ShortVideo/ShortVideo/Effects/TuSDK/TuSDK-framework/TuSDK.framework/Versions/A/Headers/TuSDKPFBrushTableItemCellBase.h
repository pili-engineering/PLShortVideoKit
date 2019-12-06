//
//  TuSDKPFBrushTableItemCellBase.h
//  TuSDK
//
//  Created by Yanlin on 11/8/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFBrush.h"
#import "TuSDKICTableViewCell.h"


#pragma mark - TuSDKPFBrushTableItemCellInterface

/**
 *  笔刷元素视图接口
 */
@protocol TuSDKPFBrushTableItemCellInterface <NSObject>

/**
 *  数据对象
 */
@property (nonatomic, retain) TuSDKPFBrush *mode;

@end

#pragma mark - TuSDKPFBrushTableItemCellDelegate

@class TuSDKPFBrushTableItemCellBase;

/**
 *  笔刷视图基础类委托
 */
@protocol TuSDKPFBrushTableItemCellDelegate <NSObject>

/**
 *  删除笔刷
 *
 *  @param cell 笔刷视图
 */
- (void)onBrushCellRemove:(TuSDKPFBrushTableItemCellBase *)cell;
@end


#pragma mark - TuSDKPFBrushTableItemCellBase
/**
 *  笔刷元素视图基础类
 */
@interface TuSDKPFBrushTableItemCellBase : TuSDKICTableViewCell<TuSDKPFBrushTableItemCellInterface>

/**
 *  数据对象
 */
@property (nonatomic, retain) TuSDKPFBrush *mode;

/**
 *  图片视图
 */
@property (nonatomic, readonly) UIImageView *thumbView;

/**
 *  滤镜分组视图委托
 */
@property (nonatomic, weak) id<TuSDKPFBrushTableItemCellDelegate> delegate;

/**
 *  初始化视图 (空方法, 默认当使用+(id)initWithFrame:(CGRect)frame;初始化视图时调用)
 */
- (void)lsqInitView;

/**
 *  是否隐藏删除标识
 *
 *  @return 是否隐藏删除标识
 */
- (BOOL)canHiddenRemoveFlag;

/**
 *  笔刷
 *
 *  @param mode 笔刷元素
 */
- (void)handleTypeBrush:(TuSDKPFBrush *)mode;

/**
 *  在线笔刷
 *
 *  @param mode 笔刷元素
 */
- (void)handleTypeOnlie:(TuSDKPFBrush *)mode;

/**
 *  橡皮擦
 *
 *  @param mode 笔刷元素
 */
- (void)handleTypeEraser:(TuSDKPFBrush *)mode;

/**
 *  设置功能块视图
 *
 *  @param color 颜色
 *  @param icon  图标
 */
- (void)handleBlockView:(UIColor *)color icon:(NSString *)icon;
@end
