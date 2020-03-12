//
//  DubViewController.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/9/5.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "DubViewController.h"
#import "PLSProgressBar.h"
#import "PLShortVideoKit/PLShortVideoKit.h"


@interface DubViewController ()
<
PLShortVideoRecorderDelegate,
PLSEditPlayerDelegate
>
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *settingToolboxView;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UILabel *audioInfoLabel;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *previewButton;
@property (strong, nonatomic) UIView *saveOriginView;

@property (strong, nonatomic) PLSVideoConfiguration *videoConfiguration;
@property (strong, nonatomic) PLSAudioConfiguration *audioConfiguration;
@property (strong, nonatomic) PLShortVideoRecorder *shortVideoRecorder;
@property (strong, nonatomic) PLSEditPlayer *editPlayer;

@end


@implementation DubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBaseToolboxView];
    [self setupSettingToolboxView];
    
    // 纯音频录制
    self.audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    
    self.shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:nil audioConfiguration:self.audioConfiguration];
                               
    self.shortVideoRecorder.delegate = self;
    self.shortVideoRecorder.minDuration = 2.0f; // 设置最小录制时长
    self.shortVideoRecorder.maxDuration = [self.movieSettings[PLSDurationKey] floatValue]; // 设置最长录制时长
    self.shortVideoRecorder.outputFileType = PLSFileTypeM4A; // 音视频容器格式
    
    // 播放视频
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    self.editPlayer = [[PLSEditPlayer alloc]init];
    [self.editPlayer setItemByAsset:asset];
    self.editPlayer.delegate = self;
    self.editPlayer.loopEnabled = NO;
    self.editPlayer.volume = 0.0f; // 静音
    self.editPlayer.preview.frame = CGRectMake(0, 64, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
    self.editPlayer.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.view addSubview:_editPlayer.preview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.shortVideoRecorder startCaptureSession];

    [self.editPlayer play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shortVideoRecorder stopCaptureSession];

    [self.editPlayer pause];
    
    if (self.shortVideoRecorder.isRecording) {
        [self.shortVideoRecorder cancelRecording];
    }
}

#pragma mark -- 配置顶部视图
- (void)setupBaseToolboxView {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 64)];
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
    if (iPhoneX_SERIES) {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 48);
    } else {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    }
    titleLabel.text = @"录制音频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.baseToolboxView addSubview:titleLabel];
    
    // 下一步
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.hidden = YES;
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 60, 0, 60, 64);
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:_saveButton];
}

#pragma mark -- 配置底部视图
- (void)setupSettingToolboxView {
    self.settingToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - 64 - PLS_SCREEN_WIDTH)];
    self.settingToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.settingToolboxView];
    
    // 录制音频
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.backgroundColor = PLS_RGBCOLOR(68, 66, 79);
    self.recordButton.frame = CGRectMake(15, 20, 36, 36);
    self.recordButton.layer.cornerRadius = 18;
    self.recordButton.layer.borderColor = PLS_RGBCOLOR(68, 66, 79).CGColor;
    self.recordButton.layer.borderWidth = 1.f;
    [self.recordButton setImage:[UIImage imageNamed:@"dubber_start"] forState:UIControlStateNormal];
    [self.recordButton setImage:[UIImage imageNamed:@"dubber_stop"] forState:UIControlStateSelected];
    [self.settingToolboxView addSubview:_recordButton];
    [self.recordButton addTarget:self action:@selector(audioRecordButtonEvent:) forControlEvents:UIControlEventTouchDown];
    
    // 删除
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.hidden = YES;
    self.deleteButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 45, 20, 36, 36);
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    [self.settingToolboxView addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchDown];
        
    // 视频录制进度条
    self.progressBar = [[PLSProgressBar alloc] initWithFrame:CGRectMake(0, 98, PLS_SCREEN_WIDTH, 10)];
    [self.settingToolboxView addSubview:_progressBar];
    
    // 音频信息
    self.audioInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 118, PLS_SCREEN_WIDTH - 134, 28)];
    self.audioInfoLabel.font = [UIFont systemFontOfSize:15.f];
    self.audioInfoLabel.textColor = [UIColor whiteColor];
    self.audioInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.audioInfoLabel.text = @"0 段 - 0.00 秒";
    [self.settingToolboxView addSubview:_audioInfoLabel];
    
    self.saveOriginView = [[UIView alloc]initWithFrame:CGRectMake(15, 158, PLS_SCREEN_WIDTH - 90, 30)];
    [self.settingToolboxView addSubview:_saveOriginView];
    
    // 预览
    self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previewButton.backgroundColor = [UIColor whiteColor];
    self.previewButton.layer.cornerRadius = 3;
    self.previewButton.hidden = YES;
    self.previewButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 75, 160, 64, 28);
    self.previewButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.previewButton setTitleColor:PLS_RGBCOLOR(25, 24, 36) forState:UIControlStateNormal];
    [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [self.previewButton setTitleColor:PLS_RGBCOLOR(25, 24, 36) forState:UIControlStateSelected];
    [self.previewButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.settingToolboxView addSubview:_previewButton];
    [self.previewButton addTarget:self action:@selector(previewButtonEvent:) forControlEvents:UIControlEventTouchDown];
}

#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 保存
- (void)saveButtonClick {
    AVAsset *asset = [self mixAssetProcessing];
    
    [self backButtonClick];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOutputAsset:)]) {
        [self.delegate didOutputAsset:asset];
    }
}

- (AVAsset *)mixAssetProcessing {
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    CMTimeRange timeRange = CMTimeRangeMake(start, duration);

    // 先去掉 self.movieSettings[PLSAssetKey] 的音频轨，再跟录制的纯音频混合
    asset = [self.shortVideoRecorder mixAsset:asset timeRange:timeRange];
    
    return asset;
}

#pragma mark -- 录制音频
- (void)audioRecordButtonEvent:(UIButton *)button {
    if (self.shortVideoRecorder.isRecording) {
        self.deleteButton.hidden = NO;
        self.previewButton.hidden = NO;
        self.saveButton.hidden = NO;
        self.saveOriginView.hidden = NO;
        
        [self.editPlayer pause];
        [self.shortVideoRecorder stopRecording];
        
    } else{
        self.deleteButton.hidden = YES;
        self.previewButton.hidden = YES;
        self.saveButton.hidden = YES;
        self.saveOriginView.hidden = YES;
        
        [self.editPlayer play];
        [self.shortVideoRecorder startRecording];
    }
    
    button.selected = self.shortVideoRecorder.isRecording;
}

#pragma mark -- 删除
- (void)deleteButtonEvent:(id)sender {
    [self.editPlayer pause];
    
    [self.shortVideoRecorder deleteLastFile];
    
    [_progressBar deleteLastProgress];
    
    if ([self.shortVideoRecorder getFilesCount] == 0) {
        AVAsset *asset = self.movieSettings[PLSAssetKey];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
        [self.editPlayer replaceCurrentItemWithPlayerItem:playerItem];
        self.editPlayer.volume = 0.0f; // 静音
    }

    CGFloat totalDuration = [self.shortVideoRecorder getTotalDuration];
    CMTime newTime = self.editPlayer.currentTime;
    newTime.value = newTime.timescale * totalDuration;
    [self.editPlayer seekToTime:newTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark -- 预览
- (void)previewButtonEvent:(UIButton *)previewButton {
    AVAsset *asset = [self mixAssetProcessing];

    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.editPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self.editPlayer play];
}

#pragma mark -- PLShortVideoRecorderDelegate 录制的回调
// 麦克风权限
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    NSLog(@"didGetMicrophoneAuthorizationStatus");
    
    if (status == PLSAuthorizationStatusAuthorized) {
        NSLog(@"PLSAuthorizationStatusAuthorized");
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: PLSAuthorizationStatusDenied");
    }
}

// 获取到麦克风原数据时的回调
- (CMSampleBufferRef)shortVideoRecorder:(PLShortVideoRecorder *)recorder microphoneSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    NSLog(@"microphoneSourceDidGetSampleBuffer");
    
    return sampleBuffer;
}

// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar startShining];
}

// 正在录制的过程中
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [_progressBar setLastProgressToWidth:fileDuration / self.shortVideoRecorder.maxDuration * _progressBar.frame.size.width];
    self.audioInfoLabel.text = [NSString stringWithFormat:@"%.2f 秒", totalDuration];
}

// 删除了某一段视频
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"delete fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    if (totalDuration <= 0.0000001f) {
        self.deleteButton.hidden = YES;
        self.previewButton.hidden = YES;
        self.saveOriginView.hidden = YES;
    } else{
        self.deleteButton.hidden = NO;
        self.previewButton.hidden = NO;
        self.saveOriginView.hidden = NO;
    }
    
    if (totalDuration <= self.shortVideoRecorder.minDuration) {
        self.saveButton.hidden = YES;
    } else {
        self.saveButton.hidden = NO;
    }
    
    self.audioInfoLabel.text = [NSString stringWithFormat:@"%ld 段 - %.2f 秒", (long)[self.shortVideoRecorder getFilesCount], [self.shortVideoRecorder getTotalDuration]];
    if (totalDuration < self.shortVideoRecorder.maxDuration) {
        self.recordButton.selected = NO;
        self.recordButton.userInteractionEnabled = YES;
    }
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    if (totalDuration <= 0.0000001f) {
        self.deleteButton.hidden = YES;
        self.previewButton.hidden = YES;
        self.saveOriginView.hidden = YES;
    } else{
        self.deleteButton.hidden = NO;
        self.previewButton.hidden = NO;
        self.saveOriginView.hidden = NO;
    }
    
    if (totalDuration <= self.shortVideoRecorder.minDuration) {
        self.saveButton.hidden = YES;
    } else {
        self.saveButton.hidden = NO;
    }
    
    [_progressBar stopShining];
    
    self.audioInfoLabel.text = [NSString stringWithFormat:@"%ld 段 - %.2f 秒", (long)[self.shortVideoRecorder getFilesCount], totalDuration];
    if (totalDuration >= self.shortVideoRecorder.maxDuration) {
        [self.editPlayer pause];

        self.recordButton.selected = NO;
        self.recordButton.userInteractionEnabled = NO;
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);
}

#pragma mark -- PLSEditPlayerDelegate
- (CVPixelBufferRef)player:(PLSEditPlayer *)player didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // 视频数据可用来做滤镜处理，将滤镜效果写入视频文件中
    
    return pixelBuffer;
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.shortVideoRecorder.delegate = nil;
    self.shortVideoRecorder = nil;
    
    self.editPlayer.delegate = nil;
    self.editPlayer = nil;

    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
