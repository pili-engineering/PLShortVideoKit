//
//  PLSClipMulitMediaView.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/2.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSClipMulitMediaView.h"
#import <Photos/Photos.h>
#import "PLShortVideoKit/PLShortVideoKit.h"

#ifndef MAS_SHORTHAND_GLOBALS
    #define MAS_SHORTHAND_GLOBALS
#endif

#import <Masonry.h>

@interface PLSClipMulitMediaView ()

@property (nonatomic, strong) NSLock *lock;
    
@property (nonatomic, strong) UIButton  *cutButton;
@property (nonatomic, strong) UIButton  *insertButton;
@property (nonatomic, strong) UIButton  *continueButton;
@property (nonatomic, strong) UILabel   *durationLabel;
@property (nonatomic, strong) UILabel   *positionTimeLabel;

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIImageView       *positionLine;

@property (nonatomic, strong) NSMutableArray <AVAssetImageGenerator *> *imageGeneratorArray;
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *thumbImageArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *thumbCountArray;

@property (nonatomic, strong) NSMutableArray <PLSRangeMedia *>    *clipMediaArray;

@property (nonatomic, assign) CGFloat   positionOffset;
@property (nonatomic, assign) CGFloat   totalDuration;

@property (nonatomic, assign) NSInteger mediaInsertPosition;

/**
    标记变量。在手滑动collectionview的时候，会将播放器的进度设置到对应的collectionview滑动的位置，而播放器播放位置变化的时候，也会来设置collectionView的contentoffset，避免循环作用，在手使collectionview.contentOffset发生变化的时候，播放器的播放位置变化将不会作用于collectionview.contentOffset
 */
@property (nonatomic, assign) BOOL isDragging;

@end

@implementation PLSClipMulitMediaView

- (void)dealloc {
    [self removeObservers];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lock = [[NSLock alloc] init];
        self.clipMediaArray     = [[NSMutableArray alloc] init];
        self.thumbImageArray    = [[NSMutableArray alloc] init];
        self.thumbCountArray    = [[NSMutableArray alloc] init];
        _fillMode = PLSVideoFillModePreserveAspectRatioAndFill;
        
        [self initTopBar];
        
        [self initSwipControl];
    }
    
    [self addObservers];
    
    return self;
}

- (void)showAlert:(NSString *)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)initTopBar {
    
    self.durationLabel             = [[UILabel alloc] init];
    self.durationLabel.font        = [UIFont systemFontOfSize:12];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        self.durationLabel.font    = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightBold)];
    }
    self.durationLabel.textColor   = [UIColor whiteColor];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    
    self.positionTimeLabel             = [[UILabel alloc] init];
    self.positionTimeLabel.font        = [UIFont systemFontOfSize:12];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        self.positionTimeLabel.font    = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightBold)];
    }
    self.positionTimeLabel.textColor   = [UIColor whiteColor];
    self.positionTimeLabel.textAlignment = NSTextAlignmentCenter;

    self.cutButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.cutButton setTitle:@"切割" forState:UIControlStateNormal];
    self.cutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cutButton setTintColor:[UIColor whiteColor]];
    [self.cutButton addTarget:self action:@selector(clickCutButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.insertButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.insertButton setTitle:@"插入" forState:UIControlStateNormal];
    self.insertButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.insertButton setTintColor:[UIColor whiteColor]];
    [self.insertButton addTarget:self action:@selector(clickInsertButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.continueButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.continueButton setTitle:@"完成" forState:UIControlStateNormal];
    self.continueButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.continueButton setTintColor:[UIColor whiteColor]];
    [self.continueButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIView *superView = self;
    [superView addSubview:self.continueButton];
    [superView addSubview:self.insertButton];
    [superView addSubview:self.cutButton];
    [superView addSubview:self.durationLabel];
    [superView addSubview:self.positionTimeLabel];
    
    [self.cutButton sizeToFit];
    [self.cutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.size.equalTo(self.cutButton.bounds.size);
    }];
    
    [self.insertButton sizeToFit];
    [self.insertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.size.equalTo(self.insertButton.bounds.size);
    }];
    
    [self.continueButton sizeToFit];
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.size.equalTo(self.continueButton.bounds.size);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cutButton);
        make.left.equalTo(self.cutButton.mas_right).offset(10);
        make.right.equalTo(self.continueButton.mas_left).offset(10);
    }];
}

- (void)initSwipControl {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing       = 0;
    layout.minimumInteritemSpacing  = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource      = self;
    self.collectionView.delegate        = self;
    self.collectionView.bounces         = NO;
    self.collectionView.delaysContentTouches            = NO;
    self.collectionView.showsHorizontalScrollIndicator  = NO;
    
    self.positionLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cut_bar_progress"]];
    
    UIView *superView = self;
    [superView addSubview:self.collectionView];
    [superView addSubview:self.positionLine];
    
    superView = self.collectionView;
    
    [self.positionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(superView);
        make.centerX.equalTo(self);
        make.width.equalTo(self.positionLine.image.size.width);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.insertButton.mas_bottom).offset(10);
        make.height.equalTo(60);
        make.width.equalTo(self).offset(-20);
    }];
    
    
    [self.positionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.positionLine.mas_bottom).offset(2);
    }];
}

// 切割一个视频
- (void)clickCutButton:(UIButton *)sender {
    
    CGFloat startX = -1;
    CGFloat endX = -1;
    NSInteger section = -1;
    
    [self getCenterSectionPosition:&startX endX:&endX section:&section];
    
    if (-1 == startX ||
        -1 == endX ||
        -1 == section) {
        return;
    }
    
    PLSRangeMedia *media = self.clipMediaArray[section];
    if (media.isTransition) {//禁止切割转场视频，开发者可以去掉限制
        [self showAlert:@"转场视频不支持切割"];
        return;
    }
    
    CGPoint point       = [self convertPoint:self.positionLine.center toView:self.collectionView];
    CGFloat duration    = CMTimeGetSeconds(CMTimeSubtract(media.endTime, media.startTime));
    CGFloat frontWidth  = point.x - startX;
    CGFloat frontDuration = duration * frontWidth / (endX - startX);
    CMTime cutTime = CMTimeAdd(media.startTime, CMTimeMake(frontDuration * 1000, 1000));
    
    //小于1秒的视频和某个分段小于.5秒的视频不让切割，开发者可以去掉限制
    if (duration < 1 || frontDuration <.5 || duration - frontDuration < .5) {
        [self showAlert:@"视频太短了,每一段视频必须大于0.5秒"];
        return;
    }
    
    PLSRangeMedia *newMedia   = [[PLSRangeMedia alloc] init];
    newMedia.asset              = media.asset;
    newMedia.endTime    = media.endTime;
    newMedia.startTime  = cutTime;
    media.endTime       = cutTime;
    
    [_clipMediaArray insertObject:newMedia atIndex:[self.clipMediaArray indexOfObject:media] + 1];
    
    [self mediaArrayHasUpdate];
}

// 插入一个视频
- (void)clickInsertButton:(UIButton *)sender {

    CGPoint point = [self convertPoint:self.positionLine.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(point.x - 21, point.y)];
    if (!indexPath) {
        indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(point.x + 20, point.y)];
        self.mediaInsertPosition = indexPath.section;//加入到第0个section
    } else {
        self.mediaInsertPosition = indexPath.section + 1;
    }
    if (!indexPath) return;
    
    if (self.clipMediaArray.count < indexPath.section) return;
    
    [self.delegate clipView:self insertVideoWithAsset:self.clipMediaArray[indexPath.section].asset];
}

// 所有视频分段完成之后
- (void)clickDoneButton:(UIButton *)sender {
    [self.delegate clipView:self finishClip:self.clipMediaArray];
}

// 删除某一分段
- (void)deleteAction {
    
    CGPoint point = [self convertPoint:self.positionLine.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (!indexPath) return;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除本段？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.clipMediaArray removeObjectAtIndex:indexPath.section];
        [self mediaArrayHasUpdate];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];

    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    UIViewController *controller = [UIApplication sharedApplication].windows[0].rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)setFillMode:(PLSVideoFillModeType)fillMode {
    _fillMode = fillMode;
    [self mediaArrayHasUpdate];
}

// 分段视频有更新,包括删除，插入转场视频，插入新视频，切割视频
- (void)mediaArrayHasUpdate {
    
    if (0 == _clipMediaArray.count) {
        [self.delegate clipView:self finishClip:nil];
        return;
    }
    
    [self refreshThumbImage:nil];

    AVPlayerItem *playItem = [PLSRangeMediaTools playerItemWithRangeMedia:_clipMediaArray videoSize:CGSizeMake(540, 960) fillMode:self.fillMode];
    [self.delegate clipView:self refreshPlayItem:playItem];
}

// set方法，
- (void)setAssetArray:(NSArray<AVAsset *> *)assetArray {
    _assetArray = assetArray;
    
    @synchronized(self.clipMediaArray) {
        self.totalDuration = 0;
        [self.clipMediaArray removeAllObjects];
        for (int i = 0; i < assetArray.count; i ++) {
            
            PLSRangeMedia *mediaObj   = [[PLSRangeMedia alloc] init];
            mediaObj.asset              = assetArray[i];
            mediaObj.startTime  = CMTimeMake(0, 1000);
            mediaObj.endTime    = mediaObj.asset.duration;
            self.totalDuration         += CMTimeGetSeconds(CMTimeSubtract(mediaObj.endTime, mediaObj.startTime));
            
            [self.clipMediaArray addObject:mediaObj];
        }
    }
    
    [self mediaArrayHasUpdate];
}

// 添加转场字母
- (void)addTransition:(AVAsset *)asset {
    
    PLSRangeMedia *mediaObj   = [[PLSRangeMedia alloc] init];
    mediaObj.asset              = asset;
    mediaObj.isTransition       = YES;
    mediaObj.startTime  = CMTimeMake(0, 1000);
    mediaObj.endTime    = mediaObj.asset.duration;
    self.totalDuration         += CMTimeGetSeconds(CMTimeSubtract(mediaObj.endTime, mediaObj.startTime));
    
    @synchronized(self.clipMediaArray) {
        [self.clipMediaArray insertObject:mediaObj atIndex:self.mediaInsertPosition];
    }
    
    [self mediaArrayHasUpdate];
}


// KVO
static int clipKVOContext = 0;

static NSString *keyPaths [] = {
    @"collectionView.contentOffset",
};

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew;
    for (int i = 0; i < ARRAY_SIZE(keyPaths); i ++) {
        [self addObserver:self forKeyPath:keyPaths[i] options:options context:&clipKVOContext];
    }
}

- (void)removeObservers {
    for (int i = 0; i < ARRAY_SIZE(keyPaths); i ++) {
        [self removeObserver:self forKeyPath:keyPaths[i]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (&clipKVOContext != context) return;
    
    NSValue *newValue = change[NSKeyValueChangeNewKey];
    
    if ([keyPaths[0] isEqualToString:keyPath]) {
        [self collectionViewContentOffsetChange:[newValue CGPointValue]];
    }
}

// 监听collectionView的contentOffset来设置按钮的显示和隐藏
- (void)collectionViewContentOffsetChange:(CGPoint)contentOffset {
    
    CGPoint point = [self convertPoint:self.positionLine.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (indexPath) {
        self.cutButton.hidden       = NO;
        self.insertButton.hidden    = YES;
        self.durationLabel.hidden   = NO;
        self.positionTimeLabel.hidden = NO;
    } else {
        self.cutButton.hidden       = YES;
        self.insertButton.hidden    = NO;
        self.durationLabel.hidden   = YES;
        self.positionTimeLabel.hidden = YES;
        return;
    }
    
    if (indexPath.section >= _clipMediaArray.count) return;
    
    CMTime duration = CMTimeSubtract(_clipMediaArray[indexPath.section].endTime, _clipMediaArray[indexPath.section].startTime);
    self.durationLabel.text = [NSString stringWithFormat:@"%3.1f\"", CMTimeGetSeconds(duration)];
    
    CGFloat startX      = -1;
    CGFloat endX        = -1;
    NSInteger section   = -1;
    
    [self getCenterSectionPosition:&startX endX:&endX section:&section];

    CGFloat position = CMTimeGetSeconds(duration) * (point.x - startX) / (endX - startX);
    self.positionTimeLabel.text = [NSString stringWithFormat:@"%3.1f\"", fabs(position)];
}

// 对collectionview的section进行 self.collectionView.bounds.size.width/2 的 inset 之后，位置和时长的换算要加上或减去这个值
- (CGFloat)positionOffset {
    return self.collectionView.bounds.size.width / 2 + 20;//20的宽度用于插入片头或者片尾
}

// 对外方法，根据播放时间点设置collecview的contentoffset，保证self.positionLine在collectionView的位置始终在当前播放点
- (void)setPlayPosition:(CMTime)playPositon{
    //防止循环调用
    if (self.isDragging) return;
    if (0 == CMTimeCompare(playPositon, kCMTimeZero)) return;
    
    int index = 0;
    for (index = 0 ; index < self.clipMediaArray.count; index ++) {
        PLSRangeMedia *media = self.clipMediaArray[index];
        CMTime duration = CMTimeSubtract(media.endTime, media.startTime);
        
        if (-1 == CMTimeCompare(playPositon, duration)) break;
        
        playPositon  = CMTimeSubtract(playPositon, duration);
    }
    
    if (index >= self.clipMediaArray.count) return;
    
    PLSRangeMedia *media      = self.clipMediaArray[index];
    NSInteger itemCount         = [self.collectionView numberOfItemsInSection:index];
    NSIndexPath *startPath      = [NSIndexPath indexPathForRow:0 inSection:index];
    NSIndexPath *endIndexPath   = [NSIndexPath indexPathForRow:itemCount - 1 inSection:index];
    
    UICollectionViewLayoutAttributes *startAttributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:startPath];
    UICollectionViewLayoutAttributes *endAttributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:endIndexPath];
    
    CGFloat startX  = startAttributes.frame.origin.x;
    CGFloat endX    = endAttributes.frame.origin.x + endAttributes.frame.size.width;
    
    CGFloat position = CMTimeGetSeconds(playPositon);
    CGFloat duration = CMTimeGetSeconds(CMTimeSubtract(media.endTime, media.startTime));
    CGFloat frontWidth = (endX - startX) * position / duration;
    
    CGFloat seekOriginX = startX + frontWidth;
    [self.collectionView setContentOffset:CGPointMake(seekOriginX - self.collectionView.bounds.size.width/2, 0)];
}

// 获取positionline在collectionview中的frame和所在section
- (void)getCenterSectionPosition:(CGFloat *)startX endX:(CGFloat *)endX section:(NSInteger *)section {
    
    CGPoint point = [self convertPoint:self.positionLine.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (!indexPath) return;
    
    NSInteger itemCount         = [self.collectionView numberOfItemsInSection:indexPath.section];
    NSIndexPath *startPath      = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    NSIndexPath *endIndexPath   = [NSIndexPath indexPathForRow:itemCount - 1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *startAttributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:startPath];
    UICollectionViewLayoutAttributes *endAttributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:endIndexPath];
    *startX     = startAttributes.frame.origin.x;
    *endX       = endAttributes.frame.origin.x + endAttributes.frame.size.width;
    *section    = indexPath.section;
}

// 每次编辑的视频变化之后、重新获取thumbImage，Demo为了方便，每次更新都重新获取缩率图，有点浪费资源，开发者可以自己优化
- (void)refreshThumbImage:(AVAsset *)asset {

    [self.lock lock];
    
    for (AVAssetImageGenerator *generator in self.imageGeneratorArray) {
        [generator cancelAllCGImageGeneration];
    }
    [self.imageGeneratorArray removeAllObjects];
    [self.thumbCountArray removeAllObjects];
    [self.thumbImageArray removeAllObjects];

    dispatch_main_async_safe(^{
        [self.collectionView reloadData];
    });
    
    for (int i = 0; i < _clipMediaArray.count; i ++) {
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        
        float duration = CMTimeGetSeconds(_clipMediaArray[i].endTime) - CMTimeGetSeconds(_clipMediaArray[i].startTime);
        float spaceTime = 1;//默认 1s 取一帧, 可以根据实际需要随时改变值
        for (int j = 0; j * spaceTime <= duration; j ++) {
            CMTime time = CMTimeMake(j * spaceTime * 1000, 1000);
            time = CMTimeAdd(time, _clipMediaArray[i].startTime);
            [timeArray addObject:[NSValue valueWithCMTime:time]];
        }
        [self.thumbCountArray addObject:[NSNumber numberWithInteger:timeArray.count]];
        
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:_clipMediaArray[i].asset];
        imageGenerator.requestedTimeToleranceAfter       = kCMTimeZero;
        imageGenerator.requestedTimeToleranceBefore      = kCMTimeZero;
        imageGenerator.appliesPreferredTrackTransform    = YES;
        CGFloat scale = [UIScreen mainScreen].scale;
        imageGenerator.maximumSize = CGSizeMake(scale * 40, scale * 60);
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        [self.thumbImageArray addObject:imageArray];
        
        __weak typeof(self) weakSelf = self;
        [imageGenerator generateCGImagesAsynchronouslyForTimes:timeArray completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            if (image && AVAssetImageGeneratorSucceeded == result) {
                [imageArray addObject:[UIImage imageWithCGImage:image]];
                dispatch_main_async_safe(^{
                    [weakSelf.collectionView reloadData];
                });
            }
        }];
    }
    
    [self.lock unlock];
}

// 实现collectionView的滑动代理方法，随时将播放器的当前时间点seek到当前的collectionView的中间点位置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isDragging) {
        
        CGFloat position = scrollView.contentOffset.x;
        if (position < 0) {
            position = 0;
        }
        if (position > scrollView.contentSize.width - scrollView.bounds.size.width) {
            position = scrollView.contentSize.width - scrollView.bounds.size.width;
        }
        
        CGFloat startX      = -1;
        CGFloat endX        = -1;
        NSInteger section   = -1;
        
        [self getCenterSectionPosition:&startX endX:&endX section:&section];
        
        if (-1 == startX ||
            -1 == endX ||
            -1 == section) {
            return;
        }
        
        CGPoint point = [self convertPoint:self.positionLine.center toView:self.collectionView];
        
        PLSRangeMedia *media  = self.clipMediaArray[section];
        CGFloat duration        = CMTimeGetSeconds(CMTimeSubtract(media.endTime, media.startTime));
        CGFloat frontWidth      = point.x - startX;
        CGFloat frontDuration   = duration * frontWidth / (endX - startX);
        CMTime seekTime         = CMTimeMake(frontDuration * 1000, 1000);
        for (int i = 0; i < section; i ++) {
            media = [self.clipMediaArray objectAtIndex:i];
            seekTime = CMTimeAdd(seekTime, CMTimeSubtract(media.endTime, media.startTime));
        }
        
        [self.delegate clipView:self seekToTime:seekTime];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
    [self.delegate clipScrollViewWillBeginDragging:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isDragging = decelerate;
    if (!self.isDragging) {
        [self.delegate clipScrollViewWillEndDragging:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isDragging = NO;
    [self.delegate clipScrollViewWillEndDragging:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.thumbCountArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.thumbCountArray objectAtIndex:section] integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
#define IMAGE_VIEW_TAG 0x24
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = IMAGE_VIEW_TAG;
        [cell.contentView addSubview:imageView];
    }

    if (indexPath.section < self.thumbImageArray.count &&
        indexPath.row < [self.thumbImageArray objectAtIndex:indexPath.section].count) {
            imageView.image = [[self.thumbImageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        imageView.image = [UIImage imageNamed:@"mv4"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, collectionView.bounds.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return CGSizeMake(self.positionOffset, collectionView.bounds.size.height);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.clipMediaArray.count - 1) {
        return CGSizeMake(self.positionOffset, collectionView.bounds.size.height);
    }
    return CGSizeMake(20, collectionView.bounds.size.height);;
}

@end
