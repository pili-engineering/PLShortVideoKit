//
//  PLSFadeTranstion.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

@interface PLSFadeTranstion : PLSTransition

/**
 @brief 起始透明度
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat fromOpacity;

/**
 @brief 结束透明度
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat toOpacity;

@end
