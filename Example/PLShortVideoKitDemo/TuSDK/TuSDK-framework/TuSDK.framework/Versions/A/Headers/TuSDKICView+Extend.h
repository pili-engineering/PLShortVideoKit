//
//  TuSDKICView+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/28.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UIView_Define
#define UIView_Define
/**
 *  系统字体
 *
 *  @param X 字号
 *
 *  @return font 返回字体对象
 */
#define lsqFontSize(X)                 [UIFont systemFontOfSize:X]

/**
 *  系统加粗字体
 *
 *  @param X 字号
 *
 *  @return font 返回字体对象
 */
#define lsqBoldFontSize(X)             [UIFont boldSystemFontOfSize:X]

/**
 *  系统颜色
 *
 *  @param r
 *  @param g
 *  @param b
 *  @param a
 *
 *  @return color 系统颜色
 */
#define lsqRGBA(r, g, b, a)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/**
 *  系统颜色
 *
 *  @param r
 *  @param g
 *  @param b
 *
 *  @return color
 */
#define lsqRGB(r, g, b)            lsqRGBA(r, g, b, 1)

/**
 *  定义获取语言
 *
 *  @param key     语言键名
 *  @param comment 注释
 *
 *  @return string 语言字符串
 */
#define LSQString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:comment table:@"TuSDK"]
#endif

#pragma mark - UIViewExtend
/**
 *  视图帮助类
 */
@interface UIView(UIViewExtend)
/**
 *  初始化视图快速方法
 *
 *  @param frame 坐标长宽
 *
 *  @return frame 视图
 */
+ (instancetype)initWithFrame:(CGRect)frame;

/**
 *  获取相对传入视图底部CGRect
 *
 *  @param view  传入视图
 *  @param space 底部距离
 *  @param size  视图大小
 *
 *  @return frame 相对传入视图底部CGRect
 */
+ (CGRect)lsqGetRectOnBottomWithView:(UIView *)view space:(CGFloat)space size:(CGSize)size;

/**
 *  初始化视图 (空方法, 默认当使用+(id)initWithFrame:(CGRect)frame;初始化视图时调用)
 */
- (void)lsqInitView;

/**
 *  设置放置在目标视图下面
 *
 *  @param target 目标视图
 *  @param space  距离
 */
- (void) lsqSetToBottomWithTarget:(UIView *)target space:(CGFloat)space;
/**
 *  设置长宽
 *
 *  @param size 长宽
 *
 *  @return size 视图对象
 */
- (id)lsqSetSize:(CGSize)size;

/**
 *  获取长宽
 *
 *  @return lsqGetSize 长宽
 */
- (CGSize)lsqGetSize;

/**
 *  获取像素长宽
 *
 *  @return lsqGetSize 长宽
 */
- (CGSize)lsqGetPixiesSize;

/**
 *  设置宽度
 *
 *  @param width 宽度
 *
 *  @return width 视图对象
 */
- (id)lsqSetSizeWidth:(CGFloat)width;

/**
 *  获取宽度
 *
 *  @return lsqGetSizeWidth 宽度
 */
- (CGFloat)lsqGetSizeWidth;

/**
 *  设置高度
 *
 *  @param height 高度
 *
 *  @return height 视图对象
 */
- (id)lsqSetSizeHeight:(CGFloat)height;

/**
 *  获取高度
 *
 *  @return lsqGetSizeHeight 高度
 */
- (CGFloat)lsqGetSizeHeight;

/**
 *  设置坐标
 *
 *  @param origin 坐标
 *
 *  @return origin 视图对象
 */
- (id)lsqSetOrigin:(CGPoint)origin;

/**
 *  获取坐标
 *
 *  @return lsqGetOrigin 坐标
 */
- (CGPoint)lsqGetOrigin;

/**
 *  设置x坐标
 *
 *  @param originX x坐标
 *
 *  @return originX 视图对象
 */
- (id)lsqSetOriginX:(CGFloat)originX;

/**
 *  获取x坐标
 *
 *  @return x 坐标
 */
- (CGFloat)lsqGetOriginX;

/**
 *  设置y坐标
 *
 *  @param originY y坐标
 *
 *  @return originY 视图对象
 */
- (id)lsqSetOriginY:(CGFloat)originY;

/**
 *  获取y坐标
 *
 *  @return y 坐标
 */
- (CGFloat)lsqGetOriginY;

/**
 *  获取右边X坐标
 *
 *  @return lsqGetRightX 右边X坐标
 */
- (CGFloat)lsqGetRightX;

/**
 *  获取下边Y坐标
 *
 *  @return lsqGetBottomY 下边Y坐标
 */
- (CGFloat)lsqGetBottomY;

/**
 *  获取右下角坐标
 *
 *  @return lsqGetRightBottomXY 右下角坐标
 */
- (CGPoint)lsqGetRightBottomXY;

/**
 *  获取目标相对于自己中心的X坐标
 *
 *  @param targetWidth 目标视图宽度
 *
 *  @return centerX 目标相对于自己中心的X坐标
 */
- (CGFloat)lsqGetCenterX:(float)targetWidth;

/**
 *  获取目标相对于自己中心的Y坐标
 *
 *  @param targetHeight 目标视图高度
 *
 *  @return centerYCenterY 目标相对于自己中心的Y坐标
 */
- (CGFloat)lsqGetCenterY:(float)targetHeight;

/**
 *  获取目标相对于自己中心的坐标
 *
 *  @param size 目标长宽
 *
 *  @return size 目标相对于自己中心的坐标
 */
- (CGPoint)lsqGetCenterWithSize:(CGSize)size;

/**
 *  删除所有子元素
 */
- (void)removeAllSubviews;

/**
 *  设置边框
 *
 *  @param width 边框宽度
 *  @param color 颜色
 */
- (void)lsqSetBorderWidth:(CGFloat)width color:(UIColor *)color;

/**
 *  设置圆角
 *
 *  @param radius 角度
 */
- (void)lsqSetCornerRadius:(CGFloat)radius;

/**
 *  旋转视图
 *
 *  @param degrees 角度
 */
- (void)rotationWithDegrees:(CGFloat)degrees;

/**
 *  旋转视图
 *
 *  @param angle 弧度
 */
- (void)rotationWithAngle:(CGFloat)angle;

/**
 *  将变形应用到视图
 *  防止使用变形后导致视图位置，大小错误 (视图变形后设置大小使用bounds, 位置使用: center)
 */
- (void)transformToView;

/**
 *  视图将要销毁
 */
- (void)viewWillDestory;

/**
 *  查找视图
 *
 *  @param tag 视图Tag
 *
 *  @return view 视图(没有找到返回nil)
 */
- (UIView *) findViewByTag:(NSInteger)tag;

/**
 *  查找视图, 是否查找子视图
 *
 *  @param tag       视图Tag
 *  @param needChild 是否查找子视图
 *
 *  @return view 视图(没有找到返回nil)
 */
- (UIView *) findViewByTag:(NSInteger)tag needChild:(BOOL)needChild;

/**
 *  将输入长宽按最大比例换为实际位置长宽
 *
 *  @param ratio 长宽比例
 *
 *  @return ratio 实际位置长宽  (contents scaled to fit with fixed aspect. remainder is transparent)
 */
- (CGRect)convertScaleAspectFitWithRatio:(float)ratio;

/**
 *  将输入长宽按最大比例换为实际位置长宽
 *
 *  @param size 长宽
 *
 *  @return size 实际位置长宽 (contents scaled to fit with fixed aspect. remainder is transparent)
 */
- (CGRect)convertScaleAspectFitWithSize:(CGSize)size;

/**
 *  将输入长宽按最大比例换为视图位置长宽
 *
 *  @param viewSize 视图位置
 *  @param size     长宽
 *
 *  @return size 实际位置长宽 (contents scaled to fit with fixed aspect. remainder is transparent)
 */
+ (CGRect)convertViewSize:(CGSize)viewSize scaleAspectFitWithSize:(CGSize)size;

/**
 *  将输入长宽按最小比例换为实际位置长宽
 *
 *  @param size 长宽
 *
 *  @return size 实际位置长宽 (contents scaled to fill with fixed aspect. some portion of content may be clipped.)
 */
- (CGRect)convertScaleAspectFillWithSize:(CGSize)size;

/**
 *  将输入长宽按最小比例换为视图位置长宽
 *
 *  @param viewSize 视图位置
 *  @param size     长宽
 *
 *  @return size 实际位置长宽 (contents scaled to fill with fixed aspect. some portion of content may be clipped.)
 */
+ (CGRect)convertViewSize:(CGSize)viewSize scaleAspectFillWithSize:(CGSize)size;
@end

#pragma mark - UILabelExtend
/**
 *  UILabel帮助类
 */
@interface UILabel(UILabelExtend)
/**
 *  初始化
 *
 *  @param frame    坐标长宽
 *  @param fontSize 文字大小(单位:PT)
 *  @param color    颜色
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor*)color;

/**
 *  初始化
 *
 *  @param frame    坐标长宽
 *  @param fontSize 文字大小(单位:PT)
 *  @param color    颜色
 *  @param aligment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor*)color aligment:(NSTextAlignment)aligment;

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *  @param font  字体
 *  @param color 颜色
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;

/**
 *  初始化
 *
 *  @param frame    坐标长宽
 *  @param font     字体
 *  @param color    颜色
 *  @param aligment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color aligment:(NSTextAlignment)aligment;

/**
 *  当设置文字时返回label大小
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 *
 *  @return label大小
 */
- (CGSize)getSizeWithSetText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置单行文本宽度  只设置宽度 高度保持不变
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setLineText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置多行文本
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setMultipleText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置文字，并直接设置尺寸
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置阴影
 *
 *  @param color  颜色
 *  @param offset 偏移 CGSizeMake(1, 1)
 */
- (void)shadowColor:(UIColor *)color offset:(CGSize)offset;

/**
 *  设置阴影 (默认偏移:CGSizeMake(1, 1))
 *
 *  @param color 颜色
 */
- (void)shadowColor:(UIColor *)color;

/**
 *  显示默认阴影 (默认偏移:CGSizeMake(1, 1), 默认颜色:[UIColor blackColor])
 */
- (void)shadowDefault;

/**
 *  获取最佳字体大小
 *
 *  @param font 字体
 *  @param size 希望的大小
 *
 *  @return size 最佳字体大小
 */
- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end

#pragma mark - UIImageViewExtend
/**
 *  UIImageView帮助类
 */
@interface UIImageView(UIImageViewExtend)
/**
 *  初始化图片
 *
 *  @param frame      坐标长宽
 *  @param imageNamed 图片名称
 *
 *  @return image 图片对象
 */
+ (instancetype)initWithFrame:(CGRect)frame imageNamed:(NSString *)imageNamed;
@end

#pragma mark - UIControl
/**
 *  UIControl帮助类
 */
@interface UIControl (UIControlExtend)
/**
 *  删除所有绑定事件
 */
- (void)removeAllTargets;
@end

#pragma mark - UIButtonExtend
/**
 *  按钮帮助类
 */
@interface UIButton(UIButtonExtend)
/**
 *  初始化
 *
 *  @param frame     坐标长宽
 *  @param imageName 图片名称
 *
 *  @return button 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName;

/**
 *  初始化
 *
 *  @param frame     坐标长宽
 *  @param imageName 背景图片名称
 *
 *  @return button 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame backgroundImageName:(NSString *)imageName;

/**
 *  初始化
 *
 *  @param frame     坐标长宽
 *  @param imageName 背景图片名称
 *  @param title     标题文字
 *  @param capInsets 图片拉伸区域
 *  @param font      字体
 *
 *  @return button 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame
            backgroundImageName:(NSString *)imageName
                          title:(NSString *)title
                      capInsets:(UIEdgeInsets)capInsets
                           font:(UIFont *)font;

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *  @param title 标题文字
 *  @param font  字体
 *  @param color 颜色
 *
 *  @return button 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame
                          title:(NSString *)title
                           font:(UIFont *)font
                          color:(UIColor *)color;

/**
 *  设置属性
 *
 *  @param title     标题文字
 *  @param imageName 背景图片名称
 *  @param capInsets 图片拉伸区域
 */
- (void)setTitle:(NSString *)title backgroundImageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets;

/**
 *  设置默认状态标题文字
 *
 *  @param title 标题文字
 */
- (void)setStateNormalTitle:(NSString *)title;

/**
 *  设置默认状态标题颜色
 *
 *  @param color 颜色
 */
- (void)setStateNormalTitleColor:(UIColor *)color;

/**
 *  设置默认状态标题阴影颜色
 *
 *  @param color 颜色
 */
- (void)setStateNormalTitleShadowColor:(UIColor *)color;

/**
 *  设置默认状态图片
 *
 *  @param image 图片
 */
- (void)setStateNormalImage:(UIImage *)image;

/**
 *  设置默认状态图片
 *
 *  @param name 图片名称
 */
- (void)setStateNormalImageName:(NSString *)name;

/**
 *  设置默认状态背景
 *
 *  @param image 背景图片
 */
- (void)setStateNormalBackgroundImage:(UIImage *)image;

/**
 *  设置默认状态背景图片名称
 *
 *  @param imageName 背景图片名称
 */
- (void)setStateNormalBackgroundImageName:(NSString *)imageName;

/**
 *  设置默认状态背景
 *
 *  @param imageName 背景图片名称
 *  @param capInsets 图片拉伸区域
 */
- (void)setStateNormalBackgroundImageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets;

/**
 *  设置默认状态标题属性
 *
 *  @param title 标题属性
 */
- (void)setStateNormalAttributedTitle:(NSAttributedString *)title;

/**
 *  设置默认状态图片背景色
 *
 *  @param color 背景色
 */
- (void)setStateNormalBackgroundImageColor:(UIColor *)color;

/**
 *  设置可以触发事件的背景色
 *
 *  @param imageColor 背景色
 *  @param state      事件状态
 */
- (void)setBackgroundImageColor:(UIColor *)imageColor forState:(UIControlState)state;

/**
 *  添加范围内点击事件
 *
 *  @param target 目标对象
 *  @param action 动作
 */
- (void)addTouchUpInsideTarget:(id)target action:(SEL)action;

/**
 *  垂直居中图片和标题
 *
 *  @param space 图片和标题间距
 */
- (void)centerImageAndTitle:(float)space;
@end

#pragma mark - UIScrollViewExtend
/**
 *  UIScrollView帮助类
 */
@interface UIScrollView(UIScrollViewExtend)
/**
 *  获取缩放后的中心点
 *
 *  @return getScaleCenter 中心点
 */
- (CGPoint)getScaleCenter;

/**
 *  是否正在动作
 *
 *  @return BOOL 是否正在动作
 */
- (BOOL)inActioning;
@end
