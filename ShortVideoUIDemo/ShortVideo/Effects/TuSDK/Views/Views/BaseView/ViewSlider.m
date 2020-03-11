//
//  ViewSlider.m
//  ControllerSlider
//
//  Created by bqlin on 2018/6/14.
//  Copyright © 2018年 bqlin. All rights reserved.
//

#import "ViewSlider.h"

static const CGFloat kMinPanOffset = 50;

static const NSTimeInterval kAnimationDuration = 0.25;


@interface ViewSlider ()

@property (nonatomic, assign) NSInteger fromIndex;

@property (nonatomic, assign) NSInteger toIndex;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGPoint panStartPoint;

@property (nonatomic, strong) UIView *fromView;

@property (nonatomic, strong) UIView *toView;

@property (nonatomic, assign, getter=isSwitching) BOOL switching;

@end


@implementation ViewSlider

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _fromIndex = -1;
    _toIndex = -1;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self addGestureRecognizer:_pan];
}

- (void)layoutSubviews {
    if (_switching) return;
    _fromView.frame = self.bounds;
}

#pragma mark - property

- (NSInteger)selectedIndex {
    return _fromIndex;
}
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex != _fromIndex) {
        [self switchToIndex:selectedIndex];
    }
}

- (void)setDisableSlide:(BOOL)disableSlide {
    _disableSlide = disableSlide;
    _pan.enabled = !disableSlide;
}

- (UIView *)currentView  {
    return _fromView;
}

#pragma mark - private

- (void)removeFromView {
    [_fromView removeFromSuperview];
    _fromView = nil;
    _fromIndex = -1;
}
- (void)removeToView {
    [_toView removeFromSuperview];
    _toView = nil;
    _toIndex = -1;
}

/**
 显示对应索引的视图

 @param index 视图索引
 */
- (void)showAtIndex:(NSInteger)index {
    if (_fromIndex == index) return;
    
    [self removeFromView];
    UIView *view = [self.dataSource viewSlider:self viewAtIndex:index];
    view.frame = self.bounds;
    [self insertSubview:view atIndex:0];
    _fromIndex = index;
    _fromView = view;
    
    if ([self.delegate respondsToSelector:@selector(viewSlider:didSwitchToIndex:)]) {
        [self.delegate viewSlider:self didSwitchToIndex:index];
    }
}

/**
 从上一个视图切换到对应索引的视图

 @param index 视图索引
 */
- (void)switchToIndex:(NSInteger)index {
    if (_fromIndex == index || _switching) return;
    if (!_fromView) {
        [self showAtIndex:index];
        return;
    }
    
    _switching = YES;
    UIView *toView = [self.dataSource viewSlider:self viewAtIndex:index];
    
    CGRect currentFrame = self.bounds;
    CGRect leftFrame = currentFrame;
    leftFrame.origin.x -= leftFrame.size.width;
    CGRect rightFrame = currentFrame;
    rightFrame.origin.x += rightFrame.size.width;
    
    CGRect startSwitchingFrame;
    CGRect endSwitchingFrame;
    if (index > _fromIndex) {
        startSwitchingFrame = rightFrame;
        endSwitchingFrame = leftFrame;
    } else {
        startSwitchingFrame = leftFrame;
        endSwitchingFrame = rightFrame;
    }
    
    [self insertSubview:toView atIndex:0];
    toView.frame = startSwitchingFrame;

    // bread
    //NSLog(@"toView - %@: \n%@ -> %@", toView, NSStringFromCGRect(startSwitchingFrame), NSStringFromCGRect(currentFrame));
    //NSLog(@"fromView - %@: \n%@ -> %@", fromView, NSStringFromCGRect(currentFrame), NSStringFromCGRect(endSwitchingFrame));
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.fromView.frame = endSwitchingFrame;
        toView.frame = currentFrame;
    } completion:^(BOOL finished) {
        self.switching = NO;
        [self removeFromView];

        self.fromIndex = index;
        self.fromView = toView;

        if ([self.delegate respondsToSelector:@selector(viewSlider:didSwitchToIndex:)]) {
            [self.delegate viewSlider:self didSwitchToIndex:index];
        }
    }];
}

- (void)switchingWithOffsetX:(CGFloat)offsetX {
    CGFloat x = 0;
    if (_toIndex < _fromIndex) {
        x = offsetX - CGRectGetWidth(self.bounds);
    } else if (_toIndex > _fromIndex) {
        x = offsetX + CGRectGetWidth(self.bounds);
    }
    
    CGRect fromFrame = self.bounds;
    fromFrame.origin.x = offsetX;
    _fromView.frame = fromFrame;
    
    if (_toIndex >= 0 && _toIndex < [self.dataSource numberOfViewsInSlider:self]) {
        CGRect toFrame = self.bounds;
        toFrame.origin.x = x;
        _toView.frame = toFrame;
    }
    
    if ([self.delegate respondsToSelector:@selector(viewSlider:switchingFromIndex:toIndex:progress:)]) {
        [self.delegate viewSlider:self switchingFromIndex:_fromIndex toIndex:_toIndex progress:fabs(offsetX)/CGRectGetWidth(self.bounds)];
    }
}

- (void)switchBackWithOffsetX:(CGFloat)offsetX {
    NSTimeInterval animationDuration = 0.3;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animationDuration animations:^{
        [self switchingWithOffsetX:0];
    } completion:^(BOOL finished) {
        if (self.toIndex >= 0 && self.toIndex < [self.dataSource numberOfViewsInSlider:self] && self.toIndex != self.fromIndex) {
            [self removeToView];
        }
        if ([self.delegate respondsToSelector:@selector(viewSlider:didSwitchBackIndex:)]) {
            [self.delegate viewSlider:self didSwitchBackIndex:self.fromIndex];
        }
    }];
}

#pragma mark - pan recognizer

/**
 实现手势滑动切换控制器

 @param pan 手势
 */
- (void)panHandler:(UIPanGestureRecognizer *)pan {
    if (_fromIndex < 0) return;

    CGPoint point = [pan translationInView:self];

    if (pan.state == UIGestureRecognizerStateBegan) {
        _panStartPoint = point;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        NSInteger toIndex = -1;
        CGFloat offsetX = point.x - _panStartPoint.x;

        if (offsetX > 0) {
            toIndex = _fromIndex-1;
        } else if (offsetX < 0) {
            toIndex = _fromIndex + 1;
        }

        if (toIndex != _toIndex) {
            if (_toView) [self removeToView];
        }

        // 超出范围
        if (toIndex < 0 || toIndex >= [self.dataSource numberOfViewsInSlider:self]) {
            _toIndex = toIndex;
            [self switchingWithOffsetX:offsetX/2.0];
            return;
        }

        if (toIndex != _toIndex) {
            _toView = [self.dataSource viewSlider:self viewAtIndex:toIndex];
            [self insertSubview:_toView atIndex:0];

            _toIndex = toIndex;
        }
        [self switchingWithOffsetX:offsetX];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat offsetX = point.x - _panStartPoint.x;
        CGFloat width = CGRectGetWidth(self.bounds);
        if (_toIndex >= 0 && _toIndex < [self.dataSource numberOfViewsInSlider:self] && _toIndex != _fromIndex && fabs(offsetX) > kMinPanOffset) {
            NSTimeInterval animationDuration = fabs(width - fabs(offsetX)) / width * kAnimationDuration;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView animateWithDuration:animationDuration animations:^{
                [self switchingWithOffsetX:offsetX > 0 ? width : -width];
            } completion:^(BOOL finished) {
                [self removeFromView];
                self.fromIndex = self.toIndex;
                self.fromView = self.toView;
                self.toView = nil;
                self.toIndex = -1;

                if ([self.delegate respondsToSelector:@selector(viewSlider:didSwitchToIndex:)]) {
                    [self.delegate viewSlider:self didSwitchToIndex:self.fromIndex];
                }
            }];
        } else {
            [self switchBackWithOffsetX:offsetX];
        }
    }
}

@end
