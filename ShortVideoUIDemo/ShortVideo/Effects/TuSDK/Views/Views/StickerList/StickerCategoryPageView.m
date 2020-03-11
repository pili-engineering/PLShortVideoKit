//
//  StickerCategoryPageView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "StickerCategoryPageView.h"

static NSString * const kStickerCellReuseID = @"StickerCellReuseID";

/**
 贴纸单元格
 */
@interface StickerCollectionCell()

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, copy) void (^deleteButtonActionHandler)(StickerCollectionCell *cell);

- (void)setDeleteButtonHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@implementation StickerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    _thumbnailView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_thumbnailView];
    _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_loadingView];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _loadingView.hidesWhenStopped = YES;
    
    CGSize size = self.bounds.size;
    _downloadIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_ic_download"]];
    [self.contentView addSubview:_downloadIconView];
    CGSize downloadIconSize = _downloadIconView.intrinsicContentSize;
    _downloadIconView.frame = CGRectMake(size.width - downloadIconSize.width, size.height - downloadIconSize.height, downloadIconSize.width, downloadIconSize.height);
    _downloadIconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_deleteButton];
    [_deleteButton setImage:[UIImage imageNamed:@"video_ic_delete"] forState:UIControlStateNormal];
    _deleteButton.imageView.contentMode = UIViewContentModeCenter;
    _deleteButton.hidden = YES;
    _deleteButton.layer.borderColor = borderColor.CGColor;
    _deleteButton.layer.borderWidth = 2;
    _deleteButton.layer.cornerRadius = 4;
    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.backgroundColor = [UIColor colorWithWhite:0 alpha:.65];
    _deleteButton.frame = self.contentView.bounds;
    _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:selectedView];
    _selectedView = selectedView;
    selectedView.layer.borderColor = borderColor.CGColor;
    selectedView.layer.borderWidth = 2;
    selectedView.layer.cornerRadius = 4;
    selectedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    selectedView.userInteractionEnabled = NO;
    selectedView.hidden = YES;
}

#pragma mark - property

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _selectedView.hidden = !selected;
}

- (void)setOnline:(BOOL)online {
    _online = online;
    _downloadIconView.hidden = !online;
    [_loadingView stopAnimating];
}

#pragma mark - action

- (void)deleteButtonAction:(UIButton *)sender {
    if (self.deleteButtonActionHandler) self.deleteButtonActionHandler(self);
}

#pragma mark - public

- (void)startLoading {
    [self.loadingView startAnimating];
    self.downloadIconView.hidden = YES;
}
- (void)finishLoading {
    [self.loadingView stopAnimating];
}

- (void)setDeleteButtonHidden:(BOOL)hidden animated:(BOOL)animated {
    if (!animated) {
        _deleteButton.hidden = hidden;
        return;
    }
    double startAlpha = hidden;
    double endAlpha = !hidden;
    _deleteButton.alpha = startAlpha;
    _deleteButton.hidden = NO;
    [UIView animateWithDuration:.25 animations:^{
        self.deleteButton.alpha = endAlpha;
    } completion:^(BOOL finished) {
        self.deleteButton.hidden = hidden;
        self.deleteButton.alpha = 1;
    }];
}

@end


/**
 贴纸每个分类的页面视图
 */
@interface StickerCategoryPageView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSIndexPath *shouldShowDeleteButtonIndexPath;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation StickerCategoryPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    const int countPerRow = 5;
    const CGFloat itemHorizontalSpacing = 21;
    const CGFloat itemVerticalSpacing = 15;
    CGFloat itemWidth = (screenWidth - itemHorizontalSpacing) / countPerRow - itemHorizontalSpacing;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(itemVerticalSpacing, itemHorizontalSpacing, itemVerticalSpacing, itemHorizontalSpacing);
    flowLayout.minimumLineSpacing = itemVerticalSpacing;
    
    _stickerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self addSubview:_stickerCollectionView];
    _stickerCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _stickerCollectionView.backgroundColor = [UIColor clearColor];
    _stickerCollectionView.dataSource = self;
    _stickerCollectionView.allowsSelection = NO;
    
    [_stickerCollectionView registerClass:[StickerCollectionCell class] forCellWithReuseIdentifier:kStickerCellReuseID];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
}

#pragma mark - property

- (void)setShouldShowDeleteButtonIndexPath:(NSIndexPath *)shouldShowDeleteButtonIndexPath {
    if ([shouldShowDeleteButtonIndexPath isEqual:_shouldShowDeleteButtonIndexPath]) {
        return;
    }
    
    StickerCollectionCell *cellShouldHideButton = (StickerCollectionCell *)[_stickerCollectionView cellForItemAtIndexPath:_shouldShowDeleteButtonIndexPath];
    [cellShouldHideButton setDeleteButtonHidden:YES animated:YES];
    StickerCollectionCell *cellShouldShowButton = (StickerCollectionCell *)[_stickerCollectionView cellForItemAtIndexPath:shouldShowDeleteButtonIndexPath];
    [cellShouldShowButton setDeleteButtonHidden:NO animated:YES];
    
    _shouldShowDeleteButtonIndexPath = shouldShowDeleteButtonIndexPath;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if ([selectedIndexPath isEqual:_selectedIndexPath]) {
        return;
    }
//    UICollectionViewCell *cellShouldDeselect = [_stickerCollectionView cellForItemAtIndexPath:_selectedIndexPath];
//    cellShouldDeselect.selected = NO;
    for (UICollectionViewCell *cellShouldDeselect in _stickerCollectionView.visibleCells) {
        if (cellShouldDeselect.selected) cellShouldDeselect.selected = NO;
    }
    UICollectionViewCell *cellShouldSelect = [_stickerCollectionView cellForItemAtIndexPath:selectedIndexPath];
    cellShouldSelect.selected = YES;
    
    _selectedIndexPath = selectedIndexPath;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= [self.dataSource numberOfItemsInCategoryPageView:self]) {
        return;
    }
    
    self.selectedIndexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
}
- (NSInteger)selectedIndex {
    return _selectedIndexPath.item;
}

#pragma mark - public

- (void)dismissDeleteButtons {
    if ([_shouldShowDeleteButtonIndexPath isEqual:_selectedIndexPath]) {
        [self deselect];
        if ([self.delegate respondsToSelector:@selector(stickerCategoryPageView:didSelectCell:atIndex:)]) {
            [self.delegate stickerCategoryPageView:self didSelectCell:nil atIndex:-1];
        }
    }
    self.shouldShowDeleteButtonIndexPath = nil;
}

- (void)deselect {
    self.selectedIndexPath = nil;
}

#pragma mark - action

- (void)tapAction:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:_stickerCollectionView];
    if (!CGRectContainsPoint(_stickerCollectionView.bounds, touchPoint)) return;
    NSIndexPath *touchIndexPath = [_stickerCollectionView indexPathForItemAtPoint:touchPoint];
    if (!touchIndexPath) return;
    
    [self dismissDeleteButtons];
    self.selectedIndexPath = touchIndexPath;
    StickerCollectionCell *cell = (StickerCollectionCell *)[_stickerCollectionView cellForItemAtIndexPath:touchIndexPath];
    if ([self.delegate respondsToSelector:@selector(stickerCategoryPageView:didSelectCell:atIndex:)]) {
        [self.delegate stickerCategoryPageView:self didSelectCell:cell atIndex:touchIndexPath.item];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;
    
    CGPoint touchPoint = [sender locationInView:_stickerCollectionView];
    if (!CGRectContainsPoint(_stickerCollectionView.bounds, touchPoint)) return;
    
    NSIndexPath *touchIndexPath = [_stickerCollectionView indexPathForItemAtPoint:touchPoint];
    if (!touchIndexPath) return;
    
    StickerCollectionCell *cell = (StickerCollectionCell *)[_stickerCollectionView cellForItemAtIndexPath:touchIndexPath];
    if (cell.online) return;
    
    self.shouldShowDeleteButtonIndexPath = touchIndexPath;
}

- (void)cell:(StickerCollectionCell *)cell didTapWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(stickerCategoryPageView:didTapDeleteButtonAtIndex:)]) {
        [self.delegate stickerCategoryPageView:self didTapDeleteButtonAtIndex:indexPath.item];
    }
}

#pragma mark - UICollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStickerCellReuseID forIndexPath:indexPath];
    
    //cell.thumbnailView.image = [UIImage imageNamed:@"default"];
    [self.dataSource stickerCategoryPageView:self setupStickerCollectionCell:cell atIndex:indexPath.item];
    
    cell.deleteButton.hidden = cell.selected || ![indexPath isEqual:_shouldShowDeleteButtonIndexPath] || cell.online;
    __weak typeof(self) weakSelf = self;
    cell.deleteButtonActionHandler = ^(StickerCollectionCell *cell) {
        [weakSelf cell:cell didTapWithIndexPath:indexPath];
    };
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInCategoryPageView:self];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    for (UIView *view in _stickerCollectionView.visibleCells) {
        if ([touch.view isDescendantOfView:view]) {
            return YES;
        }
    }
    return NO;
}

@end
