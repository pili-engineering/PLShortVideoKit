//
//  QNVerticalButton.m
//  QNShortVideoDemo
//
//  Created by hxiongan on 2018/8/30.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QNVerticalButton.h"

@implementation QNVerticalButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchDown:) forControlEvents:(UIControlEventTouchDown)];
        [self addTarget:self action:@selector(touchUp:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];
    }
    return self;
}

- (void)touchDown:(id)button {
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
    } completion:nil];
}

- (void)touchUp:(id)button {
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rc = self.bounds;
    CGRect rcImg = self.imageView.frame;
    [self.titleLabel sizeToFit];
    CGRect rcLabel = self.titleLabel.frame;
    if (CGRectIsEmpty(rcLabel) || CGRectIsEmpty(rc) || CGRectIsEmpty(rcImg)) return;

    CGFloat edgeSpace = 5;
    CGFloat space = rc.size.height - rcImg.size.height - rcLabel.size.height - edgeSpace * 2;
    self.imageView.frame = CGRectMake((rc.size.width - rcImg.size.width)/2, edgeSpace, rcImg.size.width, rcImg.size.height);
    self.titleLabel.frame = CGRectMake((rc.size.width - rcLabel.size.width)/2, space + self.imageView.frame.origin.y + self.imageView.frame.size.height, rcLabel.size.width, rcLabel.size.height);
}

@end
