//
//  PLSFadeTranstion.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransition.h"

/*!
 @class PLSFadeTranstion
 @brief 渐隐渐现动画类
 
 @since      v1.10.0
 */
@interface PLSFadeTranstion : PLSTransition

/*!
 @property fromOpacity
 @brief 起始透明度
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat fromOpacity;

/*!
 @property toOpacity
 @brief 结束透明度
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGFloat toOpacity;

@end
