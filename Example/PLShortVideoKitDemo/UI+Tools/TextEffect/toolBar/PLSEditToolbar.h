//
//  PLSEditToolbar.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PLSEditToolbarType) {
    /** 涂鸦 */
    PLSEditToolbarType_draw = 1 << 0,
    /** 贴图 */
    PLSEditToolbarType_sticker = 1 << 1,
    /** 文本 */
    PLSEditToolbarType_text = 1 << 2,
    /** 所有 */
    PLSEditToolbarType_All = ~0UL,
};

@protocol PLSEditToolbarDelegate;

@interface PLSEditToolbar : UIView

- (instancetype)initWithType:(PLSEditToolbarType)type;

@property (nonatomic, weak) id<PLSEditToolbarDelegate> delegate;

/** 当前激活主菜单 return -1 没有激活 */
- (NSUInteger)mainSelectAtIndex;

/** 允许撤销 */
- (void)setRevokeAtIndex:(NSUInteger)index;

/** 获取拾色器的颜色 */
- (NSArray <UIColor *>*)drawSliderColors;
- (UIColor *)drawSliderCurrentColor;
/** 设置绘画拾色器默认颜色 */
- (void)setDrawSliderColor:(UIColor *)color;
- (void)setDrawSliderColorAtIndex:(NSUInteger)index;

@end

@protocol PLSEditToolbarDelegate <NSObject>


/**
 主菜单点击事件

 @param editToolbar self
 @param index 坐标（第几个按钮）
 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar mainDidSelectAtIndex:(NSUInteger)index;
/** 二级菜单点击事件-撤销 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar subDidRevokeAtIndex:(NSUInteger)index;
/** 二级菜单点击事件-按钮 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar subDidSelectAtIndex:(NSIndexPath *)indexPath;
/** 撤销允许权限获取 */
- (BOOL)editToolbar:(PLSEditToolbar *)editToolbar canRevokeAtIndex:(NSUInteger)index;
/** 二级菜单滑动事件-绘画 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar drawColorDidChange:(UIColor *)color;
@end
