//
//  CartoonPanelView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CartoonPanelView.h"
#import "HorizontalListView.h"
#import "TuSDKConstants.h"

static const CGFloat kCartoonListHeight = 92;

@interface CartoonListView : HorizontalListView

@property (nonatomic, strong) NSArray *cartoonCodes;
@property (nonatomic, copy) NSString *selectedCartoonCode;

@property (nonatomic, copy) void (^itemViewTapActionHandler)(CartoonListView *filterListView, HorizontalListItemView *selectedItemView, NSString *filterCode);

@end

@implementation CartoonListView

- (void)commonInit {
    [super commonInit];
    [self setupData];
}

- (void)setupData {
    _cartoonCodes = @[kCameraCartoonCodes];
    typeof(self)weakSelf = self;
    // 配置 UI
    [self addItemViewsWithCount:_cartoonCodes.count config:^(HorizontalListView *listView, NSUInteger index, HorizontalListItemView *itemView) {
        NSString *cartoonCode = weakSelf.cartoonCodes[index];
        // 标题
        NSString *title = [NSString stringWithFormat:@"lsq_filter_%@", cartoonCode];
        itemView.titleLabel.text = NSLocalizedStringFromTable(title, @"TuSDKConstants", @"无需国际化");
        
        // 缩略图
        NSString *imageName = [NSString stringWithFormat:@"lsq_filter_thumb_%@",cartoonCode];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        itemView.thumbnailView.image = [UIImage imageWithContentsOfFile:imagePath];
        // 点击次数
        itemView.maxTapCount = 1;
    }];
    [self insertItemView:[HorizontalListItemView disableItemView] atIndex:0];
}

#pragma mark - property

- (void)selectedCartoonCode:(NSString *)selectedCartoonCode {
    _selectedCartoonCode = selectedCartoonCode;
    NSInteger selectedIndex = [_cartoonCodes indexOfObject:selectedCartoonCode];
    if (selectedIndex < 0 || selectedIndex >= _cartoonCodes.count) { // 若不在 _filterCodes 范围内，则选中无效果
        _selectedCartoonCode = nil;
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
        code = _cartoonCodes[self.selectedIndex - 1];
    }
    _selectedCartoonCode = code;
    if (self.itemViewTapActionHandler) self.itemViewTapActionHandler(self, itemView, code);
}

@end


@interface CartoonPanelView ()

@property (nonatomic, strong, readonly) CartoonListView *cartoonListView;
@property (nonatomic, strong) UIVisualEffectView *effectBackgroundView;

@end

@implementation CartoonPanelView

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
    _effectBackgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self addSubview:_effectBackgroundView];
    
    _cartoonListView = [[CartoonListView alloc] initWithFrame:CGRectZero];
    [_effectBackgroundView.contentView addSubview:_cartoonListView];
    __weak typeof(self) weakSelf = self;
    _cartoonListView.itemViewTapActionHandler = ^(CartoonListView *filterListView, HorizontalListItemView *selectedItemView, NSString *filterCode) {

        selectedItemView.selectedImageView.hidden = YES;
        if ([weakSelf.delegate respondsToSelector:@selector(cartoonPanel:didSelectedCartoonCode:)]) {
            [weakSelf.delegate cartoonPanel:weakSelf didSelectedCartoonCode:filterCode];
        }
        // 不能在此处调用 reloadData，应在外部滤镜应用后才调用
    };
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    CGRect safeBounds = self.bounds;
    if (@available(iOS 11.0, *)) {
        safeBounds = UIEdgeInsetsInsetRect(safeBounds, self.safeAreaInsets);
    }
    const CGFloat listViewY = CGRectGetMaxY(safeBounds) - kCartoonListHeight;
    _effectBackgroundView.frame = CGRectMake(0, listViewY, size.width, size.height - listViewY);
    _cartoonListView.frame = CGRectMake(CGRectGetMinX(safeBounds), 0, CGRectGetWidth(safeBounds), kCartoonListHeight);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(-1,kCartoonListHeight);
}

- (BOOL)display {
    return self.alpha > 0.0;
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
