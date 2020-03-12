//
//  BaseStickerPanelView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageTabbar.h"
#import "ViewSlider.h"

@class StickerCategory;
@interface BaseStickerPanelView : UIView <PageTabbarDelegate, ViewSliderDataSource, ViewSliderDelegate>

@property (nonatomic, strong, readonly) UIButton *unsetButton;

/**
 贴纸分类
 */
@property (nonatomic, strong, readonly) PageTabbar *categoryTabbar;

/**
 分类的滑动栏
 */
@property (nonatomic, strong, readonly) ViewSlider *categoryPageSlider;

- (void)commonInit;

@end
