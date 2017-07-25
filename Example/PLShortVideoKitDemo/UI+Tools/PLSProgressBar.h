//
//  PLSProgressBar.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/2/28.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    PLSProgressBarProgressStyleNormal,
    PLSProgressBarProgressStyleDelete,
} PLSProgressBarProgressStyle;

@interface PLSProgressBar : UIView

- (void)setLastProgressToStyle:(PLSProgressBarProgressStyle)style;
- (void)setLastProgressToWidth:(CGFloat)width;

- (void)deleteLastProgress;
- (void)addProgressView;

- (void)stopShining;
- (void)startShining;

@end

