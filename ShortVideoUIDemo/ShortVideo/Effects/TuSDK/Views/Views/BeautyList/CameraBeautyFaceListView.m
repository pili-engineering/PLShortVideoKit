//
//  CameraBeautyFaceListView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/9/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CameraBeautyFaceListView.h"
#import "TuSDKConstants.h"
#import "CameraBeautyFaceListItemView.h"

@interface CameraBeautyFaceListView ()

@end

@implementation CameraBeautyFaceListView

+ (Class)listItemViewClass {
    return [CameraBeautyFaceListItemView class];
}

- (void)commonInit {
    [super commonInit];
    NSArray *faceFeatures = @[kBeautyFaceKeys];
    _faceFeatures = faceFeatures;
    
    // 配置 UI
    self.autoItemSize = YES;
    [self addItemViewsWithCount:faceFeatures.count config:^(HorizontalListView *listView, NSUInteger index, HorizontalListItemView *_itemView) {
        CameraBeautyFaceListItemView *itemView = (CameraBeautyFaceListItemView *)_itemView;
        NSString *faceFeature = faceFeatures[index];
        // 标题
        NSString *title = [NSString stringWithFormat:@"lsq_filter_set_%@", faceFeature];
        itemView.titleLabel.text = NSLocalizedStringFromTable(title, @"TuSDKConstants", @"无需国际化");
        // 缩略图
        NSString *imageName = [NSString stringWithFormat:@"face_ic_%@", faceFeature];
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        itemView.thumbnailView.image = image;
    }];
    HorizontalListItemView *resetItemView = [CameraBeautyFaceListItemView itemViewWithImage:[UIImage imageNamed:@"face_ic_reset"] title:@"重置"];
    resetItemView.disableSelect = YES;
    [self insertItemView:resetItemView atIndex:0];
}

#pragma mark HorizontalListItemViewDelegate

- (void)itemViewDidTap:(HorizontalListItemView *)tapedItemView {
    [super itemViewDidTap:tapedItemView];
    NSString *faceFeature = self.selectedIndex > 0 ? _faceFeatures[self.selectedIndex - 1] : nil;
    _selectedFaceFeature = faceFeature;
    if (self.itemViewTapActionHandler) self.itemViewTapActionHandler(self, tapedItemView, faceFeature);
}

@end
