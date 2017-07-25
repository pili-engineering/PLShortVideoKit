//
//  KWStickerCell.h
//  KWMediaStreamingKitDemo
//
//  Created by 伍科 on 16/12/6.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KWSticker;


@interface KWIndicatorView : UIView

- (id)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end


@interface KWStickerCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setSticker:(KWSticker *)sticker index:(NSInteger)index;

/**
是否隐藏背景框
 */
-(void)hideBackView:(BOOL)hidden;


/**
 开启动画
 */
- (void)startDownload;


@end
