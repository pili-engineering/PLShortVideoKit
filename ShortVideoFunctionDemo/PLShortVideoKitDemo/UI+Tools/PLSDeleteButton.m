//
//  PLSDeleteButton.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/3.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSDeleteButton.h"

#define DELETE_BTN_NORMAL_IAMGE @"delete.png"
#define DELETE_BTN_DELETE_IAMGE @"delete.png"
#define DELETE_BTN_DISABLE_IMAGE @"delete.png"

@interface PLSDeleteButton ()


@end

@implementation PLSDeleteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    [self setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:DELETE_BTN_DISABLE_IMAGE] forState:UIControlStateDisabled];
}

+ (PLSDeleteButton *)getInstance
{
    PLSDeleteButton *deleteButton = [[PLSDeleteButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    return deleteButton;
}

- (void)setButtonStyle:(PLSDeleteButtonStyle)style
{
    self.style = style;
    switch (style) {
        case PLSDeleteButtonStyleNormal:
        {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
        }
            break;
        case PLSDeleteButtonStyleDisable:
        {
            self.enabled = NO;
        }
            break;
        case PLSDeleteButtonStyleDelete:
        {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:DELETE_BTN_DELETE_IAMGE] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

@end
