//
//  MixRecordViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/4/18.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MixRecordViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSProgressBar.h"
#import "PLSDeleteButton.h"
#import "EditViewController.h"
#import <Photos/Photos.h>
#import "PLSEditVideoCell.h"
#import "PLSFilterGroup.h"

#define PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG 10001
#define PLS_BaseToolboxView_HEIGHT 64

@interface MixRecordViewController ()
<
PLSVideoMixRecordererDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) PLSVideoMixConfiguration *videoConfiguration;
@property (strong, nonatomic) PLSAudioMixConfiguration *audioConfiguration;
@property (strong, nonatomic) PLSVideoMixRecorder *videoMixRecorder;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) PLSDeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *endButton;
@property (strong, nonatomic) UIButton *selectVideoButton;
@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) NSInteger titleIndex;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *recordToolboxView;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UIAlertView *alertView;

// 录制的视频文件的存储路径设置
@property (strong, nonatomic) UIButton *filePathButton;
@property (assign, nonatomic) BOOL useSDKInternalPath;

// 录制时是否使用滤镜
@property (assign, nonatomic) BOOL isUseFilterWhenRecording;

// 所有滤镜
@property (strong, nonatomic) PLSFilterGroup *filterGroup;
// 展示所有滤镜的集合视图
@property (strong, nonatomic) UICollectionView *editVideoCollectionView;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersArray;
// 切换滤镜的时候，为了更好的用户体验，添加以下属性来做切换动画
@property (nonatomic, assign) BOOL isPanning;
@property (nonatomic, assign) BOOL isLeftToRight;
@property (nonatomic, assign) BOOL isNeedChangeFilter;
@property (nonatomic, weak) PLSFilter *leftFilter;
@property (nonatomic, weak) PLSFilter *rightFilter;
@property (nonatomic, assign) float leftPercent;

@property (strong, nonatomic) UIButton *draftButton;
@property (strong, nonatomic) NSURL *URL;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UISwitch *acousticEchoCancellationSwitch;//回音消除开关
@property (strong, nonatomic) UISwitch *microphoneSwitch;//麦克风采集开关
@property (strong, nonatomic) UISwitch *sampleSwitch;//素材音频是否加入混音使用开关
@property (strong, nonatomic) UISlider *microphoneSlider;//如果做混音处理，混音的时候麦克风采集音频音量
@property (strong, nonatomic) UISlider *sampleSlider;//如果做混音处理，混音的时候素材音频音量
@property (assign, nonatomic) CGFloat maxDuration;
@property (assign, nonatomic) CGFloat minDuration;
@property (assign, nonatomic) CGFloat fileEndDecoding;

@end

@implementation MixRecordViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        // 录制时默认关闭滤镜
        self.isUseFilterWhenRecording = YES;
        
        if (self.isUseFilterWhenRecording) {
            // 滤镜
            self.filterGroup = [[PLSFilterGroup alloc] init];
        }
    }
    return self;
}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    self.minDuration = 2.0;
    
    // --------------------------
    // 短视频录制核心类设置
    [self setupvideoMixRecorder];
    
    // --------------------------
    [self setupBaseToolboxView];
    [self setupRecordToolboxView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // --------------------------
    // 通过手势切换滤镜
    [self setupGestureRecognizer];
    
    // --------------------------
//    [self setupRenderManager];
//    [self setupKiwiFaceUI];
    // --------------------------
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.videoMixRecorder startCaptureSession];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoMixRecorder stopCaptureSession];
}

- (void)setupvideoMixRecorder {
    
    CGSize videoSize = CGSizeZero;
    CGRect cameraFrame = CGRectZero;
    CGRect sampleFrame = CGRectZero;
    NSInteger cameraZIndex = 0;
    NSInteger sampleZIndex = 0;
    
    if (enumMixTypeLeftRight == self.mixType) {
        videoSize = CGSizeMake(1080, 960);
        cameraFrame = CGRectMake(0, 0, 540, 960);
        sampleFrame = CGRectMake(540, 0, 540, 960);
        cameraZIndex = 0;
        sampleZIndex = 1;
    } else if (enumMixTypeUpdown == self.mixType) {
        videoSize = CGSizeMake(720, 1280);
        cameraFrame = CGRectMake(0, 0, 720, 1280);
        sampleFrame = CGRectMake(50, 50, 240, 426);
        cameraZIndex = 0;
        sampleZIndex = 1;
    } else {
        videoSize = CGSizeMake(720, 1280);
        sampleFrame = CGRectMake(0, 0, 720, 1280);
        cameraFrame = CGRectMake(50, 50, 240, 426);
        cameraZIndex = 1;
        sampleZIndex = 0;
    }
    
    self.videoConfiguration = [PLSVideoMixConfiguration defaultConfiguration];
    self.videoConfiguration.position = AVCaptureDevicePositionFront;
    self.videoConfiguration.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
    self.videoConfiguration.videoFrameRate = 30;
    self.videoConfiguration.videoSize = videoSize;
    self.videoConfiguration.averageVideoBitRate = 1024*4000;
    self.videoConfiguration.cameraVideoFrame = cameraFrame;
    self.videoConfiguration.sampleVideoFrame = sampleFrame;
    self.videoConfiguration.camermZIndex = cameraZIndex;
    self.videoConfiguration.sampleZIndex = sampleZIndex;
    self.videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoConfiguration.previewMirrorFrontFacing = YES;
    self.videoConfiguration.streamMirrorFrontFacing = YES;
    
    self.audioConfiguration = [PLSAudioMixConfiguration defaultConfiguration];
    self.audioConfiguration.sampleVolume = 0.5;
    self.audioConfiguration.microphoneVolume = 1.0;
    self.audioConfiguration.acousticEchoCancellationEnable = YES;
    self.audioConfiguration.numberOfChannels = 1;
    self.audioConfiguration.disableSample = NO;
    self.audioConfiguration.disableMicrophone = NO;
    
    self.videoMixRecorder = [[PLSVideoMixRecorder alloc] initWithVideoConfiguration:self.videoConfiguration audioConfiguration:self.audioConfiguration];
    self.videoMixRecorder.delegate = self;
    self.videoMixRecorder.outputFileType = PLSFileTypeMPEG4;
    self.videoMixRecorder.innerFocusViewShowEnable = YES; // 显示 SDK 内部自带的对焦动画
    self.videoMixRecorder.mergeVideoURL = self.mixURL;
    [self.videoMixRecorder setBeautifyModeOn:YES];
    CGFloat height = PLS_SCREEN_WIDTH/2 * 640.0 / 360.0;
    if (enumMixTypeLeftRight != self.mixType) {
        height = PLS_SCREEN_WIDTH * 1280 / 720;
    }
    self.videoMixRecorder.previewView.frame = CGRectMake(0, (PLS_SCREEN_HEIGHT - height)/2, PLS_SCREEN_WIDTH, height);
    [self.view addSubview:self.videoMixRecorder.previewView];
    
    // 默认关闭内部滤镜
    if (self.isUseFilterWhenRecording) {
        // 滤镜资源
        self.filtersArray = [[NSMutableArray alloc] init];
        for (NSDictionary *filterInfoDic in self.filterGroup.filtersInfo) {
            NSString *name = [filterInfoDic objectForKey:@"name"];
            NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
            
            NSDictionary *dic = @{
                                  @"name"            : name,
                                  @"coverImagePath"  : coverImagePath
                                  };
            
            [self.filtersArray addObject:dic];
        }
        
        // 展示多种滤镜的 UICollectionView
        CGRect frame = self.editVideoCollectionView.frame;
        CGFloat x = PLS_BaseToolboxView_HEIGHT;
        CGFloat y = PLS_BaseToolboxView_HEIGHT;
        CGFloat width = frame.size.width - 2*x;
        CGFloat height = frame.size.height;
        self.editVideoCollectionView.frame = CGRectMake(x, y, width, height);
        [self.view addSubview:self.editVideoCollectionView];
        [self.editVideoCollectionView reloadData];
        self.editVideoCollectionView.hidden = YES;
    }
    
    // 本地视频
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"video_draft_test" ofType:@"mp4"];
    self.URL = [NSURL fileURLWithPath:filePath];
}

- (void)setupBaseToolboxView {
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_BaseToolboxView_HEIGHT, PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 10, 35, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_cancel_a"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_cancel_b"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 七牛滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(10, 55, 35, 35);
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [filterButton addTarget:self action:@selector(filterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:filterButton];

    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake(10, 100, 35, 35);
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_close"] forState:UIControlStateNormal];
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_open"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:flashButton];
    
    // 美颜
    UIButton *beautyFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautyFaceButton.frame = CGRectMake(10, 145, 30, 30);
    [beautyFaceButton setTitle:@"美颜" forState:UIControlStateNormal];
    [beautyFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    beautyFaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [beautyFaceButton addTarget:self action:@selector(beautyFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    beautyFaceButton.selected = YES;
    [self.baseToolboxView addSubview:beautyFaceButton];
    
    // 切换摄像头
    UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleCameraButton.frame = CGRectMake(10, 190, 35, 35);
    [toggleCameraButton setBackgroundImage:[UIImage imageNamed:@"toggle_camera"] forState:UIControlStateNormal];
    [toggleCameraButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:toggleCameraButton];
    
    // 录制的视频文件的存储路径设置
    self.filePathButton = [[UIButton alloc] init];
    self.filePathButton.frame = CGRectMake(10, 235, 35, 35);
    [self.filePathButton setImage:[UIImage imageNamed:@"file_path"] forState:UIControlStateNormal];
    [self.filePathButton addTarget:self action:@selector(filePathButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.filePathButton];
    
    self.filePathButton.selected = NO;
    self.useSDKInternalPath = YES;
    
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 回音消除开关
    self.acousticEchoCancellationSwitch = [[UISwitch alloc] init];
    CGRect frame = self.acousticEchoCancellationSwitch.frame;
    frame = CGRectMake(self.view.bounds.size.width - frame.size.width - 20, 30, frame.size.width, frame.size.height);
    self.acousticEchoCancellationSwitch.frame = frame;
    [self.acousticEchoCancellationSwitch setOn:_audioConfiguration.acousticEchoCancellationEnable];
    [self.acousticEchoCancellationSwitch addTarget:self action:@selector(acousticEchoCancellationSwitchChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:self.acousticEchoCancellationSwitch];
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"回音消除开关"];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label sizeToFit];
    label.center = CGPointMake(frame.origin.x - label.bounds.size.width/2, self.acousticEchoCancellationSwitch.center.y);
    [self.view addSubview:label];
    
    // 麦克风采集开关
    self.microphoneSwitch = [[UISwitch alloc] init];
    frame = self.acousticEchoCancellationSwitch.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 10, frame.size.width, frame.size.height);
    self.microphoneSwitch.frame = frame;
    [self.microphoneSwitch setOn:!_audioConfiguration.disableMicrophone];
    [self.microphoneSwitch addTarget:self action:@selector(microphoneSwitchChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:self.microphoneSwitch];
    label = [[UILabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"麦克风开关和音量调节(0 ~ 1)"];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label sizeToFit];
    label.center = CGPointMake(frame.origin.x - label.bounds.size.width/2, self.microphoneSwitch.center.y);
    [self.view addSubview:label];
    
    self.microphoneSlider = [[UISlider alloc] init];
    self.microphoneSlider.maximumValue = 1.0;
    self.microphoneSlider.minimumValue = 0.0;
    self.microphoneSlider.value = _audioConfiguration.microphoneVolume;
    [self.microphoneSlider addTarget:self action:@selector(microphoneSliderChange:) forControlEvents:(UIControlEventValueChanged)];
    CGFloat sliderWidth = 200;
    frame = CGRectMake(self.view.bounds.size.width - sliderWidth - 20, frame.origin.y + frame.size.height, sliderWidth, self.microphoneSlider.bounds.size.height);
    self.microphoneSlider.frame = frame;
    [self.view addSubview:self.microphoneSlider];
    
    // 素材音频开关
    self.sampleSwitch = [[UISwitch alloc] init];
    frame = CGRectMake(self.view.bounds.size.width - self.sampleSwitch.bounds.size.width - 20, frame.origin.y + frame.size.height + 10, self.sampleSwitch.bounds.size.width, self.sampleSwitch.bounds.size.height);
    self.sampleSwitch.frame = frame;
    [self.sampleSwitch setOn:!_audioConfiguration.disableSample];
    [self.sampleSwitch addTarget:self action:@selector(sampleSwitchChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:self.sampleSwitch];
    label = [[UILabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"素材音频开关和音量调节(0 ~ 1)"];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label sizeToFit];
    label.center = CGPointMake(frame.origin.x - label.bounds.size.width/2, self.sampleSwitch.center.y);
    [self.view addSubview:label];
    
    self.sampleSlider = [[UISlider alloc] init];
    self.sampleSlider.maximumValue = 1.0;
    self.sampleSlider.minimumValue = 0.0;
    self.sampleSlider.value = _audioConfiguration.sampleVolume;
    [self.sampleSlider addTarget:self action:@selector(sampleSliderChange:) forControlEvents:(UIControlEventValueChanged)];
    frame = CGRectMake(self.view.bounds.size.width - sliderWidth - 20, frame.origin.y + frame.size.height, sliderWidth, self.sampleSlider.bounds.size.height);
    self.sampleSlider.frame = frame;
    [self.view addSubview:self.sampleSlider];
}

- (void)setupRecordToolboxView {
    CGFloat y = PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH;
    self.recordToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT- y)];
    self.recordToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordToolboxView];
    
    // 录制视频的操作按钮
    CGFloat buttonWidth = 80.0f;
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    self.recordButton.center = CGPointMake(PLS_SCREEN_WIDTH / 2, self.recordToolboxView.frame.size.height - 80);
    [self.recordButton setImage:[UIImage imageNamed:@"btn_record_a"] forState:UIControlStateNormal];
    [self.recordButton addTarget:self action:@selector(recordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.recordButton];
    
    // 删除视频片段的按钮
    CGPoint center = self.recordButton.center;
    center.x = 40;
    self.deleteButton = [PLSDeleteButton getInstance];
    self.deleteButton.style = PLSDeleteButtonStyleNormal;
    self.deleteButton.frame = CGRectMake(15, PLS_SCREEN_HEIGHT - 80, 50, 50);
    self.deleteButton.center = center;
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.deleteButton];
    self.deleteButton.hidden = NO;
    
    // 结束录制的按钮
    center = self.recordButton.center;
    center.x = CGRectGetWidth([UIScreen mainScreen].bounds) - 60;
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 60, PLS_SCREEN_HEIGHT - 80, 50, 50);
    self.endButton.center = center;
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"end_normal"] forState:UIControlStateNormal];
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"end_disable"] forState:UIControlStateDisabled];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.endButton.enabled = NO;
    [self.recordToolboxView addSubview:self.endButton];
    self.endButton.hidden = YES;
    
    // 视频录制进度条
    self.progressBar = [[PLSProgressBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.recordToolboxView.frame) - 10, PLS_SCREEN_WIDTH, 10)];
    [self.recordToolboxView addSubview:self.progressBar];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 150, CGRectGetHeight(self.recordToolboxView.frame) - 45, 130, 40)];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.videoMixRecorder.getTotalDuration];
    self.durationLabel.textAlignment = NSTextAlignmentRight;
    [self.recordToolboxView addSubview:self.durationLabel];
}

- (void)resetAudioControlUI {
    if ([self.microphoneSwitch isOn] && [self.sampleSwitch isOn]) {
        self.sampleSlider.enabled = YES;
        self.microphoneSlider.enabled = YES;
    } else {
        self.sampleSlider.enabled = NO;
        self.microphoneSlider.enabled = NO;
    }
    
    self.acousticEchoCancellationSwitch.enabled = [self.microphoneSwitch isOn];
}

- (void)acousticEchoCancellationSwitchChange:(UISwitch *)uiswitch {
    if ([self.videoMixRecorder isRecording]) return;
    
    self.videoMixRecorder.acousticEchoCancellationEnable = [uiswitch isOn];
}

- (void)microphoneSwitchChange:(UISwitch *)uiswitch {
    if ([self.videoMixRecorder isRecording]) return;
    
    self.videoMixRecorder.disableMicrophone = ![uiswitch isOn];
    [self resetAudioControlUI];
}

- (void)microphoneSliderChange:(UISlider *)slider {
    self.videoMixRecorder.microphoneVolume = slider.value;
}

- (void)sampleSwitchChange:(UISwitch *)uiswitch {
    if ([self.videoMixRecorder isRecording]) return;
    
    self.videoMixRecorder.disableSample = ![uiswitch isOn];
    [self resetAudioControlUI];
}

- (void)sampleSliderChange:(UISlider *)slider {
    self.videoMixRecorder.sampleVolume = slider.value;
}

// 返回上一层
- (void)backButtonEvent:(id)sender {

    if ([self.videoMixRecorder getFilesCount] > 0) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"放弃这个视频(共%ld个视频段)?", (long)[self.videoMixRecorder getFilesCount]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG;
        [self.alertView show];
    } else {
        [self discardRecord];
    }
}

// 打开／关闭闪光灯
- (void)flashButtonEvent:(id)sender {
    if (self.videoMixRecorder.torchOn) {
        self.videoMixRecorder.torchOn = NO;
    } else {
        self.videoMixRecorder.torchOn = YES;
    }
}

// 打开／关闭美颜
- (void)beautyFaceButtonEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self.videoMixRecorder setBeautifyModeOn:!button.selected];
    
    button.selected = !button.selected;
}

// 切换前后置摄像头
- (void)toggleCameraButtonEvent:(id)sender {
    [self.videoMixRecorder toggleCamera];
}

// 七牛滤镜
- (void)filterButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    self.editVideoCollectionView.hidden = !button.selected;
}

//
- (void)filePathButtonClickedEvent:(id)sender {
    self.filePathButton.selected = !self.filePathButton.selected;
    if (self.filePathButton.selected) {
        self.useSDKInternalPath = NO;
    } else {
        self.useSDKInternalPath = YES;
    }
}

// 删除上一段视频
- (void)deleteButtonEvent:(id)sender {
    if (_deleteButton.style == PLSDeleteButtonStyleNormal) {
        
        [_progressBar setLastProgressToStyle:PLSProgressBarProgressStyleDelete];
        _deleteButton.style = PLSDeleteButtonStyleDelete;
        
    } else if (_deleteButton.style == PLSDeleteButtonStyleDelete) {
        
        [self.videoMixRecorder deleteLastFile];
        
        [_progressBar deleteLastProgress];
        
        _deleteButton.style = PLSDeleteButtonStyleNormal;
    }
}

// 录制视频
- (void)recordButtonEvent:(id)sender {
    if (self.videoMixRecorder.isRecording) {
        [self.videoMixRecorder stopRecording];
    } else {
        if (self.useSDKInternalPath) {
            // 方式1
            // 录制的视频的存放地址由 SDK 内部自动生成
            [self.videoMixRecorder startRecording];
        } else {
            // 方式2
            // fileURL 录制的视频的存放地址，该参数可以在外部设置，录制的视频会保存到该位置
            [self.videoMixRecorder startRecording:[self getFileURL]];
        }
    }
}

- (NSURL *)getFileURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"TestPath"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        // 如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:fileName];
    
    return fileURL;
}

// 结束录制
- (void)endButtonEvent:(id)sender {
    AVAsset *asset = self.videoMixRecorder.assetRepresentingAllFiles;
    [self playEvent:asset];
}

// 取消录制
- (void)discardRecord {
    [self.videoMixRecorder cancelRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification
- (void)applicationWillResignActive:(NSNotification *)notification {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG:
        {
            switch (buttonIndex) {
                case 0:
                    
                    break;
                case 1:
                {
                    [self discardRecord];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- PLSVideoMixRecorderDelegate 摄像头／麦克风鉴权的回调
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

#pragma mark - PLSVideoMixRecorderDelegate 摄像头对焦位置的回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFocusAtPoint:(CGPoint)point {
    NSLog(@"videoMixRecorder: didFocusAtPoint: %@", NSStringFromCGPoint(point));
}

#pragma mark - PLSVideoMixRecorderDelegate 摄像头采集的视频数据的回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)videoMixRecorder:(PLSVideoMixRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    // 是否在录制时使用滤镜，默认是关闭的，NO
    if (self.isUseFilterWhenRecording) {
        if (self.isPanning) {
            pixelBuffer = [self.filterGroup processPixelBuffer:pixelBuffer
                                                   leftPercent:self.leftPercent
                                                    leftFilter:self.leftFilter
                                                   rightFilter:self.rightFilter];
        } else {
            PLSFilter *filter = self.filterGroup.currentFilter;
            pixelBuffer = [filter process:pixelBuffer];
        }
    }
    
    return pixelBuffer;
}

#pragma mark -- PLSVideoMixRecorderDelegate 视频录制回调
// 素材视频的部分信息回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetSampleVideoInfo:(int)videoWith videoHeight:(int)videoheight frameRate:(float)frameRate duration:(CMTime)duration {
    self.maxDuration = CMTimeGetSeconds(duration);
}


// 开始录制一段视频时
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
    
    self.acousticEchoCancellationSwitch.enabled = NO;
    self.microphoneSwitch.enabled = NO;
    self.sampleSwitch.enabled = NO;
    
    [self.progressBar addProgressView];
    [_progressBar startShining];
}

// 正在录制的过程中
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [_progressBar setLastProgressToWidth:fileDuration / self.maxDuration * _progressBar.frame.size.width];
    
    self.endButton.enabled = NO;
    
    self.endButton.hidden = YES;
    self.filePathButton.hidden = YES;
    self.deleteButton.hidden = YES;
    self.selectVideoButton.hidden = YES;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    [_progressBar stopShining];
    
    self.endButton.enabled = totalDuration > self.minDuration;
    self.endButton.hidden = NO;
    self.deleteButton.hidden = NO;
    self.selectVideoButton.hidden = NO;
    self.microphoneSwitch.enabled = YES;
    self.sampleSwitch.enabled = YES;
    self.acousticEchoCancellationSwitch.enabled = YES;
    if (self.fileEndDecoding) {
        [self endButtonEvent:nil];
    }
}

// 删除了最后一段成功的回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    self.fileEndDecoding = NO;
    self.endButton.enabled = totalDuration >= self.minDuration;
}

// 素材视频已经到达尾部
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFinishSampleMediaDecoding:(CMTime)sampleMediaDuration {
    NSLog(@"sample file end");
    self.fileEndDecoding = YES;
}

// Microphone 采集数据回调, 如果想替换 Microphone 采集的音频数据，可以直接将用于替换的音频数据放在 audioBufferList 中
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder microphoneSourceDidGetAudioBufferList:(AudioBufferList *__nonnull)audioBufferList {
}

// 素材视频音频数据回调，如果想替换素材的音频数据，可以直接将用于替换的音频数据放在 audioBufferList 中
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetAudioBufferList:(AudioBufferList *__nonnull)audioBufferList {
}


// 素材视频数据回调
- (CVPixelBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer{
    return pixelBuffer;
}

// 混音数据回调， 如果想替换混合后的音频数据，可以直接将用于替换的音频数据放在 audioBufferList 中
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergeAudioBufferList:(AudioBufferList * __nonnull)audioBufferList {
}


// 合并之后的视频数据回调
- (CVPixelBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergePixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer{
    return pixelBuffer;
}

- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder errorOccur:(NSError *)error {
    NSLog(@"error = %@", error);
}

#pragma mark -- 下一步
- (void)playEvent:(AVAsset *)asset {
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [self.videoMixRecorder getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);
    
    __block AVAsset *movieAsset = asset;
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.videoMixRecorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.filesURLArray = filesURLArray;
    videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

#pragma mark - 输出路径
- (NSURL *)exportAudioMixPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_mix.mp4",nowTimeStr]];
    return [NSURL fileURLWithPath:fileName];
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
    self.videoMixRecorder.delegate = nil;
    self.videoMixRecorder = nil;
    
    self.alertView = nil;
    self.filtersArray = nil;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

#pragma mark -- UICollectionView delegate  用来展示和处理 SDK 内部自带的滤镜效果
// 加载 collectionView 视图
- (UICollectionView *)editVideoCollectionView {
    if (!_editVideoCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(50, 65);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _editVideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, layout.itemSize.height) collectionViewLayout:layout];
        _editVideoCollectionView.backgroundColor = [UIColor clearColor];
        
        _editVideoCollectionView.showsHorizontalScrollIndicator = NO;
        _editVideoCollectionView.showsVerticalScrollIndicator = NO;
        [_editVideoCollectionView setExclusiveTouch:YES];
        
        [_editVideoCollectionView registerClass:[PLSEditVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class])];
        
        _editVideoCollectionView.delegate = self;
        _editVideoCollectionView.dataSource = self;
    }
    return _editVideoCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filtersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSEditVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class]) forIndexPath:indexPath];
    
    // 滤镜
    NSDictionary *filterInfoDic = self.filtersArray[indexPath.row];
    
    NSString *name = [filterInfoDic objectForKey:@"name"];
    NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
    
    cell.iconPromptLabel.text = name;
    cell.iconImageView.image = [UIImage imageWithContentsOfFile:coverImagePath];
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 滤镜
    self.filterGroup.filterIndex = indexPath.row;
}

#pragma mark - 通过手势切换滤镜
- (void)setupGestureRecognizer {
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFilterPan:)];
    [self.view addGestureRecognizer:panGesture];
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

@end
