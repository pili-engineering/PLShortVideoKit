//
//  PLSLoadAnimationView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/10/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSLoadAnimationView.h"

@implementation PLSLoadAnimationView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 79, 79)];
        self.scrollImageView.center = self.center;
        self.scrollImageView.image = [UIImage imageNamed:@"scroll_image"];
        [self addSubview:_scrollImageView];
        
        self.centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        self.centerLabel.center = self.scrollImageView.center;
        self.centerLabel.font = [UIFont systemFontOfSize:8];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_centerLabel];
        
        [self startScrollAnimation];
    }
    return self;
}

- (void)startScrollAnimation {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.2f;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = FLT_MAX;
    [self.scrollImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self .scrollImageView startAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
