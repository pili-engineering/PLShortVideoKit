//
//  DemoAppearance.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/8/1.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "DemoAppearance.h"

@implementation DemoAppearance

// bread
+ (void)setShadowSize:(CGFloat)shadowSize onLayer:(CALayer *)layer {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = ABS(shadowSize);
    layer.shadowOpacity = 0.6;
}

+ (void)setupDefaultShadowOnLayer:(CALayer *)layer {
    [self setShadowSize:1.0 onLayer:layer];
}

+ (void)setupDefaultShadowOnViews:(NSArray<UIView *> *)views {
    for (UIView *view in views) {
        [self setShadowSize:1.0 onLayer:view.layer];
    }
}

@end
