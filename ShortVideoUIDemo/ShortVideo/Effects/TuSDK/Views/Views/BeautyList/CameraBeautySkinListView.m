//
//  CameraBeautySkinListView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/9/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CameraBeautySkinListView.h"

@implementation CameraBeautySkinListView

- (void)commonInit {
    [super commonInit];
    
    // setup UI
    self.itemSize = CGSizeMake(52, 52);
    self.itemSpacing = 8;
    [self addItemViewsWithCount:kBeautyLevelCount config:^(HorizontalListView *listView, NSUInteger index, HorizontalListItemView *itemView) {
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        indexLabel.font = [UIFont systemFontOfSize:16];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.text = @(index + 1).description;
        itemView.thumbnailView = (UIImageView *)indexLabel;
        [itemView.titleLabel removeFromSuperview];
        itemView.layer.cornerRadius = listView.itemSize.width / 2.0;
        itemView.maxTapCount = 2;
    }];
    HorizontalListItemView *disbaleItemView = [HorizontalListItemView disableItemView];
    disbaleItemView.layer.cornerRadius = self.itemSize.width / 2.0;
    [self insertItemView:disbaleItemView atIndex:0];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self itemViewAtIndex:self.selectedIndex].thumbnailView.hidden = NO;
    [super setSelectedIndex:selectedIndex];
    if (self.selectedIndex > 0) [self itemViewAtIndex:self.selectedIndex].thumbnailView.hidden = YES;
}

- (void)setLevel:(int)level {
    if (level > 5 || level < 0) {
        return;
    }
    _level = level;
    self.selectedIndex = level;
}

#pragma mark HorizontalListItemViewDelegate

- (void)itemViewDidTap:(HorizontalListItemView *)tapedItemView {
    [super itemViewDidTap:tapedItemView];
    _level = (int)self.selectedIndex;
    if (self.itemViewTapActionHandler) self.itemViewTapActionHandler(self, tapedItemView, _level);
}

@end
