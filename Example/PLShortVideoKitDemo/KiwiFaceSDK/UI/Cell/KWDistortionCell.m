//
//  KWDistortionCell.m
//  KiwiFaceKitDemo
//
//  Created by jacoy on 17/1/12.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import "KWDistortionCell.h"

@implementation KWDistortionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor = [UIColor purpleColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(6 , 6, (CGRectGetWidth(self.frame)) - 10, CGRectGetWidth(self.frame) - 10)];
        //        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        //        [backView setImage:[UIImage imageNamed:@"yellowBorderBackground"]];
        //        [self.selectedBackgroundView addSubview:backView];
        
        UIImageView* selectedBGView = [[UIImageView alloc] initWithFrame:self.bounds];
        [selectedBGView setImage:[UIImage imageNamed:@"yellowBorderBackground"]];
        self.selectedBackgroundView = selectedBGView;
        
        [self.contentView addSubview:self.imgView];
        
        //        self.layer.shouldRasterize = YES;
    }
    return self;
}

@end
