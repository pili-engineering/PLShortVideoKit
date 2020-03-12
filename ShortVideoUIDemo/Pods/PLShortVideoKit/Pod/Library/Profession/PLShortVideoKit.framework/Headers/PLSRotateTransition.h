//
//  PLSRotateTransition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

/*!
 @class PLSRotateTransition
 @brief 旋转动画类
 
 @since      v1.10.0
 */
@interface PLSRotateTransition : PLSTransition

/*!
 @property fromAngle
 @brief 旋转起始角度(-2*M_PI ~ 2*M_PI)
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat fromAngle;


/*!
 @property toAngle
 @brief 旋转结束角度(-2*M_PI ~ 2*M_PI)
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat toAngle;

@end
