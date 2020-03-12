//
//  PLSDrawView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/7/24.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSDrawModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLSDrawView : UIView
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, copy) void(^drawBegan)();
@property (nonatomic, copy) void(^drawEnded)();

/** 数据 */
@property (nonatomic, strong) PLSDrawModel *drawModel;

- (instancetype)initWithFrame:(CGRect)frame duration:(CMTime)duration;

/** 是否可撤销 */
- (BOOL)canUndo;
// 撤销
- (void)undo;
// 清除
- (void)clear;
@end

NS_ASSUME_NONNULL_END
