//
//  PLSClipMovieView.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSClipMovieView.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <Masonry.h>
#import "UIImage+PLSClip.h"

#define PLSLineW 4                // 线宽
#define PLSMinImageCount 8     // 显示的图片个数

#define PLSImagesViewH 42  // 预览图高度
#define PLSImagesVIewW (PLS_SCREEN_WIDTH / PLSMinImageCount) // 图片宽度

@interface PLSClipMovieViewCell ()

@property (strong, nonatomic) UIImageView *scaledIamgeView;

@end

@implementation PLSClipMovieViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scaledIamgeView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.scaledIamgeView];
    }
    return self;
}

- (void)setImageData:(UIImage *)imageData {
    _imageData = imageData;
    
    self.scaledIamgeView.image = imageData;
}

@end


static NSString * const PLSClipMovieViewCellId = @"PLSClipMovieViewCellId";

@interface PLSClipMovieView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) AVAsset *asset; // 视频对象
@property (nonatomic, assign) Float64 frameRate; // 帧率
@property (assign, nonatomic) Float64 minDuration; // 截取视频的最短时间
@property (assign, nonatomic) Float64 maxDuration; // 截取视频的最长时间
@property (nonatomic, assign) Float64 totalSeconds; // 总秒数
@property (nonatomic, assign) Float64 screenSeconds; // 当前屏幕显示的秒数

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;

@property (nonatomic, assign) Float64 leftSecond; // 左侧滑块代表的时间
@property (nonatomic, assign) Float64 rightSecond; // 右侧滑块代表的时间
@property (nonatomic, assign) Float64 offsetSecond; // 偏移量时间

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImages;

@property (nonatomic, strong) UILabel *startTimeLabel; // 开始秒数
@property (nonatomic, strong) UILabel *endTimeLabel; // 结束秒数
@property (nonatomic, strong) UILabel *clipSecondLabel; // 一共截多少秒

@property (nonatomic, strong) UIView *leftDragView; // 左边时间拖拽view
@property (nonatomic, strong) UIView *rightDragView; // 右边时间拖拽view
@property (nonatomic, strong) UIView *progressBarView; // 进度播放view

@end

@implementation PLSClipMovieView

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration {
    AVAsset *asset = [AVAsset assetWithURL:url];
    return [self initWithMovieAsset:asset minDuration:minDuration maxDuration:maxDuration];
}

- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration {
    self = [super init];
    if (self) {
        self.asset = asset;
        self.minDuration = minDuration;
        self.maxDuration = maxDuration;
        self.leftSecond = 0.f;
        self.rightSecond = maxDuration;
        
        [self initView];
        [self initDataFromAsset:asset];
    }
    return self;
}

#pragma mark - 初始化
- (void)initView {
    self.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    [self addSubview:self.startTimeLabel];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(23);
    }];
    
    [self addSubview:self.endTimeLabel];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.startTimeLabel);
    }];
    
    [self addSubview:self.clipSecondLabel];
    [self.clipSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.centerX.mas_equalTo(self);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.startTimeLabel.mas_bottom).offset(18);
        make.height.mas_equalTo(PLSImagesViewH);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self setUpDragView];
}

/** 初始化拖拽view */
- (void)setUpDragView {
    // 添加左右拖拽view
    UIView *leftDragView = [UIView new];
    [leftDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftDragGesture:)]];
    leftDragView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_left"].CGImage;
    [self addSubview:leftDragView];
    self.leftDragView = leftDragView;
    [leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 83));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView).offset(-10);
    }];
    
    UIView *rightDragView = [UIView new];
    [rightDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightDragGesture:)]];
    rightDragView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_right"].CGImage;
    [self addSubview:rightDragView];
    self.rightDragView = rightDragView;
    [rightDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 83));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView).offset(-10);
    }];
    
    // 添加一个底层蓝色背景的view
    UIView *imagesBackView = [UIView new];
    imagesBackView.backgroundColor = PLS_RGBCOLOR(252, 221, 0);
    [self insertSubview:imagesBackView belowSubview:self.collectionView];
    [imagesBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftDragView.mas_left).offset(PLSLineW);
        make.right.mas_equalTo(rightDragView.mas_right).offset(-PLSLineW);
        make.top.mas_equalTo(self.collectionView.mas_top).offset(-PLSLineW);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(PLSLineW);
    }];
    
    // 添加左右侧阴影view
    UIView *leftShadowView = [UIView new];
    leftShadowView.userInteractionEnabled = NO;
    leftShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:leftShadowView];
    [leftShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(leftDragView.mas_left);
        make.top.bottom.mas_equalTo(imagesBackView);
    }];
    
    UIView *rightShadowView = [UIView new];
    rightShadowView.userInteractionEnabled = NO;
    rightShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:rightShadowView];
    [rightShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(rightDragView.mas_right);
        make.top.bottom.mas_equalTo(imagesBackView);
    }];
    
    UIView *progressBarView = [UIView new];
    progressBarView.hidden = YES;
    progressBarView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_progress"].CGImage;
    [self addSubview:progressBarView];
    self.progressBarView = progressBarView;
    [progressBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(PLSImagesViewH);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView);
    }];
}

- (void)initDataFromAsset:(AVAsset *)asset {
    CMTime cmtime = asset.duration;
    self.totalSeconds = CMTimeGetSeconds(cmtime);
    
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        self.frameRate = [[asset tracksWithMediaType:AVMediaTypeVideo][0] nominalFrameRate];
    }
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    NSUInteger imageCount = 0;
    if (self.totalSeconds <= self.maxDuration) {
        imageCount = PLSMinImageCount;
        self.screenSeconds = self.totalSeconds;
    } else {
        imageCount = ceil(self.totalSeconds * PLSMinImageCount / self.maxDuration);
        self.screenSeconds = self.maxDuration;
    }
    
    self.clipSecondLabel.text = [NSString stringWithFormat:@"%.1f", self.screenSeconds];
    self.endTimeLabel.text = [self secondsToStr:self.screenSeconds];
    
    __weak typeof(self) weakSelf = self;
    [self getImagesCount:imageCount imageBackBlock:^(UIImage *image) {
        if (image) {
            UIImage *scaledImg = [UIImage scaleImage:image maxDataSize:1024 * 20]; // 将图片压缩到最大20k进行显示
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionImages addObject:scaledImg];
                [weakSelf.collectionView reloadData];
            });
        }
    }];
}

- (void)getImagesCount:(NSUInteger)imageCount imageBackBlock:(void (^)(UIImage *))imageBackBlock {
    Float64 durationSeconds = self.totalSeconds;
    float fps = self.frameRate;
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    
    Float64 perFrames = totalFrames / imageCount; // 一共切imageCount张图
    Float64 frame = 0;
    
    CMTime timeFrame;
    while (frame < totalFrames) {
        timeFrame = CMTimeMake(frame, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
        
        frame += perFrames;
    }
    
    // 防止时间出现偏差
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    self.imageGenerator.appliesPreferredTrackTransform = YES;  // 截图的时候调整到正确的方向
    self.imageGenerator.maximumSize = CGSizeMake(100, 100);
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                break;
            case AVAssetImageGeneratorFailed:
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *displayImage = [UIImage imageWithCGImage:image];
                
                !imageBackBlock ? : imageBackBlock(displayImage);
            }
                break;
        }
    }];
}

/** 将秒转为字符串 */
- (NSString *)secondsToStr:(Float64)seconds {
    NSInteger secondI = (NSInteger) seconds;
    if (!secondI) {
        return @"00:00";
    } else {
        NSInteger second = floor(secondI % 60);
        NSInteger minute = floor((secondI / 60) % secondI);
        return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    }
}

#pragma mark - 拖拽事件
- (void)leftDragGesture:(UIPanGestureRecognizer *)ges {
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(didStartDragView)]) {
                [self.delegate didStartDragView];
            }
            
            [self resetProgressBarMode];
            break;
        case UIGestureRecognizerStateChanged: {
            
            // 1.控制最小间距
            CGPoint translation = [ges translationInView:self];
            CGFloat maxX = CGRectGetMaxX(self.rightDragView.frame) - self.minDuration / self.screenSeconds * self.width;
            
            if ((ges.view.x > maxX && translation.x > 0) || (ges.view.x < 0 && translation.x < 0)) {
                return;
            }
            
            if (ges.view.x + translation.x <= maxX && ges.view.x + translation.x >= 0) {
                [ges.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(ges.view.x + translation.x);
                }];
                
                [ges setTranslation:CGPointZero inView:self];
                
                [self layoutIfNeeded];
            }
            
            // 2.计算leftDragView对应的时间
            Float64 leftTotalSecond = [self getSecondsUsingView:ges.view];
            
            // 3.显示左边时间和截取时间
            self.leftSecond = leftTotalSecond;
            self.startTimeLabel.text = [self secondsToStr:leftTotalSecond];
            
            Float64 clipSeconds = (CGRectGetMaxX(self.rightDragView.frame) - ges.view.x) / self.width * self.screenSeconds;
            self.clipSecondLabel.text = [NSString stringWithFormat:@"%.1f", clipSeconds];
        } break;
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
                [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
            }
            break;
        default:
            break;
    }
}

- (void)rightDragGesture:(UIPanGestureRecognizer *)ges {
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(didStartDragView)]) {
                [self.delegate didStartDragView];
            }
            
            [self resetProgressBarMode];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [ges translationInView:self];
            
            // 1.控制最小间距
            CGFloat minX = CGRectGetMinX(self.leftDragView.frame) + self.minDuration / self.screenSeconds * self.width;
            
            if ((CGRectGetMaxX(ges.view.frame) < minX && translation.x < 0) || (CGRectGetMaxX(ges.view.frame) > self.width && translation.x > 0)) {
                return;
            }
            
            if (CGRectGetMaxX(ges.view.frame) + translation.x >=minX && CGRectGetMaxX(ges.view.frame) + translation.x <= self.width) {
                CGFloat distance = self.width - (CGRectGetMaxX(ges.view.frame) + translation.x);
                [ges.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_offset(-distance);
                }];
                
                [ges setTranslation:CGPointZero inView:self];
            }
            
            // 2.计算leftDragView对应的时间
            Float64 rightTotalSecond = [self getSecondsUsingView:ges.view];
            
            // 3.显示左边时间和截取时间
            self.rightSecond = rightTotalSecond;
            self.endTimeLabel.text = [self secondsToStr:rightTotalSecond];
            
            Float64 clipSeconds = (CGRectGetMaxX(ges.view.frame) - CGRectGetMinX(self.leftDragView.frame)) / self.width * self.screenSeconds;
            self.clipSecondLabel.text = [NSString stringWithFormat:@"%.1f", clipSeconds];
        } break;
        case UIGestureRecognizerStateEnded: {
            if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
                [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
            }
            
        } break;
        default:
            break;
    }
}

#pragma mark - 事件处理
- (void)resetProgressBarMode {
    self.progressBarView.hidden = YES;
}

- (Float64)getSecondsUsingView:(UIView *)view {
    CGFloat offsetX = 0;
    if (self.collectionView.contentOffset.x < 0) {
        offsetX = 0;
    } else {
        offsetX = self.collectionView.contentOffset.x;
    }
    
    Float64 offsetSecond = offsetX / self.collectionView.contentSize.width * self.totalSeconds;
    
    Float64 second = 0;
    if (view == self.leftDragView) {
        second = view.x / self.width * self.screenSeconds;
    } else {
        second = CGRectGetMaxX(view.frame) / self.width * self.screenSeconds;
    }
    
    Float64 totalSecond = second + offsetSecond;
    
    return totalSecond;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // leftDragView和rightDragView 1.5倍高度矩形区域成为拖拽区域
    
    // 计算leftDragView矩形拖拽区域
    CGFloat leftDragWH = self.leftDragView.height * 1.5;
    CGFloat leftDragX = self.leftDragView.center.x - leftDragWH * 0.5;
    CGFloat leftDragY = self.leftDragView.center.y - leftDragWH * 0.5;
    
    CGRect leftDragVRect = CGRectMake(leftDragX, leftDragY, leftDragWH, leftDragWH);
    
    // 计算rightDragView矩形拖拽区域
    CGFloat rightDragWH = self.rightDragView.height * 1.5;
    CGFloat rightDragX = self.rightDragView.center.x - rightDragWH * 0.5;
    CGFloat rightDragY = self.rightDragView.center.y - rightDragWH * 0.5;
    
    CGRect rightDragVRect = CGRectMake(rightDragX, rightDragY, rightDragWH, rightDragWH);
    
    if (CGRectContainsPoint(leftDragVRect, point)) {
        return self.leftDragView;
    } else if (CGRectContainsPoint(rightDragVRect, point)) {
        return self.rightDragView;
    } else {
        return [super hitTest:point withEvent:event];
    }
    
}

#pragma mark - 进度条移动动画
- (void)setProgressBarPoisionWithSecond:(Float64)second {
    CGFloat position = self.width / self.screenSeconds * (second - self.offsetSecond);
    
    self.progressBarView.x = position;
    
    self.progressBarView.hidden = NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSClipMovieViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PLSClipMovieViewCellId forIndexPath:indexPath];
    
    cell.imageData = self.collectionImages[indexPath.item];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(didStartDragView)]) {
        [self.delegate didStartDragView];
    }
    [self resetProgressBarMode];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Float64 leftTime = [self getSecondsUsingView:self.leftDragView];
    Float64 rightTime = [self getSecondsUsingView:self.rightDragView];
    
    self.startTimeLabel.text = [self secondsToStr:leftTime];
    self.endTimeLabel.text = [self secondsToStr:rightTime];
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:isScrolling:)]) {
        [self.delegate clipFrameView:self isScrolling:YES];
    }
    
    self.offsetSecond = scrollView.contentOffset.x / scrollView.contentSize.width * self.totalSeconds;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.leftSecond = [self getSecondsUsingView:self.leftDragView];
    self.rightSecond = [self getSecondsUsingView:self.rightDragView];
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
        [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
    }
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:isScrolling:)]) {
        [self.delegate clipFrameView:self isScrolling:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.leftSecond = [self getSecondsUsingView:self.leftDragView];
        self.rightSecond = [self getSecondsUsingView:self.rightDragView];
        
        if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
            [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:isScrolling:)]) {
        [self.delegate clipFrameView:self isScrolling:decelerate];
    }
}

#pragma mark - 懒加载
- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        UILabel *startTimeLabel = [UILabel new];
        startTimeLabel.textColor = [UIColor whiteColor];
        startTimeLabel.font = [UIFont systemFontOfSize:14];
        startTimeLabel.text = @"00:00";
        
        _startTimeLabel = startTimeLabel;
    }
    
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        UILabel *endTimeLabel = [UILabel new];
        endTimeLabel.textColor = [UIColor whiteColor];
        endTimeLabel.font = [UIFont systemFontOfSize:14];
        
        _endTimeLabel = endTimeLabel;
    }
    
    return _endTimeLabel;
}

- (UILabel *)clipSecondLabel {
    if (!_clipSecondLabel) {
        UILabel *clipSecondLabel = [UILabel new];
        clipSecondLabel.textColor = PLS_RGBCOLOR(253, 220, 0);
        clipSecondLabel.font = [UIFont systemFontOfSize:17];
        
        _clipSecondLabel = clipSecondLabel;
    }
    
    return _clipSecondLabel;
}

- (NSMutableArray *)collectionImages {
    if (!_collectionImages) {
        _collectionImages = [NSMutableArray array];
    }
    
    return _collectionImages;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(PLSImagesVIewW, PLSImagesViewH);
        layout.minimumLineSpacing = 0;
        
        CGRect collectionRect = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLSImagesViewH);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [self.collectionView registerClass:[PLSClipMovieViewCell class] forCellWithReuseIdentifier:PLSClipMovieViewCellId];

        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _collectionView;
}

@end

