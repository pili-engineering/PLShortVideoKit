//
//  ScreenRecordViewController.m
//  PLShortVideoKitDemo
//
//  Created by 何云旗 on 2020/2/23.
//  Copyright © 2020 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ScreenRecordViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSProgressBar.h"
#import "PLSDeleteButton.h"
#import "EditViewController.h"
#import <Photos/Photos.h>
#import "PhotoAlbumViewController.h"
#import "PLSEditVideoCell.h"
#import "PLSFilterGroup.h"
#import "PLSViewRecorderManager.h"
#import "PLSRateButtonView.h"
#import "PLScreenRecorderManager.h"

#define PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG 10001
#define PLS_BaseToolboxView_HEIGHT 64


@interface ScreenRecordViewController ()
<
PLSViewRecorderManagerDelegate,
PLScreenRecorderManagerDelegate
>

@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) PLSViewRecorderManager *viewRecorderManager;
@property (strong, nonatomic) PLScreenRecorderManager *screenRecorderManager;
@property (strong, nonatomic) UILabel * showText;
@property (strong, nonatomic) NSTimer * timer;
@property (assign, nonatomic) NSInteger timeNumer;
@property (strong, nonatomic) AVAsset* asset;
@property (assign, nonatomic) CGFloat totalDuration;
@property (strong, nonatomic) UIButton *endButton;

@end

@implementation ScreenRecordViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self viewRecorder];
    [self setupScreenView];
}

- (void)setupScreenView {
    // 屏幕录制的操作按钮
    CGFloat buttonWidth = 80.0f;
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.layer.cornerRadius = buttonWidth/2;
    self.recordButton.layer.borderWidth = 5;
    self.recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.recordButton.backgroundColor = PLS_RGBCOLOR(65, 154, 208);
    self.recordButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    self.recordButton.center = CGPointMake(PLS_SCREEN_WIDTH / 2, self.view.frame.size.height - 80);
    [self.recordButton addTarget:self action:@selector(recordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    self.recordButton.selected = NO;
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 60, 35, 35);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [backButton setImage:[UIImage imageNamed:@"close_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //显示字幕
    self.showText = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame) - 45)/2, PLS_SCREEN_WIDTH, 40)];
    self.showText.textColor = [UIColor whiteColor];
    self.showText.text = @"点击开始屏幕录制";
    self.showText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.showText];
    
    // 结束录制的按钮
    CGPoint center = self.recordButton.center;
    center.x = CGRectGetWidth([UIScreen mainScreen].bounds) - 60;
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 60, PLS_SCREEN_HEIGHT - 80, 50, 50);
    self.endButton.center = center;
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"end_normal"] forState:UIControlStateNormal];
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"end_disable"] forState:UIControlStateDisabled];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.endButton.enabled = NO;
    [self.view addSubview:self.endButton];
    self.endButton.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [self.screenRecorderManager cancelRecording];
    [self.viewRecorderManager cancelRecording];
    
}

//录制 self.view
- (void)viewRecorder {
    if (@available(iOS 11.0, *)) {
        if (!self.screenRecorderManager) {
            self.screenRecorderManager = [[PLScreenRecorderManager alloc] init];
            self.screenRecorderManager.delegate = self;
        }
    } else {
        if (!self.viewRecorderManager) {
            self.viewRecorderManager = [[PLSViewRecorderManager alloc] initWithRecordedView:self.view];
            self.viewRecorderManager.delegate = self;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(applicationWillResignActive:)
        name:UIApplicationWillResignActiveNotification
      object:nil];
}

- (void)recordButtonEvent:(id)sender {
    if (self.screenRecorderManager.isStartRunning || self.viewRecorderManager.isStartRunning) {
        [self.timer invalidate];
        self.endButton.hidden = NO;
        self.endButton.enabled = YES;
        if (@available(iOS 11.0, *)) {
            [self.screenRecorderManager stopRecording];
        } else {
            [self.viewRecorderManager stopRecording];
        }
        self.showText.text = @"点击开始屏幕录制";
    }else {
        self.showText.text = @"开始屏幕录制";
        self.timeNumer = 0;
        self.endButton.enabled = NO;
        self.endButton.hidden = YES;
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerRun];
        }];
        if (@available(iOS 11.0, *)) {
            [self.screenRecorderManager startRecording];
        } else {
            [self.viewRecorderManager startRecording];
        }
    }
}

- (void)timerRun {
    self.showText.text = [NSString stringWithFormat:@"开始屏幕录制 %ld s",(long)++self.timeNumer];;
}

// 返回上一层
- (void)backButtonEvent:(id)sender {
    [self.viewRecorderManager cancelRecording];
    [self.screenRecorderManager cancelRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.timer invalidate];
    
}

// 结束录制
- (void)endButtonEvent:(id)sender {
    [self playEvent:self.asset];
}

- (void)playEvent:(AVAsset *)asset {
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:self.totalDuration];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

#pragma mark - PLSViewRecorderManagerDelegate
- (void)viewRecorderManager:(PLSViewRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration {
    self.asset = asset;
    self.totalDuration = totalDuration;
}

#pragma mark - PLScreenRecorderManagerDelegate
- (void)screenRecorderManager:(PLScreenRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration {
    self.asset = asset;
    self.totalDuration = totalDuration;
}

- (void)screenRecorderManager:(PLScreenRecorderManager *)manager errorOccur:(NSError *)error {
    NSString *message = [NSString stringWithFormat:@"%@", error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    if (self.screenRecorderManager.isStartRunning || self.viewRecorderManager.isStartRunning) {
        [self recordButtonEvent:nil];
    }
}

- (void)dealloc {
    // 移除前后台监听的通知
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc: %@", [[self class] description]);
}


@end
