//
//  PLSPositionTransition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

@interface PLSPositionTransition : PLSTransition

/**
 @brief  起始位置，相对于PLSVideoSetting中设置的width、height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGPoint fromPoint;

/**
 @brief  结束位置, 相对于PLSVideoSetting中设置的width、height的偏移像素
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGPoint toPoint;

@end
