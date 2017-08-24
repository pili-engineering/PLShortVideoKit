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
#import "KWSDK.h"
#import "Global.h"
#import "KWSmiliesStickerRenderer.h"

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
PLSViewRecorderManagerDelegate
>

@property (strong, nonatomic) PLShortVideoRecorder *shortVideoRecorder;
@property (strong, nonatomic) PLSViewRecorderManager *viewRecorderManager;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *viewRecordButton;
@property (strong, nonatomic) PLSDeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *endButton;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *recordToolboxView;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) UIButton *squareRecordButton;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) UIView *importMovieView;
@property (strong, nonatomic) UIButton *importMovieButton;

// 录制时是否使用滤镜
@property (assign, nonatomic) BOOL isUseFilterWhenRecording;

// 所有滤镜
@property (strong, nonatomic) PLSFilterGroup *filterGroup;
// 展示所有滤镜的集合视图
@property (strong, nonatomic) UICollectionView *editVideoCollectionView;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersArray;
@property (assign, nonatomic) NSInteger filterIndex;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    // --------------------------
    // 短视频录制核心类设置
    [self setupShortVideoRecorder];
    
    // --------------------------
    [self setupBaseToolboxView];
    [self setupRecordToolboxView];
    
    // --------------------------
    // Kiwi 人脸识别
    self.kwSdkUI = [KWSDK_UI shareManagerUI];
    self.kwSdkUI.kwSdk = [KWSDK sharedManager];
    self.kwSdkUI.kwSdk.renderer = [[KWRenderer alloc]initWithModelPath:self.modelPath];
    
    if([KWRenderer isSdkInitFailed]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"使用 license 文件生成激活码时失败，可能是授权文件过期。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
        return;
    }
    
    [self.kwSdkUI.kwSdk initSdk];
    [self.kwSdkUI setViewDelegate:self];
    self.kwSdkUI.isClearOldUI = NO;
    [self.kwSdkUI initSDKUI];
    self.kwSdkUI.kwSdk.cameraPositionBack = NO;
    [self.kwSdkUI setOffPhoneBtnHidden:YES];
    [self.kwSdkUI setToggleBtnHidden:YES];
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
    
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    videoConfiguration.position = AVCaptureDevicePositionFront;
    videoConfiguration.videoFrameRate = 25;
    videoConfiguration.averageVideoBitRate = 1024*1000;
    videoConfiguration.videoSize = CGSizeMake(480, 854);
    videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;

    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    
    self.shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    self.shortVideoRecorder.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    [self.view addSubview:self.shortVideoRecorder.previewView];
    
    self.shortVideoRecorder.delegate = self;
    
    self.shortVideoRecorder.maxDuration = 30.0f; // 设置最长录制时长
    
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
            NSLog(@"deviceOrientation : %ld", (long)deviceOrientation);
            
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
        self.editVideoCollectionView.frame = CGRectMake(0, 260, frame.size.width, frame.size.height);
        [self.view addSubview:self.editVideoCollectionView];
        [self.editVideoCollectionView reloadData];
    }
}

- (void)setupBaseToolboxView {
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 10, 35, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_cancel_a"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_cancel_b"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 录屏按钮
    self.viewRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewRecordButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 265, 10, 35, 35);
    [self.viewRecordButton setTitle:@"录屏" forState:UIControlStateNormal];
    [self.viewRecordButton setTitle:@"完成" forState:UIControlStateSelected];
    self.viewRecordButton.selected = NO;
    [self.viewRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.viewRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.viewRecordButton addTarget:self action:@selector(viewRecorderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.viewRecordButton];
    
    // 全屏／正方形录制模式
    self.squareRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.squareRecordButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 210, 10, 35, 35);
    [self.squareRecordButton setTitle:@"1:1" forState:UIControlStateNormal];
    [self.squareRecordButton setTitle:@"全屏" forState:UIControlStateSelected];
    self.squareRecordButton.selected = NO;
    [self.squareRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.squareRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.squareRecordButton addTarget:self action:@selector(squareRecordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.squareRecordButton];
    
    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 155, 10, 35, 35);
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_close"] forState:UIControlStateNormal];
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_open"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:flashButton];
    
    // 美颜
    UIButton *beautyFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautyFaceButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 100, 12, 30, 30);
    [beautyFaceButton setTitle:@"美颜" forState:UIControlStateNormal];
    [beautyFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    beautyFaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [beautyFaceButton addTarget:self action:@selector(beautyFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:beautyFaceButton];
    
    // 切换摄像头
    UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleCameraButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 45, 10, 35, 35);
    [toggleCameraButton setBackgroundImage:[UIImage imageNamed:@"toggle_camera"] forState:UIControlStateNormal];
    [toggleCameraButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:toggleCameraButton];
}

- (void)setupRecordToolboxView {
    CGFloat y = self.baseToolboxView.frame.origin.y + self.baseToolboxView.frame.size.height + PLS_SCREEN_WIDTH;
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
    self.durationLabel.text = @"0.00s";
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
            CGSize size = self.importMovieButton.frame.size;
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
        
        PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
        videoConfiguration.videoSize = CGSizeMake(480, 480);
        [self.shortVideoRecorder reloadvideoConfiguration:videoConfiguration];
        
        self.shortVideoRecorder.maxDuration = 10.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shortVideoRecorder.previewView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
            self.progressBar.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, 10);
            
        });
        
    } else {
        PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
        videoConfiguration.videoSize = CGSizeMake(480, 854);
        [self.shortVideoRecorder reloadvideoConfiguration:videoConfiguration];
        
        self.shortVideoRecorder.maxDuration = 60.0f;
        
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
        [self.shortVideoRecorder startRecording];
    }
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

#pragma mark -- 鉴权回调
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

#pragma mark - 视频数据回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)shortVideoRecorder:(PLShortVideoRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    
    // 是否在录制时使用滤镜，默认是关闭的，NO
    if (self.isUseFilterWhenRecording) {
        PLSFilter *filter = self.filterGroup.currentFilter;
        pixelBuffer = [filter process:pixelBuffer];
    }
    
    
    /* 横竖屏时更新sdk内置UI 坐标 */
    [_kwSdkUI resetScreemMode];
    
    
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
    //    BOOL mirrored = !self.kwSdkUI.kwSdk.cameraPositionBack;
    BOOL mirrored = NO;
    
    cv_rotate_type cvMobileRotate;
    
    switch (iDeviceOrientation) {
        case UIDeviceOrientationPortrait:
            cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            cvMobileRotate = mirrored ?  CV_CLOCKWISE_ROTATE_90: CV_CLOCKWISE_ROTATE_270;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_270 : CV_CLOCKWISE_ROTATE_90;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            cvMobileRotate = CV_CLOCKWISE_ROTATE_180;
            break;
            
        default:
            cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
            break;
    }
    
    /*********** 获得人脸捕捉数据 可供开发者在人脸捕捉之后 视频帧渲染之前 自定义执行的block ***********/
    //    self.kwSdkUI.kwSdk.renderer.kwRenderBlock = ^(unsigned char *pixels, int format, int width, int height, result_68_t *p_result, int rstNum, int orientation,int faceMaxNum)
    //    {
    //        //        NSLog(@"format:%d,width:%d,height:%d,restNum:%d,orientation:%d,faceMaxNum:%d",format,width,height,rstNum,orientation,faceMaxNum);
    //
    //        NSMutableArray *faces = nil;
    //        if (faceMaxNum > 0) {
    //
    //            // 检测结果
    //            faces = [NSMutableArray arrayWithCapacity:faceMaxNum];
    //            for (int i = 0; i < faceMaxNum; i++) {
    //                //                NSMutableArray *points = [NSMutableArray arrayWithCapacity:68];
    //                for (int j = 0; j < 68; j++) {
    //                    //                    cv_pointf_t p = p_result[i].points_array[j];
    //                    //保存人脸坐标点 展示
    //                    //                    [points addObject:[NSValue valueWithCGPoint:CGPointMake(p.x, p.y)]];
    //                }
    //                //保存人脸坐标集合 展示
    //                //                [faces addObject:points];
    //            }
    //        }
    //    };
    __weak typeof (self) __weakSelf = self;
    self.kwSdkUI.kwSdk.renderer.kwRenderBlock = ^(unsigned char *pixels, int format, int width, int height,result_68_t *p_result, int rstNum, int orientation,int faceNum){
        
        BOOL mouth_open = NO;
        
        for (int i = 0; i < rstNum; i++) {
            mouth_open = p_result[i].mouth_open;
            if (mouth_open) {
                break;
            }
        }
        
        if (mouth_open && ![__weakSelf.kwSdkUI.kwSdk.renderer checkSmiliesSticker:(GPUImageFilter *)__weakSelf.kwSdkUI.kwSdk.filters[3]] && __weakSelf.kwSdkUI.kwSdk.renderer.isEnableSmiliesSticker) {
            [((KWSmiliesStickerRenderer *)__weakSelf.kwSdkUI.kwSdk.filters[3]).sticker setPlayCount:1];
            ((KWSmiliesStickerRenderer *)__weakSelf.kwSdkUI.kwSdk.filters[3]).isAutomaticallyPlay = YES;
            [((KWSmiliesStickerRenderer *)__weakSelf.kwSdkUI.kwSdk.filters[3]) setSticker:__weakSelf.kwSdkUI.kwSdk.presentStickers[0]];
            
            KWSticker *lastSticker = __weakSelf.kwSdkUI.kwSdk.presentStickers[0];
            //设置播放次数
            [lastSticker setPlayCount:1];
            //贴纸帧数置零 将贴纸重新播放
            for (KWStickerItem *item in lastSticker.items) {
                item.currentFrameIndex = 0;
                item.accumulator = 0;
            }
            //礼物贴纸 默认设置为跟脸 渲染
            ((KWSmiliesStickerRenderer *)__weakSelf.kwSdkUI.kwSdk.filters[3]).needTrackData = YES;
            
            [__weakSelf.kwSdkUI.kwSdk.renderer addFilter:__weakSelf.kwSdkUI.kwSdk.filters[3]];
            
        }
    };
    
    /*********** 视频帧渲染 ***********/
    [self.kwSdkUI.kwSdk.renderer processPixelBuffer:pixelBuffer withRotation:cvMobileRotate mirrored:NO];
    
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
    }

    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    [_progressBar stopShining];

    self.deleteButton.hidden = NO;
    self.endButton.hidden = NO;

    
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
    
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.shortVideoRecorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;

    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
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
    NSLog(@"dealloc: %@", [[self class] description]);

    self.shortVideoRecorder.delegate = nil;
    self.shortVideoRecorder = nil;
    
    self.alertView = nil;
    
    self.filtersArray = nil;
    // 离开页面的时候释放内存
    [KWSDK releaseManager];
    [KWSDK_UI releaseManager];
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

@end

