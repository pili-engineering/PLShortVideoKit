//
//  PLSDeleteButton.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/3.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PLSDeleteButtonStyleDelete,
    PLSDeleteButtonStyleNormal,
    PLSDeleteButtonStyleDisable,
} PLSDeleteButtonStyle;

@interface PLSDeleteButton : UIButton

@property (assign, nonatomic) PLSDeleteButtonStyle style;

- (void)setButtonStyle:(PLSDeleteButtonStyle)style;
+ (PLSDeleteButton *)getInstance;

@end
