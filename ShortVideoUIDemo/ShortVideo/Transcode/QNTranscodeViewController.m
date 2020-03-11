//
//  QNTranscodeViewController.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/15.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNTranscodeViewController.h"
#import "QNAssetRangeBar.h"
#import "QNVerticalButton.h"
#import "QNEditorViewController.h"
#import "QNScopeCutView.h"
#import "QNGradientView.h"

typedef enum : NSUInteger {
    enumPanPositionTopLeft,
    enumPanPositionTopRight,
    enumPanPositionBottomLeft,
    enumPanPositionBottomRight,
    enumPanPositionCenter,
} EnumPanPosition;

@interface QNTranscodeViewController ()
<
QNAssetRangeBarDelagete,
PLSEditPlayerDelegate
>
@property (nonatomic, strong) AVAsset *originAsset;
@property (nonatomic, strong) AVAsset *currentAsset;
@property (nonatomic, strong) PLSEditPlayer *player;

// 区域剪裁 UI
@property (nonatomic, strong) UIView *maxScopeView;
@property (nonatomic, strong) QNScopeCutView *scopeView;
@property (nonatomic, assign) EnumPanPosition enumTapPosition;
@property (nonatomic, assign) CGRect selectedFrame;

// 视频旋转方向
@property (nonatomic, assign) PLSPreviewOrientation rotateOrientation;
@property (nonatomic, strong) QNVerticalButton *rotateButton;

// 速度选取
@property (nonatomic, strong) QNVerticalButton *rateButton;
@property (nonatomic, strong) UISegmentedControl *rateControl;
@property (nonatomic, strong) UIView *rateIndicatorView;

// 时长截取
@property (nonatomic, strong) QNAssetRangeBar *assetRangeBar;

@property (nonatomic, strong) QNGradientView *gradientBar;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation QNTranscodeViewController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.selectedFrame = CGRectZero;
    
    [self setupRangeView];
    
    self.gradientBar = [[QNGradientView alloc] init];
    self.gradientBar.gradienLayer.colors = @[(__bridge id)[[UIColor colorWithWhite:0 alpha:.8] CGColor], (__bridge id)[[UIColor clearColor] CGColor]];
    [self.view addSubview:self.gradientBar];
    [self.gradientBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_topLayoutGuide).offset(50);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [backButton setTintColor:UIColor.whiteColor];
    [backButton setImage:[UIImage imageNamed:@"qn_icon_close"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.gradientBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 44));
        make.left.bottom.equalTo(self.gradientBar);
    }];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 32)];;
    nextButton.backgroundColor = QN_MAIN_COLOR;
    nextButton.layer.cornerRadius = 4.0f;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [nextButton setTitle:@"编 辑" forState:(UIControlStateNormal)];
    [nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.gradientBar addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backButton);
        make.size.equalTo(nextButton.bounds.size);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    QNVerticalButton *rotateButton = [[QNVerticalButton alloc] init];
    rotateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rotateButton setImage:[UIImage imageNamed:@"qn_rotate_video"] forState:(UIControlStateNormal)];
    [rotateButton setTitle:@"旋转" forState:(UIControlStateNormal)];
    [rotateButton addTarget:self action:@selector(clickRotateButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rotateButton];
    self.rotateButton = rotateButton;
    
    QNVerticalButton *rateButton = [[QNVerticalButton alloc] init];
    rateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rateButton setImage:[UIImage imageNamed:@"qn_speed"] forState:(UIControlStateNormal)];
    [rateButton setTitle:@"倍速" forState:(UIControlStateNormal)];
    [rateButton addTarget:self action:@selector(clickRateButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rateButton];
    self.rateButton = rateButton;
    
    self.rateControl = [[UISegmentedControl alloc] initWithItems:@[@"极慢", @"慢", @"标准", @"快", @"极快"]];
    [self.rateControl sizeToFit];
    self.rateControl.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
    self.rateControl.layer.cornerRadius = 5;
    self.rateControl.selectedSegmentIndex = 2;
    self.rateControl.clipsToBounds = YES;
    [self.rateControl addTarget:self action:@selector(rateSegmentChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.rateControl setTintColor:[UIColor clearColor]];
    
    self.rateIndicatorView = [[UIView alloc] init];
    self.rateIndicatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.8];
    self.rateControl.hidden = YES;
    [self.rateControl addSubview:self.rateIndicatorView];
    [self.view addSubview:self.rateControl];
    
    [self.rateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rateButton.mas_left).offset(-20);
        make.centerY.equalTo(self.rateButton);
        make.centerX.equalTo(self.view);
        make.height.equalTo(36);
    }];
    
    [self.rateIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.rateControl).multipliedBy(.2);
        make.center.equalTo(self.rateControl);
        make.height.equalTo(self.rateControl).offset(2);
    }];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    [self.rateControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    NSDictionary *dicS = [NSDictionary dictionaryWithObjectsAndKeys:QN_MAIN_COLOR, NSForegroundColorAttributeName, [UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    [self.rateControl setTitleTextAttributes:dicS forState:UIControlStateSelected];
    
    [rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 55));
        make.bottom.equalTo(self.assetRangeBar.mas_top).offset(-10);
        make.right.equalTo(self.view);
    }];
    
    [rateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.right.equalTo(CGSizeMake(44, 55));
        make.bottom.equalTo(rotateButton.mas_top).offset(-10);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor lightTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
    [self.titleLabel sizeToFit];
    [self.gradientBar addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gradientBar);
        make.centerY.equalTo(nextButton);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.sourceURL == nil) {
            self.sourceURL = [self.class movieURL:self.phAsset];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPlayer];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.player play];
    [self addObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player pause];
    [self removeObserver];
    [super viewDidDisappear:animated];
}

- (void)updateTitle {
    
    NSInteger width = 0;
    NSInteger height = 0;
    CGSize originSize = [self.currentAsset pls_videoSize];
    if (PLSPreviewOrientationLandscapeLeft == self.rotateOrientation ||
        PLSPreviewOrientationLandscapeRight == self.rotateOrientation) {
        originSize = CGSizeMake(originSize.height, originSize.width);
    }
    if (CGRectEqualToRect(self.selectedFrame, CGRectZero)) {
        width = originSize.width;
        height = originSize.height;
    } else {
        CGRect rc = self.maxScopeView.bounds;
        width = round(self.selectedFrame.size.width / rc.size.width * originSize.width);
        height = round(self.selectedFrame.size.height / rc.size.height * originSize.height);
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ldx%ld", (long)width, (long)height];
}

// 初始化视频区域选取 UI
- (void)setupQNScopeCutView {
    
    self.maxScopeView = [[UIView alloc] init];
    [self.player.preview addSubview:self.maxScopeView];
    self.maxScopeView.frame = [PLShortVideoTranscoder videoDisplay:self.currentAsset bounds:self.player.preview.bounds rotate:self.rotateOrientation];
    
    self.scopeView = [[QNScopeCutView alloc] init];
    self.scopeView.userInteractionEnabled = YES;
    self.scopeView.frame = self.maxScopeView.bounds;
    [self.maxScopeView addSubview:self.scopeView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self.scopeView addGestureRecognizer:panGesture];
}

// 初始化时长选取 UI
- (void)setupRangeView {
    
    self.assetRangeBar = [[QNAssetRangeBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 150, self.view.bounds.size.width, QNAssetRangeBar.suitableHeight)];
    self.assetRangeBar.delegate = self;

    [self.view addSubview:self.assetRangeBar];
    [self.assetRangeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-10);
        make.height.equalTo(QNAssetRangeBar.suitableHeight);
    }];
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRotateButton:(UIButton *)button {
    
    /*!
     执行旋转，如果使用的是 PLSEditPlayer 作为预览的播放器，可以直接调用接口旋转,
     如果开发者使用自己的播放器作为预览播放器，那么可以直接对预览 view 进行旋转，没有必要对视频内容进行旋转
     */
    self.rotateOrientation = [self.player rotateVideoLayer];
    
    self.maxScopeView.frame = [PLShortVideoTranscoder videoDisplay:self.currentAsset bounds:self.player.preview.bounds rotate:self.rotateOrientation];
    self.scopeView.frame = self.maxScopeView.bounds;
    self.selectedFrame = CGRectZero;
    [self updateTitle];
}

- (void)clickRateButton:(UIButton *)button {
    if (self.rateControl.hidden) {
        [self.rateControl alphaShowAnimation];
    } else {
        [self.rateControl alphaHideAnimation];
    }
}

- (void)rateSegmentChange:(UISegmentedControl *)segmentControl {
    
    [self.rateIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.rateIndicatorView.bounds.size);
        make.centerY.equalTo(segmentControl);
        make.left.equalTo(segmentControl.bounds.size.width / 5 * segmentControl.selectedSegmentIndex);
    }];
    [UIView animateWithDuration:.3 animations:^{
        [segmentControl layoutIfNeeded];
    }];
    
    [self.player pause];
    
    static PLSVideoRecoderRateType rates[] = {
        PLSVideoRecoderRateTopSlow,
        PLSVideoRecoderRateSlow,
        PLSVideoRecoderRateNormal,
        PLSVideoRecoderRateFast,
        PLSVideoRecoderRateTopFast
    };
    
    if (rates[segmentControl.selectedSegmentIndex] == PLSVideoRecoderRateNormal) {
        self.currentAsset = self.originAsset;
    } else {
        PLShortVideoAsset *shortVideoAsset = [[PLShortVideoAsset alloc] initWithAsset:self.originAsset];
        self.currentAsset = [shortVideoAsset scaleTimeRange:CMTimeRangeMake(kCMTimeZero, self.originAsset.duration) toRateType:(rates[segmentControl.selectedSegmentIndex])];
    }
    
    [self.player setItemByAsset:self.currentAsset];
    [self.assetRangeBar setAsset:self.currentAsset];
    self.player.timeRange = CMTimeRangeMake(kCMTimeZero, self.currentAsset.duration);
    [self.player play];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint transPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
    [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view];
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            // 手势开始的时候，根据触摸位置来决定是执行何种操作
            CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
            CGFloat edgeWidth = self.scopeView.bounds.size.width / 3;
            CGFloat edgeHeight = self.scopeView.bounds.size.height / 3;
            if (point.x <= edgeWidth && point.y <= edgeHeight) {
                self.enumTapPosition = enumPanPositionTopLeft;
            } else if (point.x <= edgeWidth && point.y >= self.scopeView.bounds.size.height - edgeHeight) {
                self.enumTapPosition = enumPanPositionBottomLeft;
            } else if (point.x >= self.scopeView.bounds.size.width - edgeWidth && point.y <= edgeHeight) {
                self.enumTapPosition = enumPanPositionTopRight;
            } else if (point.x >= self.scopeView.bounds.size.width - edgeWidth && point.y >= self.scopeView.bounds.size.height - edgeHeight) {
                self.enumTapPosition = enumPanPositionBottomRight;
            } else {
                self.enumTapPosition = enumPanPositionCenter;
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGRect rect = self.scopeView.frame;
            CGRect maxRect = self.maxScopeView.bounds;
            
            // 设置最小的宽高值，避免剪裁区域太小了
            CGFloat minWidth = self.maxScopeView.bounds.size.width / 4;
            CGFloat minHeight = self.maxScopeView.bounds.size.height / 4;
            
            switch (self.enumTapPosition) {
                case enumPanPositionTopLeft: {
                    transPoint.x = MIN(transPoint.x, rect.size.width - minWidth);
                    transPoint.y = MIN(transPoint.y, rect.size.height - minHeight);
                    if (rect.origin.x + transPoint.x < 0) {
                        transPoint.x =  - rect.origin.x;
                    }
                    if (rect.origin.y + transPoint.y < 0) {
                        transPoint.y =  - rect.origin.y;
                    }
                    rect = CGRectMake(rect.origin.x + transPoint.x, rect.origin.y + transPoint.y, rect.size.width - transPoint.x, rect.size.height - transPoint.y);
                }
                    break;
                    
                case enumPanPositionTopRight: {
                    transPoint.x = MIN(maxRect.size.width - rect.size.width - rect.origin.x, transPoint.x);
                    transPoint.x = MAX(-rect.size.width + minWidth, transPoint.x);
                    transPoint.y = MIN(transPoint.y, rect.size.height - minHeight);
                    if (rect.origin.y + transPoint.y < 0) {
                        transPoint.y = -rect.origin.y;
                    }
                    rect = CGRectMake(rect.origin.x, rect.origin.y + transPoint.y, rect.size.width + transPoint.x, rect.size.height - transPoint.y);
                }
                    break;
                case enumPanPositionBottomLeft: {
                    transPoint.x = MIN(transPoint.x, rect.size.width - minWidth);
                    if (rect.origin.x + transPoint.x < 0) {
                        transPoint.x =  - rect.origin.x;
                    }
                    transPoint.y = MAX(-rect.size.height + minHeight, transPoint.y);
                    transPoint.y = MIN(maxRect.size.height - rect.size.height - rect.origin.y, transPoint.y);
                    
                    rect = CGRectMake(rect.origin.x + transPoint.x, rect.origin.y, rect.size.width - transPoint.x, rect.size.height + transPoint.y);
                }
                    break;
                case enumPanPositionBottomRight: {
                    transPoint.x = MIN(maxRect.size.width - rect.origin.x - rect.size.width, transPoint.x);
                    transPoint.y = MIN(maxRect.size.height - rect.origin.y - rect.size.height, transPoint.y);
                    transPoint.x = MAX(-rect.size.width + minWidth, transPoint.x);
                    transPoint.y = MAX(-rect.size.height + minHeight, transPoint.y);
                    
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + transPoint.x, rect.size.height + transPoint.y);
                }
                    break;
                case enumPanPositionCenter: {
                    rect = CGRectMake(rect.origin.x + transPoint.x, rect.origin.y + transPoint.y, rect.size.width, rect.size.height);
                    rect.origin.x = MAX(rect.origin.x, 0);
                    rect.origin.x = MIN(maxRect.size.width - rect.size.width, rect.origin.x);
                    rect.origin.y = MAX(rect.origin.y, 0);
                    rect.origin.y = MIN(maxRect.size.height - rect.size.height, rect.origin.y);
                }
                    break;
            }
            self.scopeView.frame = rect;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default:
            break;
    }
    self.selectedFrame = self.scopeView.frame;
    [self updateTitle];
}

- (void)setupPlayer {
    if (!self.sourceURL) return;
    
    // 这里的播放可以自己使用 AVPlayer，也可以使用七牛短视频编辑播放器 PLSEditPlayer
    self.player = [[PLSEditPlayer alloc] init];
    self.player.delegate = self;
    self.originAsset = [AVAsset assetWithURL:self.sourceURL];
    self.currentAsset = self.originAsset;
    [self.player setItemByAsset:self.currentAsset];
    self.player.loopEnabled = YES;// 设置循环播放
    [self.view insertSubview:self.player.preview atIndex:0];
    
    [self.player.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.gradientBar.mas_bottom);
        make.bottom.equalTo(self.assetRangeBar.mas_top).offset(-10);
    }];
    
    [self.player play];
    self.assetRangeBar.asset = self.currentAsset;
    
    [UIView animateWithDuration:.0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 在视频渲染 view  的 frame 确定之后，再初始化区域剪裁，因为要用到 preview  的 frame
        [self setupQNScopeCutView];
    }];
    
    [self updateTitle];
}

- (void)addObserver {
    
    [self removeObserver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    /*！
     这里不监听 UIApplicationWillEnterForegroundNotification 的原因是 app 返回前台的时候，
     UIApplicationWillEnterForegroundNotification 不一定有回调
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)info {
    [self.player pause];
}

- (void)applicationDidBecomeActive:(NSNotification *)info {
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

// 执行转码
- (void)clickNextButton:(UIButton *)button {
    
    [self.player pause];
    
    // 视频区域是否存在变化
    BOOL isScopeCut = !(CGRectEqualToRect(CGRectZero, self.selectedFrame) || CGRectEqualToRect(self.selectedFrame, self.maxScopeView.bounds));
    
    // 时长选取是否有变化
    BOOL isRangeCut = !(CMTIMERANGE_IS_EMPTY(self.player.timeRange) || CMTimeRangeEqual(self.player.timeRange, CMTimeRangeMake(kCMTimeZero, self.currentAsset.duration)));
    
    /*!
     是否是超高分辨率的视频，虽然七牛 SDK 编辑部分并没有限制视频的宽高，但是像素太高了，部分手机性能跟不上，
     甚至出现内存问题，因此当遇到超过 720p 的视频的时候，做一下降分辨率处理
     */
    BOOL isHighPixel = (self.currentAsset.pls_videoSize.width + self.currentAsset.pls_videoSize.height) > (720 + 1280);
    
    /*!
     是否进行了倍速处理
     */
    BOOL isSpeed = self.currentAsset != self.originAsset;
    
    if (isScopeCut || isRangeCut || isHighPixel || PLSPreviewOrientationPortrait != self.rotateOrientation || isSpeed) {
        
        if (isScopeCut) {
            // 存在区域剪裁, 设置参数稍微麻烦点
            [self doPixelScopeCutTranscoding];
        } else {
            // 不存在区域剪裁，直接转码
            [self doDirectTranscoding];
        }
        
    } else {
        // 如果不存在变化，直接进入编辑页面
        [self gotoEditorController:self.sourceURL];
    }
}

- (void)doDirectTranscoding {
    
    PLShortVideoTranscoder *transcoder = [[PLShortVideoTranscoder alloc] initWithAsset:self.currentAsset];
    transcoder.rotateOrientation = self.rotateOrientation;
    transcoder.videoFrameRate = MAX(60, self.currentAsset.pls_normalFrameRate);
    transcoder.isExportMovieToPhotosAlbum = NO;
    transcoder.outputURL = nil; // 转码之后的视频保存地址，设置为 nil 话，内部会自动创建
    
    if (CMTIMERANGE_IS_VALID(self.player.timeRange) && !CMTIMERANGE_IS_EMPTY(self.player.timeRange)) {
        // 如果不设置 timeRange, 默认为整个视频时长，如果设置，那么必须是可用的并且不能为空（EMPTY）
        transcoder.timeRange = self.player.timeRange;
    }
    
    CGSize originVideoSize = self.currentAsset.pls_videoSize;
    CGSize tempSize = originVideoSize;
    if (originVideoSize.width + originVideoSize.height > 720 + 1280) {
        // 如果原视频大于 1080P，限制一下转码之后的视频为 1080P
        transcoder.outputFilePreset = PLSFilePreset1280x720;
        tempSize = CGSizeMake(720, 1280);
    } else {
        // 设置为 PLSFilePresetHighestQuality，则转码后的宽高等于原视频的宽高
        transcoder.outputFilePreset = PLSFilePresetHighestQuality;
    }
    
    /*!
     如果不设置码率，SDK 内部会根据设置的 outputFilePreset 自动计算码率，如果设置的码率大于原视频的码率，
     则会被自动降到原视频码率，因此码率值只能是小于等于原视频码率
     */
    transcoder.bitrate = [QNBaseViewController suitableVideoBitrateWithSize:tempSize];
    
    [self showWating];
    
    // 设置转码进度回调
    [transcoder setProcessingBlock:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setProgress:progress];
        });
    }];
    
    // 设置转码失败回调
    [transcoder setFailureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWating];
            [self showAlertMessage:nil message:error.localizedDescription];
        });
    }];
    
    // 设置转码成功回调
    [transcoder setCompletionBlock:^(NSURL *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWating];
            [self gotoEditorController:url];
        });
    }];
    
    //启动
    [self.player pause];
    [transcoder startTranscoding];
}

- (void)doPixelScopeCutTranscoding {
    
    PLShortVideoTranscoder *transcoder = [[PLShortVideoTranscoder alloc] initWithAsset:self.currentAsset];
    transcoder.rotateOrientation = self.rotateOrientation;
    transcoder.videoFrameRate = MAX(60, self.currentAsset.pls_normalFrameRate);
    transcoder.isExportMovieToPhotosAlbum = NO;
    transcoder.outputURL = nil; // 转码之后的视频保存地址，设置为 nil 的话，内部会自动创建
    
    if (CMTIMERANGE_IS_VALID(self.player.timeRange) && !CMTIMERANGE_IS_EMPTY(self.player.timeRange)) {
        // 如果不设置 timeRange, 默认为整个视频时长，如果设置，那么必须是可用的并且不能为空（EMPTY）
        transcoder.timeRange = self.player.timeRange;
    }
    
    CGRect maxRect = self.maxScopeView.bounds;
    CGSize originVideoSize = [self.currentAsset pls_videoSize];
    if (PLSPreviewOrientationLandscapeLeft == self.rotateOrientation ||
        PLSPreviewOrientationLandscapeRight == self.rotateOrientation) {
        originVideoSize = CGSizeMake(originVideoSize.height, originVideoSize.width);
    }
    CGFloat scale = originVideoSize.width / maxRect.size.width;
    
    CGRect cutPixelFrame = CGRectMake(
                                      (self.scopeView.frame.origin.x - maxRect.origin.x) * scale,
                                      (self.scopeView.frame.origin.y - maxRect.origin.y) * scale,
                                      self.scopeView.frame.size.width * scale,
                                      self.scopeView.frame.size.height * scale
                                      );
    
    // videoSelectedRect 为我们选取的像素区域
    transcoder.videoSelectedRect = cutPixelFrame;
    
    /*!
     1. 如果不设置 destVideoSize， 导出视频的宽高为 videoSelectedRect.size
     2. destVideoSize 的值不受 rotateOrientation 影响，无论 rotateOrientation 为何值，导出视频始终是 destVideoSize
     3. 如果 destVideoSize 不是 2 的整数倍，SDK 内部会自动调整宽高到 2 的整数倍
     */
    CGSize cutPixelSize = CGSizeMake(cutPixelFrame.size.width, cutPixelFrame.size.height);;
    CGSize destVideoSize = cutPixelSize;
    
    // 如果剪裁区域的像素大于 720 + 1280，则缩放一下限制到 720p 以内，否则就使用剪裁的像素宽高作为最终生成视频的宽高
    if (cutPixelSize.width + cutPixelSize.height > 720 + 1280) {
        if (cutPixelSize.width > cutPixelSize.height) {
            if (cutPixelSize.width / cutPixelSize.height > 1280.0 / 720.0) {
                destVideoSize.width = 1280;
                destVideoSize.height = cutPixelSize.height * 1280 / cutPixelSize.width;
            } else {
                destVideoSize.height = 720;
                destVideoSize.width = cutPixelSize.width * 720 / cutPixelSize.height;
            }
        } else {
            if (cutPixelSize.width / cutPixelSize.height > 720.0 / 1280.0) {
                destVideoSize.width = 720;
                destVideoSize.height = cutPixelSize.height * 720 / cutPixelSize.width;
            } else {
                destVideoSize.height = 1280;
                destVideoSize.width = cutPixelSize.width * 1280 / cutPixelSize.height;
            }
        }
    }
    transcoder.destVideoSize = destVideoSize;
    
    /*!
     如果不设置码率，SDK 内部会自动设置合适的码率值。在区域剪裁存在的情况下，设置 destVideoSize 的时候，
     SDK 内部会自动设置码率，因此想自定义码率，码率值必须在设置 destVideoSize 之后设置才会生效
     */
    transcoder.bitrate = [QNBaseViewController suitableVideoBitrateWithSize:cutPixelFrame.size];
    
    [self showWating];
    
    [transcoder setProcessingBlock:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setProgress:progress];
        });
    }];
    
    [transcoder setFailureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWating];
            [self showAlertMessage:nil message:error.localizedDescription ];
        });
    }];
    
    [transcoder setCompletionBlock:^(NSURL *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWating];
            [self gotoEditorController:url];
        });
    }];
    
    //启动
    [transcoder startTranscoding];
}

- (void)gotoEditorController:(NSURL *)url {
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    [asset loadValuesAsynchronouslyForKeys:@[@"duration", @"tracks"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
            // 待编辑的原始视频素材
            NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
            plsMovieSettings[PLSURLKey] = url;
            plsMovieSettings[PLSAssetKey] = [AVAsset assetWithURL:url];
            plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
            plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
            
            outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
            
            QNEditorViewController *controller = [[QNEditorViewController alloc] init];
            controller.settings = outputSettings;
            controller.fileURLArray = @[url];
            controller.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:controller animated:YES completion:nil];
        });
    }];
}

// ====== QNAssetRangeBarDelegate
- (void)assetRangeBar:(QNAssetRangeBar *)assetRangeBar didStartMove:(BOOL)isLeft {
    // 开始滑动的时候，暂停播放器播放，能达到跟精确的预览效果
    [self.player pause];
}

- (void)assetRangeBar:(QNAssetRangeBar *)assetRangeBar movingToTime:(CMTime)time isLeft:(BOOL)isLeft {
    CMTime offset = kCMTimeZero;
    if (CMTimeCompare(CMTimeMake(200, 1000), time) > 0) {
        // 避免部分视频文件的视频通道开始时间不是从 0 开始的，seek 的时候出现黑屏
        offset = CMTimeMake(200, 1000);
    }
    [self.player seekToTime:time toleranceBefore:offset toleranceAfter:offset];
}

- (void)assetRangeBar:(QNAssetRangeBar *)assetRangeBar didEndMoveWithSelectedTimeRange:(CMTimeRange)timeRange isLeft:(BOOL)isLeft {
    if (!isLeft) {
        CMTime offset = kCMTimeZero;
        if (CMTimeCompare(CMTimeMake(200, 1000), timeRange.start) > 0) {
            offset = CMTimeMake(200, 1000);
        }
        [self.player seekToTime:assetRangeBar.startTime toleranceBefore:offset toleranceAfter:offset];
    }
    self.player.timeRange = timeRange;
    [self.player play];
}

// ====== PLSEditPlayerDelegate
- (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timestamp:(CMTime)timestamp {
    [self.assetRangeBar setCurrentTime:timestamp];
    return pixelBuffer;
}

- (void)dealloc {
    [self.player pause];
    [self removeObserver];
}

@end
