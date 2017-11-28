//
//  PLSText.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLSText : NSObject

/**
 @brief 文字内容
 
 @since      v1.7.0
 */
@property (nonatomic, copy) NSString *text;

/**
 @brief 文字 font
 
 @since      v1.7.0
 */
@property (nonatomic, strong) UIFont *font;

/**
 @brief 文字颜色
 
 @since      v1.7.0
 */
@property (nonatomic, strong) UIColor *textColor;

@end
