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
#import <PLPlayerKit/PLPlayerKit.h>

#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

static NSString *const kUploadToken = @"MqF35-H32j1PH8igh-am7aEkduP511g-5-F7j47Z:clOQ5Y4gJ15PnfZciswh7mQbBJ4=:eyJkZWxldGVBZnRlckRheXMiOjMwLCJzY29wZSI6InNob3J0LXZpZGVvIiwiZGVhZGxpbmUiOjE2NTUyNjAzNTd9";
static NSString *const kURLPrefix = @"http://shortvideo.pdex-service.com";

@interface PlayViewController ()
<
PLShortVideoUploaderDelegate,
PLPlayerDelegate,
UIGestureRecognizerDelegate
>

// 工具视图
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *processerToolboxView;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UISlider *playSlider;
@property (strong, nonatomic) UILabel * currentTime;
@property (strong, nonatomic) UILabel * duration;
@property (strong, nonatomic) UILabel * playerInfo;
@property (strong, nonatomic) UILabel * statLabel;
@property (strong, nonatomic) UILabel * videoInfo;


// 视频播放
@property (strong, nonatomic) PLPlayer *player;

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
        // 演示 gif 动图
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - PLS_BaseToolboxView_HEIGHT)];
        webView.center = self.view.center;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        webView.scalesPageToFit = YES;
        webView.userInteractionEnabled = NO;
        [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
        [self.view addSubview:webView];
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
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.actionType == PLSActionTypePlayer) {
        [self.player pause];
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
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [self.uploadButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    self.uploadButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    self.uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.uploadButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.uploadButton];
}

- (void)setupPlayerUI {
    self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(20, PLS_SCREEN_HEIGHT - 130, 130, 30)];
    self.currentTime.text = @"0.00s";
    self.currentTime.textColor = [UIColor blueColor];
    [self.view addSubview:self.currentTime];
    
    self.duration = [[UILabel alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 80, PLS_SCREEN_HEIGHT - 130, 130, 30)];
    self.duration.text = @"0.00s";
    self.duration.textColor = [UIColor blueColor];
    [self.view addSubview:self.duration];
    
    self.playerInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, PLS_SCREEN_WIDTH-40, 30)];
    self.playerInfo.text = @"player info";
    self.playerInfo.textColor = [UIColor blueColor];
    [self.view addSubview:self.playerInfo];
    
    self.videoInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, PLS_SCREEN_WIDTH-40, 80)];
    self.videoInfo.text = @"video info";
    self.videoInfo.textColor = [UIColor blueColor];
    [self.view addSubview:self.videoInfo];
    
    self.statLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, PLS_SCREEN_WIDTH-40, 30)];
    self.statLabel.text = @"stat info";
    self.statLabel.textColor = [UIColor blueColor];
    [self.view addSubview:self.statLabel];
    
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
    
    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    // 初始化 PLPlayer
    self.player = [PLPlayer playerWithURL:self.url option:option];
    
    // 设定代理 (optional)
    self.player.delegate = self;
    
    //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    self.player.playerView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.player.playerView];
}

#pragma mark -- 添加定时器
- (void)addDurationTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                      target:self
                                                    selector:@selector(onDurationTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

#pragma mark -- 移除定时器
- (void)removeDurationTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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

- (void)onDurationTimer {
    double elapsed = CMTimeGetSeconds(self.player.currentTime);
    double duration = CMTimeGetSeconds(self.player.totalDuration);
    self.playSlider.value = elapsed / duration;
    if (isnan(elapsed)) {
        self.currentTime.text = self.duration.text;
    } else {
       self.currentTime.text = [NSString stringWithFormat:@"%.2fs", elapsed];
        self.duration.text = [NSString stringWithFormat:@"%.2fs", duration];
    }
    
    NSString *info = [NSString stringWithFormat:@"videoFPS:%d, bitrate: %.2fkbs", _player.videoFPS, _player.bitrate];
    self.videoInfo.text = info;
    
    info = [NSString stringWithFormat:@"renderFPS:%d, %dX%d", _player.renderFPS, _player.width, _player.height];
    self.playerInfo.text = info;
    NSLog(@"onDurationTimer");
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
    [self.player play];
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
    CMTime time = CMTimeMake(slider.value * CMTimeGetSeconds(self.player.totalDuration), 1);
    self.currentTime.text = [NSString stringWithFormat:@"%.2fs",slider.value];
    [self.player seekTo:time];
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

#pragma mark -- PLPlayerDelegate 播放器状态获取
// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
    // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
    // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
    // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
    // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    if (state == PLPlayerStatusReady) {
        [self addDurationTimer];
    }
    if (state == PLPlayerStatusPlaying) {
        NSString *stat = [NSString stringWithFormat:@"connect:%.2f/first:%.2f", _player.connectTime, _player.firstVideoTime];
        self.statLabel.text = stat;
    }
    if (state == PLPlayerStatusStopped || state == PLPlayerStatusPaused) {
        self.currentTime.text = self.duration.text;
        self.playSlider.value = 1;
        [self removeDurationTimer];
    }
    
    NSLog(@"status: %ld", (long)state);
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误，停止播放时，会回调这个方法
    [self showAlertWithMessage:[NSString stringWithFormat:@"播放出错，error = %@", error]];
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
    // 当解码器发生错误时，会回调这个方法
    // 当 videotoolbox 硬解初始化或解码出错时
    // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
    // 播发器也将自动切换成软解，继续播放
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
    [self removeDurationTimer];

    self.player.delegate = nil;
    self.player = nil;

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
