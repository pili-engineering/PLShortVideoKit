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
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
        
        _iconPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame)+2, CGRectGetMaxX(_iconImageView.bounds), 15)];
        _iconPromptLabel.textAlignment = 1;
        _iconPromptLabel.font = [UIFont systemFontOfSize:11];
        _iconPromptLabel.textColor = [UIColor whiteColor];
        [self addSubview:_iconPromptLabel];
        
    }
    return self;
}

@end
