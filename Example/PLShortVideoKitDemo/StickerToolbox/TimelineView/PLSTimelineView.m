//
//  PLSTimelineView.m
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTimelineView.h"
#import "PLSTimelineItemCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PLSAssetImageGenerator.h"

typedef NS_ENUM(NSUInteger, kVideoDirection) {
    kVideoDirectionUnkown = 0,
    kVideoDirectionPortrait,
    kVideoDirectionPortraitUpsideDown,
    kVideoDirectionLandscapeRight,
    kVideoDirectionLandscapeLeft,
};

#define ITEMS_PER_SEGMENT 8

const CGFloat PINCH_THRESHOLD = 50.0;
const CGFloat DELTA_X = 2.0;
const CGFloat MIN_DURATION = 0.0;

typedef NS_ENUM(NSUInteger, kSpaceType) {
    kSpaceTypeCollectionViewLeading = 0,
    kSpaceTypeCollectionViewTrailing,
    kSpaceTypeLeftPinchView,
    kSpaceTypeRightPinchView
};

typedef NS_ENUM(NSUInteger, kRunDirection) {
    kRunDirectionLeft = 0,
    kRunDirectionRight
};

static NSString *PLSTimelineItemCellId = @"PLSTimelineItemCell";

@interface PLSTimelineView ()

@property (nonatomic, assign) CGFloat             itemWidth;
@property (nonatomic, assign) CGFloat             itemHeight;
@property (nonatomic, assign) CGFloat             totalItemsWidth;
@property (nonatomic, strong) UICollectionView    *collectionView;
@property (nonatomic, strong) NSMutableArray      *photoItems;
@property (nonatomic, assign) CGFloat             videoDuration;
@property (nonatomic, strong) UIView              *indicator;
@property (nonatomic, strong) UIImageView         *leftPinchView;
@property (nonatomic, strong) UIImageView         *rightPinchView;
@property (nonatomic, strong) UIImageView         *pinchBackgroudView;
@property (nonatomic, assign) CGFloat             segment;
@property (nonatomic, assign) CGFloat             singleItemDuration;
@property (nonatomic, copy  ) NSArray             *photoCounts;
@property (nonatomic, assign) NSInteger           photosPersegment;
@property (nonatomic, assign) CGFloat             leftPinchTime;
@property (nonatomic, assign) CGFloat             rightPinchTime;
@property (nonatomic, strong) NSMutableArray      *timelinePercentItems;
@property (nonatomic, strong) NSMutableArray <PLSTimeLineItem*> *timelineItems;
@property (nonatomic, strong) NSMutableDictionary *rotateDict;
@property (nonatomic, strong) NSMutableDictionary *durationDict;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

// 音效
@property (nonatomic, strong) NSMutableArray *timelinePercentAudioItems;
@property (nonatomic, strong) NSMutableArray *timelineAudioItems;

@end


@implementation PLSTimelineView
{
    BOOL _isDragging;
    BOOL _isDecelerate;
    CGFloat _leftPinchWidth;
    CGFloat _rightPinchWidth;
    UIImageView *_selectedPinchImageView;
    NSTimer *_scheduleTimer;
    PLSTimeLineItem *_currentItem;
    PLSAssetImageGenerator *_generator;
}

#pragma mark - Update

- (void)setNeedDisplaySlider {
    if (!_currentItem) {
        return;
    }
    
    [self setSliderEditStatus:YES];
    [self sliderPositionWithBeginTime:_currentItem.startTime endTime:_currentItem.endTime];
}

- (void)setNeedsUpdateGreyViews {
    [self generateTimelinePercentItems];
}

- (void)setNeedsUpdatePinch {
    [self setNeedsUpdateLeftPinch];
    [self setNeedsUpdateRightPinch];
}

- (void)setNeedsUpdatePinchBackgroudView {
    self.pinchBackgroudView.frame = CGRectMake(self.leftPinchView.frame.origin.x, 0, self.rightPinchView.frame.origin.x - self.leftPinchView.frame.origin.x + _rightPinchWidth, self.itemHeight);
}

- (void)setNeedsUpdateLeftPinch {
    CGFloat xp = [self transformOffsetPointOfSelfFromTime:self.leftPinchTime];
    CGRect leftPinchFrame = self.leftPinchView.frame;
    leftPinchFrame.origin.x = xp - _leftPinchWidth;
    self.leftPinchView.frame = leftPinchFrame;
}

- (void)setNeedsUpdateRightPinch {
    CGFloat xp = [self transformOffsetPointOfSelfFromTime:self.rightPinchTime];
    CGRect rightPinchFrame = self.rightPinchView.frame;
    rightPinchFrame.origin.x = xp;
    self.rightPinchView.frame = rightPinchFrame;
}

- (void)setSliderEditStatus:(BOOL)isEdit {
    if (isEdit) {
        self.leftPinchView.hidden = self.rightPinchView.hidden = self.pinchBackgroudView.hidden = NO;
    } else {
        self.leftPinchView.hidden = self.rightPinchView.hidden = self.pinchBackgroudView.hidden = YES;
    }
}

- (void)sliderPositionWithBeginTime:(CGFloat)beginTime endTime:(CGFloat)endTime {
    self.leftPinchTime = beginTime;
    self.rightPinchTime = endTime;
    [self setNeedsUpdatePinch];
}

//将时间转化为相对于collectionview上的长度
- (CGFloat)transformOffsetPointOfCollectionViewFromTime:(CGFloat)time {
    CGFloat offset = time / self.videoDuration *(self.photoCounts.count * self.itemWidth);
    
    if (self.actualDuration == 0) {
        self.actualDuration = self.videoDuration;
    }
    offset /= (self.actualDuration / self.videoDuration);
    
    
    return offset;
}

//将时间转化为在timelineView坐标上的x坐标
- (CGFloat)transformOffsetPointOfSelfFromTime:(CGFloat)time {
    CGFloat offset = [self transformOffsetPointOfCollectionViewFromTime:time];
    CGFloat targetOffset = offset - self.collectionView.contentOffset.x;
    
    
    return targetOffset;
}

// 将 timelineView 坐标上的 x 坐标转化为时间
- (CGFloat)transformTimeFromSelfOffset:(CGFloat)offset {
    CGFloat timeOffset = [self transformCollectionViewOffsetFromSelfOffset:offset];
    CGFloat time = self.videoDuration * (timeOffset / (self.photoCounts.count * self.itemWidth));
    
    if (self.actualDuration == 0) {
        self.actualDuration = self.videoDuration;
    }
    time *= (self.actualDuration / self.videoDuration);
    
    return time;
}

// 将 timelineview x 坐标 映射到 collectionView 上
- (CGFloat)transformCollectionViewOffsetFromSelfOffset:(CGFloat)offset {
    CGFloat selfOffset = offset + self.collectionView.contentOffset.x;
    if (selfOffset < 0) {
        selfOffset = 0;
    }
    return selfOffset;
}

- (NSArray *)checkPasterExistBetween:(CGFloat)beginTime and:(CGFloat)endTime {
    NSMutableArray *timelinePercents = [[NSMutableArray alloc] init];
    
    for (PLSTimeLineItem *item in self.timelineItems) {
        if (beginTime >= item.startTime && item.endTime >= beginTime && item.endTime <= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = 0.0f;
            timelinePercent.rightPercent = (item.endTime - beginTime) / (endTime - beginTime);
            [timelinePercents addObject:timelinePercent];
        }
        if (beginTime >= item.startTime && item.endTime >= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = 0.0f;
            timelinePercent.rightPercent = 1.0f;
            [timelinePercents addObject:timelinePercent];
        }
        if (item.startTime >= beginTime && item.endTime <= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = (item.startTime - beginTime) / (endTime - beginTime);
            timelinePercent.rightPercent = (item.endTime - beginTime) / (endTime - beginTime);
            [timelinePercents addObject:timelinePercent];
        }
        if (item.startTime >= beginTime && item.startTime <= endTime && item.endTime >= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = (item.startTime - beginTime) / (endTime - beginTime);
            timelinePercent.rightPercent = 1.0f;
            [timelinePercents addObject:timelinePercent];
        }
    }
    
    return timelinePercents;
}

- (void)dealloc {
    [self.imageGenerator cancelAllCGImageGeneration];
    [_generator cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObservers];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
        self.itemWidth = frame.size.height;
        self.itemHeight = frame.size.height;
    }
    return self;
}

- (id)initWithSize:(CGSize)size videoUrls:(NSArray *)urls rotate:(NSInteger)rotate segment:(CGFloat)segment photosPersegment:(NSInteger)photos {
    if (urls == nil || urls.count ==0) {
        return nil;
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
        self.itemWidth = size.height;
        self.itemHeight = size.height;
        self.segment = segment;
        
        self.photosPersegment = photos;
        if (photos <= 0) {
            self.photosPersegment = 8;
        }
        
        [self setupSubviews];
        [self setSliderEditStatus:NO];
        [self generateImagesWithVideoUrls:urls rotate:rotate];
        [self generateTimelinePercentItems];
        
        [self addObservers];
    }
    return self;
}

- (void)setupVideoUrls:(NSArray *)urls segment:(CGFloat)segment photosPersegent:(NSInteger)photos {
    self.segment = segment;
    
    self.photosPersegment = photos;
    if (photos <= 0) {
        self.photosPersegment = 8;
    }
    
    [self setupSubviews];
    [self setSliderEditStatus:NO];
    [self generateImagesWithVideoUrls:urls rotate:0];
    [self generateTimelinePercentItems];
    
    [self addObservers];
}

- (void)setMediaClips:(NSArray<PLSTimelineMediaInfo *> *)clips segment:(CGFloat)segment photosPersegent:(NSInteger)photos {
    self.segment = segment;
    
    self.photosPersegment = photos;
    if (photos <= 0) {
        self.photosPersegment = 8;
    }
    
    [self setupSubviews];
    [self setSliderEditStatus:NO];
    [self generateImagesWithMediaInfoClips:clips rotate:0];
    [self generateTimelinePercentItems];
    
    [self addObservers];
}

- (void)setupSubviews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:flowLayout];
    self.collectionView.delegate = (id)self;
    self.collectionView.dataSource = (id)self;
    self.collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    [self addSubview:self.collectionView];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, CGRectGetMidX(self.bounds), 0, CGRectGetMidX(self.bounds));
    [self.collectionView registerClass:[PLSTimelineItemCell class] forCellWithReuseIdentifier:PLSTimelineItemCellId];
    
    self.indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, CGRectGetHeight(self.bounds))];
    UIView *indicatorCenterView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, 2, CGRectGetHeight(self.indicator.bounds))];
    
    indicatorCenterView.backgroundColor = self.indicatorColor == nil ? UIColorFromRGB(31, 255, 102) : self.indicatorColor;
    [self.indicator addSubview:indicatorCenterView];
    [self addSubview:self.indicator];
    CGPoint indicatorCenter = self.indicator.center;
    self.indicator.backgroundColor  = rgba(255, 255, 255, 0.4);
    indicatorCenter.x = CGRectGetMidX(self.bounds);
    self.indicator.center = indicatorCenter;
    
    _leftPinchWidth = 20.0 / 2;
    
    NSString *leftPinchImageName = self.leftPinchImageName;
    if (!leftPinchImageName || [leftPinchImageName isEqualToString:@""]) {
        leftPinchImageName = @"video_edit_trim_slider";
    }
    
    UIImage *leftPinchImage = [[UIImage imageNamed:leftPinchImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 0, 10, 0)];//37*84
    self.leftPinchView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds), 0, _leftPinchWidth, self.itemHeight)];
    self.leftPinchView.image = leftPinchImage;
    self.leftPinchView.userInteractionEnabled = YES;
    [self addSubview:self.leftPinchView];
    
    NSString *rightPinchImageName = self.rightPinchImageName;
    if (!rightPinchImageName || [rightPinchImageName isEqualToString:@""]) {
        rightPinchImageName = @"video_edit_trim_slider";
    }
    
    _rightPinchWidth = 20.0 / 2;
    UIImage *rightPinchImage = [[UIImage imageNamed:rightPinchImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 0, 10, 0)];//36.0*84.0
    self.rightPinchView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) + self.itemWidth, 0, _rightPinchWidth, self.itemHeight)];
    self.rightPinchView.image = rightPinchImage;
    self.rightPinchView.userInteractionEnabled = YES;
    [self addSubview:self.rightPinchView];
    
    
    NSString *pinchBgImageName = self.pinchBgImageName;
    if (!pinchBgImageName || [pinchBgImageName isEqualToString:@""]) {
        pinchBgImageName = @"paster_time_edit_slider_bg";
    }
    
    UIImage *pinchBgImage = [UIImage imageNamed:pinchBgImageName] ;
    self.pinchBackgroudView = [[UIImageView alloc] initWithFrame:CGRectMake(self.leftPinchView.frame.origin.x, 0, self.rightPinchView.frame.origin.x - self.leftPinchView.frame.origin.x + _rightPinchWidth, self.itemHeight)];
    self.pinchBackgroudView.image = pinchBgImage;
    self.pinchBackgroudView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.2];
    [self insertSubview:self.pinchBackgroudView belowSubview:self.leftPinchView];
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        [self.imageGenerator cancelAllCGImageGeneration];
        [_generator cancel];
    }
}

- (void)updateTimelineViewAlpha:(CGFloat)alpha {
    
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:alpha];
}

- (NSMutableArray <PLSTimeLineItem *>*)getAllAddedItems{
    return self.timelineItems;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicator.backgroundColor = indicatorColor;
}

-(void)setPinchBgColor:(UIColor *)pinchBgColor {
    _pinchBgColor = pinchBgColor;
    self.pinchBackgroudView.backgroundColor = pinchBgColor;
}

- (void)generateImagesWithVideoUrl:(NSString *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:nil];
    if (!asset) {
        return;
    }
    
    CMTime duration = [asset duration];
    self.videoDuration = CMTimeGetSeconds(duration);
    
    CGFloat singleTime = self.segment / self.photosPersegment;// 一个图片的时间
    self.singleItemDuration = singleTime;
    
    NSMutableArray *timeValues = [[NSMutableArray alloc] init];
    
    CMTime addTime = CMTimeMake(1000 * singleTime,1000);
    CMTime startTime = kCMTimeZero;
    while (CMTIME_COMPARE_INLINE(startTime, <=, duration)) {
        [timeValues addObject:[NSValue valueWithCMTime:startTime]];
        startTime = CMTimeAdd(startTime, addTime);
    }
    //向上取最后一张
    CMTime lastTime = CMTimeSubtract(startTime, addTime);
    if (CMTIME_COMPARE_INLINE(lastTime, <, duration)) {
        [timeValues addObject:[NSValue valueWithCMTime:duration]];
    }
    
    self.photoCounts = timeValues;
    
    self.totalItemsWidth = self.itemWidth * [self.photoCounts count];
    
    
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    self.imageGenerator.maximumSize = CGSizeMake(100, 100);

    AVAssetImageGeneratorCompletionHandler completionHandler = ^(CMTime requestedTime, CGImageRef imageRef, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *err) {
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            [self addGenateImage:image];
        }
    };
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timeValues completionHandler:completionHandler];
    
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)generateTimelinePercentItems {
    [self.timelinePercentItems removeAllObjects];
    [self.timelinePercentAudioItems removeAllObjects];

    CGFloat itemDuration = self.videoDuration / [self.photoCounts count];
    
    for (NSInteger idx = 1; idx <= self.photoCounts.count; idx++) {
        CGFloat mappedBeginTime = itemDuration * (idx - 1);
        CGFloat mappedEndTime = itemDuration * idx;
        
        if (idx == [self.photoCounts count]) {
            if (mappedEndTime > self.videoDuration) {
                mappedEndTime = self.videoDuration;
            }
        }
        
        if (self.actualDuration == 0) {
            self.actualDuration = self.videoDuration;
        }
        mappedBeginTime *= (self.actualDuration / self.videoDuration);
        mappedEndTime *= (self.actualDuration / self.videoDuration);
        
        NSArray *timelinePercents = [self checkPasterExistBetween:mappedBeginTime and:mappedEndTime];
        [self.timelinePercentItems addObject:timelinePercents];
        
        NSArray *timelineAudioPercents = [self checkAudioExistBetween:mappedBeginTime and:mappedEndTime];
        [self.timelinePercentAudioItems addObject:timelineAudioPercents];
    }
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)addGenateImage:(UIImage *)image {
    [self.photoItems addObject:image];
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)addObservers {
    [self.leftPinchView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [self.rightPinchView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObservers {
    [self.leftPinchView removeObserver:self forKeyPath:@"frame"];
    [self.rightPinchView removeObserver:self forKeyPath:@"frame"];
}

- (CGFloat)getCurrentTime {
    CGFloat offsetPoint = self.indicator.center.x + self.collectionView.contentOffset.x; //中间指针距离第一张图片的偏移量
    if (offsetPoint < 0) {
        offsetPoint = 0;
    } else if (offsetPoint > self.totalItemsWidth) {
        offsetPoint = self.totalItemsWidth;
    }
    
    CGFloat timeFromOffset = [self timeWithOffset:offsetPoint];
    return timeFromOffset;
}

- (void)seekToTime:(CGFloat)time {
    if (isnan(time)) { return; }
    if (_isDragging || _isDecelerate || self.videoDuration <= 0) {
        return;
    }
    
    if (self.actualDuration == 0) {
        self.actualDuration = self.videoDuration;
    }
    
    CGFloat mappedTime = (self.videoDuration / self.actualDuration) * time;
    
    CGFloat offset = [self offsetWithTime:mappedTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.contentOffset = CGPointMake(offset - self.indicator.center.x, self.collectionView.contentOffset.y);
    });
}

- (void)cancel {
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    _isDragging = NO;
    _isDecelerate = NO;
}

- (void)previewAction {
    [self allPasterviewsEndEited];
}

- (void)addTimelineItem:(PLSTimeLineItem *)timelineItem {
    [self.timelineItems addObject:timelineItem];
    
    BOOL isScrolling = (self.collectionView.isDragging || self.collectionView.isDecelerating);
    if (isScrolling) {
        [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    }
    
    [self setNeedsUpdateGreyViews];
}

- (void)removeTimelineItem:(PLSTimeLineItem *)timelineItem {
    [self.timelineItems removeObject:timelineItem];
    [self allPasterviewsEndEited];
}

- (void)editTimelineItem:(PLSTimeLineItem *)timelineItem {
    _currentItem = timelineItem;
    [self setNeedDisplaySlider];
}

- (void)editTimelineComplete {
    _currentItem = nil;
    [self allPasterviewsEndEited];
}

- (PLSTimeLineItem *)getTimelineItemWithOjb:(id)obj {
    __block PLSTimeLineItem *targetItem = nil;
    
    [self.timelineItems enumerateObjectsUsingBlock:^(PLSTimeLineItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if([item.target isEqual:obj]) {
            targetItem = item;
            *stop = YES;
        }
    }];
    
    return targetItem;
}

#pragma mark - Notification
- (void)allPasterviewsEndEited {
    _currentItem = nil;
    [self setSliderEditStatus:NO];
    [self setNeedsUpdateGreyViews];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self setNeedsUpdatePinchBackgroudView];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect leftPinchFrame = self.leftPinchView.frame;
    CGRect rightPinchFrame = self.rightPinchView.frame;
    
    CGRect leftPinchTouchFrame = leftPinchFrame;
    CGPoint leftPinchTouchCenter = self.leftPinchView.center;
    leftPinchTouchFrame.size.width += 30;
    leftPinchTouchFrame.origin.x = leftPinchTouchCenter.x - leftPinchTouchFrame.size.width / 2;
    
    CGRect rightPinchTouchFrame = rightPinchFrame;
    CGPoint rightPinchTouchCenter = self.rightPinchView.center;
    rightPinchTouchFrame.size.width += 30;
    rightPinchTouchFrame.origin.x = rightPinchTouchCenter.x - rightPinchTouchFrame.size.width / 2;
    
    if (self.leftPinchView.hidden == NO) {
        if (CGRectContainsPoint(leftPinchTouchFrame, point)) {
            _selectedPinchImageView = self.leftPinchView;
        }
        
        if (CGRectContainsPoint(rightPinchTouchFrame, point)) {
            _selectedPinchImageView = self.rightPinchView;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint newPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGRect selectPinchViewFrame = _selectedPinchImageView.frame;
    
    if (_selectedPinchImageView == self.leftPinchView) {
        
        if (newPoint.x > prePoint.x) {
            [self destroy];
        }
        CGFloat collectionLeadingPointX = [self timelineXpointSpace:kSpaceTypeCollectionViewLeading];
        if (newPoint.x >= collectionLeadingPointX - _leftPinchWidth && newPoint.x >= PINCH_THRESHOLD - _leftPinchWidth) {
            // 左滑动块未达到左侧阀值且未到视频起点  左侧滑块继续往左滑动 右侧滑块不动
            selectPinchViewFrame.origin.x = newPoint.x;
            _selectedPinchImageView.frame = selectPinchViewFrame;
        } else if (newPoint.x > collectionLeadingPointX && newPoint.x < PINCH_THRESHOLD - _leftPinchWidth) {
            // 左滑动块达到左侧阀值但未到视频起点  左侧滑块保持不动，collectview需向右滑动 且右边滑动块也要跟着collection
            selectPinchViewFrame.origin.x = PINCH_THRESHOLD - _leftPinchWidth;
            _selectedPinchImageView.frame = selectPinchViewFrame;
            [self runWithDirection:kRunDirectionLeft];
        } else if (newPoint.x < collectionLeadingPointX - _leftPinchWidth && newPoint.x > PINCH_THRESHOLD) {
            // 左滑动块未达到左侧阀值但已到视频起点  左侧滑块不动 collectionView不动 右侧滑竿不动
            selectPinchViewFrame.origin.x = collectionLeadingPointX - _leftPinchWidth;
            _selectedPinchImageView.frame = selectPinchViewFrame;
        }
        
        CGFloat delta = [self minDurationFromItem];
        
        if (_selectedPinchImageView.frame.origin.x + _leftPinchWidth > self.rightPinchView.frame.origin.x - delta) {
            selectPinchViewFrame.origin.x = self.rightPinchView.frame.origin.x - _leftPinchWidth - delta;
            _selectedPinchImageView.frame = selectPinchViewFrame;
        }
        [self setNeedsUpdateRightPinch];
    } else if (_selectedPinchImageView == self.rightPinchView) {
        if (newPoint.x < prePoint.x) {
            [self destroy];
        }
        CGFloat collectionTrailingPointX = [self timelineXpointSpace:kSpaceTypeCollectionViewTrailing];
        if (newPoint.x <= CGRectGetWidth(self.bounds) - PINCH_THRESHOLD && newPoint.x <= collectionTrailingPointX ) {
            // 右滑动块未达到右侧阀值且未到达视频终点  右侧滑动块继续向右滑动 左侧滑块不动
            selectPinchViewFrame.origin.x = newPoint.x;
            _selectedPinchImageView.frame = selectPinchViewFrame;
        } else if (newPoint.x > CGRectGetWidth(self.bounds) - PINCH_THRESHOLD && newPoint.x < collectionTrailingPointX) {
            // 右滑块达到右侧阀值但未到视频结束 右滑动块不动 collectionview向左滑动 且做滑动块要跟着向左滑动
            selectPinchViewFrame.origin.x = CGRectGetWidth(self.bounds) - PINCH_THRESHOLD;
            _selectedPinchImageView.frame = selectPinchViewFrame;
            
            [self runWithDirection:kRunDirectionRight];
        } else if (newPoint.x < CGRectGetWidth(self.bounds) - PINCH_THRESHOLD && newPoint.x > collectionTrailingPointX) {
            // 右滑块未到达阀值但已到达视频结束 右滑块不动 collectionView不动
            selectPinchViewFrame.origin.x = collectionTrailingPointX;
            _selectedPinchImageView.frame = selectPinchViewFrame;
        }
        CGFloat delta = [self minDurationFromItem];
        
        if (_selectedPinchImageView.frame.origin.x < self.leftPinchView.frame.origin.x + _leftPinchWidth + delta) {
            selectPinchViewFrame.origin.x = self.leftPinchView.frame.origin.x + _leftPinchWidth + delta;
            _selectedPinchImageView.frame = selectPinchViewFrame;
        }
        [self setNeedsUpdateLeftPinch];
    }
}

- (CGFloat)minDurationFromItem {
    return [self offsetWithTime:MIN_DURATION];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGFloat touchEndTime = 0;
    if (_selectedPinchImageView == self.rightPinchView) {
        self.rightPinchTime = [self transformTimeFromSelfOffset:self.rightPinchView.frame.origin.x];
        _currentItem.endTime = self.rightPinchTime;
        [self seekToTime:_currentItem.endTime];
        touchEndTime = _currentItem.endTime;
    } else if (_selectedPinchImageView == self.leftPinchView) {
        self.leftPinchTime = [self transformTimeFromSelfOffset:self.leftPinchView.frame.origin.x + _leftPinchWidth];
        _currentItem.startTime = self.leftPinchTime;
        [self seekToTime:_currentItem.startTime];
        touchEndTime = _currentItem.startTime;
    }
    
    _selectedPinchImageView = nil;
    [self destroy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsUpdatePinch];
        [self setNeedsUpdateGreyViews];
    });
    if (self.actualDuration == 0) {
        self.actualDuration = self.videoDuration;
    }
    touchEndTime *= (self.actualDuration / self.videoDuration);
    
    [self.delegate timelineDraggingAtTime:touchEndTime];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(timelineDraggingTimelineItem:)]) {
        [self.delegate timelineDraggingTimelineItem:_currentItem];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    _selectedPinchImageView = nil;
    [self destroy];
}

- (void)collectionViewShouldScrollDirection:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    kRunDirection runDirection = [[userInfo objectForKey:@"runDirection"] integerValue];
    
    if (![self checkCollectionViewContentOffsetInAvailableSlider]) {
        [self destroy];
        
        if (runDirection == kRunDirectionLeft) {
            CGPoint offset = self.collectionView.contentOffset;
            offset.x = - (self.leftPinchView.frame.origin.x + _leftPinchWidth);
            self.collectionView.contentOffset = offset;
        }
        
        if (runDirection == kRunDirectionRight) {
            CGPoint offset = self.collectionView.contentOffset;
            offset.x = self.photoCounts.count * self.itemWidth - (CGRectGetWidth(self.bounds) - PINCH_THRESHOLD);
            self.collectionView.contentOffset = offset;
        }
        return;
    }
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    if (runDirection == kRunDirectionLeft) {
        contentOffset.x -= DELTA_X;
    } else {
        contentOffset.x += DELTA_X;
    }
    
    self.collectionView.contentOffset = contentOffset;
    
    if (runDirection == kRunDirectionLeft) {
        [self setNeedsUpdateRightPinch];
    } else {
        [self setNeedsUpdateLeftPinch];
    }
}

- (BOOL)checkCollectionViewContentOffsetInAvailableSlider {
    CGFloat timelineLeadingXPoint = [self timelineXpointSpace:kSpaceTypeCollectionViewLeading];
    CGFloat timelineTrailingXPoint = [self timelineXpointSpace:kSpaceTypeCollectionViewTrailing];
    CGFloat leftPinchXPoint = [self timelineXpointSpace:kSpaceTypeLeftPinchView];
    CGFloat rightPinchXPoint = [self timelineXpointSpace:kSpaceTypeRightPinchView];
    
    if (timelineLeadingXPoint > leftPinchXPoint + _leftPinchWidth) {
        return NO;
    }
    
    if (timelineTrailingXPoint < rightPinchXPoint) {
        return NO;
    }
    
    return YES;
}

- (void)runWithDirection:(kRunDirection)runDirection {
    [self destroy];
    _scheduleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60 target:self selector:@selector(collectionViewShouldScrollDirection:) userInfo:@{@"runDirection": @(runDirection)} repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_scheduleTimer forMode:NSRunLoopCommonModes];
}

- (void)destroy {
    [_scheduleTimer invalidate];
    _scheduleTimer = nil;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoCounts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSTimelineItemCell *timelineCell = [collectionView dequeueReusableCellWithReuseIdentifier:PLSTimelineItemCellId forIndexPath:indexPath];
    
    UIImage *image = nil;
    if (indexPath.row < self.photoItems.count) {
        image = [self.photoItems objectAtIndex:indexPath.row];
    }
    
    NSInteger idx = indexPath.row + 1; // 当前所在的图片块index
    
    CGFloat itemDuration = self.videoDuration / [self.photoCounts count];
    
    CGFloat mappedBeginTime = itemDuration * (idx - 1);
    CGFloat mappedEndTime = itemDuration * idx;
    
    if (idx == [self.photoCounts count]) {
        if (mappedEndTime > self.videoDuration) {
            mappedEndTime = self.videoDuration;
        }
    }
    
    NSArray *timelinePercent = [self.timelinePercentItems objectAtIndex:indexPath.row];
    NSArray *timelineAudioPercent = [self.timelinePercentAudioItems objectAtIndex:indexPath.row];
    
    [timelineCell setMappedBeginTime:mappedBeginTime endTime:mappedEndTime image:image timelinePercents:timelinePercent timelineAudioPercents:timelineAudioPercent];
    
    return timelineCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isDecelerate || _isDragging) {
        CGFloat offsetPoint = self.indicator.center.x + self.collectionView.contentOffset.x; // 中间指针距离第一张图片的偏移量
        if (offsetPoint < 0) {
            offsetPoint = 0;
        } else if (offsetPoint > self.totalItemsWidth) {
            offsetPoint = self.totalItemsWidth;
        }
        
        CGFloat timeFromOffset = [self timeWithOffset:offsetPoint];
        if (self.delegate && [self.delegate respondsToSelector:@selector(timelineDraggingAtTime:)]) {
            if (self.actualDuration == 0) {
                self.actualDuration = self.videoDuration;
            }
            timeFromOffset *= (self.actualDuration / self.videoDuration);
            [self.delegate timelineDraggingAtTime:timeFromOffset];
        }
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(timelineCurrentTime: duration:)]) {
            CGFloat currentTime = [self getCurrentTime];
            if (self.actualDuration == 0) {
                self.actualDuration = self.videoDuration;
            }
            currentTime *= (self.actualDuration / self.videoDuration);
            
            [self.delegate timelineCurrentTime:currentTime duration:self.actualDuration];
        }
//    });
}

- (CGFloat)timeWithOffset:(CGFloat)offset {
    CGFloat time =  (offset / ([self.photoCounts count] * self.itemWidth) ) * self.videoDuration;
    return time;
}

- (CGFloat)offsetWithTime:(CGFloat)time {
    CGFloat offset = (time / self.videoDuration) * (self.itemWidth * [self.photoCounts count]);
    return offset;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDragging = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(timelineBeginDragging)]) {
        [self.delegate timelineBeginDragging];
    }
    _currentItem = nil;
    [self setSliderEditStatus:NO];
    [self setNeedsUpdateGreyViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isDragging = NO;
    if (_isDragging == NO && _isDecelerate == NO) {
        
        CGFloat offsetPoint = self.indicator.center.x + self.collectionView.contentOffset.x; // 中间指针距离第一张图片的偏移量
        if (offsetPoint < 0) {
            offsetPoint = 0;
        } else if (offsetPoint > self.totalItemsWidth) {
            offsetPoint = self.totalItemsWidth;
        }
        CGFloat timeFromOffset = [self timeWithOffset:offsetPoint];
        if (self.actualDuration == 0) {
            self.actualDuration = self.videoDuration;
        }
        timeFromOffset *= (self.actualDuration / self.videoDuration);
        
        if (decelerate) {
            [self.delegate timelineDraggingAtTime:timeFromOffset];
        }else {
            [self.delegate timelineEndDraggingAndDecelerate:timeFromOffset];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    _isDecelerate = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isDecelerate = NO;
    if (_isDecelerate == NO && _isDragging == NO) {
        CGFloat offsetPoint = self.indicator.center.x + self.collectionView.contentOffset.x; // 中间指针距离第一张图片的偏移量
        if (offsetPoint < 0) {
            offsetPoint = 0;
        } else if (offsetPoint > self.totalItemsWidth) {
            offsetPoint = self.totalItemsWidth;
        }
        CGFloat timeFromOffset = [self timeWithOffset:offsetPoint];
        if (self.actualDuration == 0) {
            self.actualDuration = self.videoDuration;
        }
        timeFromOffset *= (self.actualDuration / self.videoDuration);
        
        
        [self.delegate timelineEndDraggingAndDecelerate:timeFromOffset];
    }
}

/**
 坐标转化  导航条作为参考系 进行其他控件的坐标转换
 */
- (CGFloat)timelineXpointSpace:(kSpaceType)spaceType {
    if (spaceType == kSpaceTypeCollectionViewLeading) {
        return - self.collectionView.contentOffset.x;
    } else if (spaceType == kSpaceTypeCollectionViewTrailing) {
        return ( - self.collectionView.contentOffset.x + self.itemWidth * self.photoCounts.count);
    } else if (spaceType == kSpaceTypeLeftPinchView) {
        return self.leftPinchView.frame.origin.x;
    } else if (spaceType == kSpaceTypeRightPinchView) {
        return self.rightPinchView.frame.origin.x;
    }
    return NAN;
}

#pragma mark - Getter
- (NSMutableArray *)photoItems {
    if (!_photoItems) {
        _photoItems = [[NSMutableArray alloc] init];
    }
    return _photoItems;
}

- (NSMutableArray *)timelinePercentItems {
    if (!_timelinePercentItems) {
        _timelinePercentItems = [[NSMutableArray alloc] init];
    }
    return _timelinePercentItems;
}

- (NSMutableArray *)timelineItems {
    if (!_timelineItems) {
        _timelineItems = [[NSMutableArray alloc] init];
    }
    return _timelineItems;
}

- (kVideoDirection)getRotate:(CGAffineTransform)t {
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
        return kVideoDirectionPortrait;
    }
    if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {
        return kVideoDirectionPortraitUpsideDown;
    }
    if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
        return kVideoDirectionLandscapeLeft;
    }
    if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
        return kVideoDirectionLandscapeRight;
    }
    return kVideoDirectionUnkown;
}

- (void)generateImagesWithMediaInfoClips:(NSArray *)clips rotate:(NSInteger)rotate {
    _generator = [[PLSAssetImageGenerator alloc] init];
    
    for (PLSTimelineMediaInfo *info in clips) {
        [_generator addVideoWithAsset:info.asset startTime:info.startTime duration:info.duration animDuration:0];
    }
    
    self.videoDuration = _generator.duration;
    CGFloat singleTime = self.segment / self.photosPersegment;// 一个图片的时间
    self.singleItemDuration = singleTime;
    NSMutableArray *timeValues = [[NSMutableArray alloc] init];
    int idx = 0;
    while (idx * singleTime < self.videoDuration) {
        double time = idx * singleTime;
        [timeValues addObject:@(time)];
        idx++;
    }
    self.photoCounts = timeValues;
    self.totalItemsWidth = self.itemWidth * [self.photoCounts count];
    _generator.imageCount = [self.photoCounts count];
    _generator.outputSize = CGSizeMake(100, 100);
    [_generator generateWithCompleteHandler:^(UIImage *image) {
        if (image) {
            [self addGenateImage:image];
        }
    }];
}

- (void)generateImagesWithVideoUrls:(NSArray *)urls rotate:(NSInteger)rotate {
    AVMutableComposition *compsition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [compsition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    self.rotateDict = [[NSMutableDictionary alloc] init];
    self.durationDict = [[NSMutableDictionary alloc] init];
    
    for (NSInteger idx = [urls count] - 1; idx >= 0; idx--) {
        NSString *url = [urls objectAtIndex:idx];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:nil];
        CMTime assetDuration = [asset duration];
        
        AVAssetTrack *assetTrackVideo = nil;
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
            assetTrackVideo = [asset tracksWithMediaType:AVMediaTypeVideo][0];
            [self.rotateDict setValue:@([self getRotate:assetTrackVideo.preferredTransform]) forKey:[NSString stringWithFormat:@"%@", @(idx)]];
        }
        assetDuration = assetTrackVideo.timeRange.duration;
        
        NSValue *assetDurationValue = [NSValue valueWithCMTime:assetDuration];
        [self.durationDict setValue:assetDurationValue forKey:[NSString stringWithFormat:@"%@",@(idx)]];
        
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, assetDuration);
        if (assetTrackVideo) {
            [compositionVideoTrack insertTimeRange:timeRange ofTrack:assetTrackVideo atTime:kCMTimeZero error:nil];
        }
    }
    
    CMTime duration = [compsition duration];
    self.videoDuration = CMTimeGetSeconds(duration);
    
    CGFloat singleTime = self.segment / self.photosPersegment; // 一个图片的时间
    self.singleItemDuration = singleTime;
    
    NSMutableArray *timeValues = [[NSMutableArray alloc] init];
    
    CMTime addTime = CMTimeMake(1000 *singleTime,1000);
    CMTime startTime = CMTimeMake(1000*0.1, 1000); // 从0.1s开始取图片 规避从0取会产生黑帧的问题
    
    while (CMTIME_COMPARE_INLINE(startTime, <=, duration)) {
        [timeValues addObject:[NSValue valueWithCMTime:startTime]];
        startTime = CMTimeAdd(startTime, addTime);
    }
    // 向上取最后一张
    CMTime lastTime = CMTimeSubtract(startTime, addTime);
    if (CMTIME_COMPARE_INLINE(lastTime, <, duration)) {
        [timeValues addObject:[NSValue valueWithCMTime:CMTimeSubtract(duration, CMTimeMake(1000 * 0.01, 1000))]];
    }
    
    self.photoCounts = timeValues;
    self.totalItemsWidth = self.itemWidth * [self.photoCounts count];
    
    
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:compsition];
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    
    AVAssetImageGeneratorCompletionHandler completionHandler = ^(CMTime requestedTime, CGImageRef imageRef, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *err) {
        if (result == AVAssetImageGeneratorSucceeded) {
            kVideoDirection direction = [[self.rotateDict objectForKey:[NSString stringWithFormat:@"%@",@([self getIdxByCMTime:actualTime])]] intValue];
            CGAffineTransform transform = [self transformFromRotate:direction];
            
            @autoreleasepool {
                CIImage *coreImage = [[CIImage imageWithCGImage:imageRef] imageByApplyingTransform:transform];
                CIContext *context = [CIContext contextWithOptions:nil];
                CGImageRef newImageRef = [context createCGImage:coreImage fromRect:[coreImage extent]];
                
                UIImage *image = [UIImage imageWithCGImage:newImageRef];
                [self addGenateImage:image];
                
                CGImageRelease(newImageRef);
            }
        } else {
            UIImage *image = [self.photoItems lastObject];
            if (image) {
                [self.photoItems addObject:image];
                [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }
    };
    self.imageGenerator.maximumSize = CGSizeMake(100, 100);
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timeValues completionHandler:completionHandler];
    
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (int)getIdxByCMTime:(CMTime)actualTime {
    __block int targetIdx = 0;
    
    int count = (int)[[self.durationDict allKeys] count];
    for (int p = 0; p < count; p++) {
        CMTime beginTime = kCMTimeZero;
        CMTime endTime = kCMTimeZero;
        for (int i = 0; i <= p; i++) {
            NSValue *durationValue = [self.durationDict valueForKey:[NSString stringWithFormat:@"%@",@(i)]];
            endTime = CMTimeAdd(endTime, [durationValue CMTimeValue]);
        }
        for (int j = 0; j < p; j++) {
            NSValue *durationValue = [self.durationDict valueForKey:[NSString stringWithFormat:@"%@",@(j)]];
            beginTime = CMTimeAdd(beginTime, [durationValue CMTimeValue]);
        }
        if (CMTimeGetSeconds(endTime) >= CMTimeGetSeconds(actualTime) && CMTimeGetSeconds(actualTime) >= CMTimeGetSeconds(beginTime)) {
            targetIdx = (int)p;
        }
    }
    return targetIdx;
}

- (CGAffineTransform)transformFromRotate:(kVideoDirection)rotate {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (rotate) {
        case kVideoDirectionPortrait: {
            transform = CGAffineTransformRotate(transform, -M_PI_2 );
        }
            break;
        case kVideoDirectionLandscapeLeft: {
            transform = CGAffineTransformRotate(transform, 0);
        }
            break;
        case kVideoDirectionPortraitUpsideDown: {
            transform = CGAffineTransformRotate(transform, M_PI_2);
        }
            break;
        case kVideoDirectionLandscapeRight: {
            transform = CGAffineTransformRotate(transform, M_PI);
        }
            break;
            
        default:
            break;
    }
    return transform;
}

#pragma mark - 添加音效信息的增删改查
- (NSMutableArray *)timelinePercentAudioItems {
    if (!_timelinePercentAudioItems) {
        _timelinePercentAudioItems = [[NSMutableArray alloc] init];
    }
    return _timelinePercentAudioItems;
}

- (NSMutableArray *)timelineAudioItems {
    if (!_timelineAudioItems) {
        _timelineAudioItems = [[NSMutableArray alloc] init];
    }
    return _timelineAudioItems;
}

//- (void)addTimeLineAudioItem:(PLSTimeLineAudioItem *)audioItem {
//    [self.timelineAudioItems addObject:audioItem];
//    [self setNeedsUpdateGreyViews];
//}

- (void)updateTimelineAudioItem:(PLSTimeLineAudioItem *)audioItem {
    if (audioItem && [self.timelineAudioItems containsObject:audioItem] == NO) {
        [self.timelineAudioItems addObject:audioItem];
    }
    [self setNeedsUpdateGreyViews];
}

- (void)removeTimeLineAudioItem:(PLSTimeLineAudioItem *)audioItem {
    [self.timelineAudioItems removeObject:audioItem];
    [self setNeedsUpdateGreyViews];
}

- (void)removeLastAudioItemFromTimeline {
    [self.timelineAudioItems removeLastObject];
    [self setNeedsUpdateGreyViews];
}

- (NSMutableArray <PLSTimeLineAudioItem *>*)getAllAddedAudioItems {
    return self.timelineAudioItems;
}

- (NSArray *)checkAudioExistBetween:(CGFloat)beginTime and:(CGFloat)endTime {
    NSMutableArray *timelineAudioPercents = [[NSMutableArray alloc] init];
    
    for (PLSTimeLineAudioItem *item in self.timelineAudioItems) {
        if (beginTime >= item.startTime && item.endTime >= beginTime && item.endTime <= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = 0.0f;
            timelinePercent.rightPercent = (item.endTime - beginTime) / (endTime - beginTime);
            timelinePercent.color = item.displayColor;
            [timelineAudioPercents addObject:timelinePercent];
        }
        if (beginTime >= item.startTime && item.endTime >= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = 0.0f;
            timelinePercent.rightPercent = 1.0f;
            timelinePercent.color = item.displayColor;
            [timelineAudioPercents addObject:timelinePercent];
        }
        if (item.startTime >= beginTime && item.endTime <= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = (item.startTime - beginTime) / (endTime - beginTime);
            timelinePercent.rightPercent = (item.endTime - beginTime) / (endTime - beginTime);
            timelinePercent.color = item.displayColor;
            [timelineAudioPercents addObject:timelinePercent];
        }
        if (item.startTime >= beginTime && item.startTime <= endTime && item.endTime >= endTime) {
            PLSTimelinePercent *timelinePercent = [[PLSTimelinePercent alloc] init];
            timelinePercent.leftPercent = (item.startTime - beginTime) / (endTime - beginTime);
            timelinePercent.color = item.displayColor;
            timelinePercent.rightPercent = 1.0f;
            [timelineAudioPercents addObject:timelinePercent];
        }
    }
    
    return timelineAudioPercents;
}

@end

