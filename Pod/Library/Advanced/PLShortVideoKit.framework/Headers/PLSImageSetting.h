//
//  PLSImageSetting.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class PLSImageSetting
 @brief 转场动画图片设置
 
 @since      v1.10.0
 */
@interface PLSImageSetting : NSObject

/*!
 @property image
 @brief 图片实例
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIImage *image;

/*!
 @property imageSize
 @brief 图片所占区域大小
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGSize imageSize;

/*!
 @property startX
 @brief 图片所占区域的起始x位置，相对于PLSVideoSetting中设置的width的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat startX;

/*!
 @property startY
 @brief 图片所占区域的起始Y位置，相对于PLSVideoSetting中设置的height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat startY;

@end
