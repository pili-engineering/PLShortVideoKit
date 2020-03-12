//
//  PLSStickerView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/8/16.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLSStickerView;

@protocol PLSStickerViewDelegate <NSObject>

/**
 双击文字贴纸编辑文本

 @param stickerView 贴纸视图
 @param tapGestureRecognizer 双击手势
 */
- (void)stickerView:(PLSStickerView *_Nonnull)stickerView startTextEdit:(UITapGestureRecognizer *_Nonnull)tapGestureRecognizer;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 * 贴纸类型
 */
typedef NS_ENUM(NSInteger, StickerType){
    StickerType_Text,     // 文字
    StickerType_Image,    // 图片
    StickerType_Gif,      // GIF
};

/**
 * 操作icon 的位置
 */
typedef NS_ENUM(NSInteger, IconPosition){
    IconPosition_Left_Top,       // 左上
    IconPosition_Right_Top,      // 右上
    IconPosition_Left_Bottom,    // 左下
    IconPosition_Right_Bottom,   // 右下
};

/**
 * 文本对齐方式
 */
typedef NS_ENUM(NSInteger, TextAlignment){
    TextAlignment_Center,     // 居中
    TextAlignment_Left,       // 靠左
    TextAlignment_Right,      // 靠右
};

@interface PLSStickerView : UIImageView

@property (nonatomic, assign) id<PLSStickerViewDelegate> delegate;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) StickerType stickerType;

// 自定义边框参数
@property (nonatomic, assign) CGFloat layerWidth;
@property (nonatomic, assign) CGFloat layerCornerRadius;
@property (nonatomic, strong) UIColor *layerColor;

@property (nonatomic, strong) UIImage *layerImage;        // 边框图片

@property (nonatomic, assign) IconPosition closePosition; // 默认右上
@property (nonatomic, assign) IconPosition scalePosition; // 默认右下


// StickerType 为 StickerType_Image/StickerType_Gif 下可用
@property (nonatomic, strong) NSURL *stickerURL;
@property (nonatomic, assign) CGFloat layoutSpace; // 0.5 ~ 8
@property (nonatomic, strong, readonly) UIImage *stickerImage;

// StickerType 为 StickerType_Text 下可用
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, copy) NSString *textContent;
@property (nonatomic, assign) TextAlignment textAlignment; // 默认居中


// StickerType 为非 StickerType_Text 下的初始化方法
- (instancetype)initWithFrame:(CGRect)frame stickerType:(StickerType)type stickerURL:(NSURL *)stickerURL;

// StickerType 为 StickerType_Text 时的初始化方法
- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content font:(UIFont *)font color:(UIColor *)color;


/**
 设置缩放按钮图标以及大小

 @param image 显示图标
 @param selectedImage 选中图标
 @param size 大小
 */
- (void)setScaleImage:(UIImage *)image selectedImage:(UIImage *)selectedImage size:(CGSize)size;


/**
 设置缩放的最小值以及最大值

 @param minValue 可缩放到最小的值
 @param maxValue 可缩放到最大的值
 */
- (void)setScaleMinScaleValue:(CGFloat)minValue maxScaleValue:(CGFloat)maxValue;


/**
 设置关闭按钮图标以及大小

 @param image 显示图标
 @param selectedImage 选中图标
 @param size 大小
 */
- (void)setCloseImage:(UIImage *)image selectedImage:(UIImage *)selectedImage size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
