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

#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

#define PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG 10001
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface RecordViewController ()
<
PLShortVideoRecorderDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
PLSViewRecorderManagerDelegate,
PLSRateButtonViewDelegate
>

@property (strong, nonatomic) PLSVideoConfiguration *videoConfiguration;
@property (strong, nonatomic) PLSAudioConfiguration *audioConfiguration;
@property (strong, nonatomic) PLShortVideoRecorder *shortVideoRecorder;
@property (strong, nonatomic) PLSViewRecorderManager *viewRecorderManager;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *viewRecordButton;
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
@property (assign, nonatomic) NSInteger filterIndex;

@property (strong, nonatomic) UIButton *draftButton;
@property (strong, nonatomic) NSURL *URL;

@property (strong, nonatomic) UIButton *musicButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIButton *monitorButton;
// 实时截图按钮
@property (strong, nonatomic) UIButton *snapshotButton;

// 录制前是否开启自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
@property (assign, nonatomic) BOOL isUseAutoCheckDeviceOrientationBeforeRecording;

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
    
    [self.shortVideoRecorder startCaptureSession];
    
    [self getFirstMovieFromPhotoAlbum];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shortVideoRecorder stopCaptureSession];
}

// 短视频录制核心类设置
- (void)setupShortVideoRecorder {
    // SDK 的版本信息
    NSLog(@"PLShortVideoRecorder versionInfo: %@", [PLShortVideoRecorder versionInfo]);
    
    self.videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    self.videoConfiguration.position = AVCaptureDevicePositionFront;
    self.videoConfiguration.videoFrameRate = 25;
    self.videoConfiguration.averageVideoBitRate = 1024*1000;
    self.videoConfiguration.videoSize = CGSizeMake(544, 960);
    self.videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;

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
        UIView *deviceOrientationView = [[UIView alloc] init];
        deviceOrientationView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH/2, 44);
        deviceOrientationView.center = CGPointMake(PLS_SCREEN_WIDTH/2, 44/2);
        deviceOrientationView.backgroundColor = [UIColor grayColor];
        deviceOrientationView.alpha = 0.7;
        [self.view addSubview:deviceOrientationView];
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
            
            if (deviceOrientation == PLSPreviewOrientationPortrait) {
                deviceOrientationView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH/2, 44);
                deviceOrientationView.center = CGPointMake(PLS_SCREEN_WIDTH/2, 44/2);
                
            } else if (deviceOrientation == PLSPreviewOrientationPortraitUpsideDown) {
                deviceOrientationView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH/2, 44);
                deviceOrientationView.center = CGPointMake(PLS_SCREEN_WIDTH/2, PLS_SCREEN_HEIGHT - 44/2);
                
            } else if (deviceOrientation == PLSPreviewOrientationLandscapeRight) {
                deviceOrientationView.frame = CGRectMake(0, 0, 44, PLS_SCREEN_HEIGHT/2);
                deviceOrientationView.center = CGPointMake(PLS_SCREEN_WIDTH - 44/2, PLS_SCREEN_HEIGHT/2);
                
            } else if (deviceOrientation == PLSPreviewOrientationLandscapeLeft) {
                deviceOrientationView.frame = CGRectMake(0, 0, 44, PLS_SCREEN_HEIGHT/2);
                deviceOrientationView.center = CGPointMake(44/2, PLS_SCREEN_HEIGHT/2);
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
    
    // 录屏按钮
    self.viewRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewRecordButton.frame = CGRectMake(10, 100, 35, 35);
    [self.viewRecordButton setTitle:@"录屏" forState:UIControlStateNormal];
    [self.viewRecordButton setTitle:@"完成" forState:UIControlStateSelected];
    self.viewRecordButton.selected = NO;
    [self.viewRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.viewRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.viewRecordButton addTarget:self action:@selector(viewRecorderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.viewRecordButton];
    
    // 全屏／正方形录制模式
    self.squareRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.squareRecordButton.frame = CGRectMake(10, 145, 35, 35);
    [self.squareRecordButton setTitle:@"1:1" forState:UIControlStateNormal];
    [self.squareRecordButton setTitle:@"全屏" forState:UIControlStateSelected];
    self.squareRecordButton.selected = NO;
    [self.squareRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.squareRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.squareRecordButton addTarget:self action:@selector(squareRecordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.squareRecordButton];
    
    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake(10, 190, 35, 35);
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_close"] forState:UIControlStateNormal];
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_open"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:flashButton];
    
    // 美颜
    UIButton *beautyFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautyFaceButton.frame = CGRectMake(10, 235, 30, 30);
    [beautyFaceButton setTitle:@"美颜" forState:UIControlStateNormal];
    [beautyFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    beautyFaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [beautyFaceButton addTarget:self action:@selector(beautyFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:beautyFaceButton];
    beautyFaceButton.selected = YES;
    
    // 切换摄像头
    UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleCameraButton.frame = CGRectMake(10, 280, 35, 35);
    [toggleCameraButton setBackgroundImage:[UIImage imageNamed:@"toggle_camera"] forState:UIControlStateNormal];
    [toggleCameraButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:toggleCameraButton];
    
    // 录制的视频文件的存储路径设置
    self.filePathButton = [[UIButton alloc] init];
    self.filePathButton.frame = CGRectMake(10, 325, 35, 35);
    [self.filePathButton setImage:[UIImage imageNamed:@"file_path"] forState:UIControlStateNormal];
    [self.filePathButton addTarget:self action:@selector(filePathButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.filePathButton];
    
    self.filePathButton.selected = NO;
    self.useSDKInternalPath = YES;
    
    // 拍照
    self.snapshotButton = [[UIButton alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 60, 10, 46, 46)];
    self.snapshotButton.layer.cornerRadius = 23;
    self.snapshotButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    [self.snapshotButton setImage:[UIImage imageNamed:@"icon_trim"] forState:UIControlStateNormal];
    self.snapshotButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self.snapshotButton addTarget:self action:@selector(snapshotButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_snapshotButton];
    
    // 加载草稿视频
    self.draftButton = [[UIButton alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 60, 70, 46, 46)];
    self.draftButton.layer.cornerRadius = 23;
    self.draftButton.backgroundColor = [UIColor colorWithRed:116/255 green:116/255 blue:116/255 alpha:0.55];
    [self.draftButton setImage:[UIImage imageNamed:@"draft_video"] forState:UIControlStateNormal];
    self.draftButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self.draftButton addTarget:self action:@selector(draftVideoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_draftButton];
    
    // 是否使用背景音乐
    self.musicButton = [[UIButton alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 60, 130, 46, 46)];
    self.musicButton.layer.cornerRadius = 23;
    self.musicButton.backgroundColor = [UIColor colorWithRed:116/255 green:116/255 blue:116/255 alpha:0.55];
    [self.musicButton setImage:[UIImage imageNamed:@"music_no_selected"] forState:UIControlStateNormal];
    [self.musicButton setImage:[UIImage imageNamed:@"music_selected"] forState:UIControlStateSelected];
    self.musicButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self.musicButton addTarget:self action:@selector(musicButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_musicButton];
    
    //是否开启 SDK 退到后台监听
    self.monitorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.monitorButton setTitle:@"监听已关闭" forState:UIControlStateNormal];
    [self.monitorButton setTitle:@"监听已打开" forState:UIControlStateSelected];
    self.monitorButton.selected = NO;
    [self.monitorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.monitorButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.monitorButton sizeToFit];
    self.monitorButton.frame = CGRectMake(PLS_SCREEN_WIDTH - self.monitorButton.bounds.size.width, 190, self.monitorButton.bounds.size.width, self.monitorButton.bounds.size.height);
    [self.monitorButton addTarget:self action:@selector(monitorButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.monitorButton];

    
    
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupRecordToolboxView {
    CGFloat y = PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH;
    self.recordToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT- y)];
    self.recordToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordToolboxView];

    
    // 倍数拍摄
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
                    
                    [self.importMovieButton setBackgroundImage:result forState:UIControlStateNormal];
                    
                } else {
                    // Do something with the regraded image
                    
                }
            }];
        }
    });
}

// 返回上一层
- (void)backButtonEvent:(id)sender {
    if (self.viewRecordButton.isSelected) {
        [self.viewRecorderManager cancelRecording];
    }
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
        self.videoConfiguration.videoSize = CGSizeMake(480, 480);
        [self.shortVideoRecorder reloadvideoConfiguration:self.videoConfiguration];
        
        self.shortVideoRecorder.maxDuration = 10.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shortVideoRecorder.previewView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
            self.progressBar.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, 10);
            
        });
        
    } else {
        self.videoConfiguration.videoSize = CGSizeMake(544, 960);
        [self.shortVideoRecorder reloadvideoConfiguration:self.videoConfiguration];
        
        self.shortVideoRecorder.maxDuration = 10.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shortVideoRecorder.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
            self.progressBar.frame = CGRectMake(0, CGRectGetHeight(self.recordToolboxView.frame) - 10, PLS_SCREEN_WIDTH, 10);
        });
    }
}

//录制 self.view
- (void)viewRecorderButtonClick:(id)sender {
    if (!self.viewRecorderManager) {
        self.viewRecorderManager = [[PLSViewRecorderManager alloc] initWithRecordedView:self.view];
        self.viewRecorderManager.delegate = self;
    }
    
    if (self.viewRecordButton.isSelected) {
        self.viewRecordButton.selected = NO;
        [self.viewRecorderManager stopRecording];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    }
    else {
        self.viewRecordButton.selected = YES;
        [self.viewRecorderManager startRecording];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
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
- (void)toggleCameraButtonEvent:(id)sender {
    [self.shortVideoRecorder toggleCamera];
}

// 七牛滤镜
- (void)filterButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    self.editVideoCollectionView.hidden = !button.selected;
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
    [self.viewRecorderManager cancelRecording];
    self.viewRecordButton.selected = NO;
}

// 取消录制
- (void)discardRecord {
    [self.shortVideoRecorder cancelRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 导入视频
- (void)importMovieButtonEvent:(id)sender {
    PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
    [self presentViewController:photoAlbumViewController animated:YES completion:nil];
}

#pragma mark - Notification
- (void)applicationWillResignActive:(NSNotification *)notification {
    if (self.viewRecordButton.selected) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
        self.viewRecordButton.selected = NO;        
        [self.viewRecorderManager cancelRecording];
    }
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
    self.viewRecordButton.selected = NO;
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
    [self presentViewController:videoEditViewController animated:YES completion:nil];
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
- (CVPixelBufferRef)shortVideoRecorder:(PLShortVideoRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    // 是否在录制时使用滤镜，默认是关闭的，NO
    if (self.isUseFilterWhenRecording) {
        PLSFilter *filter = self.filterGroup.currentFilter;
        pixelBuffer = [filter process:pixelBuffer];
    }
    
    return pixelBuffer;
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
    [self.viewRecorderManager cancelRecording];
    self.viewRecordButton.selected = NO;
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
    UISwipeGestureRecognizer *recognizer;
    // 添加右滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    // 添加左滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    // 添加上滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:recognizer];
    // 添加下滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:recognizer];
}

// 添加手势的响应事件
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        self.filterIndex++;
        self.filterIndex %= self.filterGroup.filtersInfo.count;
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        self.filterIndex--;
        if (self.filterIndex < 0) {
            self.filterIndex = self.filterGroup.filtersInfo.count - 1;
        }
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        self.filterIndex--;
        if (self.filterIndex < 0) {
            self.filterIndex = self.filterGroup.filtersInfo.count - 1;
        }
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        self.filterIndex++;
        self.filterIndex %= self.filterGroup.filtersInfo.count;
    }
    
    // 滤镜
    self.filterGroup.filterIndex = self.filterIndex;
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

@end

