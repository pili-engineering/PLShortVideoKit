//
//  TuSDKPFTextView.h
//  TuSDK
//
//  Created by wen on 24/07/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFStickerResult.h"
#import "TuSDKPFTextLabel.h"

@class TuSDKPFTextItemView;
@class TuSDKPFTextView;
@protocol TuSDKPFTextItemViewInterface;


#pragma mark - TuSDKPFTextItemViewDelegate
/**
 *  贴纸元件视图委托
 */
@protocol TuSDKPFTextItemViewDelegate <NSObject>
/**
 *  贴纸元件关闭
 *
 *  @param view 贴纸元件视图
 */
- (void)onClosedTextItemView:(UIView<TuSDKPFTextItemViewInterface> *)view;

/**
 *  选中贴纸元件
 *
 *  @param view 贴纸元件视图
 */
- (void)onSelectedTextItemView:(UIView<TuSDKPFTextItemViewInterface> *)view;
@end



#pragma mark - TuSDKPFTextItemViewInterface
/**
 *  贴纸元件视图接口
 */
@protocol TuSDKPFTextItemViewInterface <NSObject>
/**
 *  贴纸元件视图委托
 */
@property (nonatomic, weak) id<TuSDKPFTextItemViewDelegate> delegate;

/**
 *  贴纸数据对象
 */
@property (nonatomic, retain) TuSDKPFSticker *textSticker;

/**
 *  边框宽度
 */
@property (nonatomic, assign) CGFloat textBorderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, retain) UIColor *textBorderColor;

/**
 *  文字颜色
 */
@property (nonatomic, retain) UIColor *textColor;

/**
 *  选中状态
 */
@property (nonatomic, assign) BOOL selected;

/**
 *  文字内容
 */
@property (nonatomic, strong) NSString *textString;

/**
 *  文字样式信息设置
 */
@property (nonatomic, strong) NSMutableParagraphStyle *textParaStyle;

/**
 *  是否显示下划线
 */
@property (nonatomic, assign) BOOL enableUnderline;

/**
 *  书写方向 参考 NSWritingDirectionAttributeName
 */
@property (nonatomic, strong) NSArray<NSNumber *> *writingDirection;

/**
 *  文字对齐方式
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**
 *  文字背景色
 */
@property (nonatomic, strong) UIColor *textBackgroudColor;

/**
 *  线条颜色
 */
@property (nonatomic, strong) UIColor *textStrokeColor;

/**
 *  文字边距 默认 （0，0，0，0）
 */
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

/**
 *  文字最大放大倍数 (相对于父视图) 默认 1.0
 */
@property (nonatomic, assign) CGFloat textMaxScale;

/**
 *  初始化字体信息
 *
 *  @param textFont 字体
 */
- (void)initWithTextFont:(UIFont *)textFont;

/**
 *  获取贴纸处理结果
 *
 *  @param regionRect 图片选区范围
 *
 *  @return 贴纸处理结果
 */
- (TuSDKPFStickerResult *)resultWithRegionRect:(CGRect)regionRect;

@end


#pragma mark - TuSDKPFTextItemView
/**
 *  贴纸元件视图
 */
@interface TuSDKPFTextItemView : UIView<TuSDKPFTextItemViewInterface>{
@protected
    // 图片视图
    TuSDKPFTextLabel *_textView;
    // 取消按钮
    UIButton *_cancelButton;
    // 旋转缩放按钮
    UIButton *_turnButton;
    // 宽度拉伸按钮
    UIButton *_stretchButton;

}
/**
 *  图片视图
 */
@property (nonatomic, readonly) UILabel *textView;
/**
 *  取消按钮
 */
@property (nonatomic, readonly) UIButton *cancelButton;
/**
 *  旋转缩放按钮
 */
@property (nonatomic, readonly) UIButton *turnButton;
/**
 *  宽度拉伸按钮
 */
@property (nonatomic, readonly) UIButton *stretchButton;

/**
 *  贴纸元件视图委托
 */
@property (nonatomic, weak) id<TuSDKPFTextItemViewDelegate> delegate;

/**
 *  最小缩小比例(默认: 0.5f <= mMinScale <= 1)
 */
@property (nonatomic, assign) CGFloat minScale;

/**
 *  边框宽度
 */
@property (nonatomic, assign) CGFloat textBorderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, retain) UIColor *textBorderColor;

/**
 *  文字颜色
 */
@property (nonatomic, retain) UIColor *textColor;

/**
 *  选中状态
 */
@property (nonatomic, assign) BOOL selected;

/**
 *  文字内容
 */
@property (nonatomic, strong) NSString *textString;

/**
 *  贴纸数据对象
 */
@property (nonatomic, retain) TuSDKPFSticker *textSticker;

/**
 *  文字样式信息设置
 */
@property (nonatomic, strong) NSMutableParagraphStyle *textParaStyle;

/**
 *  是否显示下划线
 */
@property (nonatomic, assign) BOOL enableUnderline;

/**
 *  书写方向 参考 NSWritingDirectionAttributeName
 */
@property (nonatomic, strong) NSArray<NSNumber *> *writingDirection;

/**
 *  文字对齐方式
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**
 *  文字背景色
 */
@property (nonatomic, strong) UIColor *textBackgroudColor;

/**
 *  线条颜色
 */
@property (nonatomic, strong) UIColor *textStrokeColor;

/**
 *  文字边距 默认 （0，0，0，0）
 */
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

/**
 *  文字最大放大倍数 (相对于父视图) 默认 1.0
 */
@property (nonatomic, assign) CGFloat textMaxScale;

/**
 *  初始化字体信息
 *
 *  @param textFont 字体
 */
- (void)initWithTextFont:(UIFont *)textFont;

/**
 *  重置文字视图边缘距离
 */
- (void)resetTextEdge;

/**
 *  获取贴纸处理结果
 *
 *  @param regionRect 图片选区范围
 *
 *  @return 贴纸处理结果
 */
- (TuSDKPFStickerResult *)resultWithRegionRect:(CGRect)regionRect;

@end

#pragma mark - TuSDKPFTextViewDelegate

@protocol TuSDKPFTextViewDelegate <NSObject>
@optional

/**
 点击已选中item 进行编辑
 */
- (void)clickToEnterEvent:(NSString *)originText itemCenter:(CGPoint)center;

/**
 切换选中的item
 */
- (void)switchSelectedItem:(NSString *)originText itemCenter:(CGPoint)center;

/**
 是否取消全部选中

 @return YES 允许取消
 */
- (BOOL)canCancelAllSelected;

/**
 删除选中的item
 */
- (void)deleteSelectedItem;

@end

#pragma mark - TuSDKPFTextView

@interface TuSDKPFTextView : UIView<TuSDKPFTextItemViewDelegate>

@property (nonatomic, weak) id<TuSDKPFTextViewDelegate> textDelegate;
/**
 *  初始化提示信息
 */
@property (nonatomic, retain) NSString *textString;
/**
 *  初始化文字样式信息设置
 */
@property (nonatomic, strong) NSMutableParagraphStyle *textParaStyle;
/**
 *  当前已使用贴纸总数
 */
@property (nonatomic, readonly) NSUInteger textCount;

/**
 *  边框宽度
 */
@property (nonatomic, assign) CGFloat textBorderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, retain) UIColor *textBorderColor;

/**
 *  文字边距 默认 （0，0，0，0）
 */
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

/**
 *  文字最大放大倍数 (相对于父视图) 默认 1.0
 */
@property (nonatomic, assign) CGFloat textMaxScale;


/**
 初始化方法

 @param frame View的frame
 @param textFont 字体
 @param textColor 字体颜色
 @return textView对象
 */
- (instancetype)initWithFrame:(CGRect)frame textFont:(UIFont *)textFont textColor:(UIColor *)textColor;

/**
 *  添加一个文字
 *
 *  @param sticker 文字元素
 */
- (void)appendText;

/**
 *  改变文字内容
 *
 *  @param text 文字内容
 */
- (void)changeText:(NSString *)text;

/**
 *  改变文字颜色
 *
 *  @param textColor 文字颜色
 */
- (void)changeTextColor:(UIColor *)textColor;

/**
 *  改变线条颜色
 *
 *  @param strokeColor 线条颜色
 */
- (void)changeStrokeColor:(UIColor *)strokeColor;

/**
 *  改变字体背景颜色
 *
 *  @param textBackgroudColor 字体背景颜色
 */
- (void)changeTextBackgroudColor:(UIColor *)textBackgroudColor;

/**
 *  改变书写方向 参考 NSWritingDirectionAttributeName
 *
 *  @param writingDirection 书写方向
 */
- (void)changeWritingDirection:(NSArray<NSNumber *> *)writingDirection;

/**
 *  改变文字对齐方式
 *
 *  @param textAlignment 对齐方式
 */
- (void)changeTextAlignment:(NSTextAlignment)textAlignment;

/**
 *  获取文字处理结果
 *
 *  @param regionRect 图片选区范围
 *
 *  @return 贴纸处理结果
 */
- (NSArray *)resultsWithRegionRect:(CGRect)regionRect;

/**
 是否已经选中某一个文字

 @return YES：已经选中
 */
- (BOOL)hasSelectedItem;

/**
 修改下划线状态
 */
- (void)toggleUnderline;

@end
