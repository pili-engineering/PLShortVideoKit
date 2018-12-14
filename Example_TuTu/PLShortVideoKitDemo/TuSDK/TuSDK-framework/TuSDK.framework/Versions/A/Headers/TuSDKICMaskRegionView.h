//
//  TuSDKICMaskRegionView.h
//  TuSDK
//
//  Created by Clear Hu on 14/12/17.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - TuSDKICMaskRegionView
/**
 *  裁剪区域视图
 */
@interface TuSDKICMaskRegionView : UIView{
    // 选区信息
    CGRect _regionRect;
}

/**
 *  区域长宽比例
 */
@property (nonatomic) CGFloat regionRatio;

/**
 *  选区信息
 */
@property (nonatomic, readonly) CGRect regionRect;

/**
 *  边缘覆盖区域颜色 (默认:[UIColor clearColor])
 */
@property (nonatomic, retain) UIColor *edgeMaskColor;

/**
 *  边缘线颜色 (默认:[UIColor clearColor])
 */
@property (nonatomic, retain) UIColor *edgeSideColor;

/**
 *  边缘线宽度 (默认:0)
 */
@property (nonatomic) CGFloat edgeSideWidth;

/**
 *  更新布局
 */
- (void)needUpdateLayout;

/**
 *  改变范围比例 (使用动画)
 *
 *  @param regionRatio 范围比例
 *
 *  @return regionRatio 确定的选取方位
 */
- (CGRect)changeRegionRatio:(CGFloat)regionRatio;

@end
