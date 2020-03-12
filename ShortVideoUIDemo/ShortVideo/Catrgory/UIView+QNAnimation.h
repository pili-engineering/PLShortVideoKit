//
//  UIView+QNAnimation.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QNAnimation)

@property (nonatomic, assign) BOOL alphaShowAnimating;

- (void)alphaShowAnimation;

- (void)alphaHideAnimation;

// frame 动画
- (void)bottomShowAnimation;

// frame 动画
- (void)bottomHideAnimation;

// autoLayout 动画，update 为 YES 时会执行 layoutIfNeeded
- (void)autoLayoutBottomShow:(BOOL)update;

// autoLayout 动画，update 为 YES 时会执行 layoutIfNeeded
- (void)autoLayoutBottomHide:(BOOL)update;

- (void)scaleShowAnimation;

- (void)scaleHideAnimation;

@end

NS_ASSUME_NONNULL_END
