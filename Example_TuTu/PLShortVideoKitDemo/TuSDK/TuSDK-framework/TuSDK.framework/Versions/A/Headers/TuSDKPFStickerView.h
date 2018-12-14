//
//  TuSDKPFStickerView.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/4.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFStickerResult.h"

@class TuSDKPFStickerItemView;
@class TuSDKPFStickerView;
@protocol TuSDKPFStickerItemViewInterface;

/**
 *  贴纸元件视图委托
 */
@protocol TuSDKPFStickerItemViewDelegate <NSObject>
/**
 *  贴纸元件关闭
 *
 *  @param view 贴纸元件视图
 */
- (void)onClosedStickerItemView:(UIView<TuSDKPFStickerItemViewInterface> *)view;

/**
 *  选中贴纸元件
 *
 *  @param view 贴纸元件视图
 */
- (void)onSelectedStickerItemView:(UIView<TuSDKPFStickerItemViewInterface> *)view;
@end

/**
 *  贴纸元件视图接口
 */
@protocol TuSDKPFStickerItemViewInterface <NSObject>
/**
 *  贴纸元件视图委托
 */
@property (nonatomic, weak) id<TuSDKPFStickerItemViewDelegate> delegate;

/**
 *  贴纸数据对象
 */
@property (nonatomic, retain) TuSDKPFSticker *sticker;

/**
 *  边框宽度
 */
@property (nonatomic) CGFloat strokeWidth;

/**
 *  边框颜色
 */
@property (nonatomic, retain) UIColor *strokeColor;

/**
 *  选中状态
 */
@property (nonatomic) BOOL selected;

/**
 *  获取贴纸处理结果
 *
 *  @param regionRect 图片选区范围
 *
 *  @return 贴纸处理结果
 */
- (TuSDKPFStickerResult *)resultWithRegionRect:(CGRect)regionRect;
@end

#pragma mark - TuSDKPFStickerItemView
/**
 *  贴纸元件视图
 */
@interface TuSDKPFStickerItemView : UIView<TuSDKPFStickerItemViewInterface>{
    @protected
    // 图片视图
    UIImageView *_imageView;
    // 取消按钮
    UIButton *_cancelButton;
    // 旋转缩放按钮
    UIButton *_turnButton;
}
/**
 *  图片视图
 */
@property (nonatomic, readonly) UIImageView *imageView;
/**
 *  取消按钮
 */
@property (nonatomic, readonly) UIButton *cancelButton;
/**
 *  旋转缩放按钮
 */
@property (nonatomic, readonly) UIButton *turnButton;

/**
 *  贴纸元件视图委托
 */
@property (nonatomic, weak) id<TuSDKPFStickerItemViewDelegate> delegate;

/**
 *  最小缩小比例(默认: 0.5f <= mMinScale <= 1)
 */
@property (nonatomic) CGFloat minScale;

/**
 *  边框宽度
 */
@property (nonatomic) CGFloat strokeWidth;

/**
 *  边框颜色
 */
@property (nonatomic, retain) UIColor *strokeColor;

/**
 *  选中状态
 */
@property (nonatomic) BOOL selected;

/**
 *  贴纸数据对象
 */
@property (nonatomic, retain) TuSDKPFSticker *sticker;

/**
 *  重置图片视图边缘距离
 */
- (void)resetImageEdge;

/**
 *  获取贴纸处理结果
 *
 *  @param regionRect 图片选区范围
 *
 *  @return 贴纸处理结果
 */
- (TuSDKPFStickerResult *)resultWithRegionRect:(CGRect)regionRect;
@end

#pragma mark - TuSDKPFStickerView

/**
 *  贴纸视图委托
 */
@protocol TuSDKPFStickerViewDelegate <NSObject>
/**
 *  检查是否允许使用贴纸
 *
 *  @param view    贴纸视图
 *  @param sticker 贴纸数据
 *
 *  @return 是否允许使用贴纸
 */
- (BOOL)stickerView:(TuSDKPFStickerView *)view canAppend:(TuSDKPFSticker *)sticker;
@end

/**
 *  贴纸视图
 */
@interface TuSDKPFStickerView : UIView<TuSDKPFStickerItemViewDelegate>
/**
 *  贴纸视图委托
 */
@property (nonatomic, weak) id<TuSDKPFStickerViewDelegate> delegate;

/**
 *  当前已使用贴纸总数
 */
@property (nonatomic, readonly) NSUInteger stickerCount;

/**
 *  添加一个贴纸
 *
 *  @param sticker 贴纸元素
 */
- (void)appenSticker:(TuSDKPFSticker *)sticker;

/**
 *  添加贴纸
 *
 *  @param stickerImage 贴纸图片 (PNG格式)
 */
- (void)appendStickerImage:(UIImage *) stickerImage;


/**
 *  获取贴纸处理结果
 *
 *  @param regionRect 图片选区范围
 *
 *  @return 贴纸处理结果
 */
- (NSArray *)resultsWithRegionRect:(CGRect)regionRect;
@end
