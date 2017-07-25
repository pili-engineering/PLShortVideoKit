//
//  MovieTransCodeViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/7/12.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MovieTransCodeViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "ClipMovieViewController.h"
#import "PLSClipMovieView.h"
#import <Masonry/Masonry.h>
#import "PLSSelectionView.h"

#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)


@interface MovieTransCodeViewController ()
<
PLSClipMovieViewDelegate,
PLSSelectionViewDelegate
>

// 视图
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;

// 选取需要的视频段
@property (strong, nonatomic) PLSClipMovieView *clipMovieView;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;

// 选取转码质量
@property (strong, nonatomic) PLSSelectionView *selectionView;

// 播放器
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;

// 客户端转码，能压缩视频的大小 + 剪辑视频
@property (assign, nonatomic) PLSFilePreset transcoderPreset;
@property (strong, nonatomic) PLShortVideoTranscoder *shortVideoTranscoder;

@end

@implementation MovieTransCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // --------------------------

    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    // --------------------------
    
    // 配置工具视图
    [self setupBaseToolboxView];
    
    [self setupSelectionView];
    
    [self setupClipMovieView];
    
    // --------------------------
    
    // 播放器初始化
    [self initPlayer];
}

#pragma mark -- 配置视图
- (void)setupBaseToolboxView {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
    self.baseToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.baseToolboxView];
    
    // 关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 64)];
    titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    titleLabel.text = @"转码";
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
    nextButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:nextButton];
    
    // 展示转码的进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 200, 45)];
    self.progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    [self.baseToolboxView addSubview:self.progressLabel];
    
    // 展示转码的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupSelectionView {
    self.selectionView = [[PLSSelectionView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT + 10, PLS_SCREEN_WIDTH, 35) lineWidth:1 lineColor:[UIColor blackColor]];
    [self.selectionView setItemsWithTitle:[NSArray arrayWithObjects:@"Medium", @"Highest", @"480P", @"540P", @"720P", @"1080P", nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor blackColor] normalTitleColor:[UIColor blackColor] selectTitleColor:[UIColor whiteColor] titleTextSize:15 selectItemNumber:3];
    self.selectionView.delegate = self;
    self.selectionView.layer.cornerRadius = 5.0;
    [self.view addSubview:self.selectionView];
    
    self.transcoderPreset = PLSFilePreset960x540; // 默认, 对应 selectItemNumber:3
}

- (void)setupClipMovieView {
    self.clipMovieView = [[PLSClipMovieView alloc] initWithMovieURL:self.url minDuration:2.0f maxDuration:180.f];
    self.clipMovieView.delegate = self;
    [self.view addSubview:self.clipMovieView];
    [self.clipMovieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
}

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

#pragma mark -- 播放器初始化
- (void)initPlayer {
    if (!_url) {
        return;
    }
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.url options:nil];
    self.startTime = 0.f;
    self.endTime = CMTimeGetSeconds(movieAsset.duration);
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    self.playerLayer.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    UIView *playerView = [[UIView alloc] initWithFrame:self.playerLayer.frame];
    [playerView.layer addSublayer:self.playerLayer];
    [self.view insertSubview:playerView belowSubview:self.baseToolboxView];
}

#pragma mark - PLSClipMovieView delegate
- (void)didStartDragView {
    //    if (self.player.rate > 0) { // 正在播放的时候
    //        [self.player pause];
    //    }
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didDragView:(CMTime)time {
    
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)time; {
    self.startTime = CMTimeGetSeconds(time);
    
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragRightView:(CMTime)time; {
    self.endTime = CMTimeGetSeconds(time);
    
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling {
    self.view.userInteractionEnabled = !scrolling;
}

#pragma mark -- PLSSelectionViewDelegate
- (void)selectionView:(PLSSelectionView *)selectionView didSelectedItemNumber:(NSInteger)number {
    switch (number) {
        case 0:
            self.transcoderPreset = PLSFilePresetMediumQuality;
            break;
        case 1:
            self.transcoderPreset = PLSFilePresetHighestQuality;
            break;
        case 2:
            self.transcoderPreset = PLSFilePreset640x480;
            break;
        case 3:
            self.transcoderPreset = PLSFilePreset960x540;
            break;
        case 4:
            self.transcoderPreset = PLSFilePreset1280x720;
            break;
        case 5:
            self.transcoderPreset = PLSFilePreset1920x1080;
            break;
            
        default:
            self.transcoderPreset = PLSFilePreset960x540;
            break;
    }
}

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    [self loadActivityIndicatorView];
    
    [self movieTransCodeAction];
}

#pragma mark -- 开始视频转码动作
- (void)movieTransCodeAction {
    __weak typeof(self) weakSelf = self;
    
    // 比如选取 [startTime, endTime] 这段视频来转码输出
    CMTimeRange timeRange = CMTimeRangeFromTimeToTime(CMTimeMake(self.startTime, 1), CMTimeMake(self.endTime, 1));

    self.shortVideoTranscoder = [[PLShortVideoTranscoder alloc] initWithURL:self.url];
    self.shortVideoTranscoder.outputFileType = PLSFileTypeMPEG4;
    self.shortVideoTranscoder.outputFilePreset = self.transcoderPreset;
    self.shortVideoTranscoder.timeRange = timeRange;
    [self.shortVideoTranscoder startTranscoding];
    
    [self.shortVideoTranscoder setCompletionBlock:^(NSURL *url){

        NSLog(@"transCoding successd, url: %@", url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            weakSelf.progressLabel.text = @"";
            
            NSString *beforeTranscodingSize = [NSString stringWithFormat:@"%.2f", [weakSelf fileSize:weakSelf.url]];
            NSString *afterTranscodingSize = [NSString stringWithFormat:@"%.2f", [weakSelf fileSize:url]];
            
            NSLog(@"%@-->%@", beforeTranscodingSize, afterTranscodingSize);
            
            ClipMovieViewController *clipMovieViewController = [[ClipMovieViewController alloc] init];
            clipMovieViewController.url = url;
            [weakSelf presentViewController:clipMovieViewController animated:YES completion:nil];
        });
    }];
    
    [self.shortVideoTranscoder setFailureBlock:^(NSError *error){
        
        NSLog(@"transCoding failed: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            weakSelf.progressLabel.text = @"";
        });
    }];
    
    [self.shortVideoTranscoder setProcessingBlock:^(float progress){
        // 更新压缩进度的 UI
        NSLog(@"transCoding progress: %f", progress);
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"转码进度%d%%", (int)(progress * 100)];
    }];
}

#pragma mark -- 计算文件的大小，单位为 M
- (CGFloat)fileSize:(NSURL *)url {
    return [[NSData dataWithContentsOfURL:url] length] / 1024.00 / 1024.00;
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- dealloc
- (void)dealloc {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    self.selectionView = nil;
    
    self.player = nil;
    self.playerLayer = nil;
    self.playerItem = nil;
    
    self.shortVideoTranscoder = nil;
}

@end
