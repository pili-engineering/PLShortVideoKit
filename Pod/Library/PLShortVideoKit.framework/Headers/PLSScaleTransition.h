//
//  PLSScaleTransition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

@interface PLSScaleTransition : PLSTransition

/**
 @brief 放大或者缩小的起始值
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat fromScale;

/**
 @brief 放大或者缩小的结束值
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat toScale;



@end
