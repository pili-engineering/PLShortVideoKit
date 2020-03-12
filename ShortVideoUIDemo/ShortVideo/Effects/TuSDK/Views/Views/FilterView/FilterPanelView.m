//
//  FilterListView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "FilterPanelView.h"
#import "HorizontalListView.h"
#import "TuSDKConstants.h"

static const CGFloat kFilterListHeight = 92;
static const CGFloat kFilterListParamtersViewSpacing = 24;

@interface FilterListView : HorizontalListView

@property (nonatomic, strong) NSArray *filterCodes;
@property (nonatomic, copy) NSString *selectedFilterCode;

@property (nonatomic, copy) void (^itemViewTapActionHandler)(FilterListView *filterListView, HorizontalListItemView *selectedItemView, NSString *filterCode);

@end

@implementation FilterListView

- (void)commonInit {
    [super commonInit];
}


/**
 设置滤镜代号列表

 @param filterCodes <#filterCodes description#>
 */
- (void)setFilterCodes:(NSArray *)filterCodes;
{
    _filterCodes = [filterCodes copy];
    
    [self removeAllSubViews];
    
    [self setupData];

}

- (void)setupData {
    
    typeof(self)weakSelf = self;
    // 配置 UI
    [self addItemViewsWithCount:_filterCodes.count config:^(HorizontalListView *listView, NSUInteger index, HorizontalListItemView *itemView) {
        NSString *filterCode = weakSelf.filterCodes[index];
        // 标题
        NSString *title = [NSString stringWithFormat:@"lsq_filter_%@", filterCode];
        itemView.titleLabel.text = NSLocalizedStringFromTable(title, @"TuSDKConstants", @"无需国际化");
        // 缩略图
        NSString *imageName = [NSString stringWithFormat:@"lsq_filter_thumb_%@", filterCode];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        itemView.thumbnailView.image = [UIImage imageWithContentsOfFile:imagePath];
        // 点击次数
        itemView.maxTapCount = 2;
    }];
    [self insertItemView:[HorizontalListItemView disableItemView] atIndex:0];
}

#pragma mark - property

- (void)setSelectedFilterCode:(NSString *)selectedFilterCode {
    _selectedFilterCode = selectedFilterCode;
    NSInteger selectedIndex = [_filterCodes indexOfObject:selectedFilterCode];
    if (selectedIndex < 0 || selectedIndex >= _filterCodes.count) { // 若不在 _filterCodes 范围内，则选中无效果
        _selectedFilterCode = nil;
        selectedIndex = -1;
    }
    selectedIndex += 1;
    self.selectedIndex = selectedIndex;
}

#pragma mark - HorizontalListItemViewDelegate

- (void)itemViewDidTap:(HorizontalListItemView *)itemView {
    [super itemViewDidTap:itemView];
    NSString *code = nil;
    if (self.selectedIndex > 0) {
        code = _filterCodes[self.selectedIndex - 1];
    }
    _selectedFilterCode = code;
    if (self.itemViewTapActionHandler) self.itemViewTapActionHandler(self, itemView, code);
}

@end


@interface FilterPanelView ()

@property (nonatomic, strong, readonly) FilterListView *filterListView;
@property (nonatomic, strong, readonly) ParametersAdjustView *paramtersView;

@property (nonatomic, strong) UIVisualEffectView *effectBackgroundView;

@property (nonatomic, strong) NSArray *beautyFilterKeys;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FilterPanelView

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

- (void)setCodes:(NSArray<NSString *> *)codes;
{
    _filterListView.filterCodes = codes;
}

- (void)commonInit {
    _effectBackgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self addSubview:_effectBackgroundView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
    self.titleLabel.textColor = [UIColor lightTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"高级滤镜";
    [_effectBackgroundView.contentView addSubview:self.titleLabel];
    
    _filterListView = [[FilterListView alloc] initWithFrame:CGRectZero];
    [_effectBackgroundView.contentView addSubview:_filterListView];
    __weak typeof(self) weakSelf = self;
    _filterListView.itemViewTapActionHandler = ^(FilterListView *filterListView, HorizontalListItemView *selectedItemView, NSString *filterCode) {
//        weakSelf.paramtersView.hidden = selectedItemView.tapCount < selectedItemView.maxTapCount;
//        if (!weakSelf.paramtersView.hidden)return;
        
        if ([weakSelf.delegate respondsToSelector:@selector(filterPanel:didSelectedFilterCode:)]) {
            [weakSelf.delegate filterPanel:weakSelf didSelectedFilterCode:filterCode];
        }
        // 不能在此处调用 reloadData，应在外部滤镜应用后才调用
    };
    
    _paramtersView = [[ParametersAdjustView alloc] initWithFrame:CGRectZero];
    [self addSubview:_paramtersView];
    // 显示美颜界面是可打开
//    _beautyFilterKeys = @[kBeautySkinKeys, kBeautyFaceKeys];
    _beautyFilterKeys = @[kBeautyFaceKeys];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize size = self.bounds.size;
    CGRect safeBounds = self.bounds;
    if (@available(iOS 11.0, *)) {
        safeBounds = UIEdgeInsetsInsetRect(safeBounds, self.safeAreaInsets);
    }
    const CGFloat listViewY = CGRectGetMaxY(safeBounds) - kFilterListHeight;
    _effectBackgroundView.frame = CGRectMake(0, listViewY - 58, size.width, size.height - listViewY + 58);
    _filterListView.frame = CGRectMake(CGRectGetMinX(safeBounds), 38, CGRectGetWidth(safeBounds), kFilterListHeight);

    const CGFloat paramtersViewAvailableHeight = listViewY - kFilterListParamtersViewSpacing;
    const CGFloat paramtersViewLeftMargin = 16;
    const CGFloat paramtersViewRightMargin = 9;
    _paramtersView.frame =
    CGRectMake(CGRectGetMinX(safeBounds) + paramtersViewLeftMargin,
               paramtersViewAvailableHeight - _paramtersView.contentHeight - 40,
               CGRectGetWidth(safeBounds) - paramtersViewLeftMargin - paramtersViewRightMargin,
               _paramtersView.contentHeight);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(26);
        make.bottom.equalTo(self.filterListView.mas_top);
    }];

    
    [_effectBackgroundView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:_effectBackgroundView.bounds];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(-1, kFilterListParamtersViewSpacing + kFilterListHeight + _paramtersView.intrinsicContentSize.height);
}

- (BOOL)isBeautyFilterKey:(NSString *)key {
    BOOL isBeautyFilterKey = NO;
    if (!key.length) return isBeautyFilterKey;
    for (NSString *beautyFilterKey in _beautyFilterKeys) {
        if ([beautyFilterKey isEqualToString:key]) {
            isBeautyFilterKey = YES;
            break;
        }
    }
    return isBeautyFilterKey;
}

#pragma mark - property

- (void)setSelectedFilterCode:(NSString *)selectedFilterCode {
    _filterListView.selectedFilterCode = selectedFilterCode;
}
- (NSString *)selectedFilterCode {
    return _filterListView.selectedFilterCode;
}
- (BOOL)display {
    return self.alpha > 0.0;
}

#pragma mark - public


/**
 重载滤镜参数数据
 */
- (void)reloadFilterParamters {
    if (!self.display) return;
    [_paramtersView setupWithParameterCount:self.dataSource.numberOfParamter config:^(NSUInteger index, ParameterAdjustItemView *itemView, void (^parameterItemConfig)(NSString *name, double percent)) {
        NSString *parameterName = [self.dataSource paramterNameAtIndex:index];
        // 跳过美颜、美型滤镜参数
        BOOL shouldSkip = [self isBeautyFilterKey:parameterName];
        if (!shouldSkip) {
            double percentVale = [self.dataSource percentValueAtIndex:index];
            parameterName = [NSString stringWithFormat:@"lsq_filter_set_%@", parameterName];
            parameterItemConfig(NSLocalizedStringFromTable(parameterName, @"TuSDKConstants", @"无需国际化"), percentVale);
        }
    } valueChange:^(NSUInteger index, double percent) {
        if ([self.delegate respondsToSelector:@selector(filterPanel:didChangeValue:paramterIndex:)]) {
            [self.delegate filterPanel:self didChangeValue:percent paramterIndex:index];
        }
    }];
    [self setNeedsLayout];
}

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
