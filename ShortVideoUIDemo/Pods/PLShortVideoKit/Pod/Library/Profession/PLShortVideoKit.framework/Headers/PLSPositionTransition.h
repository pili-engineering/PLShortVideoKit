//
//  PLSPositionTransition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

/*!
 @class PLSPositionTransition
 @brief 位置变化动画类
 
 @since      v1.10.0
 */
@interface PLSPositionTransition : PLSTransition

/*!
 @property fromPoint
 @brief  起始位置，相对于PLSVideoSetting中设置的width、height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGPoint fromPoint;

/*!
 @property toPoint
 @brief  结束位置, 相对于PLSVideoSetting中设置的width、height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGPoint toPoint;

@end
