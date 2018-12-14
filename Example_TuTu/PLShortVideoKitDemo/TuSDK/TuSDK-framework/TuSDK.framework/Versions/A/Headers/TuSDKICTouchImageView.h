//
//  TuSDKICTouchImageView.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/5.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKICMaskRegionView.h"

/**
 *  图片方向改变
 */
typedef NS_ENUM(NSInteger, lsqImageChange)
{
    /**
     *  未知方向
     */
    lsqImageChangeUnknow                = 0,
    /**
     *  向左旋转
     */
    lsqImageChangeTurnLeft              = 1 << 0,
    /**
     *  向右旋转
     */
    lsqImageChangeTurnRight             = 1 << 1,
    /**
     *  水平镜像
     */
    lsqImageChangeMirrorHorizontal      = 1 << 2,
    /**
     *  垂直镜像
     */
    lsqImageChangeMirrorVertical        = 1 << 3
};

@class TuSDKICTouchImageView;
@protocol TuSDKICTouchImageViewInterface;

/**
 *  图片编辑视图 (旋转，缩放)委托
 */
@protocol TuSDKICTouchImageViewDelegate <NSObject>
/**
 *  动画状态改变
 *
 *  @param view      图片编辑视图 (旋转，缩放)
 *  @param inAniming 动画是否正在进行
 */
- (void)onTuSDKICTouchImageView:(UIView<TuSDKICTouchImageViewInterface> *)view inAniming:(BOOL)inAniming;
@end

/**
 *  图片编辑视图接口
 */
@protocol TuSDKICTouchImageViewInterface <NSObject>
/**
 *  图片编辑视图 (旋转，缩放)委托
 */
@property (nonatomic, weak) id<TuSDKICTouchImageViewDelegate> delegate;

/**
 *  图片视图
 */
@property (nonatomic, readonly) UIImageView *imageView;

/**
 *  是否正在处理动画
 */
@property (nonatomic, readonly) BOOL isInAniming;

/**
 *  区域长宽比例
 */
@property (nonatomic) CGFloat regionRatio;

/**
 *  图片方向
 */
@property (nonatomic, readonly) UIImageOrientation imageOrientation;

/**
 *  缩放倍数
 */
@property(nonatomic, readonly) CGFloat zoomScale;

/**
 *  更新布局
 */
- (void)needUpdateLayout;

/**
 *  设置图片
 *
 *  @param image           图片
 */
- (void)setImage:(UIImage *)image;

/**
 *  改变图片方向
 *
 *  @param changed 图片方向改变
 */
- (void)changeImage:(lsqImageChange)changed;

/**
 *  改变图片区域长宽比例
 *
 *  @param regionRatio 图片区域长宽比例
 */
- (void)changeRegionRatio:(CGFloat)regionRatio;

/**
 *  计算图片裁剪区域百分比
 *
 *  @return countImageCutRect 图片裁剪区域百分比
 */
- (CGRect)countImageCutRect;

/**
 *  是否正在动作
 *
 *  @return BOOL 是否正在动作
 */
- (BOOL)inActioning;

/**
 *  恢复图片缩放选区位置
 *
 *  @param zoomRect  缩放选区
 *  @param zoomScale 缩放倍数
 */
- (void)restoreWithZoomRect:(CGRect)zoomRect zoomScale:(CGFloat)zoomScale;
@end

/**
 *  图片编辑视图 (旋转，缩放)
 */
@interface TuSDKICTouchImageView : UIView<UIScrollViewDelegate, TuSDKICTouchImageViewInterface>{
@protected
    // 旋转和裁剪 裁剪区域视图
    TuSDKICMaskRegionView *_cutRegionView;
    // 包装视图
    UIScrollView *_wrapView;
    // 图片包装类 (处理缩放)
    UIView *_imageWrapView;
    // 图片视图  (处理旋转)
    UIImageView *_imageView;
    // 是否正在处理动画
    BOOL _isInAniming;
}
/**
 *  图片编辑视图 (旋转，缩放)委托
 */
@property (nonatomic, weak) id<TuSDKICTouchImageViewDelegate> delegate;

/**
 *  旋转和裁剪 裁剪区域视图
 */
@property (nonatomic, readonly) TuSDKICMaskRegionView *cutRegionView;
/**
 *  包装视图
 */
@property (nonatomic, readonly) UIScrollView *wrapView;

/**
 *  图片包装类 (处理缩放)
 */
@property (nonatomic, readonly) UIView *imageWrapView;

/**
 *  图片视图
 */
@property (nonatomic, readonly) UIImageView *imageView;

/**
 *  是否正在处理动画
 */
@property (nonatomic, readonly) BOOL isInAniming;

/**
 *  区域长宽比例
 */
@property (nonatomic) CGFloat regionRatio;

/**
 *  图片方向
 */
@property (nonatomic, readonly) UIImageOrientation imageOrientation;

/**
 *  缩放倍数
 */
@property(nonatomic, readonly) CGFloat zoomScale;
@end
