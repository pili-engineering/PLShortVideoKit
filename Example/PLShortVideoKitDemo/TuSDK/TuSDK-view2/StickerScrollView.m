//
//  StickerScrollView.m
//  TuSDKVideoDemo
//
//  Created by tutu on 2017/3/10.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import "StickerScrollView.h"
#import "StickerCollectionViewCell.h"

@interface StickerScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource, TuSDKOnlineStickerDownloaderDelegate>{
    UICollectionView *_collectionView;
    // 贴纸下载对象
    TuSDKOnlineStickerDownloader *_stickerDownloader;
    // 当前选中的cell
    NSIndexPath *_selectedIndexPath;
}

@end

@implementation StickerScrollView

#pragma mark - setter getter

- (void)setCameraStickerType:(lsqCameraStickersType)cameraStickerType;
{
    if (_cameraStickerType != cameraStickerType) {
        _cameraStickerType = cameraStickerType;
        [self initStickersData];
    }
}

#pragma mark - 视图布局方法

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self createStickerCollection];
    }
    return self;
}

- (void)createStickerCollection
{
    // 创建FlowLayout方式
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(60, 60);
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 创建collection
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.showsVerticalScrollIndicator = false;
    _collectionView.showsHorizontalScrollIndicator = false;
    
    [_collectionView registerClass:[StickerCollectionViewCell class] forCellWithReuseIdentifier:@"stickerCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    _stickerDownloader = [[TuSDKOnlineStickerDownloader alloc]init];
    _stickerDownloader.delegate = self;
    
    self.cameraStickerType = lsqCameraStickersTypeAll;
    
}

- (void)initStickersData;
{
    // 获取贴纸组数据源
    NSArray<TuSDKPFStickerGroup *> *allStickes = [[TuSDKPFStickerLocalPackage package] getSmartStickerGroups];
    NSString *jsonFileName = @"";
    
    if (_cameraStickerType == lsqCameraStickersTypeAll) {
        _stickerGroups = allStickes;
        return;
    }else if (_cameraStickerType == lsqCameraStickersTypeSquare){
        jsonFileName = @"squareSticker";
    }else if (_cameraStickerType == lsqCameraStickersTypeFullScreen){
        jsonFileName = @"fullScreenSticker";
    }
    
    // 解析JSON 获取正方形贴纸数组
    NSString *configJsonPath = [[NSBundle mainBundle]pathForResource:jsonFileName ofType:@"json"];
    NSDictionary *squareStickersDic = [[NSString stringWithContentsOfFile:configJsonPath encoding:NSUTF8StringEncoding error:nil] lsqToJson];
    NSMutableArray<NSDictionary *> *list = [NSMutableArray arrayWithArray:[squareStickersDic objectForKey:@"stickerGroups"]];
    
    // 获取贴纸信息
    NSMutableArray *stickerArr = [[NSMutableArray alloc]init];
    [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        uint64_t stickerID = (uint64_t)[[obj objectForKey:@"id"] intValue];
        BOOL localStickersContains = NO;
        
        for (TuSDKPFStickerGroup *group in allStickes) {
            if (group.idt == stickerID) {
                localStickersContains = YES;
                [stickerArr addObject:group];
                break;
            }
        }
        if (!localStickersContains) {
            [stickerArr addObject:obj];
        }
    }];

    _stickerGroups = nil;
    _stickerGroups = [NSArray arrayWithArray:stickerArr];
    
    [_collectionView reloadData];
}

#pragma mark -- collection代理方法 collectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentStickesIndex = indexPath.row;
    if ([self.stickerDelegate respondsToSelector:@selector(clickStickerViewWith:)]) {
        if (indexPath.row == 0) {
            [self.stickerDelegate clickStickerViewWith:nil];
        }else{
            if ([_stickerGroups[indexPath.row-1] isMemberOfClass:[TuSDKPFStickerGroup class]]) {
                // 贴纸已存在
                [self.stickerDelegate clickStickerViewWith:_stickerGroups[indexPath.row-1]];
            }else{
                // 需下载元素类型为 dictionary
                NSDictionary *stickerDic = (NSDictionary *)_stickerGroups[indexPath.row - 1];
                NSInteger stickerID = [[stickerDic objectForKey:@"id"] integerValue];
                
                if (![_stickerDownloader isDownloadingWithGroupId:stickerID]) {
                    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                    [cell displayDownloadingView];
                    
                    [_stickerDownloader downloadWithGroupId:stickerID];
                }
            }
        }
    }
    
    // 给cell添加选中边框
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        cell.borderColor = lsqRGB(244, 161, 24);
        _selectedIndexPath = indexPath;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 给上一个选中的cell取消选中边框
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.borderColor = [UIColor clearColor];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
        StickerCollectionViewCell *stickerCell = (StickerCollectionViewCell *)cell;
        stickerCell.borderColor = lsqRGB(244, 161, 24);
        
        [_collectionView selectItemAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        // 判断贴纸是否存在
        if ([_stickerGroups[indexPath.row-1] isMemberOfClass:[TuSDKPFStickerGroup class]]) {
            // 贴纸已存在
            [self.stickerDelegate clickStickerViewWith:_stickerGroups[indexPath.row-1]];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _stickerGroups.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置cell
    StickerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stickerCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        // 第一张图固定
        [cell initCellViewWith:nil];
    }else{
        [cell initCellViewWith:_stickerGroups[indexPath.row-1]];
    }
    
    return cell;
}

#pragma mark - TuSDKOnlineStickerDownloaderDelegate

- (void)onDownloadProgressChanged:(uint64_t)stickerGroupId progress:(CGFloat)progress changedStatus:(lsqDownloadTaskStatus)status;
{
    if (status == lsqDownloadTaskStatusDowned) {
        [self initStickersData];
    }else if (status == lsqDownloadTaskStatusDownFailed){
        [self initStickersData];
    }
}

@end
