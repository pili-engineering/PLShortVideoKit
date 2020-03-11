//
//  PLSRateScrollView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/8/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLSRateButtonView;
@protocol PLSRateButtonViewDelegate <NSObject>

- (void)rateButtonView:(PLSRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex;

@end

@interface PLSRateButtonView : UIView

@property (nonatomic, strong) NSArray *staticTitleArray;
@property (nonatomic, strong) NSArray *scrollTitleArr;

@property (nonatomic, strong) NSMutableArray *totalLabelArray;

@property (nonatomic, assign) id<PLSRateButtonViewDelegate> rateDelegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat space;


- (instancetype)initWithFrame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex;
@end
