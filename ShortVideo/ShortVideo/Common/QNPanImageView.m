//
//  QNPanImageView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/22.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNPanImageView.h"

@implementation QNPanImageView

// 增大滑块的响应区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
