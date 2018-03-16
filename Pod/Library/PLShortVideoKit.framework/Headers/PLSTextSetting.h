//
//  PLSTextSetting.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLSTextSetting : NSObject

/**
 @brief 内容
 
 @since      v1.10.0
 */
@property (nonatomic, copy) NSString *text;

/**
 @brief 文字字体
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 @brief 文字颜色
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 @brief 内容所占区域大小
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGSize textSize;

/**
 @brief 文字所占区域的起始x位置，相对于PLSVideoSetting中设置的width的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat startX;

/**
 @brief 文字所占区域的起始Y位置，相对于PLSVideoSetting中设置的height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat startY;

@end
