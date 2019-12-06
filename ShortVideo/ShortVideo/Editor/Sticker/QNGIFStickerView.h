//
//  QNGIFStickerView.h
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNStickerModel.h"
#import "QNPanImageView.h"

@class QNGIFStickerView;
@protocol QNGIFStickerViewDelegate <NSObject>

@optional
- (void)stickerViewClose:(QNGIFStickerView *)stickerView;

@end

@interface QNGIFStickerView : UIImageView

#pragma mark - UI
@property (nonatomic) UIButton *closeBtn;
@property (nonatomic) QNPanImageView *dragBtn;
@property (nonatomic, assign) id <QNGIFStickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) QNStickerModel *stickerModel;

// 选中后出现边框
@property (nonatomic, assign, getter=isSelected) BOOL select;

- (instancetype)initWithStickerModel:(QNStickerModel *)stickerModel;

- (void)close:(id)sender;

#pragma mark - Reserved
@property (nonatomic, assign) CGFloat oriScale;
@property (nonatomic, assign) CGAffineTransform oriTransform;

@end
