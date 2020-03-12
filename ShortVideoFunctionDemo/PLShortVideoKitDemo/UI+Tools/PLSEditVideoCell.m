//
//  PLSEditVideoCell.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/20.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSEditVideoCell.h"

@implementation PLSEditVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 15)];
        _iconPromptLabel.textAlignment = NSTextAlignmentCenter;
        _iconPromptLabel.font = [UIFont systemFontOfSize:12];
        _iconPromptLabel.textColor = [UIColor whiteColor];
        [self addSubview:_iconPromptLabel];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 45, 45)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
    }
    return self;
}

- (void)setLabelFrame:(CGRect)labelFrame imageViewFrame:(CGRect)imageViewFrame {
    _iconPromptLabel.frame = labelFrame;
    _iconImageView.frame = imageViewFrame;
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
    _iconImageView.layer.masksToBounds = YES;
}

@end
