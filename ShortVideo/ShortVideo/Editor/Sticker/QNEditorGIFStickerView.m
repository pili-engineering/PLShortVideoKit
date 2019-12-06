//
//  QNEditorGIFStickerView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/28.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNEditorGIFStickerView.h"
#import "QNPanImageView.h"

// 限制添加 GIF 的最小时长为 1s
static const CGFloat minStickerDuration = 1.0;

@implementation StickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {

        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.layer.borderColor = [UIColor colorWithWhite:.7 alpha:1].CGColor;
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.borderWidth = 1;
        
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end

@interface QNEditorGIFStickerView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UIImageView *leftPanView;
@property (nonatomic, strong) UIImageView *rightPanView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, assign) CMTime videoDuration;
@property (nonatomic, assign) CMTime currentTime;

// 时间线
@property (nonatomic, strong) NSArray* thumbArray;
@property (nonatomic, strong) UICollectionView *timelinwCollectionView;
@property (nonatomic, assign) BOOL isDragging;


@property (nonatomic, strong) UICollectionView *gifSourceCollectionView;
@property (nonatomic, strong) NSMutableArray <NSString *>* gifSourcePathArray;


@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UIView *positionLineView;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong, readwrite) NSMutableArray <QNStickerModel *> *addedStickerModelArray;

@property (nonatomic, weak) QNStickerModel *currentEditingSticker;

@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;

@end

@implementation QNEditorGIFStickerView

- (instancetype)initWithThumbImage:(NSArray<UIImage *> *)thumbArray videoDuration:(CMTime)duration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.thumbArray = [thumbArray copy];
        self.videoDuration = duration;
        self.currentTime = kCMTimeZero;
        self.addedStickerModelArray = [[NSMutableArray alloc] init];
        
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
        self.currentTimeLabel.text = @"动图 - 滑动选择插入点";
        
        [self addSubview:self.currentTimeLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30, 50);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50);
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
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 50);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50);
        self.gifSourceCollectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.gifSourceCollectionView.delegate = self;
        self.gifSourceCollectionView.dataSource = self;
        self.gifSourceCollectionView.allowsMultipleSelection = NO;
        self.gifSourceCollectionView.backgroundColor = [UIColor clearColor];
        self.gifSourceCollectionView.showsHorizontalScrollIndicator = NO;
        [self.gifSourceCollectionView registerClass:StickerCell.class forCellWithReuseIdentifier:@"sourceCell"];
        [self addSubview:self.gifSourceCollectionView];
        
        [self.timelinwCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.doneButton.mas_bottom);
            make.height.equalTo(50);
        }];
        
        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.doneButton);
        }];
        
        [self.gifSourceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.top.equalTo(self.timelinwCollectionView.mas_bottom).offset(10);
            make.height.equalTo(55);
        }];
        
        [self.timelinwCollectionView setContentInset:UIEdgeInsetsMake(0, UIScreen.mainScreen.bounds.size.width/2, 0, UIScreen.mainScreen.bounds.size.width/2)];
        
        [self loadGifSource];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

- (void)loadGifSource {
    self.gifSourcePathArray = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    bundlePath = [bundlePath stringByAppendingPathComponent:@"gifSticker.bundle"];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:nil];
    
    for (int i = 0; i < array.count; i++) {
        [self.gifSourcePathArray addObject:[bundlePath stringByAppendingPathComponent:array[i]]];
    }
}

- (void)setPlayingTime:(CMTime)time {
    if (self.isDragging) return;
    
    self.currentTime = time;
    CGFloat originX = [self timeToPosition:time];
    self.timelinwCollectionView.contentOffset = CGPointMake(originX - self.timelinwCollectionView.contentInset.left, 0);
    self.currentTimeLabel.text = [NSString stringWithFormat:@"动图 - 滑动选择插入点: %0.1fs", CMTimeGetSeconds(time)];
}

- (void)clickDoneButton:(UIButton *)button {
    [self.delegate editorGIFStickerViewDoneButtonClick:self];
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
    [self.delegate editorGIFStickerView:self wantSeekPlayerTo:time];
    self.currentTimeLabel.text = [NSString stringWithFormat:@"动图 - 滑动选择插入点: %0.1fs", CMTimeGetSeconds(time)];
    self.currentTime = time;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.timelinwCollectionView) return;
    self.isDragging = YES;
    [self.delegate editorGIFStickerViewWillBeginDragging:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.timelinwCollectionView) return;
    if (decelerate) return;
    
    self.isDragging = NO;
    [self.delegate editorGIFStickerViewWillEndDragging:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.timelinwCollectionView) return;
    self.isDragging = NO;
    [self.delegate editorGIFStickerViewWillEndDragging:self];
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
        
        StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sourceCell" forIndexPath:indexPath];
        
        if (self.gifSourcePathArray.count > indexPath.item) {
            NSString *path = [self.gifSourcePathArray objectAtIndex:indexPath.item];
            cell.imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.timelinwCollectionView) {
        return self.thumbArray.count;
    } else {
        return self.gifSourcePathArray.count;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.gifSourceCollectionView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        cell.transform = CGAffineTransformIdentity;
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
                cell.transform = CGAffineTransformMakeScale(.8, .8);
            }];
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.gifSourceCollectionView) {

        NSString *path = [self.gifSourcePathArray objectAtIndex:indexPath.item];
        
        QNStickerModel *stickerModel = [[QNStickerModel alloc] init];
        stickerModel.path = path;
        stickerModel.startPositionTime = self.currentTime;
        
        UIView *colorView = [[UIView alloc] init];
        if (CMTimeCompare(CMTimeSubtract(self.videoDuration, stickerModel.startPositionTime), stickerModel.oneLoopDuration) > 0) {
            stickerModel.endPositiontime = CMTimeAdd(stickerModel.startPositionTime, stickerModel.oneLoopDuration);
        } else {
            CMTime startTime = CMTimeSubtract(self.videoDuration, stickerModel.oneLoopDuration);
            if (CMTimeCompare(kCMTimeZero, startTime) > 0) {
                startTime = kCMTimeZero;
            }
            stickerModel.startPositionTime = startTime;
            stickerModel.endPositiontime =  self.videoDuration;
        }
        colorView.backgroundColor = stickerModel.randomColor;
        
        CGFloat originX = [self timeToPosition:stickerModel.startPositionTime];
        CGFloat width = [self timeToPosition:stickerModel.endPositiontime] - originX;
        
        CGRect rc = CGRectMake(originX, 0, width, self.timelinwCollectionView.frame.size.height);
        colorView.frame = rc;
        stickerModel.colorView = colorView;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapColorView:)];
        [colorView addGestureRecognizer:singleTap];
        
        [self.timelinwCollectionView addSubview:stickerModel.colorView];
        [self.addedStickerModelArray addObject:stickerModel];
        [self.delegate editorGIFStickerView:self addGifSticker:stickerModel];
        
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
                cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        } completion:nil];
    }
}

- (void)singleTapColorView:(UIGestureRecognizer *)gesture {
    UIView *gestureView = gesture.view;
    for (QNStickerModel *stickerModel in self.addedStickerModelArray) {
        if (stickerModel.colorView == gestureView) {
            if (stickerModel != self.currentEditingSticker) {
                [self.delegate editorGIFStickerView:self wantEntryEditing:stickerModel];
            }
            break;
        }
    }
}

#pragma mark - edit sticker

- (void)endStickerEditing:(QNStickerModel *)stickerModel {
    self.currentEditingSticker = nil;
    [self hidePanView];
}

- (void)startStickerEditing:(QNStickerModel *)stickerModel {
    self.currentEditingSticker = stickerModel;
    if (nil == self.leftPanView) {
        [self setupPanBorder];
    }
    
    UIView *colorView = stickerModel.colorView;
    CGRect rc = self.leftPanView.frame;
    rc.origin.x = colorView.frame.origin.x - rc.size.width;
    self.leftPanView.frame = rc;
    
    rc.origin.x = colorView.frame.origin.x + colorView.frame.size.width;
    self.rightPanView.frame = rc;
    
    [self showPanView];
}

- (void)deleteSticker:(QNStickerModel *)model {
    [model.colorView removeFromSuperview];
    [self.addedStickerModelArray removeObject:model];
}

#pragma mark - show/hide pan view

- (void)showPanView {
    [self.timelinwCollectionView bringSubviewToFront:self.currentEditingSticker.colorView];
    [self.timelinwCollectionView bringSubviewToFront:self.leftPanView];
    [self.timelinwCollectionView bringSubviewToFront:self.rightPanView];
    [self.timelinwCollectionView bringSubviewToFront:self.bottomLineView];
    [self.timelinwCollectionView bringSubviewToFront:self.topLineView];
    self.leftPanView.hidden = NO;
    self.rightPanView.hidden = NO;
    self.topLineView.hidden = NO;
    self.bottomLineView.hidden = NO;
}

- (void)hidePanView {
    self.leftPanView.hidden = YES;
    self.rightPanView.hidden = YES;
    self.topLineView.hidden = YES;
    self.bottomLineView.hidden = YES;
}

- (void)setupPanBorder{
    self.topLineView  = [[UIView alloc] init];
    self.bottomLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor  = QN_MAIN_COLOR;
    self.bottomLineView.backgroundColor = QN_MAIN_COLOR;
    
    self.leftPanView    = [[QNPanImageView alloc]init];
    self.rightPanView   = [[QNPanImageView alloc]init];
    self.leftPanView.clipsToBounds  = YES;
    self.rightPanView.clipsToBounds = YES;
    self.leftPanView.userInteractionEnabled = YES;
    self.rightPanView.userInteractionEnabled = YES;
    UIImage *panImage = [UIImage imageNamed:@"qn_video_pan"];
    self.leftPanView.image  = panImage;
    self.rightPanView.image = panImage;
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.leftPanView addGestureRecognizer:panGesture];
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.rightPanView addGestureRecognizer:panGesture];
    
    UIView* superView = self.timelinwCollectionView;
    
    [superView addSubview:self.topLineView];
    [superView addSubview:self.bottomLineView];
    [superView addSubview:self.leftPanView];
    [superView addSubview:self.rightPanView];
    
    [self.topLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftPanView.mas_right);
        make.right.equalTo(self.rightPanView.mas_left);
        make.height.equalTo(3);
        make.top.equalTo(self.leftPanView);
    }];
    
    [self.bottomLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.topLineView);
        make.bottom.equalTo(self.leftPanView);
    }];
    
    self.leftPanView.frame  = CGRectMake(0, 0, panImage.size.width, self.timelinwCollectionView.frame.size.height);
    self.rightPanView.frame = CGRectMake(panImage.size.width * 2, 0, panImage.size.width, self.timelinwCollectionView.frame.size.height);
}

- (CGFloat)mostLeftX {
    return - self.leftPanView.frame.size.width;
}

- (CGFloat)mostRightX {
    return self.timelinwCollectionView.contentSize.width;
}

#pragma mark - 平移手势事件

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture {
    BOOL needFeedback = NO;

    CGFloat percent = minStickerDuration / CMTimeGetSeconds(self.videoDuration);
    CGFloat minAvalibeWidth = percent * self.timelinwCollectionView.contentSize.width;
    
    CGPoint point = [gesture translationInView:gesture.view.superview];
    if (gesture.view == self.leftPanView) {

        switch (gesture.state) {

            case UIGestureRecognizerStateBegan:{
                if (@available(iOS 10.0, *)) {
                    self.feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
                    [self.feedback prepare];
                }
                self.isDragging = YES;
                [self.delegate editorGIFStickerViewWillBeginDragging:self];
            }
                break;

            case UIGestureRecognizerStateChanged:{

                CGFloat lOriginX = self.leftPanView.frame.origin.x;
                CGFloat rOriginX = self.rightPanView.frame.origin.x;

                lOriginX += point.x;

                if (lOriginX < self.mostLeftX) {
                    lOriginX = self.mostLeftX;
                    needFeedback = YES;
                }

                if (lOriginX + self.leftPanView.frame.size.width + minAvalibeWidth > rOriginX) {
                    lOriginX = rOriginX - minAvalibeWidth - self.leftPanView.frame.size.width;
                    needFeedback = YES;
                }

                CGPoint center = self.leftPanView.center;
                self.leftPanView.center = CGPointMake(lOriginX + self.leftPanView.bounds.size.width / 2, center.y);
                
                CMTime time = [self positionToTime:lOriginX + self.leftPanView.bounds.size.width];
                self.currentEditingSticker.startPositionTime = time;
                [self.delegate editorGIFStickerView:self wantSeekPlayerTo:time];
            }
                break;

            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                self.feedback = nil;
                self.isDragging = NO;
                [self.delegate editorGIFStickerViewWillEndDragging:self];
            }
                break;

            default:
                break;
        }

    } else if (gesture.view == self.rightPanView) {

        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:{
                self.isDragging = YES;
                [self.delegate editorGIFStickerViewWillBeginDragging:self];
                if (@available(iOS 10.0, *)) {
                    self.feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
                    [self.feedback prepare];
                }
            }
                break;

            case UIGestureRecognizerStateChanged:{

                CGFloat lOriginX = self.leftPanView.frame.origin.x;
                CGFloat rOriginX = self.rightPanView.frame.origin.x;

                rOriginX += point.x;

                if (rOriginX > self.mostRightX) {
                    rOriginX = self.mostRightX;
                    needFeedback = YES;
                }

                if (lOriginX + self.leftPanView.frame.size.width + minAvalibeWidth > rOriginX) {
                    rOriginX = lOriginX + self.leftPanView.frame.size.width + minAvalibeWidth;
                    needFeedback = YES;
                }

                CGPoint center = self.rightPanView.center;
                self.rightPanView.center = CGPointMake(rOriginX + self.rightPanView.bounds.size.width / 2, center.y);

                CMTime time = [self positionToTime:rOriginX];
                self.currentEditingSticker.endPositiontime = time;
                [self.delegate editorGIFStickerView:self wantSeekPlayerTo:time];
            }
                break;

            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                self.feedback = nil;
                self.isDragging = NO;
                [self.delegate editorGIFStickerViewWillEndDragging:self];
            }
                break;

            default:
                break;
        }
    }

    CGRect rc = self.currentEditingSticker.colorView.frame;
    rc.origin.x = self.leftPanView.frame.origin.x + self.leftPanView.frame.size.width;
    rc.size.width = self.rightPanView.frame.origin.x - rc.origin.x;
    self.currentEditingSticker.colorView.frame = rc;
    
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view.superview];
    if (needFeedback) {
        [self.feedback impactOccurred];

        // 强行结束手势
        [gesture setEnabled:NO];
        [gesture setEnabled:YES];
    }
}

- (CGFloat)minViewHeight {
    return 170;
}

@end
