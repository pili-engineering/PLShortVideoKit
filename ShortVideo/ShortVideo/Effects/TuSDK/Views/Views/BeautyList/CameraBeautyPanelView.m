//
//  CameraBeautyPanelView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CameraBeautyPanelView.h"
#import "ParametersAdjustView.h"
#import "HorizontalListView.h"
#import "PageTabbar.h"
#import "ViewSlider.h"
#import "TuSDKConstants.h"
#import "CameraBeautySkinListView.h"
#import "CameraBeautyFaceListView.h"

// 美颜列表高度
static const CGFloat kBeautyListHeight = 120;
// 美颜 tabbar 高度
static const CGFloat kBeautyTabbarHeight = 30;
// 美颜列表与参数视图间隔
static const CGFloat kBeautyListParamtersViewSpacing = 24;

@interface CameraBeautyPanelView () <PageTabbarDelegate, ViewSliderDataSource, ViewSliderDelegate>

/**
 美颜展示视图
 */
@property (nonatomic, strong) CameraBeautySkinListView *beautySkinListView;

/**
 美型展示视图
 */
@property (nonatomic, strong) CameraBeautyFaceListView *beautyFaceListView;

/**
 参数调节视图
 */
@property (nonatomic, strong, readonly) ParametersAdjustView *paramtersView;

@property (nonatomic, strong) UIVisualEffectView *effectBackgroundView;

@property (nonatomic, strong) PageTabbar *tabbar;

@property (nonatomic, strong) ViewSlider *pageSlider;

@end

@implementation CameraBeautyPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    __weak typeof(self) weakSelf = self;
    
    _beautySkinListView = [[CameraBeautySkinListView alloc] initWithFrame:CGRectZero];
    _beautySkinListView.itemViewTapActionHandler = ^(CameraBeautySkinListView *listView, HorizontalListItemView *selectedItemView, int level) {
        weakSelf.paramtersView.hidden = selectedItemView.tapCount < selectedItemView.maxTapCount;
        [weakSelf reloadFilterParamters];
    };
    // 默认选中二级滤镜
    _beautySkinListView.level = 1;
    
    _beautyFaceListView = [[CameraBeautyFaceListView alloc] initWithFrame:CGRectZero];
    _beautyFaceListView.itemViewTapActionHandler = ^(CameraBeautyFaceListView *listView, HorizontalListItemView *selectedItemView, NSString *faceFeature) {
        weakSelf.paramtersView.hidden = faceFeature == nil;
        if (faceFeature) {
            [weakSelf reloadFilterParamters];
            if ([weakSelf.delegate respondsToSelector:@selector(filterPanel:didSelectedFilterCode:)]) {
                [weakSelf.delegate filterPanel:weakSelf didSelectedFilterCode:nil];
            }
        } else {
            [weakSelf resetBeautyFaceFilterParamters];
        }
    };
    
    _paramtersView = [[ParametersAdjustView alloc] initWithFrame:CGRectZero];
    [self addSubview:_paramtersView];
    _paramtersView.hidden = YES;
    
    _effectBackgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self addSubview:_effectBackgroundView];
    
    PageTabbar *tabbar = [[PageTabbar alloc] initWithFrame:CGRectZero];
    [self addSubview:tabbar];
    _tabbar = tabbar;
    //tabbar.itemWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0;
    tabbar.trackerSize = CGSizeMake(20, 2);
    tabbar.itemSelectedColor = [UIColor whiteColor];
    tabbar.itemNormalColor = [UIColor colorWithWhite:1 alpha:.25];
    tabbar.delegate = self;
    tabbar.itemTitles = @[@"微整形"];
    tabbar.disableAnimation = YES;
    tabbar.itemTitleFont = [UIFont systemFontOfSize:13];
    
    ViewSlider *pageSlider = [[ViewSlider alloc] initWithFrame:CGRectZero];
    [self addSubview:pageSlider];
    _pageSlider = pageSlider;
    pageSlider.dataSource = self;
    pageSlider.delegate = self;
    pageSlider.selectedIndex = 0;
    pageSlider.disableSlide = YES;
}

- (void)layoutSubviews {
    const CGSize size = self.bounds.size;
    CGRect safeBounds = self.bounds;
    if (@available(iOS 11.0, *)) {
        safeBounds = UIEdgeInsetsInsetRect(safeBounds, self.safeAreaInsets);
    }
    
    _tabbar.itemWidth = CGRectGetWidth(safeBounds);
    const CGFloat tabbarY = CGRectGetMaxY(safeBounds) - kBeautyListHeight;
    _tabbar.frame = CGRectMake(CGRectGetMinX(safeBounds), tabbarY, CGRectGetWidth(safeBounds), kBeautyTabbarHeight);
    const CGFloat pageSliderHeight = kBeautyListHeight - kBeautyTabbarHeight;
    _pageSlider.frame = CGRectMake(CGRectGetMinX(safeBounds), CGRectGetMaxY(_tabbar.frame), CGRectGetWidth(safeBounds), pageSliderHeight);
    
    const CGFloat paramtersViewAvailableHeight = CGRectGetMaxY(safeBounds) - kBeautyListHeight - kBeautyListParamtersViewSpacing;
    const CGFloat paramtersViewSideMargin = 15;
    const CGFloat paramtersViewHeight = _paramtersView.contentHeight;
    _paramtersView.frame =
    CGRectMake(CGRectGetMinX(safeBounds) + paramtersViewSideMargin,
               paramtersViewAvailableHeight - paramtersViewHeight,
               CGRectGetWidth(_tabbar.frame) - paramtersViewSideMargin * 2,
               paramtersViewHeight);
    _effectBackgroundView.frame = CGRectMake(0, tabbarY, size.width, size.height - tabbarY);
}

#pragma mark - property

- (BOOL)display {
    return self.alpha > 0.0;
}

- (NSInteger)selectedIndex {
    return _tabbar.selectedIndex;
}

#pragma mark - private

- (void)resetBeautyFaceFilterParamters {
    NSArray *beautyFaceKeys = @[kBeautyFaceKeys];
    if ([self.delegate respondsToSelector:@selector(filterPanel:resetParamterKeys:)]) {
        [self.delegate filterPanel:self resetParamterKeys:beautyFaceKeys];
    }
}

#pragma mark - public

/**
 重载、同步美颜参数
 */
- (void)reloadBeautySkinParamters {
    NSArray *beautySkinKeys = @[kBeautySkinKeys];
    
    [_paramtersView setupWithParameterCount:self.dataSource.numberOfParamter config:^(NSUInteger index, ParameterAdjustItemView *itemView, void (^parameterItemConfig)(NSString *name, double percent)) {
        // 参数名称
        NSString *parameterName = [self.dataSource paramterNameAtIndex:index];
        // 是否进行配置
        BOOL shouldConfig = [beautySkinKeys containsObject:parameterName];
        if (!shouldConfig) return;
        
        // 参数百分比值
        double percentValue = (double)self.beautySkinListView.level / kBeautyLevelCount;
        // 应用参数名称和参数值
        parameterName = [NSString stringWithFormat:@"lsq_filter_set_%@", parameterName];
        parameterItemConfig(NSLocalizedStringFromTable(parameterName, @"TuSDKConstants", @"无需国际化"), percentValue);
        if ([self.delegate respondsToSelector:@selector(filterPanel:didChangeValue:paramterIndex:)]) {
            [self.delegate filterPanel:self didChangeValue:percentValue paramterIndex:index];
        }
    } valueChange:^(NSUInteger index, double percent) {
        if ([self.delegate respondsToSelector:@selector(filterPanel:didChangeValue:paramterIndex:)]) {
            [self.delegate filterPanel:self didChangeValue:percent paramterIndex:index];
        }
    }];
}

/**
 更新显示微整形参数
 */
- (void)reloadBeautyFaceParamters {
    [_paramtersView setupWithParameterCount:self.dataSource.numberOfParamter config:^(NSUInteger index, ParameterAdjustItemView *itemView, void (^parameterItemConfig)(NSString *name, double percent)) {
        // 参数名称
        NSString *parameterName = [self.dataSource paramterNameAtIndex:index];
        // 是否进行配置，只更新选中项参数
        BOOL shouldConfig = [self.beautyFaceListView.selectedFaceFeature isEqualToString:parameterName];
        if (!shouldConfig) return;
        
        // 参数值为从数据源获取的值
        double percentValue = [self.dataSource percentValueAtIndex:index];
        //NSLog(@"美型 - %@: %f", parameterName, percentValue);
        
        // 显示偏移取值范围
        if ([parameterName isEqualToString:@"mouthWidth"] ||
            [parameterName isEqualToString:@"archEyebrow"] ||
            [parameterName isEqualToString:@"jawSize"] ||
            [parameterName isEqualToString:@"eyeAngle"] ||
            [parameterName isEqualToString:@"eyeDis"]) {
            itemView.displayValueOffset = -.5;
        }
        
        // 更新显示参数名称和参数值
        parameterName = [NSString stringWithFormat:@"lsq_filter_set_%@", parameterName];
        parameterItemConfig(NSLocalizedStringFromTable(parameterName, @"TuSDKConstants", @"无需国际化"), percentValue);
    } valueChange:^(NSUInteger index, double percent) {
        NSString *parameterName = [self.dataSource paramterNameAtIndex:index];
        //NSLog(@"%@ -> %f", parameterName, percent);
        
        if ([self.delegate respondsToSelector:@selector(filterPanel:didChangeValue:paramterIndex:)]) {
            [self.delegate filterPanel:self didChangeValue:percent paramterIndex:index];
        }
    }];
}

/**
 重载滤镜参数值
 */
- (void)reloadFilterParamters {
//    if (!self.display && self.paramtersView.hidden) return;
//    if (self.tabbar.selectedIndex == 0) { // 当前为美颜列表
//        [self reloadBeautySkinParamters];
//    } else if (self.tabbar.selectedIndex == 1) { // 当前为微整形列表
//        [self reloadBeautyFaceParamters];
//    }
    [self reloadBeautyFaceParamters];
    [self setNeedsLayout];
}

#pragma mark - PageTabbarDelegate

- (void)tabbar:(PageTabbar *)tabbar didSwitchFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageSlider.selectedIndex = toIndex;
    [self reloadFilterParamters];
}

#pragma mark - ViewSliderDataSource

- (NSInteger)numberOfViewsInSlider:(ViewSlider *)slider {
    return 1;
}

/**
 调节栏视图切换

 @param slider 调节栏
 @param index 视图索引
 @return 调节视图
 */
- (UIView *)viewSlider:(ViewSlider *)slider viewAtIndex:(NSInteger)index {
    return _beautyFaceListView;
//    switch (index) {
//        case 0:{
//            return _beautySkinListView;
//        } break;
//        case 1:{
//            return _beautyFaceListView;
//        } break;
//        default:{
//            return nil;
//        } break;
//    }
}

#pragma mark - ViewSliderDelegate

- (void)viewSlider:(ViewSlider *)slider didSwitchBackIndex:(NSInteger)index {}

- (void)viewSlider:(ViewSlider *)slider didSwitchToIndex:(NSInteger)index {
    _tabbar.selectedIndex = index;
}

- (void)viewSlider:(ViewSlider *)slider switchingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {}

#pragma mark - touch

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01 || ![self pointInside:point withEvent:event]) return nil;
    UIView *hitView = [super hitTest:point withEvent:event];
    // 响应子视图
    if (hitView != self && !hitView.hidden) {
        return hitView;
    }
    return nil;
}

@end
