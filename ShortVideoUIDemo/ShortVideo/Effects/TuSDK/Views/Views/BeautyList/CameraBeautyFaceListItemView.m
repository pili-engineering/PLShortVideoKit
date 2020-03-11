//
//  CameraBeautyFaceListItemView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/9/19.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CameraBeautyFaceListItemView.h"
#import "TuSDKFramework.h"

@interface CameraBeautyFaceListItemView ()

@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *normalImageColor;
@property (nonatomic, strong) UIColor *selectedImageColor;
@property (nonatomic, strong) UIColor *normalImageBackgroundColor;
@property (nonatomic, strong) UIColor *selectedImageBackgroundColor;

@end

@implementation CameraBeautyFaceListItemView

- (void)commonInit {
    [super commonInit];
    
    _itemWidth = 52;
    _thumnalTitleSpacing = 6;
    _normalTitleColor = [UIColor colorWithWhite:1 alpha:.4];
    _selectedImageColor = _selectedTitleColor = lsqRGB(255, 204, 0);
    _normalImageColor = [UIColor colorWithWhite:1 alpha:1];
    _selectedImageBackgroundColor = [UIColor colorWithWhite:0 alpha:.45];
    _normalImageBackgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = NO;
    self.backgroundColor = nil;
    
    self.thumbnailView.tintColor = _normalImageColor;
    self.selectedImageView.contentMode = self.thumbnailView.contentMode = UIViewContentModeCenter;
    self.selectedImageView.image = nil;
    self.thumbnailView.backgroundColor = _normalImageBackgroundColor;
    self.selectedImageView.layer.cornerRadius = self.thumbnailView.layer.cornerRadius = _itemWidth / 2;
    [self.selectedImageView removeFromSuperview];
    
    self.titleLabel.backgroundColor = nil;
    self.titleLabel.textColor = _normalTitleColor;
    self.clipsToBounds = YES;
}

+ (instancetype)itemViewWithImage:(UIImage *)image title:(NSString *)title {
    CameraBeautyFaceListItemView *itemView = [[self alloc] initWithFrame:CGRectZero];
    itemView.thumbnailView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    itemView.titleLabel.text = title;
    return itemView;
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    self.selectedImageView.layer.cornerRadius = self.thumbnailView.layer.cornerRadius = _itemWidth / 2;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.disableSelect) return;
    self.thumbnailView.tintColor = selected ? _selectedImageColor : _normalImageColor;
    self.thumbnailView.backgroundColor = selected ? _selectedImageBackgroundColor : _normalImageBackgroundColor;
    self.titleLabel.textColor = selected ? _selectedTitleColor : _normalTitleColor;
    self.titleLabel.hidden = NO;
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    self.selectedImageView.frame = self.thumbnailView.frame = CGRectMake(0, 0, _itemWidth, _itemWidth);
    const CGFloat titleLabelY = CGRectGetMaxY(self.thumbnailView.frame) + _thumnalTitleSpacing;
    self.titleLabel.frame =
    CGRectMake(0, titleLabelY, _itemWidth, size.height - titleLabelY);
    self.touchButton.frame = self.bounds;
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = CGSizeMake(_itemWidth,  UIViewNoIntrinsicMetric);
    //[self.titleLabel sizeToFit];
    if (self.titleLabel.text.length) {
        contentSize.height = _itemWidth + _thumnalTitleSpacing + self.titleLabel.intrinsicContentSize.height;
    } else {
        contentSize.height = _itemWidth;
    }
    
    return contentSize;
}

@end
