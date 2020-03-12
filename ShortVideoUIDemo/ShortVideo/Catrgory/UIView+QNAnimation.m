//
//  UIView+QNAnimation.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "UIView+QNAnimation.h"
#import <objc/runtime.h>

@implementation UIView (QNAnimation)

@dynamic alphaShowAnimating;

static char alphaAnimationKey;

- (BOOL)alphaShowAnimating {
    return [(NSNumber *)objc_getAssociatedObject(self, &alphaAnimationKey) boolValue];
}

- (void)setAlphaShowAnimating:(BOOL)alphaShowAnimating {
    objc_setAssociatedObject(self, &alphaAnimationKey, @(alphaShowAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)alphaShowAnimation {
    self.hidden = NO;
    self.alphaShowAnimating = YES;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)alphaHideAnimation {
    self.alphaShowAnimating = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (!self.alphaShowAnimating) {
            self.hidden = YES;
        }
    }];
}

- (void)bottomShowAnimation {
    CGRect rc = self.frame;
    rc = CGRectMake(rc.origin.x, self.superview.bounds.size.height - rc.size.height, rc.size.width, rc.size.height);
    [UIView animateWithDuration:.3 animations:^{
        self.frame = rc;
    }];
}

- (void)bottomHideAnimation {
    CGRect rc = self.frame;
    rc = CGRectMake(rc.origin.x, self.superview.bounds.size.height, rc.size.width, rc.size.height);
    [UIView animateWithDuration:.3 animations:^{
        self.frame = rc;
    }];
}

- (void)autoLayoutBottomShow:(BOOL)update {
    
    CGRect rc = self.frame;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.superview);
        make.height.equalTo(rc.size.height);
    }];
    
    if (update) {
        [UIView animateWithDuration:.3 animations:^{
            [self.superview layoutIfNeeded];
        }];
    }
}

- (void)autoLayoutBottomHide:(BOOL)update {
    
    CGRect rc = self.frame;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.superview);
        make.height.equalTo(rc.size.height);
        make.top.equalTo(self.superview.mas_bottom);
    }];
    
    if (update) {
        [UIView animateWithDuration:.3 animations:^{
            [self.superview layoutIfNeeded];
        }];
    }
}

- (void)scaleShowAnimation {
    
    if (!self.hidden) return;
    
    self.hidden = NO;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:2.0];
    scaleAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration  = .3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue  = [NSNumber numberWithFloat:.5];
    opacityAnimation.toValue    = [NSNumber numberWithFloat:1];
    opacityAnimation.duration   = .3;
    
    [self.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
}

- (void)scaleHideAnimation {
    self.hidden = YES;
}

@end
