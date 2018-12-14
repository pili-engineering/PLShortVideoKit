//
//  PLSLoadAnimationView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/10/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLSLoadAnimationView : UIView
@property (strong, nonatomic) UIImageView *scrollImageView;
@property (strong, nonatomic) UILabel *centerLabel;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)startScrollAnimation;

@end
