//
//  StickerPanelView.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "StickerPanelView.h"
#import "TuSDKFramework.h"

#import "CameraStickerManager.h"
#import "OnlineStickerGroup.h"
#import "StickerCategoryPageView.h"

@interface StickerPanelView () <
StickerCategoryPageViewDataSource, StickerCategoryPageViewDelegate,
TuSDKOnlineStickerDownloaderDelegate>

@property (nonatomic, strong) NSArray<StickerCategory *> *stickerCategorys;
@property (nonatomic, strong) NSArray *categoryNames;
@property (nonatomic, weak) StickerCategoryPageView *currentCategoryPageView;

/**
 贴纸下载对象
 */
@property (nonatomic, strong) TuSDKOnlineStickerDownloader *stickerDownloader;

/**
 下载回调字典
 */
@property (nonatomic, strong) NSMutableDictionary *downloadCallbackDic;

/**
 选中的贴纸 id
 */
@property (nonatomic, assign) NSInteger selectedStickerId;

@end

@implementation StickerPanelView

- (void)commonInit {
    [self loadStickers];
    [super commonInit];
    [self setupUI];
    NSLog(@"%s", __FUNCTION__);
}

/**
 获取从 CameraStickerManager 存储或重新加载的贴纸分类数组，生成分类名称数组
 */
- (void)loadStickers {
    _stickerCategorys = [CameraStickerManager sharedManager].stickerCategorys;
    
    NSMutableArray *categoryNames = [NSMutableArray array];
    for (StickerCategory *stickerCategory in _stickerCategorys) {
        [categoryNames addObject:stickerCategory.name];
    }
    _categoryNames = categoryNames.copy;
}

- (void)setupUI {
    self.categoryTabbar.itemTitles = _categoryNames;
    [self.unsetButton addTarget:self action:@selector(unsetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [_currentCategoryPageView dismissDeleteButtons];
}

#pragma mark - property

- (TuSDKOnlineStickerDownloader *)stickerDownloader {
    if (!_stickerDownloader) {
        _stickerDownloader = [[TuSDKOnlineStickerDownloader alloc] init];
        _stickerDownloader.delegate = self;
    }
    return _stickerDownloader;
}

- (NSMutableDictionary *)downloadCallbackDic {
    if (!_downloadCallbackDic) {
        _downloadCallbackDic = [NSMutableDictionary dictionary];
    }
    return _downloadCallbackDic;
}

#pragma mark - action

- (void)unsetButtonAction:(UIButton *)sender {
    [self unsetSticker];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [_currentCategoryPageView dismissDeleteButtons];
}

#pragma mark - data source

#pragma mark ViewSliderDataSource

- (NSInteger)numberOfViewsInSlider:(ViewSlider *)slider {
    return _stickerCategorys.count;
}

- (UIView *)viewSlider:(ViewSlider *)slider viewAtIndex:(NSInteger)index {
    // 每个贴纸分类下的列表是一个 StickerCategoryPageView 独立页面，显示时创建，完全离开屏幕时销毁。
    StickerCategoryPageView *categoryView = [[StickerCategoryPageView alloc] initWithFrame:CGRectZero];
    categoryView.pageIndex = index;
    categoryView.dataSource = self;
    categoryView.delegate = self;
    return categoryView;
}

#pragma mark StickerCategoryPageViewDataSource

- (NSInteger)numberOfItemsInCategoryPageView:(StickerCategoryPageView *)pageView {
    return _stickerCategorys[pageView.pageIndex].stickers.count;
}

- (void)stickerCategoryPageView:(StickerCategoryPageView *)pageView setupStickerCollectionCell:(StickerCollectionCell *)cell atIndex:(NSInteger)index {
    TuSDKPFStickerGroup *sticker = _stickerCategorys[pageView.pageIndex].stickers[index];
    cell.selected = sticker.idt == _selectedStickerId;
    
    if ([sticker isKindOfClass:[OnlineStickerGroup class]]) {
        OnlineStickerGroup *onlineSticker = (OnlineStickerGroup *)sticker;
        [cell.thumbnailView lsq_setImageWithURL:[NSURL URLWithString:onlineSticker.previewImage]];
        cell.online = YES;
        if ([self.stickerDownloader isDownloadingWithGroupId:sticker.idt]) {
            [cell startLoading];
        }
    } else {
        [[TuSDKPFStickerLocalPackage package] loadThumbWithStickerGroup:sticker imageView:cell.thumbnailView];
        cell.online = NO;
    }
}

#pragma mark - delegate

#pragma mark StickerCategoryPageViewDelegate

/**
 删除按钮点击回调

 @param pageView 贴纸分类展示视图
 @param index 按钮索引
 */
- (void)stickerCategoryPageView:(StickerCategoryPageView *)pageView didTapDeleteButtonAtIndex:(NSInteger)index {
    NSString *title = @"确认删除本地文件？";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.currentCategoryPageView dismissDeleteButtons];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.currentCategoryPageView dismissDeleteButtons];
        TuSDKPFStickerGroup *sticker = self.stickerCategorys[pageView.pageIndex].stickers[index];
        [[TuSDKPFStickerLocalPackage package] removeDownloadWithIdt:sticker.idt];
        [self reloadDataWithStickerId:sticker.idt];
    }]];
    [[self viewController] presentViewController:alertController animated:YES completion:nil];
}

/**
 贴纸项选中回调

 @param pageView 贴纸分类展示视图
 @param cell 贴纸按钮
 @param index 按钮索引
 */
- (void)stickerCategoryPageView:(StickerCategoryPageView *)pageView didSelectCell:(StickerCollectionCell *)cell atIndex:(NSInteger)index {
    if (!cell) {
        [self unsetSticker];
        return;
    }
    TuSDKPFStickerGroup *sticker = _stickerCategorys[_currentCategoryPageView.pageIndex].stickers[index];
    _selectedStickerId = sticker.idt;
    
    if (cell.online) {
        [cell startLoading];
    }
    
    if ([sticker isKindOfClass:[OnlineStickerGroup class]]) {
        __weak typeof(self) weakSelf = self;
        NSInteger stickerId = sticker.idt;
        [self downloadStickerWithId:stickerId completion:^(BOOL success) {
            [weakSelf reloadDataWithStickerId:stickerId];
            if (weakSelf.selectedStickerId == stickerId) { // 应用贴纸
                [weakSelf applyStickerWithId:stickerId];
            }
        }];
    } else if ([sticker isKindOfClass:[TuSDKPFStickerGroup class]]) {
        [self applySticker:sticker];
    }
}

#pragma mark ViewSliderDelegate

- (void)viewSlider:(ViewSlider *)slider didSwitchToIndex:(NSInteger)index {
    [super viewSlider:slider didSwitchToIndex:index];
    _currentCategoryPageView = (StickerCategoryPageView *)slider.currentView;
}

#pragma mark TuSDKOnlineStickerDownloaderDelegate

/**
 贴纸下载结束回调

 @param stickerGroupId 贴纸分组 ID
 @param progress 下载进度
 @param status 下载状态
 */
- (void)onDownloadProgressChanged:(uint64_t)stickerGroupId progress:(CGFloat)progress changedStatus:(lsqDownloadTaskStatus)status {
    NSLog(@"sticker_%@: %@", @(stickerGroupId), @(progress));
    if (status == lsqDownloadTaskStatusDowned || status == lsqDownloadTaskStatusDownFailed) {
        BOOL success = status == lsqDownloadTaskStatusDowned;
        void (^downloaderCompletion)(BOOL success) = _downloadCallbackDic[@(stickerGroupId)];
        if (downloaderCompletion) {
            downloaderCompletion(success);
            [_downloadCallbackDic removeObjectForKey:@(stickerGroupId)];
        }
    }
}

#pragma mark - private

/**
 取消应用贴纸并更新 UI
 */
- (void)unsetSticker {
    [_currentCategoryPageView deselect];
    _selectedStickerId = -1;
    [self applySticker:nil];
}

/**
 使用回调应用贴纸

 @param stickerId 贴纸 ID
 */
- (void)applyStickerWithId:(uint64_t)stickerId {
    __weak typeof(self) weakSelf = self;
    [self.stickerCategorys enumerateObjectsUsingBlock:^(StickerCategory * stickerCategory, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL shouldBreak = NO;
        [stickerCategory.stickers enumerateObjectsUsingBlock:^(TuSDKPFStickerGroup * sticker, NSUInteger idx, BOOL * _Nonnull stop) {
            if (stickerId == sticker.idt) {
                [weakSelf applySticker:sticker];
                *stop = YES;
                shouldBreak = YES;
            }
        }];
        if (shouldBreak) *stop = YES;
    }];
}

/**
 使用回调应用贴纸

 @param sticker 贴纸
 */
- (void)applySticker:(TuSDKPFStickerGroup *)sticker {
    if ([self.delegate respondsToSelector:@selector(stickerPanel:didSelectSticker:)]) {
        [self.delegate stickerPanel:self didSelectSticker:sticker];
    }
}

/**
 更新当前页包含 stickerId 的单元格

 @param stickerId 贴纸 ID
 */
- (void)reloadDataWithStickerId:(uint64_t)stickerId {
    [[CameraStickerManager sharedManager] reloadData];
    [self loadStickers];
    
    // 获取当前页的分类
    StickerCategory *stickerCategory = _stickerCategorys[_currentCategoryPageView.pageIndex];
    NSArray *stickers = stickerCategory.stickers;
    
    // 更新当前页符合条件的单元格
    NSMutableArray *indexPathsNeedUpdate = [NSMutableArray array];
    for (int i = 0; i < stickers.count; i++) {
        TuSDKPFStickerGroup *sticker = stickers[i];
        if (sticker.idt == stickerId) {
            [indexPathsNeedUpdate addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    //NSLog(@"stickerCollectionView reloadItemsAtIndexPaths: %@", indexPathsNeedUpdate);
    [_currentCategoryPageView.stickerCollectionView reloadItemsAtIndexPaths:indexPathsNeedUpdate];
}

/**
 下载指定贴纸

 @param groupId 贴纸组 ID
 @param completion 完成操作回调
 */
- (void)downloadStickerWithId:(NSInteger)groupId completion:(void (^)(BOOL success))completion {
    if ([self.stickerDownloader isDownloadingWithGroupId:groupId]) return;
    [self.stickerDownloader downloadWithGroupId:groupId];
    if (completion) {
        self.downloadCallbackDic[@(groupId)] = completion;
    }
}

/**
 获取当前视图的控制器

 @return 视图控制器
 */
- (UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
        
        if ([responder isKindOfClass: [UIWindow class]])
            return (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    return nil;
}

@end
