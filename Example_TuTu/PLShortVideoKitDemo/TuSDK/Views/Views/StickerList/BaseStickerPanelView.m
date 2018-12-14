//
//  BaseStickerPanelView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "BaseStickerPanelView.h"

@interface BaseStickerPanelView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIButton *unsetButton;

@property (nonatomic, strong) PageTabbar *categoryTabbar;

@property (nonatomic, strong) ViewSlider *categoryPageSlider;

@property (nonatomic, strong) CALayer *verticalSeparatorLayer;
@property (nonatomic, strong) CALayer *horizontalSeparatorLayer;

@property (nonatomic, strong) NSMutableArray *stickerCollectionViews;

@end

@implementation BaseStickerPanelView

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _stickerCollectionViews = [NSMutableArray array];
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    _verticalSeparatorLayer = [CALayer layer];
    [self.layer addSublayer:_verticalSeparatorLayer];
    _verticalSeparatorLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15].CGColor;
    _horizontalSeparatorLayer = [CALayer layer];
    [self.layer addSublayer:_horizontalSeparatorLayer];
    _horizontalSeparatorLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15].CGColor;
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_backgroundView];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UIButton *unsetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:unsetButton];
    _unsetButton = unsetButton;
    [unsetButton setImage:[UIImage imageNamed:@"video_ic_nix"] forState:UIControlStateNormal];
    
    PageTabbar *tabbar = [[PageTabbar alloc] initWithFrame:CGRectZero];
    [self addSubview:tabbar];
    _categoryTabbar = tabbar;
    tabbar.itemsSpacing = 24;
    tabbar.trackerSize = CGSizeMake(32, 2);
    tabbar.itemSelectedColor = [UIColor whiteColor];
    tabbar.itemNormalColor = [UIColor whiteColor];
    tabbar.delegate = self;
    tabbar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    ViewSlider *pageSlider = [[ViewSlider alloc] initWithFrame:CGRectZero];
    [self addSubview:pageSlider];
    _categoryPageSlider = pageSlider;
    pageSlider.dataSource = self;
    pageSlider.delegate = self;
    pageSlider.selectedIndex = 0;
}

- (void)layoutSubviews {
    _backgroundView.frame = self.bounds;
    const CGSize size = self.bounds.size;
    CGRect safeBounds = self.bounds;
    if (@available(iOS 11.0, *)) {
        safeBounds = UIEdgeInsetsInsetRect(safeBounds, self.safeAreaInsets);
    }
    const CGFloat tabbarHeight = 32;
    _unsetButton.frame = CGRectMake(CGRectGetMinX(safeBounds), CGRectGetMinY(safeBounds), 52, tabbarHeight);
    _categoryTabbar.frame = CGRectMake(CGRectGetMaxX(_unsetButton.frame), CGRectGetMinY(safeBounds), CGRectGetWidth(safeBounds) - CGRectGetMaxX(_unsetButton.frame), tabbarHeight);
    _categoryPageSlider.frame = CGRectMake(CGRectGetMinX(safeBounds), tabbarHeight, CGRectGetWidth(safeBounds), size.height - tabbarHeight);
    _verticalSeparatorLayer.frame = CGRectMake(CGRectGetMaxX(_unsetButton.frame), 0, 1, tabbarHeight);
    _horizontalSeparatorLayer.frame = CGRectMake(0, tabbarHeight, size.width, 1);
}

#pragma mark - PageTabbarDelegate

- (void)tabbar:(PageTabbar *)tabbar didSwitchFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _categoryPageSlider.selectedIndex = toIndex;
}

#pragma mark - ViewSliderDataSource

- (NSInteger)numberOfViewsInSlider:(ViewSlider *)slider {
    return 0;
}

- (UIView *)viewSlider:(ViewSlider *)slider viewAtIndex:(NSInteger)index {
    return nil;
}

#pragma mark - ViewSliderDelegate

- (void)viewSlider:(ViewSlider *)slider didSwitchBackIndex:(NSInteger)index {
    
}

- (void)viewSlider:(ViewSlider *)slider didSwitchToIndex:(NSInteger)index {
    _categoryTabbar.selectedIndex = index;
}

- (void)viewSlider:(ViewSlider *)slider switchingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    
}

@end
