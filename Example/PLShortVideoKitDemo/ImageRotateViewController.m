//
//  ImageRotateViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/5/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ImageRotateViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "EditViewController.h"

@interface ImageRotateViewController ()
<
PLSImageRotateRecorderDelegate
>
@property (nonatomic, strong) PLSImageRotateRecorder *recorder;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *deleteLastButton;
@end

@implementation ImageRotateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    videoConfiguration.videoSize = CGSizeMake(720, 1280);
    videoConfiguration.averageVideoBitRate = 1024 * 2000;
    videoConfiguration.videoFrameRate = 30;
    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    self.recorder = [[PLSImageRotateRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    [self.view addSubview:self.recorder.previewView];
    
    self.recorder.previewView.frame = self.view.bounds;
    self.recorder.backgroundImage = [UIImage imageNamed:@"rotate_background"];
    self.recorder.rotateImage   = [UIImage imageNamed:@"rotate_image"];
    self.recorder.rotateFrame   = CGRectMake(videoConfiguration.videoSize.width/2 - 500/2, videoConfiguration.videoSize.height/2 - 500/2, 500, 500);
    self.recorder.delegate      = self;
    self.recorder.rotateSpeed   = 10;
    
    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [closeButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:(UIControlEventTouchUpInside)];
    closeButton.frame = CGRectMake(20, 40, 50, 50);
    [self.view addSubview:closeButton];

    self.recordingButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.recordingButton setTitle:@"开始录制" forState:(UIControlStateNormal)];
    [self.recordingButton setTitle:@"结束录制" forState:(UIControlStateSelected)];
    [self.recordingButton sizeToFit];
    [self.recordingButton addTarget:self action:@selector(clickRecordButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.recordingButton.center = CGPointMake(self.view.bounds.size.width / 6, self.view.bounds.size.height - 100);
    [self.view addSubview:self.recordingButton];
    
    self.finishButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.finishButton setTitle:@"完成录制" forState:(UIControlStateNormal)];
    [self.finishButton sizeToFit];
    [self.finishButton addTarget:self action:@selector(clickFinishButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.finishButton.center = CGPointMake(self.view.bounds.size.width / 6 + self.view.bounds.size.width / 3, self.view.bounds.size.height - 100);
    [self.view addSubview:self.finishButton];
    self.finishButton.enabled = NO;
    
    self.resetButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.resetButton setTitle:@"删除所有文件" forState:(UIControlStateNormal)];
    [self.resetButton sizeToFit];
    [self.resetButton addTarget:self action:@selector(clickResetButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.resetButton.center = CGPointMake(self.view.bounds.size.width / 6  + 2 * self.view.bounds.size.width / 3, self.view.bounds.size.height - 100);
    [self.view addSubview:self.resetButton];
    self.resetButton.enabled = NO;
    
    self.deleteLastButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.deleteLastButton setTitle:@"删除最后一段文件" forState:(UIControlStateNormal)];
    [self.deleteLastButton sizeToFit];
    [self.deleteLastButton addTarget:self action:@selector(clickDeleteLastButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.deleteLastButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 60);
    [self.view addSubview:self.deleteLastButton];
    self.deleteLastButton.enabled = NO;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickCloseButton:(UIButton *)button {
    
    if (self.recorder.isRecording) {
        [self.recorder cancelRecording];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRecordButton:(UIButton *)button {
    button.enabled = NO;
    if (button.selected) {
        [self.recorder stopRecording];
    } else {
        [self.recorder startRecording:NULL];
    }
}

- (void)clickFinishButton:(UIButton *)button {
    
    EditViewController *editViewController = [[EditViewController alloc] init];
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    AVAsset *asset = [self.recorder assetRepresentingAllFiles];
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    editViewController.filesURLArray = [self.recorder getAllRecordingFiles];
    editViewController.settings = outputSettings;
    editViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:editViewController animated:YES completion:nil];

}

- (void)clickResetButton:(UIButton *)button {
    [self.recorder deleteAllRecordingFiles];
    [self.recorder resetRotateToAngle:0];
    
    self.finishButton.enabled = NO;
    self.resetButton.enabled = NO;
    self.deleteLastButton.enabled = NO;
}

- (void)clickDeleteLastButton:(UIButton *)button {
    [self.recorder deleteLastRecordingFile];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.recorder isRecording]) {
        [self.recorder stopRecording];
    }
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didGetRotatePixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer {
    
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didGetMicrophoneSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer {
    
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder didStartRecording:(NSURL *)fileURL{
    self.recordingButton.selected = YES;
    self.recordingButton.enabled = YES;
    self.finishButton.enabled = NO;
    self.resetButton.enabled = NO;
    self.deleteLastButton.enabled = NO;
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL * _Nonnull)fileURL fileDuration:(CMTime)fileDuration totalDuration:(CMTime)totalDuration currentAngle:(float)currentAngle {
    
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *__nonnull)recorder errorOccur:(NSError *)error {
    self.recordingButton.selected = NO;
    self.recordingButton.enabled = YES;
    NSLog(@"%@", error);
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration currentAngle:(float)currentAngle{
    
    NSLog(@"totalDuration = %f, currentAngle = %f", totalDuration, currentAngle);
    // SDK 内部不会将录制动画角度 reset 到 currentAngle，如果需要将角度恢复到剩余文件中最后一次录制完成时的角度，调用如下方法：
    [self.recorder resetRotateToAngle:currentAngle];
    
    BOOL enable = [recorder getAllRecordingFiles].count > 0;
    self.deleteLastButton.enabled = enable;
    self.resetButton.enabled = enable;
    self.finishButton.enabled = enable;
}

- (void)imageRotateRecorder:(PLSImageRotateRecorder *)recorder didFinishRecording:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration currentAngle:(float)currentAngle {
    
    NSLog(@"stop.fileURL = %@", fileURL.absoluteString);
    self.recordingButton.selected = NO;
    self.recordingButton.enabled = YES;
    self.finishButton.enabled = YES;
    self.resetButton.enabled = YES;
    self.deleteLastButton.enabled = YES;
}

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
