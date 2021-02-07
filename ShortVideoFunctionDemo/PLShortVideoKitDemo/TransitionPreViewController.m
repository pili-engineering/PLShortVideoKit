//
//  TransitionPreViewController.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/11/4.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "TransitionPreViewController.h"
#import "EditViewController.h"

#import "PLSTimelineView.h"    // 时间线管理
#import "PLSTimeLineAudioItem.h"

#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_TimeToolboxView_HEIGHT 50

@interface TransitionPreViewController ()
<
UIGestureRecognizerDelegate,
PLSTimelineViewDelegate,
PLSTransitionScrollViewDelegate
>

// 预览视图
@property (nonatomic, strong) UIView *previewDidplayView;
// 基础视图
@property (nonatomic, strong) UIView *baseToolboxView;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

// 时间线编辑视频组件
@property (nonatomic, strong) PLSTimelineView *timelineView;
@property (nonatomic, strong) PLSTimelineMediaInfo *mediaInfo;

// 播放/暂停按钮，点击视频预览区域实现播放/暂停功能
@property (nonatomic, strong) UIButton *playButton;

// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

// 视频合成的进度
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign) NSTimer *timer;

@end

@implementation TransitionPreViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.playButton.selected = NO;
    [self controlPlayOrPause:self.playButton.selected];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.playButton.selected = YES;
    [self controlPlayOrPause:self.playButton.selected];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBaseToolboxView];
    
    [self setupPreviewDisplayView];
    
    [self setupTransitionScrollView];
    
    [self setupTimelineView];
    
    [self setupMergeToolboxView];
}

// 编辑显示视图
- (void)setupPreviewDisplayView {
    self.previewDidplayView = [[UIView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH / 8, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - PLS_BaseToolboxView_HEIGHT - PLS_SCREEN_WIDTH / 8 - PLS_TimeToolboxView_HEIGHT)];
    self.previewDidplayView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.previewDidplayView];
    
    // player
    self.player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, 500);
    [self.previewDidplayView.layer addSublayer:self.playerLayer];
  
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectZero;
    self.playButton.center = CGPointZero;
    [self.playButton setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateSelected];
    [self.previewDidplayView addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加点击手势
    self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchBGView:)];
    self.tapGes.cancelsTouchesInView = NO;
    self.tapGes.delegate = self;
    [self.previewDidplayView addGestureRecognizer:self.tapGes];
}

- (void)setupTransitionScrollView {
    __weak typeof(self)weakSelf = self;
    // 调用 updatePreviewTransitionMedias:transitionType: 则需刷新 playerItem 做预览
    [self.imageVideoComposer setPreviewBlock:^(AVPlayerItem *playerItem) {
        if (playerItem) {
            weakSelf.playerItem = playerItem;
            [weakSelf.player replaceCurrentItemWithPlayerItem:playerItem];
            if (weakSelf.timelineView.getCurrentTime != 0.0) {
                [weakSelf.timelineView seekToTime:0.0];
            }
        } else{
            NSLog(@"playItem is nil!");
        }
    }];
    [self.imageVideoComposer setPreviewFailureBlock:^(NSError *error) {
        NSLog(@"error - %@", error);
    }];
    
    CGFloat height = ([UIScreen mainScreen].bounds.size.width / 5);
    self.transitionScrollView = [[PLSTransitionScrollView alloc] initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT - height - 80, PLS_SCREEN_WIDTH, height) withImages:self.images types:self.types];
    self.transitionScrollView.delegate = self;
    [self.view addSubview:_transitionScrollView];
}

// 基础工具视图
- (void)setupBaseToolboxView {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);

    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
    self.baseToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.baseToolboxView];
    
    CGFloat topSpace = 20;
    if (PL_iPhoneX || PL_iPhoneXR || PL_iPhoneXSMAX ||
        PL_iPhone12Min || PL_iPhone12Pro || PL_iPhone12PMax) {
        topSpace = 26;
    }

    // 关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, topSpace, 80, 44);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 44)];
    if (iPhoneX_SERIES) {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 48);
    } else {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 42);
    }
    titleLabel.text = @"预览视图";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.baseToolboxView addSubview:titleLabel];
    
    // 下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"btn_bar_next_a"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"btn_bar_next_b"] forState:UIControlStateHighlighted];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, topSpace, 80, 44);
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:nextButton];
}

// 时间线视图
- (void)setupTimelineView {
    // 时间线视图
    self.timelineView = [[PLSTimelineView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH / 8)];
    self.timelineView.backgroundColor = [UIColor clearColor];
    self.timelineView.delegate = self;
    [self.view addSubview:self.timelineView];
    [self.timelineView updateTimelineViewAlpha:0.5];
    
    // 装载当前视频到 时间线视图里面
    self.mediaInfo = [[PLSTimelineMediaInfo alloc] init];
    self.mediaInfo.asset = _playerItem.asset;
    self.mediaInfo.duration = CMTimeGetSeconds(_playerItem.asset.duration);
    
    [self.timelineView setMediaClips:@[self.mediaInfo] segment:8.0 photosPersegent:8.0];
}

// 拼接工具视图
- (void)setupMergeToolboxView {
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 展示拼接视频的进度
    CGFloat width = self.activityIndicatorView.frame.size.width;
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.center = CGPointMake(self.activityIndicatorView.center.x, self.activityIndicatorView.center.y + 40);
    [self.activityIndicatorView addSubview:self.progressLabel];
}

#pragma mark -- PLSTransitionScrollViewDelegate

- (void)transitionScrollView:(PLSTransitionScrollView *)transitionScrollView didClickIndex:(NSInteger)index button:(UIButton *)button {
    __weak typeof(self)weakSelf = self;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择转场效果" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *fadeAction = [UIAlertAction actionWithTitle:@"淡入淡出" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeFade)];
        [button setTitle:@"淡入淡出" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeFade];
    }];
    [alert addAction:fadeAction];

    
    /********* OpenGL *********/
    UIAlertAction *gradualBlackAction = [UIAlertAction actionWithTitle:@"闪黑" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeFadeBlack)];
        [button setTitle:@"闪黑" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeFadeBlack];
    }];
    
    UIAlertAction *gradualWhiteAction = [UIAlertAction actionWithTitle:@"闪白" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeFadeWhite)];
        [button setTitle:@"闪白" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeFadeWhite];
    }];
    
    [alert addAction:gradualWhiteAction];
    [alert addAction:gradualBlackAction];
          
    UIAlertAction *circularCropAction = [UIAlertAction actionWithTitle:@"圆形" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeCircularCrop)];
        [button setTitle:@"圆形" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeCircularCrop];
    }];
    [alert addAction:circularCropAction];
    
    // 飞入 上下左右
    UIAlertAction *sliderUpAction = [UIAlertAction actionWithTitle:@"从上飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderUp)];
        [button setTitle:@"从上飞入" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeSliderUp];
    }];
    
    UIAlertAction *sliderDownAction = [UIAlertAction actionWithTitle:@"从下飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderDown)];
        [button setTitle:@"从下飞入" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeSliderDown];
    }];
    
    UIAlertAction *sliderLeftAction = [UIAlertAction actionWithTitle:@"从左飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderLeft)];
        [button setTitle:@"从左飞入" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeSliderLeft];
    }];
    
    UIAlertAction *sliderRightAction = [UIAlertAction actionWithTitle:@"从右飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderRight)];
        [button setTitle:@"从右飞入" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeSliderRight];
    }];
    
    [alert addAction:sliderUpAction];
    [alert addAction:sliderDownAction];
    [alert addAction:sliderLeftAction];
    [alert addAction:sliderRightAction];
      
    // 擦除 上下左右
    UIAlertAction *wipeUpAction = [UIAlertAction actionWithTitle:@"从上擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeUp)];
        [button setTitle:@"从上擦除" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeWipeUp];
    }];
    
    UIAlertAction *wipeDownAction = [UIAlertAction actionWithTitle:@"从下擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeDown)];
        [button setTitle:@"从下擦除" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeWipeDown];
    }];
    
    UIAlertAction *wipeLeftAction = [UIAlertAction actionWithTitle:@"从左擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeLeft)];
        [button setTitle:@"从左擦除" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeWipeLeft];
    }];
    
    UIAlertAction *wipeRightAction = [UIAlertAction actionWithTitle:@"从右擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeRight)];
        [button setTitle:@"从右擦除" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeWipeRight];
    }];
    
    [alert addAction:wipeUpAction];
    [alert addAction:wipeDownAction];
    [alert addAction:wipeLeftAction];
    [alert addAction:wipeRightAction];
    
    UIAlertAction *noneAction = [UIAlertAction actionWithTitle:@"无" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.transitionScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeNone)];
        [button setTitle:@"无" forState:UIControlStateNormal];
        [weakSelf.imageVideoComposer updatePreviewTransitionMedias:index transitionType:PLSTransitionTypeNone];
    }];
           
    [alert addAction:noneAction];
     
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- timer
- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerAction {
    // 更新时间线视图
    CGFloat time = CMTimeGetSeconds(_player.currentTime);
    [self.timelineView seekToTime:time];
          
    CGFloat duration = CMTimeGetSeconds(_player.currentItem.duration);
    // 循环播放
    if (time == duration) {
        [_player seekToTime:kCMTimeZero];
        [_player play];
    }
}

#pragma mark - button action

- (void)playButtonClicked:(UIButton *)button {
    self.playButton.selected = !self.playButton.selected;
    [self controlPlayOrPause:self.playButton.selected];
}

- (void)onTouchBGView:(UITapGestureRecognizer *)tap {
    self.playButton.selected = !self.playButton.selected;
    [self controlPlayOrPause:self.playButton.selected];
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextButtonClick {
    [self controlPlayOrPause:YES];
    
    [self loadActivityIndicatorView];
    
    __weak typeof(self)weakSelf = self;

    [self.imageVideoComposer setProcessingBlock:^(float progress) {
        NSLog(@"process = %f", progress);
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"合成进度%d%%", (int)(progress * 100)];
    }];
        
    [self.imageVideoComposer setCompletionBlock:^(NSURL * _Nonnull url) {
        NSLog(@"completion");
        [weakSelf removeActivityIndicatorView];
        weakSelf.progressLabel.text = @"";
        
        [weakSelf joinEditViewController:url];
    }];
    
    [self.imageVideoComposer setFailureBlock:^(NSError * _Nonnull error) {
        [weakSelf removeActivityIndicatorView];
        weakSelf.progressLabel.text = @"";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];

    if (self.imageVideoComposer.disableTransition) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择拼接模式" message:@"同步优先：优先考虑拼接之后音视频的同步性，但是可能造个各个视频的拼接处播放的时候出现音频或者视频卡顿\n流畅优先：优先考虑拼接之后播放的流畅性，各个视频的拼接处不会出现音视频卡顿现象，但是可能造成音视频不同步\n视频优先：以每一段视频数据长度来决定每一段音频数据长度\n 音频优先：以每一段音频数据长度来决定每一段视频数据长度" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *syncAction = [UIAlertAction actionWithTitle:@"同步模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeActivityIndicatorView];
            weakSelf.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeSync;
            [weakSelf.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *smoothAction = [UIAlertAction actionWithTitle:@"流畅模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeActivityIndicatorView];
            weakSelf.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeSmooth;
            [weakSelf.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频优先" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeActivityIndicatorView];
            weakSelf.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeVideo;
            [weakSelf.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *audioAction = [UIAlertAction actionWithTitle:@"音频优先" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeActivityIndicatorView];
            weakSelf.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeAudio;
            [weakSelf.imageVideoComposer startComposing];
        }];
        
        [alert addAction:syncAction];
        [alert addAction:smoothAction];
        [alert addAction:videoAction];
        [alert addAction:audioAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self.imageVideoComposer startComposing];
    }
}

// 进入编辑页面
- (void)joinEditViewController:(NSURL *)url {
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    AVAsset *asset = [AVAsset assetWithURL:url];
    plsMovieSettings[PLSURLKey] = url;
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.filesURLArray = @[url];
    videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

- (void)controlPlayOrPause:(BOOL)isPlaying {
    if (isPlaying) {
        [self.player pause];
        [self stopTimer];
    } else {
        [self.player play];
        [self startTimer];
    }
}

#pragma mark - 时间线代理 PLSTimelineViewDelegate

- (void)timelineBeginDragging {
    
}

- (void)timelineCurrentTime:(CGFloat)time duration:(CGFloat)duration {
    
}

- (void)timelineDraggingAtTime:(CGFloat)time {
    // 确保精度达到0.001
    CMTime seekTime = CMTimeMakeWithSeconds(time, 1000);
    [self.player seekToTime:seekTime];
}

- (void)timelineDraggingTimelineItem:(PLSTimeLineItem *)item {
    
}

- (void)timelineEndDraggingAndDecelerate:(CGFloat)time {
    
}

#pragma mark - UIActivityIndicatorView

// 加载拼接视频的动画
- (void)loadActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

// 移除拼接视频的动画
- (void)removeActivityIndicatorView {
    [self.activityIndicatorView removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
}

- (void)dealloc {
    [self.playerLayer removeFromSuperlayer];
    self.timelineView = nil;
    self.player = nil;
    NSLog(@"dealloc: %@", [[self class] description]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
