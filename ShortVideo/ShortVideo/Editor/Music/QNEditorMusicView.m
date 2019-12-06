//
//  QNEditorMusicView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/22.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNEditorMusicView.h"

static CGFloat minInsertMusicDuration= 1.0;

@implementation MusicAddedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.adjustsFontSizeToFitWidth = NO;
        self.nameLabel.clipsToBounds = YES;
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
        self.nameLabel.layer.borderWidth = 2;
        self.nameLabel.layer.cornerRadius = 3;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(self.contentView);
            make.height.equalTo(30);
        }];
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.layer.cornerRadius = 3;
        self.selectedBackgroundView.layer.borderColor = QN_MAIN_COLOR.CGColor;
        self.selectedBackgroundView.layer.borderWidth = 2;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:.8 green:0 blue:0 alpha:.2];
        
        [self.selectedBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.nameLabel);
        }];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.selectedBackgroundView];
}

@end

@interface QNEditorMusicView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
QNMusicPickerViewDelegate
>
@property (nonatomic, assign) CMTime videoDuration;
@property (nonatomic, assign) CMTime currentTime;

// 时间线
@property (nonatomic, strong) UICollectionView *timelinwCollectionView;
@property (nonatomic, assign) BOOL isDragging;

// 已经添加的音乐 view
@property (nonatomic, strong) UILabel *addedLabel;
@property (nonatomic, strong) UICollectionView *addedCollectionView;

@property (nonatomic, strong) NSArray* thumbArray;

@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UIView *positionLineView;

// 选取音乐的 view，包括音频的播放和时间段选取
@property (nonatomic, strong, readwrite) QNMusicPickerView *musicPickerView;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong, readwrite) NSMutableArray <QNMusicModel *> *addedQNMusicModelArray;

@end

@implementation QNEditorMusicView

- (CGFloat)minViewHeight {
    return MAX(180, self.musicPickerView.minViewHeight);
}

- (instancetype)initWithThumbImage:(NSArray<UIImage *> *)thumbArray videoDuration:(CMTime)duration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.thumbArray = [thumbArray copy];
        self.videoDuration = duration;
        self.currentTime = kCMTimeZero;
        self.addedQNMusicModelArray = [[NSMutableArray alloc] init];
        self.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
        
        self.doneButton = [[UIButton alloc] init];
        [self.doneButton setImage:[UIImage imageNamed:@"qn_done"] forState:(UIControlStateNormal)];
        [self.doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:self.doneButton];

        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(60, 50));
            make.right.top.equalTo(self);
        }];
        
        self.currentTimeLabel = [[UILabel alloc] init];
        self.currentTimeLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.currentTimeLabel.textColor = [UIColor lightTextColor];
        self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.currentTimeLabel.text = @"音乐 - 滑动选择插入点";
        
        [self addSubview:self.currentTimeLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30, 50);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 30);
        self.timelinwCollectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.timelinwCollectionView.delegate = self;
        self.timelinwCollectionView.dataSource = self;
        self.timelinwCollectionView.backgroundColor = [UIColor clearColor];
        self.timelinwCollectionView.showsHorizontalScrollIndicator = NO;
        [self.timelinwCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"timelinwCell"];
        [self addSubview:self.timelinwCollectionView];
        
        self.positionLineView = [[UIView alloc] init];
        self.positionLineView.backgroundColor = [UIColor whiteColor];
        self.positionLineView.layer.cornerRadius = 2;
        [self addSubview:self.positionLineView];
        [self.positionLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.timelinwCollectionView);
            make.height.equalTo(self.timelinwCollectionView).offset(10);
            make.width.equalTo(4);
        }];
        
        self.addButton = [[UIButton alloc] init];
        [self.addButton setImage:[UIImage imageNamed:@"qn_edit_add"] forState:(UIControlStateNormal)];
        [self.addButton addTarget:self action:@selector(clickAddButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.deleteButton = [[UIButton alloc] init];
        self.deleteButton.hidden = YES;
        [self.deleteButton setImage:[UIImage imageNamed:@"qn_edit_delete"] forState:(UIControlStateNormal)];
        [self.deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.addButton];
        [self addSubview:self.deleteButton];
        
        self.addedLabel = [[UILabel alloc] init];
        self.addedLabel.textColor = [UIColor lightTextColor];
        self.addedLabel.text = @"已添加:";
        self.addedLabel.font = [UIFont systemFontOfSize:14];
        [self.addedLabel sizeToFit];
        [self addSubview:self.addedLabel];
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 40);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 40);
        self.addedCollectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.addedCollectionView.delegate = self;
        self.addedCollectionView.dataSource = self;
        self.addedCollectionView.allowsMultipleSelection = NO;
        self.addedCollectionView.backgroundColor = [UIColor clearColor];
        self.addedCollectionView.showsHorizontalScrollIndicator = NO;
        [self.addedCollectionView registerClass:MusicAddedCell.class forCellWithReuseIdentifier:@"addedCell"];
        [self addSubview:self.addedCollectionView];
        
        self.musicPickerView = [[QNMusicPickerView alloc] initWithFrame:CGRectZero needNullModel:NO];
        self.musicPickerView.delegate = self;
        self.musicPickerView.minMusicSelectDuration = minInsertMusicDuration;
        [self addSubview:self.musicPickerView];
        
        [self.timelinwCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.doneButton.mas_bottom);
            make.height.equalTo(50);
        }];
        
        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.doneButton);
        }];
        
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.timelinwCollectionView.mas_bottom);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.size.top.equalTo(self.addButton);
        }];
        
        [self.addedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.size.equalTo(self.addedLabel.bounds.size);
            make.centerY.equalTo(self.addedCollectionView);
        }];
        
        [self.addedCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addedLabel.mas_right).offset(10);
            make.right.equalTo(self.doneButton);
            make.top.equalTo(self.addButton.mas_bottom);
            make.height.equalTo(40);
        }];
        
        [self.musicPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self);
            make.top.equalTo(self.mas_bottom);
        }];
        
        [self.timelinwCollectionView setContentInset:UIEdgeInsetsMake(0, UIScreen.mainScreen.bounds.size.width/2, 0, UIScreen.mainScreen.bounds.size.width/2)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

- (void)setPlayingTime:(CMTime)time {
    if (self.isDragging) return;
    
    self.currentTime = time;
    CGFloat originX = [self timeToPosition:time];
    self.timelinwCollectionView.contentOffset = CGPointMake(originX - self.timelinwCollectionView.contentInset.left, 0);
    self.currentTimeLabel.text = [NSString stringWithFormat:@"音乐 - 滑动选择插入点: %0.1fs", CMTimeGetSeconds(time)];
}

#pragma mark - button actions

- (void)clickDoneButton:(UIButton *)button {
    [self.musicPickerView stopAudioPlay];
    self.doneButton.selected = NO;
    [self.delegate editorMusicViewDoneButtonClick:self];
}

- (void)clickAddButton {
    if (CMTimeGetSeconds(CMTimeSubtract(self.videoDuration, self.currentTime)) < minInsertMusicDuration) {
        [self showTip:@"可插入的音乐时长太短，请重新选择音乐插入点"];
        return;
    }
    
    [self showMusicPickerView];
}

- (void)clickDeleteButton {
    NSArray *selectedPaths = [self.addedCollectionView indexPathsForSelectedItems];
    NSIndexPath *path = nil;
    if (0 == selectedPaths.count > 0) return;
    path = selectedPaths[0];
    NSInteger index = path.item;
    
    QNMusicModel *model = self.addedQNMusicModelArray[index];
    
    [model.colorView removeFromSuperview];
    [self.addedQNMusicModelArray removeObject:model];
    [self.addedCollectionView reloadData];
    self.deleteButton.hidden = YES;
    
    [self.delegate editorMusicView:self updateMusicInfo:self.addedQNMusicModelArray];
}

#pragma mark - show/hide music picker view

- (BOOL)musicPickerViewIsShow {
    return self.musicPickerView.frame.origin.y < self.bounds.size.height;
}

- (void)showMusicPickerView {
    [self.delegate editorMusicViewWillShowPickerMusicView:self];
    
    [self.musicPickerView startAudioPlay];
    [self.musicPickerView autoLayoutBottomShow:YES];
    self.musicPickerView.titleLabel.text = [NSString stringWithFormat:@"最多可以添加 %0.1fs 的音乐", CMTimeGetSeconds(CMTimeSubtract(self.videoDuration, self.currentTime))];
}

- (void)hideMusicPickerView {
    [self.delegate editorMusicViewWillHidePickerMusicView:self];
    
    [self.musicPickerView autoLayoutBottomHide:YES];
    [self.musicPickerView stopAudioPlay];
}

- (void)alertViewAnimation:(UIView *)view {
    [UIView animateWithDuration:.2 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            view.alpha = 1;
        }];
    }];
}

- (CMTime)positionToTime:(CGFloat)originX {
    if (originX < 0) {
        return kCMTimeZero;
    }
    if (originX > self.timelinwCollectionView.contentSize.width) {
        return self.videoDuration;
    }
    CGFloat value = CMTimeGetSeconds(self.videoDuration) * originX / self.timelinwCollectionView.contentSize.width;
    return CMTimeMake(1000 * value, 1000);
}

- (CGFloat)timeToPosition:(CMTime)originTime {
    CGFloat value = CMTimeGetSeconds(originTime);
    if (value <= 0) {
        return 0;
    }
    if (value >= CMTimeGetSeconds(self.videoDuration)) {
        return self.timelinwCollectionView.contentSize.width;
    }
    return value / CMTimeGetSeconds(self.videoDuration) * self.timelinwCollectionView.contentSize.width;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.timelinwCollectionView) return;
    if (!self.isDragging) return;
    
    CGFloat originX = self.timelinwCollectionView.contentOffset.x + self.timelinwCollectionView.contentInset.left;
    CMTime time = [self positionToTime:originX];
    [self.delegate editorMusicView:self wantSeekPlayerTo:time];
    self.currentTimeLabel.text = [NSString stringWithFormat:@"音乐 - 滑动选择音乐插入点: %0.1fs", CMTimeGetSeconds(time)];
    self.currentTime = time;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.timelinwCollectionView) return;
    self.isDragging = YES;
    [self.delegate editorMusicViewWillBeginDragging:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.timelinwCollectionView) return;
    if (decelerate) return;
    
    self.isDragging = NO;
    [self.delegate editorMusicViewWillEndDragging:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.timelinwCollectionView) return;
    self.isDragging = NO;
    [self.delegate editorMusicViewWillEndDragging:self];
}

#pragma mark - UICollectionView delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.timelinwCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timelinwCell" forIndexPath:indexPath];
        
        static NSInteger imageViewTag = 0x1234;
        
        UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
        if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.tag = imageViewTag;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        
        if (self.thumbArray.count > indexPath.item) {
            imageView.image = self.thumbArray[indexPath.item];
        }
        
        return cell;
        
    } else {
        
        MusicAddedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addedCell" forIndexPath:indexPath];
        
        if (self.addedQNMusicModelArray.count > indexPath.item) {
            QNMusicModel *model = [self.addedQNMusicModelArray objectAtIndex:indexPath.item];
            cell.nameLabel.text = model.musicName;
        }
        
        
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.timelinwCollectionView) {
        return self.thumbArray.count;
    } else {
        return self.addedQNMusicModelArray.count;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.addedCollectionView) {
        QNMusicModel *model = [self.addedQNMusicModelArray objectAtIndex:indexPath.item];
        [self.timelinwCollectionView bringSubviewToFront:model.colorView];
        [self alertViewAnimation:model.colorView];
        [self setPlayingTime:model.startPositionTime];
        [self.deleteButton alphaShowAnimation];
        [self.delegate editorMusicView:self wantSeekPlayerTo:model.startPositionTime];
    }
}

#pragma mark - QNMusicPickerViewDelegate

- (void)musicViewCancelButtonClick:(QNMusicPickerView *)musicPickerView {
    [self hideMusicPickerView];
}

- (void)musicPickerView:(QNMusicPickerView *)musicPickerView didEndPickerWithMusic:(QNMusicModel *)model {
    [self hideMusicPickerView];
    
    if (model) {
        QNMusicModel *musicModel = [[QNMusicModel alloc] init];
        musicModel.musicName = model.musicName;
        musicModel.musicURL = model.musicURL;
        musicModel.duration = model.duration;
        musicModel.startTime = model.startTime;
        musicModel.endTime = model.endTime;
        musicModel.startPositionTime = self.currentTime;
        musicModel.endPositiontime = CMTimeAdd(musicModel.startPositionTime, CMTimeSubtract(model.endTime, model.startTime));
        if (1 == CMTimeCompare(musicModel.endPositiontime, self.videoDuration)) {
            musicModel.endPositiontime = self.videoDuration;
        }
        
        UIView *colorView = [[UIView alloc] init];
        colorView.backgroundColor = musicModel.randomColor;
        CGFloat xStart = [self timeToPosition:musicModel.startPositionTime];
        CGFloat xEnd = [self timeToPosition:musicModel.endPositiontime];
        CGRect rc = CGRectMake(xStart, 0, xEnd - xStart, self.timelinwCollectionView.frame.size.height);
        colorView.frame = rc;
        musicModel.colorView = colorView;
        
        [self.addedQNMusicModelArray addObject:musicModel];
        [self.timelinwCollectionView addSubview:colorView];
        [self alertViewAnimation:colorView];
        
        [self.addedCollectionView reloadData];
        [self.deleteButton alphaHideAnimation];;
        
        [self.delegate editorMusicView:self updateMusicInfo:self.addedQNMusicModelArray];
    }
}

@end
