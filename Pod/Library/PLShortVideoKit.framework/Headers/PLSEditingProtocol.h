//
//  PLSEditingProtocol.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -- PLSPhotoEditDrawDelegate
@protocol PLSPhotoEditDrawDelegate <NSObject>
@optional
/**
 *  开始绘画
 
 @since      v1.7.0
 */
- (void)photoEditDrawBegan;

/**
 *  结束绘画
 
 @since      v1.7.0
 */
- (void)photoEditDrawEnded;
@end

#pragma mark -- PLSPhotoEditStickerDelegate
@protocol PLSPhotoEditStickerDelegate <NSObject>
@optional
/**
 *  点击贴图 isActive=YES 选中的情况下点击
 
 @since      v1.7.0
 */
- (void)photoEditStickerDidSelectViewIsActive:(BOOL)isActive;

@end

#pragma mark -- PLSEditingProtocol
@protocol PLSPhotoEditDelegate <PLSPhotoEditDrawDelegate, PLSPhotoEditStickerDelegate>

@end

#pragma mark -- PLSEditingProtocol
@class PLSText;
@protocol PLSEditingProtocol <NSObject>
/**
 *  代理
 
 @since      v1.7.0
 */
@property (nonatomic ,weak) id<PLSPhotoEditDelegate> editDelegate;

/**
 *  禁用其他功能
 
 @since      v1.7.0
 */
- (void)photoEditEnable:(BOOL)enable;

/** =====================数据===================== */
/**
 *  数据
 
 @since      v1.7.0
 */
@property (nonatomic, strong) NSDictionary *photoEditData;

/** =====================绘画功能================= */
/**
 *  启用涂鸦功能
 
 @since      v1.7.0
 */
@property (nonatomic, assign) BOOL drawEnable;

/**
 *  是否可撤销涂鸦
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) BOOL drawCanUndo;

/**
 *  撤销涂鸦
 
 @since      v1.7.0
 */
- (void)drawUndo;

/**
 *  设置涂鸦颜色
 
 @since      v1.7.0
 */
- (void)setDrawColor:(UIColor *)color;

/** =====================贴图功能================== */
/**
 *  取消激活贴图
 
 @since      v1.7.0
 */
- (void)stickerDeactivated;

/**
 *  激活选中的贴图
 
 @since      v1.7.0
 */
- (void)activeSelectStickerView;

/**
 *  删除选中贴图
 
 @since      v1.7.0
 */
- (void)removeSelectStickerView;

/**
 *  创建贴图
 
 @since      v1.7.0
 */
- (void)createStickerImage:(UIImage *)image;

/** =====================文字功能===================== */
/**
 *  获取选中贴图的内容
 
 @since      v1.7.0
 */
- (PLSText *)getSelectStickerText;

/**
 *  更改选中贴图内容
 
 @since      v1.7.0
 */
- (void)changeSelectStickerText:(PLSText *)text;

/**
 *  创建文字
 
 @since      v1.7.0
 */
- (void)createStickerText:(PLSText *)text;

@end
