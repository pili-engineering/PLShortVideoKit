//
//  PLSScaleTransition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

/*!
 @class PLSScaleTransition
 @brief 缩放动画类
 
 @since      v1.10.0
 */
@interface PLSScaleTransition : PLSTransition

/*!
 @property fromScale
 @brief 放大或者缩小的起始值
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat fromScale;

/*!
 @property toScale
 @brief 放大或者缩小的结束值
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat toScale;



@end
