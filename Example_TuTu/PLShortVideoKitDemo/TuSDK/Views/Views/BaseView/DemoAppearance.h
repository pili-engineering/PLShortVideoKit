//
//  DemoAppearance.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/8/1.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 样式工具类
 */
@interface DemoAppearance : NSObject

/**
 配置默认阴影

 @param layer 配置层级视图
 */
+ (void)setupDefaultShadowOnLayer:(CALayer *)layer;
// bread
+ (void)setupDefaultShadowOnViews:(NSArray<UIView *> *)views;

@end
