//
//  QNAssetRangeBar.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/15.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNAssetRangeBar.h"

#import "QNPanImageView.h"

@interface QNAssetRangeBar ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UIImageView*    leftPanView;
@property (nonatomic, strong) UIImageView*    rightPanView;
@property (nonatomic, strong) UIImageView*    positionLineView;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat edgeSpace;
@property (nonatomic, assign) CGFloat minAvalibeWidth;//两个划片之间的最小距离
@property (nonatomic, assign) NSInteger thumbImageCount;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *thumbImageArray;

@property (nonatomic, strong) AVAssetImageGenerator* imageGenerator;

@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;

@end

@implementation QNAssetRangeBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.startTime = kCMTimeZero;
        self.endTime = kCMTimeZero;
        
        self.thumbImageCount = 10;
        UIImage *panImage = [UIImage imageNamed:@"qn_video_pan"];
        self.cellHeight = panImage.size.height;
        self.edgeSpace = panImage.size.width + 20;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((UIScreen.mainScreen.bounds.size.width - 2 * self.edgeSpace) / self.thumbImageCount, self.cellHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        CGRect rc = CGRectMake(self.edgeSpace, frame.size.height - self.cellHeight, layout.itemSize.width * 10, self.cellHeight);
        self.collectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(self.edgeSpace);
            make.right.equalTo(self).offset(-self.edgeSpace);
            make.bottom.equalTo(self);
            make.height.equalTo(self.cellHeight);
        }];
        
        [self initBorder];
    }
    return self;
}

- (void)initBorder{
    UIView *topLineView  = [[UIView alloc] init];
    UIView *bottomLineView = [[UIView alloc] init];
    topLineView.backgroundColor  = QN_MAIN_COLOR;
    bottomLineView.backgroundColor = QN_MAIN_COLOR;
    
    self.leftPanView    = [[QNPanImageView alloc]init];
    self.rightPanView   = [[QNPanImageView alloc]init];
    self.leftPanView.clipsToBounds  = YES;
    self.rightPanView.clipsToBounds = YES;
    self.leftPanView.userInteractionEnabled = YES;
    self.rightPanView.userInteractionEnabled = YES;
    UIImage *panImage = [UIImage imageNamed:@"qn_video_pan"];
    self.leftPanView.image  = panImage;
    self.rightPanView.image = panImage;
    self.leftPanView.contentMode    = UIViewContentModeCenter;
    self.rightPanView.contentMode   = UIViewContentModeCenter;
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.leftPanView addGestureRecognizer:panGesture];
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.rightPanView addGestureRecognizer:panGesture];
    
    self.positionLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qn_btn_cut_line"]];
    
    UIView* superView = self;
    
    [superView addSubview:self.positionLineView];
    [superView addSubview:topLineView];
    [superView addSubview:bottomLineView];
    [superView addSubview:self.leftPanView];
    [superView addSubview:self.rightPanView];
    
    [topLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftPanView.mas_right);
        make.right.equalTo(self.rightPanView.mas_left);
        make.height.equalTo(3);
        make.top.equalTo(self.collectionView);
    }];
    
    [bottomLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftPanView.mas_right);
        make.right.equalTo(self.rightPanView.mas_left);
        make.height.equalTo(3);
        make.bottom.equalTo(self.collectionView);
    }];
    
    self.leftPanView.frame  = CGRectMake(self.edgeSpace - panImage.size.width, self.collectionView.frame.origin.y, panImage.size.width, panImage.size.height);
    self.rightPanView.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - self.edgeSpace, self.collectionView.frame.origin.y, panImage.size.width, self.cellHeight);
    self.positionLineView.frame = CGRectMake(self.edgeSpace, self.collectionView.frame.origin.y, 4, self.cellHeight);
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.textColor = [UIColor lightTextColor];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = [UIColor lightTextColor];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.textColor = [UIColor lightTextColor];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [superView addSubview:self.leftLabel];
    [superView addSubview:self.rightLabel];
    [superView addSubview:self.centerLabel];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionView);
        make.bottom.equalTo(self.collectionView.mas_top).offset(-5);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectionView);
        make.bottom.equalTo(self.collectionView.mas_top).offset(-5);
    }];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionView);
        make.bottom.equalTo(self.collectionView.mas_top).offset(-5);
    }];
}

- (void)setAsset:(AVAsset *)asset {
    _asset = asset;
    self.endTime = asset.duration;
    [self getThumbImages:asset];
    CGFloat minDuratuion = MIN(1.0, CMTimeGetSeconds(asset.duration));
    self.minAvalibeWidth = self.collectionView.frame.size.width * minDuratuion / CMTimeGetSeconds(asset.duration);
    
    // refresh
    self.startTime = kCMTimeZero;
    self.leftPanView.center = CGPointMake(self.collectionView.frame.origin.x, self.leftPanView.center.y);
    self.rightPanView.center = CGPointMake(self.collectionView.frame.origin.x + self.collectionView.frame.size.width, self.rightPanView.center.y);
    [self updateLabelText];
}

- (void)getThumbImages:(AVAsset*)asset{
    if (_imageGenerator) {
        [_imageGenerator cancelAllCGImageGeneration];
        _imageGenerator = nil;
    }
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    self.imageGenerator.appliesPreferredTrackTransform = TRUE;
    self.imageGenerator.maximumSize = CGSizeMake(100, 100);
    self.imageGenerator.requestedTimeToleranceAfter = CMTimeMake(1000, 1000);
    self.imageGenerator.requestedTimeToleranceBefore = CMTimeMake(1000, 1000);
    
    NSMutableArray *timesArray = [[NSMutableArray alloc] init];
    CMTime duration = asset.duration;
    for (int i = 0; i < self.thumbImageCount; i++) {
        CMTime time = CMTimeMake(duration.value/self.thumbImageCount * i, duration.timescale);
        [timesArray addObject:[NSValue valueWithCMTime:time]];
    }
    __block int finishCount = 0;
    
    self.thumbImageArray = [[NSMutableArray alloc] init];
    
    __weak typeof(self) wself = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timesArray completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
        if (result == AVAssetImageGeneratorSucceeded){
            UIImage* thumbImage = [UIImage imageWithCGImage:image scale:UIScreen.mainScreen.scale orientation:(UIImageOrientationUp)];
            [wself.thumbImageArray addObject:thumbImage];
        } else if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
        } else if (result == AVAssetImageGeneratorCancelled) {
            NSLog(@"Canceled");
        }
        finishCount ++;
        if (finishCount == wself.thumbImageCount) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.collectionView reloadData];
            });
        }
    }];
}

- (void)setCurrentTime:(CMTime)currentTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat position = [self positionWithTime:currentTime];
        self.positionLineView.center = CGPointMake(position, self.positionLineView.center.y);
    });
}

- (CGFloat)mostLeftX{
    return self.collectionView.frame.origin.x - self.leftPanView.frame.size.width;
}

- (CGFloat)mostRightX{
    return self.collectionView.frame.origin.x + self.collectionView.frame.size.width;
}

- (CMTime)timeWithPosition:(CGFloat)x {
    CMTime duration = self.asset.duration;
    int64_t value = (MAX((x - self.collectionView.frame.origin.x), 0) / self.collectionView.frame.size.width ) * duration.value;
    duration.value = MIN(duration.value, value);
    return duration;
    
}

- (CGFloat)positionWithTime:(CMTime)time {
    CGFloat positionTime = CMTimeGetSeconds(time);
    CGFloat duration = CMTimeGetSeconds(self.asset.duration);
    
    CGFloat percent = MIN(1, MAX(0, positionTime / duration));
    
    return self.collectionView.frame.origin.x + percent * self.collectionView.frame.size.width;
}

- (void)updateLabelText {
    self.leftLabel.text = [NSString stringWithFormat:@"%0.1fs", CMTimeGetSeconds(self.startTime)];
    self.rightLabel.text = [NSString stringWithFormat:@"%0.1fs", CMTimeGetSeconds(self.endTime)];
    self.centerLabel.text = [NSString stringWithFormat:@"已选取 %0.1fs", CMTimeGetSeconds(CMTimeSubtract(self.endTime, self.startTime))];
}

#pragma mark - 手势事件

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture{
    
    self.positionLineView.hidden = YES;
    BOOL needFeedback = NO;
    
    CGPoint point = [gesture translationInView:gesture.view.superview];
    if (gesture.view == self.leftPanView) {
        
        switch (gesture.state) {
                
            case UIGestureRecognizerStateBegan:{
                self.positionLineView.hidden = YES;
                if (@available(iOS 10.0, *)) {
                    self.feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
                    [self.feedback prepare];
                }
                [self.delegate assetRangeBar:self didStartMove:YES];
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

                if (lOriginX + self.leftPanView.frame.size.width + self.minAvalibeWidth > rOriginX) {
                    lOriginX = rOriginX - self.minAvalibeWidth - self.leftPanView.frame.size.width;
                    needFeedback = YES;
                }
                
                self.leftPanView.center = CGPointMake(lOriginX + self.leftPanView.bounds.size.width / 2, self.leftPanView.center.y);
                CMTime time = [self timeWithPosition:lOriginX + self.leftPanView.bounds.size.width];
                [self.delegate assetRangeBar:self movingToTime:time isLeft:YES];
                
                self.startTime =  time;
            }
                break;
                
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                CGRect rc = self.positionLineView.frame;
                rc.origin.x = self.leftPanView.frame.origin.x + self.leftPanView.frame.size.width;
                self.positionLineView.frame = rc;
                self.positionLineView.hidden = NO;
                self.feedback = nil;
                [self.delegate assetRangeBar:self didEndMoveWithSelectedTimeRange:CMTimeRangeMake(self.startTime, CMTimeSubtract(self.endTime, self.startTime)) isLeft:YES];
            }
                break;
                
            default:
                break;
        }
        
    } else if (gesture.view == self.rightPanView) {
        
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:{
                self.positionLineView.hidden = YES;
                [self.delegate assetRangeBar:self didStartMove:NO];
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
                
                if (lOriginX + self.leftPanView.frame.size.width + self.minAvalibeWidth > rOriginX) {
                    rOriginX = lOriginX + self.leftPanView.frame.size.width + self.minAvalibeWidth;
                    needFeedback = YES;
                }
                
                CGPoint center = self.rightPanView.center;
                self.rightPanView.center = CGPointMake(rOriginX + self.rightPanView.bounds.size.width / 2, center.y);
                
                self.endTime = [self timeWithPosition:rOriginX];
                [self.delegate assetRangeBar:self movingToTime:self.endTime isLeft:NO];
            }
                break;
                
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                CGRect rc = self.positionLineView.frame;
                rc.origin.x = self.leftPanView.frame.origin.x + self.leftPanView.frame.size.width;
                self.positionLineView.frame = rc;
                self.positionLineView.hidden = NO;
                self.feedback = nil;
                
                CMTimeRange range = CMTimeRangeMake(self.startTime, CMTimeSubtract(self.endTime, self.startTime));
                [self.delegate assetRangeBar:self didEndMoveWithSelectedTimeRange:range isLeft:NO];
            }
                break;
                
            default:
                break;
        }
    }
    
    [self updateLabelText];
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view.superview];
    if (needFeedback) {
        [self.feedback impactOccurred];
        
        // 强行结束手势
        [gesture setEnabled:NO];
        [gesture setEnabled:YES];
    }
}

#pragma mark - UICollectionView delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    static NSInteger imageViewTag = 0x1234;
    
    UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.tag = imageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    if (self.thumbImageArray.count > indexPath.row) {
        imageView.image = self.thumbImageArray[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

+ (CGFloat)suitableHeight {
    return 75;
}


@end
