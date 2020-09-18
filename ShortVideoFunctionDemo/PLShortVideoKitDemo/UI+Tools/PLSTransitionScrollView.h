//
//  PLSTransitionScrollView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/11/25.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PLSTransitionScrollView;
@protocol PLSTransitionScrollViewDelegate <NSObject>

@optional
/**
 @abstract 点击元素选择转场特效
 */
- (void)transitionScrollView:(PLSTransitionScrollView *)transitionScrollView didClickIndex:(NSInteger)index button:(UIButton *)button;

@end

@interface PLSTransitionScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *selectedTypes;
@property (nonatomic, weak) id<PLSTransitionScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images types:(NSMutableArray *)types;

- (void)clear;
@end


NS_ASSUME_NONNULL_END
