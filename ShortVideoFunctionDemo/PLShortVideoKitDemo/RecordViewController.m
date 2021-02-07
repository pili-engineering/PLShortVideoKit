//
//  RecordViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "RecordViewController.h"
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

@interface RecordViewController ()
<
PLShortVideoRecorderDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
PLSViewRecorderManagerDelegate,
PLSRateButtonViewDelegate,
PLScreenRecorderManagerDelegate
>

@property (strong, nonatomic) PLSVideoConfiguration *videoConfiguration;
@property (strong, nonatomic) PLSAudioConfiguration *audioConfiguration;
@property (strong, nonatomic) PLShortVideoRecorder *shortVideoRecorder;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) PLSDeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *endButton;
@property (strong, nonatomic) PLSRateButtonView *rateButtonView;
@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) NSInteger titleIndex;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *recordToolboxView;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) UIButton *squareRecordButton;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) UIView *importMovieView;
@property (strong, nonatomic) UIButton *importMovieButton;

@property (strong, nonatomic) UIScrollView *rightScrollView;

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

@property (strong, nonatomic) UIButton *musicButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIButton *filterButton;

@property (strong, nonatomic) UIButton *monitorButton;
// 实时截图按钮
@property (strong, nonatomic) UIButton *snapshotButton;
// 帧率切换按钮
@property (strong, nonatomic) UIButton *frameRateButton;

// 录制前是否开启自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
@property (assign, nonatomic) BOOL isUseAutoCheckDeviceOrientationBeforeRecording;

@property (assign, nonatomic) BOOL isViewRecord;


@end

@implementation RecordViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 录制时默认关闭滤镜
        self.isUseFilterWhenRecording = YES;
        
        // 录制前默认打开自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
        self.isUseAutoCheckDeviceOrientationBeforeRecording = YES;
        
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
    
    // --------------------------
    // 短视频录制核心类设置
    [self setupShortVideoRecorder];
    
    // --------------------------
    [self setupBaseToolboxView];
    [self setupRecordToolboxView];
    [self setupRightButtonView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // --------------------------
    // 通过手势切换滤镜
    [self setupGestureRecognizer];
    
    // --------------------------
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    [self.shortVideoRecorder startCaptureSession];
    
    [self getFirstMovieFromPhotoAlbum];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
    [self.shortVideoRecorder stopCaptureSession];
}

// 短视频录制核心类设置
- (void)setupShortVideoRecorder {

    // SDK 的版本信息
    NSLog(@"PLShortVideoRecorder versionInfo: %@", [PLShortVideoRecorder versionInfo]);
    
    // SDK 授权信息查询
    [PLShortVideoRecorder checkAuthentication:^(PLSAuthenticationResult result) {
        NSString *authResult[] = {@"NotDetermined", @"Denied", @"Authorized"};
        NSLog(@"PLShortVideoRecorder auth status: %@", authResult[result]);
    }];
    
    self.videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    self.videoConfiguration.position = AVCaptureDevicePositionFront;
    self.videoConfiguration.videoFrameRate = 30;
    self.videoConfiguration.videoSize = CGSizeMake(720, 1280);
    self.videoConfiguration.averageVideoBitRate = [self suitableVideoBitrateWithSize:self.videoConfiguration.videoSize];
    self.videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoConfiguration.sessionPreset = AVCaptureSessionPreset1280x720;
//    self.videoConfiguration.videoHardwareType = PLSVideoHardwareTypeHEVC;

    self.audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    
    self.shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:self.videoConfiguration audioConfiguration:self.audioConfiguration];
    self.shortVideoRecorder.delegate = self;
    self.shortVideoRecorder.maxDuration = 10.0f; // 设置最长录制时长
    [self.shortVideoRecorder setBeautifyModeOn:YES]; // 默认打开美颜
    self.shortVideoRecorder.outputFileType = PLSFileTypeMPEG4;
    self.shortVideoRecorder.innerFocusViewShowEnable = YES; // 显示 SDK 内部自带的对焦动画
    self.shortVideoRecorder.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    [self.view addSubview:self.shortVideoRecorder.previewView];
    self.shortVideoRecorder.backgroundMonitorEnable = NO;

    // 录制前是否开启自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
    if (self.isUseAutoCheckDeviceOrientationBeforeRecording) {
        self.shortVideoRecorder.adaptationRecording = YES; // 根据设备方向自动确定横屏 or 竖屏拍摄效果
        [self.shortVideoRecorder setDeviceOrientationBlock:^(PLSPreviewOrientation deviceOrientation){
            switch (deviceOrientation) {
                case PLSPreviewOrientationPortrait:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationPortrait");
                    break;
                case PLSPreviewOrientationPortraitUpsideDown:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationPortraitUpsideDown");
                    break;
                case PLSPreviewOrientationLandscapeRight:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationLandscapeRight");
                    break;
                case PLSPreviewOrientationLandscapeLeft:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationLandscapeLeft");
                    break;
                default:
                    break;
            }
        }];
    }
    
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
    }
    
    // 本地视频
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"video_draft_test" ofType:@"mp4"];
    self.URL = [NSURL fileURLWithPath:filePath];
}

- (void)setupBaseToolboxView {
    CGFloat topSpace = 10;
    if (PL_iPhoneX || PL_iPhoneXR || PL_iPhoneXSMAX ||
        PL_iPhone12Min || PL_iPhone12Pro || PL_iPhone12PMax) {
        topSpace = 34;
    }
    
    UIView *topToolView = [[UIView alloc] initWithFrame:CGRectMake(10, topSpace, 176, 35)];
    topToolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topToolView];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 35, 35);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [backButton setImage:[UIImage imageNamed:@"close_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:backButton];
    
    // 截图
    self.snapshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapshotButton.frame = CGRectMake(47, 0, 35, 35);
    [self.snapshotButton setImage:[UIImage imageNamed:@"screen_shoots"] forState:UIControlStateNormal];
    [self.snapshotButton addTarget:self action:@selector(snapshotButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:_snapshotButton];
    
    // 切换摄像头
    UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleCameraButton.frame = CGRectMake(47 * 2, 0, 35, 35);
    toggleCameraButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    [toggleCameraButton setImage:[UIImage imageNamed:@"toggle_camera"] forState:UIControlStateNormal];
    [toggleCameraButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:toggleCameraButton];
    
    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake(47 * 3, 0, 35, 35);
    flashButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [flashButton setImage:[UIImage imageNamed:@"flash_close"] forState:UIControlStateNormal];
    [flashButton setImage:[UIImage imageNamed:@"flash_open"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:flashButton];
    
    UIView *leftToolView = [[UIView alloc] initWithFrame:CGRectMake(10, topSpace + 50, 72, 228)];
    leftToolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftToolView];
    
    // 美颜
    UIButton *beautyFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautyFaceButton.frame = CGRectMake(0, 0, 72, 28);
    [beautyFaceButton setTitle:@"美颜: 关" forState:UIControlStateNormal];
    [beautyFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beautyFaceButton setTitle:@"美颜: 开" forState:UIControlStateSelected];
    [beautyFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    beautyFaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [beautyFaceButton sizeToFit];
    [beautyFaceButton addTarget:self action:@selector(beautyFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolView addSubview:beautyFaceButton];
    beautyFaceButton.selected = YES;
    
    // 七牛滤镜
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterButton.frame = CGRectMake(0, 40, 72, 28);
    [self.filterButton setTitle:@"滤镜: 原色" forState:UIControlStateNormal];
    [self.filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.filterButton sizeToFit];
    [self.filterButton addTarget:self action:@selector(filterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolView addSubview:self.filterButton];
    
    //是否开启 SDK 退到后台监听
    self.monitorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.monitorButton.frame = CGRectMake(0, 80, 72, 28);
    [self.monitorButton setTitle:@"监听: 关" forState:UIControlStateNormal];
    [self.monitorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.monitorButton setTitle:@"监听: 开" forState:UIControlStateSelected];
    [self.monitorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.monitorButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.monitorButton sizeToFit];
    [self.monitorButton addTarget:self action:@selector(monitorButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolView addSubview:self.monitorButton];
    self.monitorButton.selected = NO;
    
    // 30FPS/60FPS
    self.frameRateButton =  [[UIButton alloc] init];
    self.frameRateButton.frame = CGRectMake(0, 120, 72, 28);
    [self.frameRateButton setTitle:@"帧率: 30" forState:(UIControlStateNormal)];
    [self.frameRateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.frameRateButton setTitle:@"帧率: 60" forState:(UIControlStateSelected)];
    [self.frameRateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.frameRateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.frameRateButton sizeToFit];
    [self.frameRateButton addTarget:self action:@selector(frameRateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolView addSubview:self.frameRateButton];
    
    // 全屏／正方形录制模式
    self.squareRecordButton = [[UIButton alloc] init];
    self.squareRecordButton.frame = CGRectMake(0, 160, 72, 28);
    [self.squareRecordButton setTitle:@"屏比: 全屏" forState:UIControlStateNormal];
    [self.squareRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.squareRecordButton setTitle:@"屏比: 1:1" forState:UIControlStateSelected];
    [self.squareRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.squareRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.squareRecordButton sizeToFit];
    [self.squareRecordButton addTarget:self action:@selector(squareRecordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolView addSubview:self.squareRecordButton];
    self.squareRecordButton.selected = NO;
    
    // 录制的视频文件的存储路径设置
    self.filePathButton = [[UIButton alloc] init];
    self.filePathButton.frame = CGRectMake(0, 200, 72, 28);
    [self.filePathButton setTitle:@"目录: 开" forState:UIControlStateNormal];
    [self.filePathButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.filePathButton setTitle:@"目录: 关" forState:UIControlStateSelected];
    [self.filePathButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.filePathButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.filePathButton sizeToFit];
    [self.filePathButton addTarget:self action:@selector(filePathButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolView addSubview:self.filePathButton];
    self.filePathButton.selected = NO;
    self.useSDKInternalPath = YES;

    
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupRightButtonView {
    self.rightScrollView = [[UIScrollView alloc] init];
    self.rightScrollView.bounces = YES;
    CGRect rc = self.rateButtonView.bounds;
    rc = [self.rateButtonView convertRect:rc toView:self.view];
    self.rightScrollView.frame = CGRectMake(self.view.bounds.size.width - 60, 0, 60, rc.origin.y);
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.rightScrollView flashScrollIndicators];
    });
    
    UIColor *backgroundColor = [UIColor whiteColor];
    
    CGFloat topSpace = 20;
    if (PL_iPhoneX || PL_iPhoneXR || PL_iPhoneXSMAX ||
        PL_iPhone12Min || PL_iPhone12Pro || PL_iPhone12PMax) {
        topSpace = 34;
    }

    int index = 0;
    // 加载草稿视频
    self.draftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, index * 46 + topSpace, 46, 32)];
    self.draftButton.layer.cornerRadius = 3;
    self.draftButton.backgroundColor = backgroundColor;
    [self.draftButton setTitle:@"片段" forState:UIControlStateNormal];
    self.draftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.draftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.draftButton addTarget:self action:@selector(draftVideoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:self.draftButton];
    
    index ++;
    // 是否使用背景音乐
    self.musicButton = [[UIButton alloc] initWithFrame:CGRectMake(0, index * 46 + topSpace, 46, 32)];
    self.musicButton.layer.cornerRadius = 3;
    self.musicButton.backgroundColor = backgroundColor;
    [self.musicButton setTitle:@"音乐" forState:UIControlStateNormal];
    self.musicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.musicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.musicButton setTitleColor:PLS_RGBCOLOR(65, 154, 208) forState:UIControlStateSelected];
    [self.musicButton addTarget:self action:@selector(musicButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:self.musicButton];
    
    index ++;
    [self.view addSubview:self.rightScrollView];
    self.rightScrollView.contentSize = CGSizeMake(60, index * 60 + 10);
}

- (void)setupRecordToolboxView {
    CGFloat y = PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH;
    self.recordToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT- y)];
    self.recordToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordToolboxView];

    
    // 倍速拍摄
    self.titleArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    CGFloat rateTopSapce;
    if (PLS_SCREEN_HEIGHT > 568) {
        rateTopSapce = 35;
    } else{
        rateTopSapce = 30;
    }
    self.rateButtonView = [[PLSRateButtonView alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH/2 - 130, rateTopSapce, 260, 34) defaultIndex:2];
    self.rateButtonView.hidden = NO;
    self.titleIndex = 2;
    CGFloat countSpace = 200 /self.titleArray.count / 6;
    self.rateButtonView.space = countSpace;
    self.rateButtonView.staticTitleArray = self.titleArray;
    self.rateButtonView.rateDelegate = self;
    [self.recordToolboxView addSubview:_rateButtonView];

    
    // 录制视频的操作按钮
    CGFloat buttonWidth = 80.0f;
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.layer.cornerRadius = buttonWidth/2;
    self.recordButton.layer.borderWidth = 5;
    self.recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.recordButton.backgroundColor = PLS_RGBCOLOR(65, 154, 208);
    self.recordButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    self.recordButton.center = CGPointMake(PLS_SCREEN_WIDTH / 2, self.recordToolboxView.frame.size.height - 80);
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
    self.deleteButton.hidden = YES;
    
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
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.shortVideoRecorder.getTotalDuration];
    self.durationLabel.textAlignment = NSTextAlignmentRight;
    [self.recordToolboxView addSubview:self.durationLabel];
    
    // 导入视频的操作按钮
    center = self.recordButton.center;
    center.x = CGRectGetWidth([UIScreen mainScreen].bounds) - 60;
    self.importMovieView = [[UIView alloc] init];
    self.importMovieView.backgroundColor = [UIColor clearColor];
    self.importMovieView.frame = CGRectMake(PLS_SCREEN_WIDTH - 60, PLS_SCREEN_HEIGHT - 80, 80, 80);
    self.importMovieView.center = center;
    [self.recordToolboxView addSubview:self.importMovieView];
    self.importMovieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.importMovieButton.frame = CGRectMake(15, 10, 50, 50);
    [self.importMovieButton setBackgroundImage:[UIImage imageNamed:@"movie"] forState:UIControlStateNormal];
    [self.importMovieButton addTarget:self action:@selector(importMovieButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.importMovieView addSubview:self.importMovieButton];
    UILabel *importMovieLabel = [[UILabel alloc] init];
    importMovieLabel.frame = CGRectMake(0, 60, 80, 20);
    importMovieLabel.text = @"导入视频";
    importMovieLabel.textColor = [UIColor whiteColor];
    importMovieLabel.textAlignment = NSTextAlignmentCenter;
    importMovieLabel.font = [UIFont systemFontOfSize:14.0];
    [self.importMovieView addSubview:importMovieLabel];
}

#pragma mark -- Button event
// 获取相册中最新的一个视频的封面
- (void)getFirstMovieFromPhotoAlbum {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [assets addObject:obj];
        }];
        
        if (assets.count > 0) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            CGSize size = CGSizeMake(50, 50);
            [[PHImageManager defaultManager] requestImageForAsset:assets[0] targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                
                // 设置的 options 可能会导致该回调调用两次，第一次返回你指定尺寸的图片，第二次将会返回原尺寸图片
                if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0){
                    // Do something with the FULL SIZED image
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.importMovieButton setBackgroundImage:result forState:UIControlStateNormal];
                    });
                } else {
                    // Do something with the regraded image
                    
                }
            }];
        }
    });
}

// 返回上一层
- (void)backButtonEvent:(id)sender {
    if ([self.shortVideoRecorder getFilesCount] > 0) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"放弃这个视频(共%ld个视频段)?", (long)[self.shortVideoRecorder getFilesCount]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG;
        [self.alertView show];
    } else {
        [self discardRecord];
    }
}

// 全屏录制／正方形录制
- (void)squareRecordButtonEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        self.videoConfiguration.videoSize = CGSizeMake(720, 720);
        [self.shortVideoRecorder reloadvideoConfiguration:self.videoConfiguration];
        
        self.shortVideoRecorder.maxDuration = 10.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shortVideoRecorder.previewView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
            self.progressBar.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, 10);
            
        });
        
    } else {
        self.videoConfiguration.videoSize = CGSizeMake(720, 1280);
        [self.shortVideoRecorder reloadvideoConfiguration:self.videoConfiguration];
        
        self.shortVideoRecorder.maxDuration = 10.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shortVideoRecorder.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
            self.progressBar.frame = CGRectMake(0, CGRectGetHeight(self.recordToolboxView.frame) - 10, PLS_SCREEN_WIDTH, 10);
        });
    }
}

// 打开／关闭闪光灯
- (void)flashButtonEvent:(id)sender {
    if (self.shortVideoRecorder.torchOn) {
        self.shortVideoRecorder.torchOn = NO;
    } else {
        self.shortVideoRecorder.torchOn = YES;
    }
}

// 打开／关闭美颜
- (void)beautyFaceButtonEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self.shortVideoRecorder setBeautifyModeOn:!button.selected];
    
    button.selected = !button.selected;
}

// 切换前后置摄像头
- (void)toggleCameraButtonEvent:(UIButton *)sender {
    // 采集帧率不大于 30 帧的时候，使用 [self.shortVideoRecorder toggleCamera] 和 [self.shortVideoRecorder toggleCamera:block] 都可以。当采集大于 30 帧的时候，为确保切换成功，需要先停止采集，再切换相机，切换完成再启动采集。如果不先停止采集，部分机型上采集 60 帧的时候，切换摄像头可能会耗时几秒钟
    if (self.videoConfiguration.videoFrameRate > 30) {
        sender.enabled = NO;
        __weak typeof(self) weakself = self;
        [self.shortVideoRecorder stopCaptureSession];
        [self.shortVideoRecorder toggleCamera:^(BOOL isFinish) {
            [weakself checkActiveFormat];// 默认的 active 可能最大只支持采集 30 帧，这里手动设置一下
            [weakself.shortVideoRecorder startCaptureSession];
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.enabled = YES;
            });
        }];
    } else {
        [self.shortVideoRecorder toggleCamera];
    }
}

// 七牛滤镜
- (void)filterButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    CGFloat height = CGRectGetHeight(self.editVideoCollectionView.frame);
    if (button.selected) {
        [self.view insertSubview:self.editVideoCollectionView aboveSubview:self.view.subviews.lastObject];
        [UIView animateWithDuration:0.5 animations:^{
            self.editVideoCollectionView.frame = CGRectMake(0, PLS_SCREEN_HEIGHT -  height, PLS_SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            [self.editVideoCollectionView reloadData];
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.editVideoCollectionView.frame = CGRectMake(0, PLS_SCREEN_HEIGHT, PLS_SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            [self.editVideoCollectionView reloadData];
            [self.editVideoCollectionView removeFromSuperview];
        }];
    }
   
}

// 加载草稿视频
- (void)draftVideoButtonOnClick:(id)sender{
    AVAsset *asset = [AVAsset assetWithURL:_URL];
    CGFloat duration = CMTimeGetSeconds(asset.duration);
    if ((self.shortVideoRecorder.getTotalDuration + duration) <= self.shortVideoRecorder.maxDuration) {
        [self.shortVideoRecorder insertVideo:_URL];
        if (self.shortVideoRecorder.getTotalDuration != 0) {
            _deleteButton.style = PLSDeleteButtonStyleNormal;
            _deleteButton.hidden = NO;
            
            [_progressBar addProgressView];
            [_progressBar startShining];
            [_progressBar setLastProgressToWidth:duration / self.shortVideoRecorder.maxDuration * _progressBar.frame.size.width];
            [_progressBar stopShining];
        }
        self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.shortVideoRecorder.getTotalDuration];
        if (self.shortVideoRecorder.getTotalDuration >= self.shortVideoRecorder.maxDuration) {
            self.importMovieButton.hidden = YES;
            [self endButtonEvent:nil];
        }
    }
}

// 是否使用背景音乐
- (void)musicButtonOnClick:(id)sender {
    self.musicButton.selected = !self.musicButton.selected;
    if (self.musicButton.selected) {
        // 背景音乐
        NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"counter-6s" ofType:@"m4a"]];
        [self.shortVideoRecorder mixAudio:audioURL];
    } else{
        [self.shortVideoRecorder mixAudio:nil];
    }
}

- (void)frameRateButtonOnClick:(UIButton *)button {
    if (60 == self.videoConfiguration.videoFrameRate) {
        self.videoConfiguration.videoFrameRate = 30;
        self.videoConfiguration.sessionPreset = AVCaptureSessionPreset1280x720;
        [self.shortVideoRecorder reloadvideoConfiguration:self.videoConfiguration];
    } else {
        self.videoConfiguration.videoFrameRate = 60;
        self.videoConfiguration.sessionPreset = AVCaptureSessionPresetInputPriority;
        [self.shortVideoRecorder reloadvideoConfiguration:self.videoConfiguration];
        [self checkActiveFormat];
    }
}

// 拍照
-(void)snapshotButtonOnClick:(UIButton *)sender {
    sender.enabled = NO;

    [self.shortVideoRecorder getScreenShotWithCompletionHandler:^(UIImage * _Nullable image) {
        sender.enabled = YES;
        if (image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            });
        }
    }];
}

- (void)monitorButtonEvent:(UIButton *)button {
    button.selected = !button.isSelected;
    self.shortVideoRecorder.backgroundMonitorEnable = button.selected;
    if (button.selected) {
        [self removeObserverEvent];
    } else {
        [self addObserverEvent];
    }
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
        
        [self.shortVideoRecorder deleteLastFile];
        
        [_progressBar deleteLastProgress];
        
        _deleteButton.style = PLSDeleteButtonStyleNormal;
    }
}

// 录制视频
- (void)recordButtonEvent:(id)sender {
    if (self.shortVideoRecorder.isRecording) {
        [self.shortVideoRecorder stopRecording];
    } else {
        if (self.useSDKInternalPath) {
            // 方式1
            // 录制的视频的存放地址由 SDK 内部自动生成
             [self.shortVideoRecorder startRecording];
        } else {
            // 方式2
            // fileURL 录制的视频的存放地址，该参数可以在外部设置，录制的视频会保存到该位置
            [self.shortVideoRecorder startRecording:[self getFileURL]];
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
    AVAsset *asset = self.shortVideoRecorder.assetRepresentingAllFiles;
    [self playEvent:asset];
}

// 取消录制
- (void)discardRecord {
    [self.shortVideoRecorder cancelRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 导入视频
- (void)importMovieButtonEvent:(id)sender {
    PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
    photoAlbumViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoAlbumViewController animated:YES completion:nil];
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

#pragma mark -- PLSRateButtonViewDelegate
- (void)rateButtonView:(PLSRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex{
    self.titleIndex = titleIndex;
    switch (titleIndex) {
        case 0:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateTopSlow;
            break;
        case 1:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateSlow;
            break;
        case 2:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateNormal;
            break;
        case 3:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateFast;
            break;
        case 4:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateTopFast;
            break;
        default:
            break;
    }
}

#pragma mark - PLSViewRecorderManagerDelegate
- (void)viewRecorderManager:(PLSViewRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration {
    self.isViewRecord = NO;
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:totalDuration];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

#pragma mark - PLScreenRecorderManagerDelegate
- (void)screenRecorderManager:(PLScreenRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration {
    self.isViewRecord = NO;
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:totalDuration];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

- (void)screenRecorderManager:(PLScreenRecorderManager *)manager errorOccur:(NSError *)error {
    NSString *message = [NSString stringWithFormat:@"%@", error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    self.isViewRecord = NO;
}

#pragma mark -- PLShortVideoRecorderDelegate 摄像头／麦克风鉴权的回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to camera");
    }
}

- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to microphone");
    }
}

#pragma mark - PLShortVideoRecorderDelegate 摄像头对焦位置的回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFocusAtPoint:(CGPoint)point {
    NSLog(@"shortVideoRecorder: didFocusAtPoint: %@", NSStringFromCGPoint(point));
}

#pragma mark - PLShortVideoRecorderDelegate 摄像头采集的视频数据的回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)shortVideoRecorder:(PLShortVideoRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer timingInfo:(CMSampleTimingInfo)timingInfo {
    //此处可以做美颜/滤镜等处理
    // 是否在录制时使用滤镜，默认是关闭的，NO
    if (self.isUseFilterWhenRecording) {
        // 进行滤镜处理
        if (self.isPanning) {
            // 正在滤镜切换过程中，使用 processPixelBuffer:leftPercent:leftFilter:rightFilter 做滤镜切换动画
            pixelBuffer = [self.filterGroup processPixelBuffer:pixelBuffer leftPercent:self.leftPercent leftFilter:self.leftFilter rightFilter:self.rightFilter];
        } else {
            // 正常滤镜处理
            pixelBuffer = [self.filterGroup.currentFilter process:pixelBuffer];
        }
    }
    
    return pixelBuffer;
}

- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
}

#pragma mark -- PLShortVideoRecorderDelegate 视频录制回调

// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);

    [self.progressBar addProgressView];
    [_progressBar startShining];
}

// 正在录制的过程中
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [_progressBar setLastProgressToWidth:fileDuration / self.shortVideoRecorder.maxDuration * _progressBar.frame.size.width];
    
    self.endButton.enabled = (totalDuration >= self.shortVideoRecorder.minDuration);
    
    self.squareRecordButton.hidden = YES; // 录制过程中不允许切换分辨率（1:1 <--> 全屏）
    self.deleteButton.hidden = YES;
    self.endButton.hidden = YES;
    self.importMovieView.hidden = YES;
    self.musicButton.hidden = YES;
    self.filePathButton.hidden = YES;
    self.frameRateButton.hidden = YES;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 删除了某一段视频
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"delete fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);

    self.endButton.enabled = totalDuration >= self.shortVideoRecorder.minDuration;

    if (totalDuration <= 0.0000001f) {
        self.squareRecordButton.hidden = NO;
        self.deleteButton.hidden = YES;
        self.endButton.hidden = YES;
        self.importMovieView.hidden = NO;
        self.musicButton.hidden = NO;
        self.filePathButton.hidden = NO;
        self.frameRateButton.hidden = NO;
    }
    
    AVAsset *asset = [AVAsset assetWithURL:_URL];
    CGFloat duration = CMTimeGetSeconds(asset.duration);
    self.draftButton.hidden = (totalDuration +  duration) >= self.shortVideoRecorder.maxDuration;

    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    [_progressBar stopShining];

    self.deleteButton.hidden = NO;
    self.endButton.hidden = NO;

    AVAsset *asset = [AVAsset assetWithURL:_URL];
    CGFloat duration = CMTimeGetSeconds(asset.duration);
    self.draftButton.hidden = (totalDuration +  duration) >= self.shortVideoRecorder.maxDuration;
    
    if (totalDuration >= self.shortVideoRecorder.maxDuration) {
        [self endButtonEvent:nil];
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);

    AVAsset *asset = self.shortVideoRecorder.assetRepresentingAllFiles;
    [self playEvent:asset];
    self.isViewRecord = NO;
}

#pragma mark -- 下一步
- (void)playEvent:(AVAsset *)asset {
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [self.shortVideoRecorder getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);

    __block AVAsset *movieAsset = asset;
    if (self.musicButton.selected) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self loadActivityIndicatorView];
        // MusicVolume：1.0，videoVolume:0.0 即完全丢弃掉拍摄时的所有声音，只保留背景音乐的声音
        [self.shortVideoRecorder mixWithMusicVolume:1.0 videoVolume:0.0 completionHandler:^(AVMutableComposition * _Nullable composition, AVAudioMix * _Nullable audioMix, NSError * _Nullable error) {
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
            NSURL *outputPath = [self exportAudioMixPath];
            exporter.outputURL = outputPath;
            exporter.outputFileType = AVFileTypeMPEG4;
            exporter.shouldOptimizeForNetworkUse= YES;
            exporter.audioMix = audioMix;
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                switch ([exporter status]) {
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"audio mix failed：%@", [[exporter error] description]);
                        AlertViewShow([[exporter error] description]);
                    } break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"audio mix canceled");
                    } break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"audio mix success");
                        movieAsset = [AVAsset assetWithURL:outputPath];
                    } break;
                    default: {
                        
                    } break;
                }
                dispatch_semaphore_signal(semaphore);
            }];
        }];
        [self removeActivityIndicatorView];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.shortVideoRecorder getTotalDuration]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- dealloc
- (void)dealloc {
    // 移除前后台监听的通知
    [self removeObserverEvent];

    self.shortVideoRecorder.delegate = nil;
    self.shortVideoRecorder = nil;
    
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
        
        _editVideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT, PLS_SCREEN_WIDTH, layout.itemSize.height) collectionViewLayout:layout];
        _editVideoCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
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
    NSArray *array = @[];
    NSDictionary *dic = self.filtersArray[indexPath.row];
    [self.filterButton setTitle:[NSString stringWithFormat:@"滤镜: %@", dic[@"name"]] forState:UIControlStateNormal];
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
            
            /*!
             手势开始的时候，根据手势的滑动方向，确定切换到下一个滤镜的索引值
             */
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
            
            /*!
             手势变化的过程中，根据滑动的距离来确定两个滤镜所占的百分比
             */
        case UIGestureRecognizerStateChanged: {
            if (self.isLeftToRight) {
                if (transPoint.x <= 0) {
                    transPoint.x = 0;
                }
                self.leftPercent = transPoint.x / gestureRecognizer.view.bounds.size.width;
                self.isNeedChangeFilter = (self.leftPercent >= 0.5) || (speed.x > 500 );
            } else {
                if (transPoint.x >= 0) {
                    transPoint.x = 0;
                }
                self.leftPercent = 1 - fabs(transPoint.x) / gestureRecognizer.view.bounds.size.width;
                self.isNeedChangeFilter = (self.leftPercent <= 0.5) || (speed.x < -500);
            }
            break;
        }
            
            /*!
             手势结束的时候，根据滑动距离，判断是否切换到下一个滤镜，并且做一下切换的动画
             */
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            gestureRecognizer.enabled = NO;
            
            // 做一个滤镜过渡动画，优化用户体验
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0.005 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                if (!self.isPanning) return;
                
                float delta = 0.03;
                if (self.isNeedChangeFilter) {
                    // apply filter change
                    if (self.isLeftToRight) {
                        self.leftPercent = MIN(1, self.leftPercent + delta);
                    } else {
                        self.leftPercent = MAX(0, self.leftPercent - delta);
                    }
                } else {
                    // cancel filter change
                    if (self.isLeftToRight) {
                        self.leftPercent = MAX(0, self.leftPercent - delta);
                    } else {
                        self.leftPercent = MIN(1, self.leftPercent + delta);
                    }
                }
                
                if (self.leftPercent < FLT_EPSILON || fabs(1.0 - self.leftPercent) < FLT_EPSILON) {
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
                }
            });
            dispatch_resume(timer);
            break;
        }
            
        case UIGestureRecognizerStatePossible: {
            NSLog(@"UIGestureRecognizerStatePossible");
        } break;
            
        default:
            break;
    }
}

#pragma mark - 较高质量下，不同分辨率对应的码率值取值
- (NSInteger)suitableVideoBitrateWithSize:(CGSize)videoSize {
    
    // 下面的码率设置均偏大，为了拍摄出来的视频更清晰，选择了偏大的码率，不过均比系统相机拍摄出来的视频码率小很多
    if (videoSize.width + videoSize.height > 720 + 1280) {
        return 8 * 1000 * 1000;
    } else if (videoSize.width + videoSize.height > 544 + 960) {
        return 4 * 1000 * 1000;
    } else if (videoSize.width + videoSize.height > 360 + 640) {
        return 2 * 1000 * 1000;
    } else {
        return 1 * 1000 * 1000;
    }
}

#pragma mark - addObserverEvent
- (void)addObserverEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - removeObserverEvent
- (void)removeObserverEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(id)sender {
    NSLog(@"%s, %d, applicationDidEnterBackground:", __func__, __LINE__);
    [self.shortVideoRecorder stopRecording];
}

- (void)applicationDidBecomeActive:(id)sender {
    NSLog(@"%s, %d, applicationDidBecomeActive:", __func__, __LINE__);
}

- (void)checkActiveFormat {
    
    CGSize needCaptureSize = self.videoConfiguration.videoSize;
    
    if (AVCaptureVideoOrientationPortrait == self.videoConfiguration.videoOrientation ||
        AVCaptureVideoOrientationPortraitUpsideDown == self.videoConfiguration.videoOrientation) {
        needCaptureSize = CGSizeMake(self.videoConfiguration.videoSize.height, self.videoConfiguration.videoSize.width);
    }
    
    AVCaptureDeviceFormat *activeFormat = self.shortVideoRecorder.videoActiveFormat;
    AVFrameRateRange *frameRateRange = [activeFormat.videoSupportedFrameRateRanges firstObject];
    
    CMVideoDimensions captureSize = CMVideoFormatDescriptionGetDimensions(activeFormat.formatDescription);
    if (frameRateRange.maxFrameRate < self.videoConfiguration.videoFrameRate ||
        frameRateRange.minFrameRate > self.videoConfiguration.videoFrameRate ||
        needCaptureSize.width > captureSize.width ||
        needCaptureSize.height > captureSize.height) {
        
        NSArray *videoFormats = self.shortVideoRecorder.videoFormats;
        for (AVCaptureDeviceFormat *format in videoFormats) {
            frameRateRange = [format.videoSupportedFrameRateRanges firstObject];
            captureSize = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
            
            if (frameRateRange.maxFrameRate >= self.videoConfiguration.videoFrameRate &&
                frameRateRange.minFrameRate <= self.videoConfiguration.videoFrameRate &&
                captureSize.width >= needCaptureSize.width &&
                captureSize.height >= needCaptureSize.height) {
                NSLog(@"size = {%d x %d}, fps = %f ~ %f", captureSize.width, captureSize.height, frameRateRange.minFrameRate, frameRateRange.maxFrameRate);
                self.shortVideoRecorder.videoActiveFormat = format;
                break;
            }
        }
    }
}
@end

