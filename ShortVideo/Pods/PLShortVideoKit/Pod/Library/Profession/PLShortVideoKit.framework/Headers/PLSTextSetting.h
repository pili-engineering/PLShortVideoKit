//
//  PLSTextSetting.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class PLSTextSetting
 @brief 转场动画文字设置
 
 @since      v1.10.0
 */
@interface PLSTextSetting : NSObject

/*!
 @property text
 @brief 内容
 
 @since      v1.10.0
 */
@property (nonatomic, copy) NSString *text;

/*!
 @property textFont
 @brief 文字字体
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIFont *textFont;

/*!
 @property textColor
 @brief 文字颜色
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIColor *textColor;

/*!
 @property textSize
 @brief 内容所占区域大小
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGSize textSize;

/*!
 @property startX
 @brief 文字所占区域的起始x位置，相对于PLSVideoSetting中设置的width的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat startX;

/*!
 @property startY
 @brief 文字所占区域的起始Y位置，相对于PLSVideoSetting中设置的height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat startY;

@end
