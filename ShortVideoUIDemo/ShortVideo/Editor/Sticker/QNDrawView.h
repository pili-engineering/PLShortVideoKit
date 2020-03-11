//
//  QNDrawView.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/7/18.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNStickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNDrawView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, copy) void(^drawBegan)();
@property (nonatomic, copy) void(^drawEnded)();

/** 数据 */
@property (nonatomic, strong) QNStickerModel *stickerModel;

- (instancetype)initWithFrame:(CGRect)frame duration:(CMTime)duration;

/** 是否可撤销 */
- (BOOL)canUndo;
// 撤销
- (void)undo;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
