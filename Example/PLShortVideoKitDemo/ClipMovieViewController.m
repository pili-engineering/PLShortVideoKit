//
//  ClipMovieViewController
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ClipMovieViewController.h"
#import "EditViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSClipMovieView.h"
#import <Masonry/Masonry.h>

#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ClipMovieViewController () <PLSClipMovieViewDelegate>

@property (strong, nonatomic) UIView *baseToolboxView;

@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;
@property (strong, nonatomic) PLSFile *fileManager;

@property (strong, nonatomic) PLSClipMovieView *clipMovieView;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;

@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (assign, nonatomic) CGFloat videoPlaybackPosition;

@end

@implementation ClipMovieViewController

#pragma mark -- 获取视频／音频文件的总时长
- (CGFloat)getFileDuration:(NSURL*)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:opts];
    
    CMTime duration = asset.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    
    return durationSeconds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    // --------------------------
    self.startTime = 0.0f;
    self.endTime = [self getFileDuration:self.url];
    
    // --------------------------
    [self setupBaseToolboxView];
    
    [self setupClipMovieView];
    
    // --------------------------
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:[AVAsset assetWithURL:self.url]];
    self.shortVideoEditor.player.loopEnabled = YES;
    self.shortVideoEditor.player.preview.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
    self.shortVideoEditor.player.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.view addSubview:self.shortVideoEditor.player.preview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.shortVideoEditor.player seekToTime:CMTimeMake(self.startTime, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.shortVideoEditor.player play];
    [self startPlaybackTimeChecker];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.shortVideoEditor.player pause];
    [self stopPlaybackTimeChecker];
}

#pragma mark -- 配置视图
- (void)setupBaseToolboxView {
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
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
    titleLabel.text = @"剪辑";
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

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    [self.shortVideoEditor.player pause];
    
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    AVAsset *asset = [AVAsset assetWithURL:self.url];
    plsMovieSettings[PLSURLKey] = self.url;
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:self.startTime];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:(self.endTime - self.startTime)];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

#pragma mark - PLSClipMovieView delegate
- (void)didStartDragView {
//    if (self.shortVideoEditor.player.rate > 0) { // 正在播放的时候
//        [self.shortVideoEditor.player pause];
//    }
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didDragView:(CMTime)time {

}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)time; {
    self.startTime = CMTimeGetSeconds(time);
    
    [self.shortVideoEditor.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragRightView:(CMTime)time; {
    self.endTime = CMTimeGetSeconds(time);    
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling {
    self.view.userInteractionEnabled = !scrolling;
}

#pragma mark -- PlaybackTimeCheckerTimer
- (void)startPlaybackTimeChecker {
    [self stopPlaybackTimeChecker];
    
    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}

- (void)stopPlaybackTimeChecker {
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}

- (void)onPlaybackTimeCheckerTimer {
    CMTime curTime = [self.shortVideoEditor.player currentTime];
    Float64 seconds = CMTimeGetSeconds(curTime);
    if (seconds < 0){
        seconds = 0; // this happens! dont know why.
    }
    self.videoPlaybackPosition = seconds;
    
    if (self.videoPlaybackPosition >= self.endTime) {
        self.videoPlaybackPosition = self.startTime;
        [self seekVideoToPos: self.startTime];
    }
}

- (void)seekVideoToPos:(CGFloat)pos {
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.shortVideoEditor.player.currentTime.timescale);
    //NSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
    [self.shortVideoEditor.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
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
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }

    self.baseToolboxView = nil;
    
    self.shortVideoEditor = nil;
}

@end

