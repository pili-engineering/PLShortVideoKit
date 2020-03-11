//
//  QNMixRecordingViewController.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/17.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNMixRecordingViewController.h"
#import "QNFilterGroup.h"
#import "QNVerticalButton.h"
#import "QNRecordingProgress.h"
#import "QNEditorViewController.h"
#import "QNFilterPickerView.h"

@interface QNMixRecordingViewController ()
<
PLSVideoMixRecordererDelegate,
QNFilterPickerViewDelegate,
UIGestureRecognizerDelegate
>

// 用来放顶部和右侧的 button，便于做隐藏动画
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIView *bottomBarView;

@property (nonatomic, strong) PLSVideoMixRecorder *mixRecorder;
@property (nonatomic, strong) QNFilterPickerView *filterPickerView;
@property (nonatomic, weak)   QNFilterGroup *filterGroup;

@property (nonatomic, strong) QNRecordingProgress *recordingProgress;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) UIButton *deleteLastButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *filterNameLabel;
@property (nonatomic, strong) UILabel *filterDetailLabel;
@property (nonatomic, strong) QNVerticalButton *cameraButton;
@property (nonatomic, strong) QNVerticalButton *beautyButton;
@property (nonatomic, strong) QNVerticalButton *flashButton;
@property (nonatomic, strong) QNVerticalButton *filterButton;

@property (nonatomic, assign) CGFloat maxDuration;
@property (nonatomic, assign) BOOL fileEndDecoding;

// 切换滤镜的时候，为了更好的用户体验，添加以下属性来做切换动画
@property (nonatomic, assign) BOOL isPanning;
@property (nonatomic, assign) BOOL isLeftToRight;
@property (nonatomic, assign) BOOL isNeedChangeFilter;
@property (nonatomic, weak) PLSFilter *leftFilter;
@property (nonatomic, weak) PLSFilter *rightFilter;
@property (nonatomic, assign) float leftPercent;

// 辅助隐藏滤镜选取 view 的 buttom
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation QNMixRecordingViewController

- (void)dealloc {
    self.mixRecorder.delegate = nil;
    self.mixRecorder = nil;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self.mixRecorder startCaptureSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.filterPickerView.frame.origin.y < self.view.bounds.size.height) {
        [self.filterPickerView autoLayoutBottomHide:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mixRecorder stopCaptureSession];
}

- (BOOL)prefersStatusBarHidden {
    return !iPhoneX_SERIES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setupMixRecorder];
    [self setupFilter];
    
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self.view);
        make.top.equalTo(self.mixRecorder.previewView.mas_bottom).offset(20);
        make.height.equalTo(self.cameraButton);
    }];
}

- (void)setupUI {
    self.recordingProgress = [[QNRecordingProgress alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 10, 5)];
    self.recordingProgress.layer.cornerRadius = 2.5;
    self.recordingProgress.clipsToBounds = YES;
       
    QNVerticalButton *backButton = [[QNVerticalButton alloc] init];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setImage:[UIImage imageNamed:@"qn_icon_close"] forState:(UIControlStateNormal)];
    [backButton setTitle:@"退出" forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
       
    self.recordingButton = [[UIButton alloc] init];
    self.recordingButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.recordingButton setBackgroundColor:QN_MAIN_COLOR];
    [self.recordingButton setImage:[UIImage imageNamed:@"qn_video"] forState:(UIControlStateNormal)];
    [self.recordingButton setImage:[UIImage imageNamed:@"qn_video_selected"] forState:(UIControlStateSelected)];
    [self.recordingButton addTarget:self action:@selector(clickRecordingButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.recordingButton.layer.cornerRadius = 40;
    self.recordingButton.clipsToBounds = YES;
       
    self.deleteLastButton = [[UIButton alloc] init];
    [self.deleteLastButton setImage:[UIImage imageNamed:@"qn_btn_del_a"] forState:(UIControlStateNormal)];
    [self.deleteLastButton setImage:[UIImage imageNamed:@"qn_btn_del_active_a"] forState:(UIControlStateSelected)];
    [self.deleteLastButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.deleteLastButton.hidden = YES;
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
    self.durationLabel.textColor = [UIColor whiteColor];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 32)];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.nextButton.layer.cornerRadius = 4.0;
    [self.nextButton setTitle:@"编 辑" forState:(UIControlStateNormal)];
    [self.nextButton setBackgroundColor:QN_MAIN_COLOR];
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:(UIControlEventTouchUpInside)];
       
    self.flashButton = [[QNVerticalButton alloc] init];
    self.flashButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.flashButton setImage:[UIImage imageNamed:@"qn_flash_off"] forState:(UIControlStateNormal)];
    [self.flashButton setImage:[UIImage imageNamed:@"qn_flash_on"] forState:(UIControlStateSelected)];
    [self.flashButton setTitle:@"补光" forState:(UIControlStateNormal)];
    [self.flashButton addTarget:self action:@selector(clickFlashButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.cameraButton = [[QNVerticalButton alloc] init];
    self.cameraButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cameraButton setImage:[UIImage imageNamed:@"qn_switch_camera"] forState:(UIControlStateNormal)];
    [self.cameraButton setTitle:@"切换" forState:(UIControlStateNormal)];
    [self.cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.beautyButton = [[QNVerticalButton alloc] init];
    self.beautyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.beautyButton setImage:[UIImage imageNamed:@"qn_record_beauty"] forState:(UIControlStateNormal)];
    [self.beautyButton setImage:[UIImage imageNamed:@"qn_record_beauty_on"] forState:(UIControlStateSelected)];
    [self.beautyButton setTitle:@"美颜" forState:(UIControlStateNormal)];
    [self.beautyButton addTarget:self action:@selector(clickBeautyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.beautyButton.selected = YES;
    
    self.filterButton = [[QNVerticalButton alloc] init];
    self.filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.filterButton setImage:[UIImage imageNamed:@"qn_filter"] forState:(UIControlStateNormal)];
    [self.filterButton setTitle:@"滤镜" forState:(UIControlStateNormal)];
    [self.filterButton addTarget:self action:@selector(clickFilterButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.topBarView = [[UIView alloc] init];
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(80);
    }];
    
    [self.topBarView addSubview:backButton];
    [self.topBarView addSubview:self.cameraButton];
    [self.topBarView addSubview:self.flashButton];
    [self.topBarView addSubview:self.beautyButton];
    [self.topBarView addSubview:self.nextButton];

    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 60));
        make.left.equalTo(self.topBarView).offset(18);
        make.centerY.equalTo(self.cameraButton);
    }];
    
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).offset(30);
        make.bottom.equalTo(self.topBarView);
        make.size.equalTo(CGSizeMake(44, 60));
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flashButton.mas_right).offset(30);
        make.top.equalTo(self.flashButton);
        make.size.equalTo(self.flashButton);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cameraButton);
        make.size.equalTo(self.nextButton.bounds.size);
        make.right.equalTo(self.topBarView).offset(-16);
    }];
    
    self.nextButton.hidden = YES;
    
    self.bottomBarView = [[UIView alloc] init];
    [self.view addSubview:self.bottomBarView];
    [self.bottomBarView addSubview:_filterButton];
    [self.bottomBarView addSubview:_beautyButton];

    CGFloat space = CGRectGetWidth(self.view.frame)/4 - CGRectGetWidth(self.cameraButton.frame)/2;

    [self.beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomBarView ).offset(-space);
        make.size.equalTo(self.cameraButton);
        make.bottom.equalTo(self.bottomBarView );
    }];

    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBarView ).offset(space);
        make.size.equalTo(self.cameraButton);
        make.bottom.equalTo(self.bottomBarView );
    }];
    
    [self.view addSubview:self.deleteLastButton];
    [self.view addSubview:self.recordingButton];
    [self.view addSubview:self.durationLabel];
    [self.view addSubview:self.recordingProgress];
    
    [self.recordingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.topBarView).offset(-10);
        make.centerX.equalTo(self.topBarView);
        make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        make.height.equalTo(5);
    }];
    
    [self.recordingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-40);
    }];
    
    [self.deleteLastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordingButton);
        make.size.equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.recordingButton.mas_right).offset(50);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordingButton.centerX);
        make.bottom.equalTo(self.recordingButton.mas_top).offset(-5);
    }];
}

- (void)setupMixRecorder {
    AVAsset *asset = [AVAsset assetWithURL:self.mixURL];
    BOOL sampleFileHaveAudio = [asset tracksWithMediaType:AVMediaTypeAudio].count > 1;
        
    NSArray *sizeArray = [self getEncodeVideoSize];
    NSInteger width = [sizeArray[0] integerValue];
    NSInteger height = [sizeArray[1] integerValue];
    
    CGSize videoSize = CGSizeMake(width, height);
    if (width < height) {
        videoSize = CGSizeMake(height, width);
    }
    // 视频参数
    PLSVideoMixConfiguration *videoConfiguration = [PLSVideoMixConfiguration defaultConfiguration];
    videoConfiguration.position = AVCaptureDevicePositionFront;
    videoConfiguration.sessionPreset = [self getPreviewVideoSize];
    videoConfiguration.videoFrameRate = 30;
    videoConfiguration.videoSize = videoSize;
    videoConfiguration.averageVideoBitRate = [QNBaseViewController suitableVideoBitrateWithSize:videoConfiguration.videoSize];
    // 设置相机采集在合拍中的位置
    videoConfiguration.cameraVideoFrame = CGRectMake(0, 0, videoSize.width/2, videoSize.height);
    // 设置素材视频在合拍中的位置
    videoConfiguration.sampleVideoFrame = CGRectMake(videoSize.width/2, 0, videoSize.width/2, videoSize.height);
    videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;

    // 设置前置预览和编码都为镜像，主要是为了预览和生成的文件效果一样
    videoConfiguration.previewMirrorFrontFacing = YES;
    videoConfiguration.streamMirrorFrontFacing = YES;
    
    videoConfiguration.previewMirrorRearFacing = NO;
    videoConfiguration.streamMirrorRearFacing = NO;
    // 设置关键帧最大间隔为 3 秒钟
    videoConfiguration.videoMaxKeyframeInterval = 3.0 * videoConfiguration.videoFrameRate;

    
    // 音频参数
    PLSAudioMixConfiguration *audioConfiguration = [PLSAudioMixConfiguration defaultConfiguration];
    // 使用素材音频作为最终的生成视频文件的音频
    audioConfiguration.disableSample = NO;
    
    // 如果素材视频没有音频通道，则使用 麦克风采集的音频作为最终生成的视频文件的音频。如果不需要使用到麦克风采集音频的时候，建议禁用麦克风采集
    if (sampleFileHaveAudio) {
        audioConfiguration.disableMicrophone = YES;
    } else {
        audioConfiguration.disableMicrophone = NO;
    }
    
    // sampleVolume, microphoneVolume 只有当素材视频文件包含音频通道并且麦克风采集也启用的情况下，做混音的时候才有意义
    audioConfiguration.sampleVolume = 1.0;
    audioConfiguration.microphoneVolume = 1.0;
    
    // 是否启用回音消除
    audioConfiguration.acousticEchoCancellationEnable = NO;
    
    audioConfiguration.numberOfChannels = [self getAudioChannels];
    audioConfiguration.sampleRate = PLSAudioSampleRate_44100Hz;
    audioConfiguration.bitRate = PLSAudioBitRate_64Kbps;
    
    self.mixRecorder = [[PLSVideoMixRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    self.mixRecorder.delegate = self;
    self.mixRecorder.outputFileType = PLSFileTypeMPEG4;
    self.mixRecorder.innerFocusViewShowEnable = YES; // 显示 SDK 内部自带的对焦动画
    self.mixRecorder.mergeVideoURL = self.mixURL;
    
    // 美颜参数设置
    [self.mixRecorder setBeautifyModeOn:YES];
    [self.mixRecorder setWhiten:.5];
    [self.mixRecorder setRedden:.5];
    [self.mixRecorder setBeautify:.5];
    
    [self.view insertSubview:self.mixRecorder.previewView atIndex:0];
    [self.mixRecorder.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(- 20);
        make.width.equalTo(self.view);
        make.height.equalTo(self.mixRecorder.previewView.mas_width).multipliedBy(640.0/720.0);
    }];
}

- (void)setupFilter {
    if (!self.filterPickerView) {
        
        self.filterPickerView = [[QNFilterPickerView alloc] initWithFrame:CGRectZero hasTitle:NO];
        self.filterPickerView.delegate = self;
        self.filterPickerView.hidden = YES;
        [self.view addSubview:self.filterPickerView];
        
        [self.filterPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.top.equalTo(self.mas_bottomLayoutGuide).offset(-self.filterPickerView.minViewHeight);
        }];
        self.filterGroup = self.filterPickerView.filterGroup;
    }
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFilterPan:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    self.filterNameLabel = [[UILabel alloc] init];
    self.filterNameLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    self.filterNameLabel.font = [UIFont systemFontOfSize:30];
    self.filterNameLabel.text = [self.filterGroup.filtersInfo[0] objectForKey:@"name"];
    
    self.filterDetailLabel = [[UILabel alloc] init];
    self.filterDetailLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.filterDetailLabel.font = [UIFont systemFontOfSize:12];
    self.filterDetailLabel.text = @"<<左右滑动切换滤镜>>";
    
    [self.view addSubview:self.filterNameLabel];
    [self.view addSubview:self.filterDetailLabel];
    [self.filterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.view).offset(-50);
    }];
    [self.filterDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterNameLabel);
        make.top.equalTo(self.filterNameLabel.mas_bottom).offset(2);
    }];
}

#pragma mark - button actions

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_dismissButton addTarget:self action:@selector(clickDismissPickerViewButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _dismissButton;
}

- (void)clickDismissPickerViewButton:(UIButton *)button {
    [button removeFromSuperview];
    if (self.filterPickerView.frame.origin.y < self.view.bounds.size.height) {
        [self.filterPickerView autoLayoutBottomHide:YES];
    }
    
    [self.recordingButton alphaShowAnimation];
    [self.deleteLastButton alphaShowAnimation];
    [self.durationLabel alphaShowAnimation];
}

- (void)clickBackButton {
    if ([self.mixRecorder getFilesCount] > 0 || self.mixRecorder.isRecording) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出?" message:@"退出之后会丢失所有已经录制的视频" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"退出" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.mixRecorder cancelRecording];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sureAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.mixRecorder cancelRecording];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickDeleteButton:(UIButton *)button {
    if (0 == self.mixRecorder.getFilesCount) return;
    if (0 == [self.mixRecorder getFilesCount]) return;
    
    if (button.selected) {
        [self.recordingProgress deleteLastProgress];
        [self.mixRecorder deleteLastFile];
    } else {
        [self.recordingProgress setLastProgressToStyle:(QNProgressStyleDelete)];
    }
    
    button.selected = !button.isSelected;
}

- (void)clickRecordingButton:(UIButton *)button {
    if (self.mixRecorder.isRecording) {
        self.recordingButton.selected = NO;
        [self.mixRecorder stopRecording];
    } else {
        self.recordingButton.selected = YES;
        [self.mixRecorder startRecording];
    }
}

- (void)clickFlashButton:(UIButton *)button {
    if (AVCaptureDevicePositionFront == self.mixRecorder.captureDevicePosition) return;
    
    button.selected = !button.isSelected;
    [self.mixRecorder setTorchOn:button.isSelected];
}

- (void)clickCameraButton:(UIButton *)button {
    if (self.mixRecorder.isRecording) return;
    
    self.flashButton.selected = NO;
    button.enabled = NO;
    [self.mixRecorder toggleCamera:^(BOOL isFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
    }];
}

- (void)clickBeautyButton:(UIButton *)button {
    button.selected = !button.selected;
    [self.mixRecorder setBeautifyModeOn:button.isSelected];
}

#pragma mark - update UI

- (void)updateUIToRecording {
    [self.recordingProgress setLastProgressToStyle:(QNProgressStyleNormal)];
    [self.recordingProgress addProgressView];
    [self.recordingProgress startShining];
    
    self.deleteLastButton.selected = NO;
    
    [self.topBarView alphaHideAnimation];
    [self.bottomBarView alphaHideAnimation];
    [self.deleteLastButton alphaHideAnimation];
}

- (void)updateUIToNormal {
    [self.recordingProgress stopShining];
    
    self.recordingButton.selected = NO;
    
    [self.deleteLastButton alphaShowAnimation];
    [self.topBarView alphaShowAnimation];
    [self.bottomBarView alphaShowAnimation];
}

- (void)clickNextButton:(UIButton *)button {
    CGFloat minDuration = MIN(2, self.maxDuration);
    
    if (!self.fileEndDecoding && [self.mixRecorder getTotalDuration] < minDuration) {
        NSString *str = [NSString stringWithFormat:@"请至少拍摄 %d 秒的视频", (int)minDuration];
        [self.view showTip:str];
        return;
    }

    AVAsset *asset = self.mixRecorder.assetRepresentingAllFiles;
    [self playEvent:asset];
}

// 添加手势的响应事件
- (void)handleFilterPan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint transPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGPoint speed = [gestureRecognizer velocityInView:gestureRecognizer.view];
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            NSInteger index = 0;
            if (speed.x > 0) {
                self.isLeftToRight = YES;
                index = self.filterGroup.filterIndex - 1;
            } else {
                index = self.filterGroup.filterIndex + 1;
                self.isLeftToRight = NO;
            }
            
            if (index < 0) {
                index = self.filterGroup.filtersInfo.count - 1;
            } else if (index >= self.filterGroup.filtersInfo.count) {
                index = index - self.filterGroup.filtersInfo.count;
            }
            self.filterGroup.nextFilterIndex = index;
            
            if (self.isLeftToRight) {
                self.leftFilter = self.filterGroup.nextFilter;
                self.rightFilter = self.filterGroup.currentFilter;
                self.leftPercent = 0.0;
            } else {
                self.leftFilter = self.filterGroup.currentFilter;
                self.rightFilter = self.filterGroup.nextFilter;
                self.leftPercent = 1.0;
            }
            self.isPanning = YES;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.isLeftToRight) {
                if (transPoint.x <= 0) {
                    transPoint.x = 0;
                }
                self.leftPercent = 2 * transPoint.x / gestureRecognizer.view.bounds.size.width;
                self.isNeedChangeFilter = (self.leftPercent >= 0.5) || (speed.x > 500 );
            } else {
                if (transPoint.x >= 0) {
                    transPoint.x = 0;
                }
                self.leftPercent = 1 - 2 * fabs(transPoint.x) / gestureRecognizer.view.bounds.size.width;
                self.isNeedChangeFilter = (self.leftPercent <= 0.5) || (speed.x < -500);
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            gestureRecognizer.enabled = NO;
            __weak typeof(self) weakself = self;
            
            // 做一个滤镜过渡动画，优化用户体验
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0.005 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                
                if (!weakself.isPanning) return;
                
                float delta = 0.03;
                if (weakself.isNeedChangeFilter) {
                    // apply filter change
                    if (weakself.isLeftToRight) {
                        weakself.leftPercent = MIN(1, weakself.leftPercent + delta);
                    } else {
                        weakself.leftPercent = MAX(0, weakself.leftPercent - delta);
                    }
                } else {
                    // cancel filter change
                    if (weakself.isLeftToRight) {
                        weakself.leftPercent = MAX(0, weakself.leftPercent - delta);
                    } else {
                        weakself.leftPercent = MIN(1, weakself.leftPercent + delta);
                    }
                }
                
                if (weakself.leftPercent < FLT_EPSILON || fabs(1.0 - weakself.leftPercent) < FLT_EPSILON) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_source_cancel(timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            dispatch_source_cancel(timer);
                            if (self.isNeedChangeFilter) {
                                self.filterGroup.filterIndex = self.filterGroup.nextFilterIndex;
                                self.filterNameLabel.text = [self.filterGroup.filtersInfo[self.filterGroup.filterIndex] objectForKey:@"name"];
                                [self showFilterNameLabel];
                                [self.filterPickerView updateSelectFilterIndex];
                            }
                            self.isPanning = NO;
                            self.isNeedChangeFilter = NO;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                gestureRecognizer.enabled = YES;
                            });
                        });
                    });
                }
            });
            dispatch_resume(timer);
            break;
        }
        default:
            break;
    }
}

- (void)showFilterNameLabel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFilterNameLabel) object:nil];
    [self.filterDetailLabel alphaShowAnimation];
    [self.filterNameLabel alphaShowAnimation];
    [self performSelector:@selector(hideFilterNameLabel) withObject:nil afterDelay:2];
}

- (void)hideFilterNameLabel {
    [self.filterNameLabel alphaHideAnimation];
    [self.filterDetailLabel alphaHideAnimation];
}

- (void)clickFilterButton:(UIButton *)button {
    
    if (self.filterPickerView.frame.origin.y >= self.view.bounds.size.height) {
        
        self.filterPickerView.hidden = NO;
        
        [self.view addSubview:self.dismissButton];
        [self.dismissButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.filterPickerView.mas_top);
        }];
        [self.view bringSubviewToFront:self.filterPickerView];
        [self.filterPickerView autoLayoutBottomShow:YES];
        
        [self.recordingButton alphaHideAnimation];
        [self.deleteLastButton alphaHideAnimation];
        [self.durationLabel alphaHideAnimation];
    }
}

#pragma mark - QNFilterPickerViewDelegate

// 通过 collectionView 选择滤镜回调
- (void)filterView:(QNFilterPickerView *)filterView didSelectedFilter:(NSString *)colorImagePath {
    self.filterNameLabel.text = [self.filterGroup.filtersInfo[self.filterGroup.filterIndex] objectForKey:@"name"];
    [self showFilterNameLabel];
}

#pragma mark - PLSVideoMixRecorderDelegate 摄像头／麦克风鉴权的回调

- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to camera");
    }
}

- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to microphone");
    }
}

- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFocusAtPoint:(CGPoint)point {
    [self showFilterNameLabel];
}

- (CVPixelBufferRef)videoMixRecorder:(PLSVideoMixRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (self.isPanning) {
        pixelBuffer = [self.filterGroup processPixelBuffer:pixelBuffer
                                               leftPercent:self.leftPercent
                                                leftFilter:self.leftFilter
                                               rightFilter:self.rightFilter];
    } else {
        PLSFilter *filter = self.filterGroup.currentFilter;
        pixelBuffer = [filter process:pixelBuffer];
    }
    
    return pixelBuffer;
}

// 素材视频信息回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetSampleVideoInfo:(int)videoWith videoHeight:(int)videoheight frameRate:(float)frameRate duration:(CMTime)duration {
    self.maxDuration = CMTimeGetSeconds(duration);
}

// 开始录制一段视频时
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    [self updateUIToRecording];
}

// 正在录制的过程中
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [self.recordingProgress setLastProgressToWidth:fileDuration / self.maxDuration * self.recordingProgress.frame.size.width];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    if (totalDuration > 0) {
        self.nextButton.hidden = NO;
    } else{
        self.nextButton.hidden = YES;
    }
    
    [self updateUIToNormal];
    
    if (self.fileEndDecoding) {
        [self clickNextButton:nil];
    }
}

// 删除了最后一段成功的回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    self.fileEndDecoding = NO;
    self.durationLabel.text = [NSString stringWithFormat:@"%0.1f s", MAX(0, totalDuration)];
    if (totalDuration == 0 || [self.mixRecorder getFilesCount] == 0) {
        self.durationLabel.hidden = YES;
        self.deleteLastButton.hidden = YES;
        self.nextButton.hidden = YES;
    } else{
        self.durationLabel.hidden = NO;
        self.deleteLastButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
}

// 素材视频已经到达尾部, 即将结束合拍，videoMixRecorder:didFinishRecordingToOutputFileAtURL:fileDuration:totalDuration 即将回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFinishSampleMediaDecoding:(CMTime)sampleMediaDuration {
    self.fileEndDecoding = YES;
}

- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder errorOccur:(NSError *)error {
    [self showAlertMessage:nil message:error.localizedDescription];
}

#pragma mark - 进入编辑

- (void)playEvent:(AVAsset *)asset {
    
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.mixRecorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    QNEditorViewController *videoEditorViewController = [[QNEditorViewController alloc] init];
    videoEditorViewController.settings = outputSettings;
    videoEditorViewController.fileURLArray = [self.mixRecorder getAllFilesURL];
    videoEditorViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditorViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
