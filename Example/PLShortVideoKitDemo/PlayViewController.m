//
//  PlayViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "FLAnimatedImage.h"
#import "PLSPlayerView.h"


#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_EditToolboxView_HEIGHT 50

static NSString *const kUploadToken = @"QxZugR8TAhI38AiJ_cptTl3RbzLyca3t-AAiH-Hh:3hK7jJJQKwmemseSwQ1duO5AXOw=:eyJzY29wZSI6InNhdmUtc2hvcnQtdmlkZW8tZnJvbS1kZW1vIiwiZGVhZGxpbmUiOjM1NTk2OTU4NzYsInVwaG9zdHMiOlsiaHR0cDovL3VwLXoyLnFpbml1LmNvbSIsImh0dHA6Ly91cGxvYWQtejIucWluaXUuY29tIiwiLUggdXAtejIucWluaXUuY29tIGh0dHA6Ly8xNC4xNTIuMzcuNCJdfQ==";
static NSString *const kURLPrefix = @"http://panm32w98.bkt.clouddn.com";

@interface PlayViewController ()
<
PLShortVideoUploaderDelegate,
UIGestureRecognizerDelegate
>
{
    id _timeObserver;
}

// 工具视图
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *processerToolboxView;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UISlider *playSlider;
@property (strong, nonatomic) UILabel * currentTime;
@property (strong, nonatomic) UILabel * duration;

// 视频播放
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) PLSPlayerView *playerView;
@property (strong, nonatomic) UIProgressView *processView;

// gif 图预览
@property (strong, nonatomic) FLAnimatedImageView *gifView;

// 上传视频到云端
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) PLShortVideoUploader *shortVideoUploader;

// 定时器监听
@property (strong, nonatomic) NSTimer * timer;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.actionType == PLSActionTypePlayer) {
        // 播放器初始化
        [self initPlayer];
        
        // 配置播放信息视图
        [self setupPlayerUI];
        
        // 单指单击，播放视频
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerToPlayVideoEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; // 手指数
        singleFingerOne.numberOfTapsRequired = 1; // tap次数
        singleFingerOne.delegate = self;
        [self.view addGestureRecognizer:singleFingerOne];
    }
    if (self.actionType == PLSActionTypeGif) {
        // 显示 gif 动图        
        self.gifView = [[FLAnimatedImageView alloc] init];
        self.gifView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - PLS_BaseToolboxView_HEIGHT);
        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.gifView];
    }
    
    // 配置工具视图
    [self setupToolboxUI];
    
    // 文件上传（可上传视频、Gif 等）
    [self setupFileUpload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.actionType == PLSActionTypePlayer) {
        [self.player play];
    }
    if (self.actionType == PLSActionTypeGif) {
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:self.url]];
        self.gifView.animatedImage = image;
    }
    
    [self addObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.actionType == PLSActionTypePlayer) {
        [self.player pause];
    }
    if (self.actionType == PLSActionTypeGif) {
        self.gifView.animatedImage = nil;
    }
    
    [self removeTimeObserver];
}

-(void)addObserver {
    if (_timeObserver) return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    __weak typeof(self) weakSelf = self;
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float process = CMTimeGetSeconds(time) / CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.playSlider.value = process;
        weakSelf.currentTime.text = [NSString stringWithFormat:@"%.2fs", CMTimeGetSeconds(time)];
        weakSelf.duration.text = [NSString stringWithFormat:@"%.2f", CMTimeGetSeconds(weakSelf.player.currentItem.duration)];
    }];
}

- (void)removeTimeObserver {
    if (_timeObserver) {
        [self.player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
}

- (void)playerToEnd:(NSNotification *)info {
    if (info.object == self.player.currentItem) {
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
}

#pragma mark -- 视图配置
- (void)setupToolboxUI {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 64)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    //关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 20, 80, 44);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [self.uploadButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    self.uploadButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 20, 80, 44);
    self.uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.uploadButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.uploadButton];
}

- (void)setupPlayerUI {
    
    UIFont *font = [UIFont systemFontOfSize:18];
    if (@available(iOS 9.0, *)) {
        font = [UIFont monospacedDigitSystemFontOfSize:18 weight:(UIFontWeightRegular)];
    }
    self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(20, PLS_SCREEN_HEIGHT - 130, 130, 30)];
    self.currentTime.text = @"0.00s";
    self.currentTime.textColor = [UIColor blueColor];
    self.currentTime.font = font;
    [self.view addSubview:self.currentTime];
    
    self.duration = [[UILabel alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 80, PLS_SCREEN_HEIGHT - 130, 130, 30)];
    self.duration.text = [NSString stringWithFormat:@"%.2f", CMTimeGetSeconds(self.player.currentItem.duration)];
    self.duration.textColor = [UIColor blueColor];
    self.duration.font = font;
    [self.view addSubview:self.duration];
    
    self.playSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, PLS_SCREEN_HEIGHT - 100, PLS_SCREEN_WIDTH - 40, 30)];
    self.playSlider.minimumValue = 0;
    self.playSlider.maximumValue = 1;
    [self.playSlider addTarget:self action:@selector(playSeekTo:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.playSlider];
}

#pragma mark -- 播放器初始化
- (void)initPlayer {
    if (!self.url) {
        return;
    }
    
    self.player = [[AVPlayer alloc] initWithURL:self.url];
    self.playerView = [[PLSPlayerView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH / 8, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - PLS_BaseToolboxView_HEIGHT - PLS_SCREEN_WIDTH / 8 - PLS_EditToolboxView_HEIGHT)];
    self.playerView.player = self.player;
    [self.view addSubview:self.playerView];
}

#pragma mark -- 视频上传准备
- (void)setupFileUpload {
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    self.progressView.trackTintColor = [UIColor blackColor];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
    
    [self prepareUpload];
}

- (void)prepareUpload {
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *key;
    if (self.actionType == PLSActionTypePlayer) {
        key = [NSString stringWithFormat:@"short_video_%@.mp4", [formatter stringFromDate:[NSDate date]]];
    }
    if (self.actionType == PLSActionTypeGif) {
        key = [NSString stringWithFormat:@"short_video_%@.gif", [formatter stringFromDate:[NSDate date]]];
    }
    PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:kUploadToken videoKey:key https:YES recorder:nil];
    self.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
    self.shortVideoUploader.delegate = self;
}

#pragma mark -- 按钮的响应事件
#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 播放
- (void)handleSingleFingerToPlayVideoEvent:(id)sender {
    if (1.0 == [self.player rate]) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

#pragma mark -- 本地视频上传到云端
- (void)uploadButtonClick:(id)sender {
    NSString *filePath = _url.path;

    self.uploadButton.selected = !self.uploadButton.selected;
    
    if (self.uploadButton.isSelected) {
        self.progressView.hidden = NO;
        [self.shortVideoUploader uploadVideoFile:filePath];
    }else {
        [self.shortVideoUploader cancelUploadVidoFile];
    }
}

#pragma mark -- seekTo
- (void)playSeekTo:(id)sender {
    UISlider * slider = (UISlider *)sender;
    slider.enabled = NO;
    CMTime time = CMTimeMake(slider.value * CMTimeGetSeconds(self.player.currentItem.duration), 1);
    self.currentTime.text = [NSString stringWithFormat:@"%.2fs", CMTimeGetSeconds(time)];
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        weakSelf.playSlider.enabled = YES;
    }];
}

#pragma mark -- 提示框
- (void)showAlertWithMessage:(NSString *)message {
    NSLog(@"alert message: %@", message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - PLShortVideoUploaderDelegate 视频上传
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader completeInfo:(PLSUploaderResponseInfo *)info uploadKey:(NSString *)uploadKey resp:(NSDictionary *)resp {
    self.progressView.hidden = YES;
    self.uploadButton.selected = NO;
    if(info.error){
        [self showAlertWithMessage:[NSString stringWithFormat:@"上传失败，error: %@", info.error]];
        return ;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kURLPrefix, uploadKey];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = urlString;
    
    [self showAlertWithMessage:[NSString stringWithFormat:@"上传成功，地址：%@ 已复制到系统剪贴板", urlString]];
    NSLog(@"uploadInfo: %@",info);
    NSLog(@"uploadKey:%@",uploadKey);
    NSLog(@"resp: %@",resp);
}

- (void)shortVideoUploader:(PLShortVideoUploader *)uploader uploadKey:(NSString *)uploadKey uploadPercent:(float)uploadPercent {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = uploadPercent;
    });
    NSLog(@"uploadKey: %@",uploadKey);
    NSLog(@"uploadPercent: %.2f",uploadPercent);
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.player = nil;
    
    self.gifView = nil;

    self.shortVideoUploader = nil;
    
    self.baseToolboxView = nil;
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

#pragma mark -- 手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]])
    {
        return NO;
    }
    return YES;
}

@end
