//
//  EditViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/4/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "EditViewController.h"
#import "GifFormatViewController.h"
#import "DubViewController.h"
#import "PlayViewController.h"
#import "PLSEditVideoCell.h"
#import "PLSAudioVolumeView.h"
#import "PLSClipAudioView.h"
#import "PLSFilterGroup.h"
#import "PLSRateButtonView.h"
#import "PLSColumnListView.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PLSTimelineView.h"
#import "PLSStickerOverlayView.h"
#import "PLSStickerView.h"
#import "PLSStickerBar.h"
#import "PLSClipMovieView.h"
#import <Masonry/Masonry.h>
#import "PLSTimeLineAudioItem.h"

#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_RGBCOLOR_ALPHA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_EditToolboxView_HEIGHT 50

@interface EditViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
PLSAudioVolumeViewDelegate,
PLSClipAudioViewDelegate,
PLSRateButtonViewDelegate,
DubViewControllerDelegate,
PLShortVideoEditorDelegate,
PLSAVAssetExportSessionDelegate,
PLSTimelineViewDelegate,
PLSStickerBarDelegate,
PLSStickerViewDelegate,
UIGestureRecognizerDelegate,
PLSClipMovieViewDelegate
>

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *editDisplayView;
@property (strong, nonatomic) UIView *editToolboxView;

// 水印
@property (strong, nonatomic) NSURL *watermarkURL;
@property (assign, nonatomic) CGSize watermarkSize;
@property (assign, nonatomic) CGPoint watermarkPosition;

// 视频的分辨率，设置之后影响编辑时的预览分辨率、导出的视频的的分辨率
@property (assign, nonatomic) CGSize videoSize;

// 编辑
@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;
// 编辑信息, movieSettings, watermarkSettings, stickerSettingsArray, audioSettingsArray 为 outputSettings 的字典元素
@property (strong, nonatomic) NSMutableDictionary *outputSettings;
// 视频文件信息
@property (strong, nonatomic) NSMutableDictionary *movieSettings;
// 多音频文件作为背景音乐
@property (strong, nonatomic) NSMutableArray *audioSettingsArray;
// 单一背景音乐的信息，最终要将其添加（addObject）到数组 audioSettingsArray 内
@property (strong, nonatomic) NSMutableDictionary *backgroundAudioSettings;
// 背景音乐是否循环播放
@property (assign, nonatomic) BOOL backgroundAudioLoopEnable;
// 水印
@property (strong, nonatomic) NSMutableDictionary *watermarkSettings;
@property (strong, nonatomic) UIImage *watermarkImage;
// 贴纸信息
@property (strong, nonatomic) NSMutableArray *stickerSettingsArray;

// 剪视频
@property (strong, nonatomic) PLSClipMovieView *clipMovieView;

// 选取要编辑的功能点
@property (assign, nonatomic) NSInteger selectionViewIndex;
// 展示所有滤镜、音乐、MV列表的集合视图
@property (strong, nonatomic) UICollectionView *editCollectionView;
// 当前被选择的 cell 对应的 NSIndexPath
@property (strong, nonatomic) NSIndexPath *currentSelectedIndexPath;
@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;
// 所有滤镜
@property (strong, nonatomic) PLSFilterGroup *filterGroup;
// 滤镜信息
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersArray;
@property (assign, nonatomic) NSInteger filterIndex;
@property (strong, nonatomic) NSString *colorImagePath;
// 多音效信息
@property (strong, nonatomic) NSMutableArray *multiMusicsArray;
@property (strong, nonatomic) PLSTimeLineAudioItem *processAudioItem;

// 音乐信息
@property (strong, nonatomic) NSMutableArray *musicsArray;
// MV信息
@property (strong, nonatomic) NSMutableArray *mvArray;
@property (strong, nonatomic) NSURL *colorURL;
@property (strong, nonatomic) NSURL *alphaURL;
// 视频倍速信息
@property (strong, nonatomic) NSMutableArray *videoSpeedArray;

// 时光倒流
@property (nonatomic, strong) PLSReverserEffect *reverser;
@property (nonatomic, strong) AVAsset *inputAsset;
@property (nonatomic, strong) UIButton *reverserButton;

// 视频合成的进度
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

// 倍数下标
@property (assign, nonatomic) NSInteger titleIndex;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableDictionary *originMovieSettings;
@property (assign, nonatomic) PLSVideoRecoderRateType currentRateType;

// 视频旋转
@property (assign, nonatomic) PLSPreviewOrientation videoLayerOrientation;

// 视频列表
@property (strong, nonatomic) PLSColumnListView *videoListView;

// 播放/暂停按钮，点击视频预览区域实现播放/暂停功能
@property (strong, nonatomic) UIButton *playButton;

///--------------------------------------------
// 时间线编辑视频组件
@property (strong, nonatomic) PLSTimelineView *timelineView;
@property (strong, nonatomic) PLSTimelineMediaInfo *mediaInfo;

// 所有 sticker 添加到该 view 上
@property (strong, nonatomic) PLSStickerOverlayView *stickerOverlayView;
// 当前选中的贴纸
@property (strong, nonatomic) PLSStickerView *currentStickerView;
// 添加tap手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
// 贴纸 gesture 交互相关
@property (assign, nonatomic) CGPoint loc_in;
@property (nonatomic, nonatomic) CGPoint ori_center;
@property (nonatomic, nonatomic) CGFloat curScale;

// 贴图工具
@property (strong, nonatomic) PLSStickerBar *stickerBar;
// 自定义贴图资源
@property (strong, nonatomic) NSString *stickerPath;
///--------------------------------------------

@end

@implementation EditViewController

// 检查视频文件中是否含有视频轨道
- (BOOL)checkMovieHasVideoTrack:(AVAsset *)asset {
    BOOL hasVideoTrack = YES;
    
    NSArray *videoAssetTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    if (videoAssetTracks.count > 0) {
        hasVideoTrack = YES;
    } else {
        hasVideoTrack = NO;
    }
    
    return hasVideoTrack;
}

// 获取视频／音频文件的总时长
- (CGFloat)getFileDuration:(NSURL*)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:opts];
    
    CMTime duration = asset.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    
    return durationSeconds;
}

//类型识别:将 NSNull类型转化成 nil
- (id)checkNSNullType:(id)object {
    if([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else {
        return object;
    }
}

// 获取视频第一帧
- (UIImage *) getVideoPreViewImage:(AVAsset *)asset {
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.maximumSize = CGSizeMake(150, 150);
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 用来演示如何获取视频的分辨率 videoSize
    NSDictionary *movieSettings = self.settings[PLSMovieSettingsKey];
    AVAsset *movieAsset = movieSettings[PLSAssetKey];
    if (!movieAsset) {
        NSURL *movieURL = movieSettings[PLSURLKey];
        movieAsset = [AVAsset assetWithURL:movieURL];
    }
    self.videoSize = movieAsset.pls_videoSize;
    
    [self setupShortVideoEditor];
    
    [self setupEditDisplayView];
    
    [self setupBaseToolboxView];
    
    [self setupTimelineView];
    
    [self setupEditToolboxView];
    
    [self setupMergeToolboxView];
}

- (CGFloat)bottomFixSpace {
    return iPhoneX ? 30 : 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self observerUIApplicationStatusForShortVideoEditor];
    
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObserverUIApplicationStatusForShortVideoEditor];
    
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;
}

#pragma mark - 编辑类
- (void)setupShortVideoEditor {
    // 编辑
    /* outputSettings 中的字典元素为 movieSettings, audioSettings, watermarkSettings */
    self.outputSettings = [[NSMutableDictionary alloc] init];
    self.movieSettings = [[NSMutableDictionary alloc] init];
    self.watermarkSettings = [[NSMutableDictionary alloc] init];
    self.stickerSettingsArray = [[NSMutableArray alloc] init];
    self.audioSettingsArray = [[NSMutableArray alloc] init];

    self.outputSettings[PLSMovieSettingsKey] = self.movieSettings;
    self.outputSettings[PLSWatermarkSettingsKey] = self.watermarkSettings;
    self.outputSettings[PLSStickerSettingsKey] = self.stickerSettingsArray;
    self.outputSettings[PLSAudioSettingsKey] = self.audioSettingsArray;
    
    // 原始视频
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
    // 备份原始视频的信息
    self.originMovieSettings = [[NSMutableDictionary alloc] init];
    [self.originMovieSettings addEntriesFromDictionary:self.movieSettings];
    self.currentRateType = PLSVideoRecoderRateNormal;
    
    // 背景音乐
    self.backgroundAudioSettings = [[NSMutableDictionary alloc] init];
    self.backgroundAudioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
    // 水印图片路径
    NSString *watermarkPath = [[NSBundle mainBundle] pathForResource:@"qiniu_logo" ofType:@".png"];
    self.watermarkImage = [UIImage imageWithContentsOfFile:watermarkPath];
    self.watermarkURL = [NSURL URLWithString:watermarkPath];
    self.watermarkSize = self.watermarkImage.size;
    self.watermarkPosition = CGPointMake(10, 65);
    // 水印
    self.watermarkSettings[PLSURLKey] = self.watermarkURL;
    self.watermarkSettings[PLSSizeKey] = [NSValue valueWithCGSize:self.watermarkSize];
    self.watermarkSettings[PLSPointKey] = [NSValue valueWithCGPoint:self.watermarkPosition];
    
    // 视频编辑类
    AVAsset *asset = self.movieSettings[PLSAssetKey];

    if (self.playerItem) {
        self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithPlayerItem:self.playerItem videoSize:CGSizeZero];
    } else {
        self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset videoSize:CGSizeZero];
    }
    
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    // 视频编辑时，添加水印
    [self.shortVideoEditor setWaterMarkWithImage:self.watermarkImage position:self.watermarkPosition];
    // 视频编辑时，改变预览分辨率
    self.shortVideoEditor.videoSize = self.videoSize;
    
    // 滤镜
    UIImage *coverImage = [self getVideoPreViewImage:self.movieSettings[PLSAssetKey]];
    self.filterGroup = [[PLSFilterGroup alloc] initWithImage:coverImage];
}

#pragma mark - 配置视图
- (void)setupBaseToolboxView {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);

    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
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
    if (iPhoneX) {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 48);
    } else {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    }
    titleLabel.text = @"编辑视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.baseToolboxView addSubview:titleLabel];
    
    // 下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"btn_bar_next_a"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"btn_bar_next_b"] forState:UIControlStateHighlighted];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:nextButton];
}

- (void)setupTimelineView {
    // 时间线视图
    self.timelineView = [[PLSTimelineView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH / 8)];
    self.timelineView.backgroundColor = [UIColor clearColor];
    self.timelineView.delegate = self;
    [self.view addSubview:self.timelineView];
    [self.timelineView updateTimelineViewAlpha:0.5];
    
    // 装载当前视频到 时间线视图里面
    self.mediaInfo = [[PLSTimelineMediaInfo alloc] init];
    self.mediaInfo.asset = self.movieSettings[PLSAssetKey];
    self.mediaInfo.duration = [self.movieSettings[PLSDurationKey] floatValue];
    
    [self.timelineView setMediaClips:@[self.mediaInfo] segment:8.0 photosPersegent:8.0];
}

- (void)setupEditDisplayView {
    self.editDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH / 8, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - PLS_BaseToolboxView_HEIGHT - PLS_SCREEN_WIDTH / 8 - PLS_EditToolboxView_HEIGHT - [self bottomFixSpace])];
    self.editDisplayView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.editDisplayView];
    
    self.shortVideoEditor.previewView.frame = self.editDisplayView.bounds;
    self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.editDisplayView addSubview:self.shortVideoEditor.previewView];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = self.shortVideoEditor.previewView.frame;
    self.playButton.center = self.shortVideoEditor.previewView.center;
    [self.playButton setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateSelected];
    [self.editDisplayView addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 视频分辨率
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    
    CGSize vSize = asset.pls_videoSize;

    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat displayViewWidth = self.editDisplayView.frame.size.width;
    CGFloat displayViewHeight = self.editDisplayView.frame.size.height;
    
    CGFloat width = displayViewWidth;
    CGFloat height = displayViewHeight;
    
    if (vSize.width / vSize.height < displayViewWidth / displayViewHeight) {
        width = vSize.width / vSize.height * displayViewHeight;
        x = (displayViewWidth - width) * 0.5;
    }else if (vSize.width / vSize.height > displayViewWidth / displayViewHeight){
        height = vSize.height / vSize.width * displayViewWidth;
        y = (displayViewHeight - height) * 0.5;
    }
    
    self.stickerOverlayView = [[PLSStickerOverlayView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.editDisplayView addSubview:self.stickerOverlayView];
    self.stickerOverlayView.backgroundColor = [UIColor clearColor];
    
    // 添加点击手势
    self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchBGView:)];
    self.tapGes.cancelsTouchesInView = NO;
    self.tapGes.delegate = self;
    [self.view addGestureRecognizer:self.tapGes];
}

// self.tapGes 手势的响应事件
- (void)onTouchBGView:(UITapGestureRecognizer *)touches {
    // 取消贴纸、字幕的选中状态
    if (_currentStickerView) {
        _currentStickerView.select = NO;
        [self.timelineView editTimelineComplete];
    }
    
    // 回收键盘
    [self.view endEditing:YES];
    
    // 隐藏显示功能面板
    [self hideStickerbar];
    
    // 隐藏显示滤镜、音乐、MV 资源的视图
    [self hideSourceCollectionView];
    
    // 隐藏剪视频的视图
    [self hideClipMovieView];
    
    // 隐藏视频列表视图
    [self removeVideoListView];
}

#pragma mark - UIGestureRecognizer 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 过滤掉 PLSEditVideoCell，让 PLSEditVideoCell 响应它自身的点击事件
    if ([touch.view.superview isKindOfClass:[PLSEditVideoCell class]]) {
        return NO;
    }
    
    // 过滤掉 PLSStickerBar，让 PLSStickerBar 响应它自身的点击事件
    if ([touch.view.superview.superview isKindOfClass:[PLSStickerBar class]]) {
        return NO;
    }
    
    // 过滤掉 UIScrollView，让 UIScrollView 响应它自身的点击事件，UIScrollView 用于展示了底部的功能按钮键
    if ([touch.view.superview.superview isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    return YES;
}

- (void)setupEditToolboxView {
    CGFloat width = PLS_EditToolboxView_HEIGHT;
    CGFloat height = 50;
    CGFloat startX = 177;
    CGFloat space = width + 15;
    CGFloat fontSize = 16;
    
    self.editToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT - width - [self bottomFixSpace], PLS_SCREEN_WIDTH, width)];
    self.editToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.editToolboxView];
    
    UIScrollView *buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.editToolboxView.frame.size.width, height)];
    buttonScrollView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    buttonScrollView.contentSize = CGSizeMake(startX + space * 15, buttonScrollView.frame.size.height);
    buttonScrollView.contentOffset = CGPointMake(0, 0);
    buttonScrollView.bounces = YES;
    buttonScrollView.showsHorizontalScrollIndicator = NO;
    buttonScrollView.showsVerticalScrollIndicator = NO;
    [self.editToolboxView addSubview:buttonScrollView];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 162, height)];
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.textAlignment = NSTextAlignmentLeft;
    hintLabel.textColor = [UIColor redColor];
    hintLabel.text = @"左右滑动体验更多功能按钮";
    [buttonScrollView addSubview:hintLabel];
    
    NSInteger index = 0;
    
    // 水印
    UIButton *watermarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    watermarkButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [watermarkButton setTitle:@"水印" forState:UIControlStateNormal];
    [watermarkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    watermarkButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [watermarkButton addTarget:self action:@selector(watermarkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:watermarkButton];
    
    index++;

    // 剪视频
    UIButton *clipVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clipVideoButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [clipVideoButton setTitle:@"剪视频" forState:UIControlStateNormal];
    [clipVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clipVideoButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [clipVideoButton addTarget:self action:@selector(clipVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:clipVideoButton];
    
    index++;
    
    // 滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [filterButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:filterButton];
    
    index++;
    
    // 多音效
    UIButton *multiMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    multiMusicButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [multiMusicButton setTitle:@"多音效" forState:UIControlStateNormal];
    [multiMusicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    multiMusicButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [multiMusicButton addTarget:self action:@selector(multiMusicButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:multiMusicButton];
    
    index++;

    // 背景音乐
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [musicButton setTitle:@"音乐" forState:UIControlStateNormal];
    [musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    musicButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [musicButton addTarget:self action:@selector(musicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:musicButton];
    
    index++;

    // 裁剪背景音乐
    UIButton *clipMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clipMusicButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [clipMusicButton setTitle:@"剪音乐" forState:UIControlStateNormal];
    [clipMusicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clipMusicButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [clipMusicButton addTarget:self action:@selector(clipMusicButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:clipMusicButton];
    
    index++;

    // 音量调节
    UIButton *volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    volumeButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [volumeButton setTitle:@"音量" forState:UIControlStateNormal];
    [volumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    volumeButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [volumeButton addTarget:self action:@selector(volumeChangeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:volumeButton];
    
    index++;

    // 关闭原声
    UIButton *closeSoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeSoundButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [closeSoundButton setTitle:@"静音" forState:UIControlStateNormal];
    [closeSoundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeSoundButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [closeSoundButton addTarget:self action:@selector(closeSoundButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:closeSoundButton];
    
    index++;

    // 添加文字
    UIButton *addTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addTextButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [addTextButton setTitle:@"文字" forState:UIControlStateNormal];
    [addTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addTextButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [addTextButton addTarget:self action:@selector(addTextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:addTextButton];
    
    index++;

    // 添加图片
    UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [addImageButton setTitle:@"图片" forState:UIControlStateNormal];
    [addImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addImageButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [addImageButton addTarget:self action:@selector(addImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:addImageButton];
    
    index++;

    // 制作Gif图
    UIButton *formGifButton = [UIButton buttonWithType:UIButtonTypeCustom];
    formGifButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [formGifButton setTitle:@"GIF图" forState:UIControlStateNormal];
    [formGifButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    formGifButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [formGifButton addTarget:self action:@selector(formatGifButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:formGifButton];
    
    index++;

    // 配音
    UIButton *audioDubButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioDubButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [audioDubButton setTitle:@"配音" forState:UIControlStateNormal];
    [audioDubButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    audioDubButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [audioDubButton addTarget:self action:@selector(dubAudioButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:audioDubButton];
    
    index++;

    // 视频倍速
    UIButton *videoSpeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoSpeedButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [videoSpeedButton setTitle:@"倍速" forState:UIControlStateNormal];
    [videoSpeedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    videoSpeedButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [videoSpeedButton addTarget:self action:@selector(videoSpeedButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:videoSpeedButton];
    
    index++;

    // 时光倒流
    self.reverserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reverserButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [self.reverserButton setTitle:@"倒序" forState:UIControlStateNormal];
    [self.reverserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reverserButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.reverserButton.selected = NO;
    [self.reverserButton addTarget:self action:@selector(reverserButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:_reverserButton];
    
    index++;

    // 视频旋转
    UIButton *rotateVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateVideoButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [rotateVideoButton setTitle:@"旋转" forState:UIControlStateNormal];
    [rotateVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rotateVideoButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [rotateVideoButton addTarget:self action:@selector(rotateVideoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:rotateVideoButton];

    index++;

    // MV 特效
    UIButton *mvButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mvButton.frame = CGRectMake(startX + space * index, 0, width, height);
    [mvButton setTitle:@"MV" forState:UIControlStateNormal];
    [mvButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mvButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [mvButton addTarget:self action:@selector(mvButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:mvButton];
    
    index++;

    // 视频列表
    UIButton *videoListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoListButton.frame = CGRectMake(startX + space * index, 0, width, height);
    videoListButton.selected = NO;
    [videoListButton setTitle:@"列表" forState:UIControlStateNormal];
    [videoListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    videoListButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [videoListButton addTarget:self action:@selector(videoListButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:videoListButton];
    
    index++;
    
    // 更新 buttonScrollView 的 contentSize
    buttonScrollView.contentSize = CGSizeMake(startX + space * index, buttonScrollView.frame.size.height);
}

- (void)setupMergeToolboxView {
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 展示拼接视频的进度
    CGFloat width = self.activityIndicatorView.frame.size.width;
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.center = CGPointMake(self.activityIndicatorView.center.x, self.activityIndicatorView.center.y + 40);
    [self.activityIndicatorView addSubview:self.progressLabel];
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

// 加载视频列表
- (void)loadVideoListView {
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    for (NSURL *url in self.filesURLArray) {
        NSDictionary *dic = @{
                              @"url"        : url,
                              @"name"       : [url absoluteString],
                              };
        
        [listArray addObject:dic];
    }
    
    // 视频列表
    self.videoListView = [[PLSColumnListView alloc] initWithFrame:CGRectMake(0, 64, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH) listArray:listArray titleArray:nil listType:PLSNormalType];
    [self.videoListView reloadData];
    
    [self.view addSubview:self.videoListView];
}

// 移除视频列表
- (void)removeVideoListView {
    [self.videoListView removeFromSuperview];
}

#pragma mark - 启动/暂停视频预览
- (void)playButtonClicked:(UIButton *)button {
    if (self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = YES;
    } else {
        [self.shortVideoEditor startEditing];
        self.playButton.selected = NO;
    }
}

#pragma mark - 滤镜资源
- (NSArray<NSDictionary *> *)filtersArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // 滤镜
    for (NSDictionary *filterInfoDic in self.filterGroup.filtersInfo) {
        NSString *name = [filterInfoDic objectForKey:@"name"];
        NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
        NSString *coverImage = [filterInfoDic objectForKey:@"coverImage"];

        NSDictionary *dic = @{
                              @"name"            : name,
                              @"coverImagePath"  : coverImagePath,
                              @"coverImage"      : coverImage
                              };
        
        [array addObject:dic];
    }
 
    return array;
}

#pragma mark - 多音效资源
- (NSMutableArray *)multiMusicsArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *jsonPath = [bundlePath stringByAppendingString:@"/pls_multi_musics.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"load internal filters json error: %@", error);
    
    NSArray *jsonArray = [dicFromJson objectForKey:@"musics"];
    
    
    NSDictionary *dic = @{
                          @"audioName"  : @"无",
                          @"audioUrl"   : @"NULL",
                          };
    [array addObject:dic];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *music = jsonArray[i];
        NSString *musicName = [music objectForKey:@"name"];
        NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        NSDictionary *dic = @{
                              @"audioName"  : musicName,
                              @"audioUrl"   : musicUrl,
                              };
        [array addObject:dic];
    }
    
    return array;
}

#pragma mark - 音乐资源
- (NSMutableArray *)musicsArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *jsonPath = [bundlePath stringByAppendingString:@"/plsmusics.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"load internal filters json error: %@", error);
    
    NSArray *jsonArray = [dicFromJson objectForKey:@"musics"];
    
    
    NSDictionary *dic = @{
                          @"audioName"  : @"无",
                          @"audioUrl"   : @"NULL",
                          };
    [array addObject:dic];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *music = jsonArray[i];
        NSString *musicName = [music objectForKey:@"name"];
        NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        NSDictionary *dic = @{
                              @"audioName"  : musicName,
                              @"audioUrl"   : musicUrl,
                              };
        [array addObject:dic];
    }
    
    return array;
}

#pragma mark - MV资源
- (NSMutableArray *)mvArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *jsonPath = [bundlePath stringByAppendingString:@"/plsMVs.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"load internal filters json error: %@", error);
    
    NSArray *jsonArray = [dicFromJson objectForKey:@"MVs"];
    
    
    NSString *name = @"None";
    NSString *coverDir = [[NSBundle mainBundle] pathForResource:@"mv" ofType:@"png"];
    NSString *colorDir = @"NULL";
    NSString *alphaDir = @"NULL";
    NSDictionary *dic = @{
                          @"name"     : name,
                          @"coverDir" : coverDir,
                          @"colorDir" : colorDir,
                          @"alphaDir" : alphaDir
                          };
    [array addObject:dic];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *mv = jsonArray[i];
        NSString *name = [mv objectForKey:@"name"];
        NSString *coverDir = [[NSBundle mainBundle] pathForResource:[mv objectForKey:@"coverDir"] ofType:@"png"];
        NSString *colorDir = [[NSBundle mainBundle] pathForResource:[mv objectForKey:@"colorDir"] ofType:@"mp4"];
        NSString *alphaDir = [[NSBundle mainBundle] pathForResource:[mv objectForKey:@"alphaDir"] ofType:@"mp4"];
        
        NSDictionary *dic = @{
                              @"name"     : name,
                              @"coverDir" : coverDir,
                              @"colorDir" : colorDir,
                              @"alphaDir" : alphaDir
                              };
        [array addObject:dic];
    }
    
    return array;
}

#pragma mark - 视频倍速资源
- (NSMutableArray *)videoSpeedArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];

    NSArray *nameArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    NSArray *dirArray = @[@"jiman", @"man", @"zhengchang", @"kuai", @"jikuai"];

    for (int i = 0; i < nameArray.count; i++) {
        NSString *name = nameArray[i];
        NSString *coverDir = [[NSBundle mainBundle] pathForResource:dirArray[i] ofType:@"png"];
        
        NSDictionary *dic = @{
                              @"name"     : name,
                              @"coverDir" : coverDir,
                              };
        [array addObject:dic];
    }
    
    return array;
}

#pragma mark - 获取音乐文件的封面
- (UIImage *)musicImageWithMusicURL:(NSURL *)url {
    NSData *data = nil;
    // 初始化媒体文件
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    // 读取文件中的数据
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            //artwork这个key对应的value里面存的就是封面缩略图，其它key可以取出其它摘要信息，例如title - 标题
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                data = (NSData *)metadataItem.value;

                break;
            }
        }
    }
    if (!data) {
        // 如果音乐没有图片，就返回默认图片
        return [UIImage imageNamed:@"music"];
    }
    return [UIImage imageWithData:data];
}

#pragma mark - UICollectionView delegate 用来展示和处理 SDK 内部自带的滤镜、音乐、MV效果
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.selectionViewIndex == 0) {
        // 滤镜
        return self.filtersArray.count;
        
    } else if (self.selectionViewIndex == 1) {
        // 音乐
        return self.musicsArray.count;
        
    } else if (self.selectionViewIndex == 2) {
        // MV
        return self.mvArray.count;
    
    } else if (self.selectionViewIndex == 3) {
        // 视频倍速
        return self.videoSpeedArray.count;
    
    } else
        // 多音效
        return self.multiMusicsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSEditVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class]) forIndexPath:indexPath];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.editCollectionView.collectionViewLayout;
    [cell setLabelFrame:CGRectMake(0, 0, layout.itemSize.width, 15) imageViewFrame:CGRectMake(0, 15, layout.itemSize.width, layout.itemSize.width)];

    if (self.selectionViewIndex == 0) {
        // 滤镜
        NSDictionary *filterInfoDic = self.filtersArray[indexPath.row];
        
        NSString *name = [filterInfoDic objectForKey:@"name"];
        NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
        UIImage *coverImage = [filterInfoDic objectForKey:@"coverImage"];
        cell.iconPromptLabel.text = name;
        cell.iconImageView.image = [UIImage imageWithContentsOfFile:coverImagePath];
        /**
         * 见 PLSFilterGroup.m 中，coverImage 可能是 [NSNull null]，
         * 防止出现 crash: *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[NSNull size]: unrecognized selector sent to instance 0x1b28fa650'
         * 需要先检查下 coverImage 是不是 [NSNull null]，是的话就设置为 nil
         */
        if ([self checkNSNullType:coverImage]) {
            cell.iconImageView.image = coverImage;
        }
        
    } else if (self.selectionViewIndex == 1) {
        // 音乐
        NSDictionary *dic = self.musicsArray[indexPath.row];
        NSString *musicName = [dic objectForKey:@"audioName"];
        NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
        UIImage *musicImage = [self musicImageWithMusicURL:musicUrl];

        cell.iconPromptLabel.text = musicName;
        cell.iconImageView.image = musicImage;

    } else if (self.selectionViewIndex == 2) {
        // MV
        NSDictionary *dic = self.mvArray[indexPath.row];
        NSString *name = [dic objectForKey:@"name"];
        NSString *coverDir = [dic objectForKey:@"coverDir"];
        UIImage *coverImage = [UIImage imageWithContentsOfFile:coverDir];
        
        cell.iconPromptLabel.text = name;
        cell.iconImageView.image = coverImage;
    
    } else if (self.selectionViewIndex == 3) {
        // 视频倍速
        NSDictionary *dic = self.videoSpeedArray[indexPath.row];
        NSString *name = [dic objectForKey:@"name"];
        NSString *coverDir = [dic objectForKey:@"coverDir"];
        UIImage *coverImage = [UIImage imageWithContentsOfFile:coverDir];
        
        cell.iconPromptLabel.text = name;
        cell.iconImageView.image = coverImage;
    
    } else if (self.selectionViewIndex == 4) {
        // 多音效
        NSDictionary *dic = self.multiMusicsArray[indexPath.row];
        NSString *musicName = [dic objectForKey:@"audioName"];
        NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
        UIImage *musicImage = [self musicImageWithMusicURL:musicUrl];
        
        cell.iconPromptLabel.text = musicName;
        cell.iconImageView.image = musicImage;
    }
    
    return  cell;
}

#pragma mark - UICollectionView delegate 切换滤镜、背景音乐、MV 特效
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectionViewIndex == 0) {
        // 滤镜
        self.filterGroup.filterIndex = indexPath.row;
        NSString *colorImagePath = self.filterGroup.colorImagePath;
        
        [self addFilter:colorImagePath];
        
    } else if (self.selectionViewIndex == 1) {
        // 音乐
        if (!indexPath.row) {
            // ****** 要特别注意此处，无音频 URL ******
            NSDictionary *dic = self.musicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            
            self.backgroundAudioSettings[PLSURLKey] = [NSNull null];
            self.backgroundAudioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.backgroundAudioSettings[PLSDurationKey] = [NSNumber numberWithFloat:0.f];
            self.backgroundAudioSettings[PLSNameKey] = musicName;

        } else {
            
            NSDictionary *dic = self.musicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
            
            self.backgroundAudioSettings[PLSURLKey] = musicUrl;
            self.backgroundAudioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.backgroundAudioSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self getFileDuration:musicUrl]];
            self.backgroundAudioSettings[PLSNameKey] = musicName;
            
        }
        
        NSURL *musicURL = self.backgroundAudioSettings[PLSURLKey];
        CMTimeRange musicTimeRange= CMTimeRangeMake(CMTimeMake([self.backgroundAudioSettings[PLSStartTimeKey] floatValue] * 1000, 1000), CMTimeMake([self.backgroundAudioSettings[PLSDurationKey] floatValue] * 1000, 1000));
        NSNumber *musicVolume = self.backgroundAudioSettings[PLSVolumeKey];
        [self addMusic:musicURL timeRange:musicTimeRange volume:musicVolume];

    } else if (self.selectionViewIndex == 2) {
        if (!indexPath.row) {
            // ****** 要特别注意此处，无MV URL ******
//            NSDictionary *dic = self.mvArray[indexPath.row];
//            NSString *name = [dic objectForKey:@"name"];
//            NSString *coverDir = [dic objectForKey:@"coverDir"];
//            NSString *colorDir = [dic objectForKey:@"colorDir"];
//            NSString *alphaDir = [dic objectForKey:@"alphaDir"];
            
            [self addMVLayerWithColor:nil alpha:nil];
            
        } else {
            NSDictionary *dic = self.mvArray[indexPath.row];
//            NSString *name = [dic objectForKey:@"name"];
//            NSString *coverDir = [dic objectForKey:@"coverDir"];
            NSString *colorDir = [dic objectForKey:@"colorDir"];
            NSString *alphaDir = [dic objectForKey:@"alphaDir"];
            
            NSURL *colorURL = [NSURL fileURLWithPath:colorDir];
            NSURL *alphaURL = [NSURL fileURLWithPath:alphaDir];
            
            [self addMVLayerWithColor:colorURL alpha:alphaURL];
        }
    
    } else if (self.selectionViewIndex == 3) {
        // 视频倍速
        NSInteger index = indexPath.row;
        
        [self videoSpeedSeletor:index];
        
    } else if (self.selectionViewIndex == 4) {
        // 多音效
        self.lastSelectedIndexPath = self.currentSelectedIndexPath;
        self.currentSelectedIndexPath = indexPath;
        
        NSMutableDictionary *audioSettings = [[NSMutableDictionary alloc] init];

        if (!indexPath.row) {
            // ****** 要特别注意此处，无音频 URL ******
            NSDictionary *dic = self.multiMusicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            
            audioSettings[PLSURLKey] = [NSNull null];
            audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:0.f];
            audioSettings[PLSNameKey] = musicName;
            
        } else {
            NSDictionary *dic = self.multiMusicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
            
            audioSettings[PLSURLKey] = musicUrl;
            audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self getFileDuration:musicUrl]];
            audioSettings[PLSNameKey] = musicName;
        }
        
        NSURL *musicURL = audioSettings[PLSURLKey];
        CMTimeRange musicTimeRange= CMTimeRangeMake(CMTimeMake([audioSettings[PLSStartTimeKey] floatValue] * 1000, 1000), CMTimeMake([audioSettings[PLSDurationKey] floatValue] * 1000, 1000));
        NSNumber *musicVolume = audioSettings[PLSVolumeKey];
        
        // 如果想试听添加的音频效果，可以在这里使用 PLSEditPlayer 播放音频文件，或者使用其他的音频播放器播放
    }
}

#pragma mark - 添加/更新 MV 特效、滤镜、背景音乐 等效果
- (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL {
    // 添加／移除 MV 特效
    self.colorURL = colorURL;
    self.alphaURL = alphaURL;
    
    // 添加了 MV 特效，就需要让原视频和 MV 特效视频的分辨率相同
    if (self.colorURL && self.alphaURL) {
        AVAsset *asset = [AVAsset assetWithURL:self.colorURL];
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        if (videoTracks.count > 0) {
            AVAssetTrack *videoTrack = videoTracks[0];
            CGSize naturalSize = videoTrack.naturalSize;
            self.videoSize = CGSizeMake(naturalSize.width, naturalSize.height);
            self.shortVideoEditor.videoSize = self.videoSize;
        }
    } else {
        self.videoSize = CGSizeZero;
        self.shortVideoEditor.videoSize = self.videoSize;
    }
    
    [self.shortVideoEditor addMVLayerWithColor:self.colorURL alpha:self.alphaURL];
}

- (void)addFilter:(NSString *)colorImagePath {
    // 添加／移除 滤镜
    self.colorImagePath = colorImagePath;
    
    [self.shortVideoEditor addFilter:self.colorImagePath];
}
     
 - (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume {
     if (!self.shortVideoEditor.isEditing) {
         [self.shortVideoEditor startEditing];
         self.playButton.selected = NO;
     }
     
    self.backgroundAudioLoopEnable = YES;
    // 添加／移除 背景音乐
    [self.shortVideoEditor addMusic:musicURL timeRange:timeRange volume:volume loopEnable:self.backgroundAudioLoopEnable];
     
     if (self.backgroundAudioLoopEnable) {
         // 设置背景音乐循环插入到视频中
         self.backgroundAudioSettings[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:0.f];
         self.backgroundAudioSettings[PLSLocationDurationKey] = self.movieSettings[PLSDurationKey];
     } else {
         // 设置背景音乐只插入一次到视频中
         self.backgroundAudioSettings[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:0.f];
         self.backgroundAudioSettings[PLSLocationDurationKey] = self.backgroundAudioSettings[PLSDurationKey];
     }
}

- (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume {
    // 更新 背景音乐 的 播放时间区间、音量
    [self.shortVideoEditor updateMusic:timeRange volume:volume];
    
    if (self.backgroundAudioLoopEnable) {
        // 设置背景音乐循环插入到视频中
        self.backgroundAudioSettings[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:0.f];
        self.backgroundAudioSettings[PLSLocationDurationKey] = self.movieSettings[PLSDurationKey];
    } else {
        // 设置背景音乐只插入一次到视频中
        self.backgroundAudioSettings[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:0.f];
        self.backgroundAudioSettings[PLSLocationDurationKey] = self.backgroundAudioSettings[PLSDurationKey];
    }
}

#pragma mark - PLShortVideoEditorDelegate 编辑时处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    //此处可以做美颜/滤镜等处理
//    NSLog(@"%s, line:%d, timestamp:%f", __FUNCTION__, __LINE__, CMTimeGetSeconds(timestamp));
    
    CVPixelBufferRef tempPixelBuffer = pixelBuffer;

    // 更新时间线视图
    CGFloat time = CMTimeGetSeconds(timestamp);
    [self.timelineView seekToTime:time];
    
    if (self.timelineView.getAllAddedItems.count != 0) {
        for (int i = 0; i < self.timelineView.getAllAddedItems.count; i++) {
            PLSTimeLineItem *item = self.timelineView.getAllAddedItems[i];
            PLSStickerView *stickerView = (PLSStickerView *)item.target;
            CGFloat itemStartTime = item.startTime;
            CGFloat itemEndTime = item.endTime;
            
            if (CMTimeGetSeconds(timestamp) < itemStartTime || CMTimeGetSeconds(timestamp) > itemEndTime) {
                stickerView.hidden = YES;
            } else {
                stickerView.hidden = NO;
            }
        }
    }
    
    // 多音效
    if (self.selectionViewIndex == 4 && self.currentSelectedIndexPath.row != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            do {
                if ([self.currentSelectedIndexPath compare:self.lastSelectedIndexPath] == NSOrderedSame) {
                    if (self.processAudioItem) {
                        self.processAudioItem.endTime = CMTimeGetSeconds(timestamp);
                        [self.timelineView updateTimelineAudioItem:self.processAudioItem];
                        
                        self.processAudioItem = nil;
                        self.currentSelectedIndexPath = nil;
                        self.lastSelectedIndexPath = nil;
                        
                        // 更新音效信息，并显示
                        [self updateMultiMusics:[self.timelineView getAllAddedAudioItems]];
                        
                        break;
                    }
                }
                
                if (!self.processAudioItem) {
                    PLSEditVideoCell *editVideoCell = (PLSEditVideoCell *)[self.editCollectionView cellForItemAtIndexPath:self.currentSelectedIndexPath];
                    
                    CGFloat startTime = CMTimeGetSeconds(timestamp);
                    CGFloat endTime = 1.0f;
                    NSString *audioName = editVideoCell.iconPromptLabel.text;
                    
                    self.processAudioItem = [[PLSTimeLineAudioItem alloc] init];
                    self.processAudioItem.url = [[NSBundle mainBundle] URLForResource:audioName withExtension:nil];
                    self.processAudioItem.startTime = startTime;
                    self.processAudioItem.endTime = endTime;
                    self.processAudioItem.volume = 1.0f;
                    self.processAudioItem.displayColor = [self colorWithName:audioName];
                }
                self.processAudioItem.endTime = CMTimeGetSeconds(timestamp);
                [self.timelineView updateTimelineAudioItem:self.processAudioItem];
            } while (0);
        });
    }
    
    return tempPixelBuffer;
}

- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReadyToPlayForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange {
    NSLog(@"%s, line:%d", __FUNCTION__, __LINE__);
    
    self.playButton.selected = NO;
}

- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReachEndForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange {
    NSLog(@"%s, line:%d", __FUNCTION__, __LINE__);
    
    // 多音效
    if (self.selectionViewIndex == 4 && self.currentSelectedIndexPath.row != 0) {
        self.processAudioItem.endTime = CMTimeGetSeconds(timeRange.duration);
        [self.timelineView updateTimelineAudioItem:self.processAudioItem];
        
        self.processAudioItem = nil;
        self.currentSelectedIndexPath = nil;
        self.lastSelectedIndexPath = nil;
        
        // 更新音效信息，并显示
        [self updateMultiMusics:[self.timelineView getAllAddedAudioItems]];
    }
}

#pragma mark -  PLSAVAssetExportSessionDelegate 合成视频文件给视频数据加滤镜效果的回调
- (CVPixelBufferRef)assetExportSession:(PLSAVAssetExportSession *)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    // 视频数据可用来做滤镜处理，将滤镜效果写入视频文件中
//    NSLog(@"%s, line:%d, timestamp:%f", __FUNCTION__, __LINE__, CMTimeGetSeconds(timestamp));

    CVPixelBufferRef tempPixelBuffer = pixelBuffer;
    
    return tempPixelBuffer;
}

#pragma mark - 显示滤镜、音乐、MV 的 CollectionView
- (void)showSourceCollectionView {
    if (!self.editCollectionView) {
        // 展示滤镜、音乐、MV列表效果的 UICollectionView
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(70, 85);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        CGFloat height = layout.itemSize.height;
        self.editCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT - PLS_EditToolboxView_HEIGHT - height - [self bottomFixSpace], PLS_SCREEN_WIDTH, height) collectionViewLayout:layout];
        self.editCollectionView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
        self.editCollectionView.showsHorizontalScrollIndicator = NO;
        self.editCollectionView.showsVerticalScrollIndicator = NO;
        [self.editCollectionView setExclusiveTouch:YES];
        [self.editCollectionView registerClass:[PLSEditVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class])];
        self.editCollectionView.delegate = self;
        self.editCollectionView.dataSource = self;
        [self.editCollectionView reloadData];
    }
    if (!self.editCollectionView.superview) {
        [self.view addSubview:self.editCollectionView];
    }
}

- (void)hideSourceCollectionView {
    [self.editCollectionView removeFromSuperview];
}

#pragma mark - UIButton 按钮响应事件
#pragma mark - 水印
- (void)watermarkButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.shortVideoEditor clearWaterMark];
        
        // 水印
        self.watermarkSettings[PLSURLKey] = [NSNull null];
        self.watermarkSettings[PLSSizeKey] = [NSValue valueWithCGSize:self.watermarkSize];
        self.watermarkSettings[PLSPointKey] = [NSValue valueWithCGPoint:self.watermarkPosition];
        
    } else {
        [self.shortVideoEditor setWaterMarkWithImage:self.watermarkImage position:self.watermarkPosition];
        
        // 水印
        self.watermarkSettings[PLSURLKey] = self.watermarkURL;
        self.watermarkSettings[PLSSizeKey] = [NSValue valueWithCGSize:self.watermarkSize];
        self.watermarkSettings[PLSPointKey] = [NSValue valueWithCGPoint:self.watermarkPosition];
    }
}

#pragma mark - 剪视频
- (void)clipVideoButtonClick:(id)sender {
    [self showClipMovieView];
}

- (void)showClipMovieView {
    if (!self.clipMovieView) {
        AVAsset *asset = self.movieSettings[PLSAssetKey];
        CGFloat duration = CMTimeGetSeconds(asset.duration);
        
        self.clipMovieView = [[PLSClipMovieView alloc] initWithMovieAsset:asset minDuration:2.0f maxDuration:duration];
        self.clipMovieView.frame = CGRectMake(0, PLS_SCREEN_HEIGHT - PLS_EditToolboxView_HEIGHT - 150 - [self bottomFixSpace], PLS_SCREEN_WIDTH, 150);
        self.clipMovieView.delegate = self;
    }
    if (!self.clipMovieView.superview) {
        [self.view addSubview:self.clipMovieView];
    }
}

- (void)hideClipMovieView {
    [self.clipMovieView removeFromSuperview];
}

#pragma mark - 裁剪视频的回调 PLSClipMovieView delegate
- (void)didStartDragView {

}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime {
    CGFloat start = CMTimeGetSeconds(leftTime);
    CGFloat end = CMTimeGetSeconds(rightTime);
    CGFloat duration = end - start;
    
    self.originMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:start];
    self.originMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:duration];
    
    // 每次选段变化之后，将变化的值按照倍速作用到 movieSettings 中
    float rate = [self getRateNumberWithRateType:self.currentRateType];
    float rateStart = start * rate;
    float rateDuration = duration * rate;
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:rateStart];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:rateDuration];
    
    self.shortVideoEditor.timeRange = CMTimeRangeMake(CMTimeMake(rateStart * 1000, 1000), CMTimeMake(rateDuration * 1000, 1000));
    [self.shortVideoEditor startEditing];
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling {
    self.view.userInteractionEnabled = !scrolling;
}

#pragma mark - 滤镜
- (void)filterButtonClick:(id)sender {
    [self showSourceCollectionView];
    
    if (self.selectionViewIndex == 0) {
        return;
    }
    self.selectionViewIndex = 0;
    [self.editCollectionView reloadData];
}

#pragma mark - 多音效
- (void)multiMusicButtonEvent:(id)sender {
    [self showSourceCollectionView];
    
    if (self.selectionViewIndex == 4) {
        return;
    }
    self.selectionViewIndex = 4;
    [self.editCollectionView reloadData];
}

- (void)updateMultiMusics:(NSMutableArray <PLSTimeLineAudioItem *>*)allAddedAudioItems {
    // 多音效
    if ([self.timelineView getAllAddedAudioItems].count != 0) {
        for (int i = 0; i < [self.timelineView getAllAddedAudioItems].count; i++) {
            PLSTimeLineAudioItem *audioItem = [self.timelineView getAllAddedAudioItems][i];
            
            NSMutableDictionary *audioItemDictionary = [[NSMutableDictionary alloc] init];
            
            audioItemDictionary[PLSURLKey] = audioItem.url;
            audioItemDictionary[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            audioItemDictionary[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds([[AVAsset assetWithURL:audioItem.url] duration])];
            audioItemDictionary[PLSVolumeKey] = [NSNumber numberWithFloat:audioItem.volume];
            audioItemDictionary[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:audioItem.startTime];
            audioItemDictionary[PLSLocationDurationKey] = [NSNumber numberWithFloat:(audioItem.endTime - audioItem.startTime)];
            
            [self.audioSettingsArray addObject:audioItemDictionary];
        }
        
        [self.shortVideoEditor updateMultiMusics:self.audioSettingsArray];
    }
}

#pragma mark - 配音
- (void)dubAudioButtonEvent:(id)sender{
    DubViewController *dubViewController = [[DubViewController alloc]init];
    dubViewController.movieSettings = self.movieSettings;
    dubViewController.delegate = self;
    [self presentViewController:dubViewController animated:YES completion:nil];
}

#pragma mark - DubViewControllerDelegate 配音的回调
- (void)didOutputAsset:(AVAsset *)asset {
    NSLog(@"保存配音后的回调");
    
    self.movieSettings[PLSAssetKey] = asset;
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
    
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    [self.shortVideoEditor replaceCurrentAssetWithAsset:self.movieSettings[PLSAssetKey]];
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
}

#pragma mark - 背景音乐
- (void)musicButtonClick:(id)sender {
    [self showSourceCollectionView];

    if (self.selectionViewIndex == 1) {
        return;
    }
    self.selectionViewIndex = 1;
    [self.editCollectionView reloadData];
}

#pragma mark - MV 特效
- (void)mvButtonClick:(id)sender {
    [self showSourceCollectionView];

    if (self.selectionViewIndex == 2) {
        return;
    }
    self.selectionViewIndex = 2;
    [self.editCollectionView reloadData];
}

#pragma mark - 制作Gif图
- (void)formatGifButtonEvent:(id)sender {
    [self joinGifFormatViewController];
}

#pragma mark - 时光倒流
- (void)reverserButtonEvent:(id)sender {
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;
    
    [self loadActivityIndicatorView];

    if (self.reverser.isReversing) {
        NSLog(@"reverser effect isReversing");
        return;
    }
    
    if (self.reverser) {
        self.reverser = nil;
    }
    
    __weak typeof(self)weakSelf = self;
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    self.reverser = [[PLSReverserEffect alloc] initWithAsset:asset];
    self.inputAsset = self.movieSettings[PLSAssetKey];
    [self.reverser setCompletionBlock:^(NSURL *url) {
        [weakSelf removeActivityIndicatorView];

        NSLog(@"reverser effect, url: %@", url);
        
        weakSelf.movieSettings[PLSURLKey] = url;
        weakSelf.movieSettings[PLSAssetKey] = [AVAsset assetWithURL:url];
        
        [weakSelf.shortVideoEditor replaceCurrentAssetWithAsset:weakSelf.movieSettings[PLSAssetKey]];
        [weakSelf.shortVideoEditor startEditing];
        weakSelf.playButton.selected = NO;
    }];
    
    [self.reverser setFailureBlock:^(NSError *error){
        [weakSelf removeActivityIndicatorView];

        NSLog(@"reverser effect, error: %@",error);
        
        weakSelf.movieSettings[PLSAssetKey] = weakSelf.inputAsset;
        
        [weakSelf.shortVideoEditor replaceCurrentAssetWithAsset:weakSelf.movieSettings[PLSAssetKey]];
        [weakSelf.shortVideoEditor startEditing];
        weakSelf.playButton.selected = NO;
    }];
    
    [self.reverser setProcessingBlock:^(float progress) {
        NSLog(@"reverser effect, progress: %f", progress);
    }];
    
    [self.reverser startReversing];
}

#pragma mark - 裁剪背景音乐
- (void)clipMusicButtonEvent:(id)sender {
    CMTimeRange currentMusicTimeRange = CMTimeRangeMake(CMTimeMake([self.backgroundAudioSettings[PLSStartTimeKey] floatValue] * 1000, 1000), CMTimeMake([self.backgroundAudioSettings[PLSDurationKey] floatValue] * 1000, 1000));
    
    PLSClipAudioView *clipAudioView = [[PLSClipAudioView alloc] initWithMuiscURL:self.backgroundAudioSettings[PLSURLKey] timeRange:currentMusicTimeRange];
    clipAudioView.delegate = self;
    [clipAudioView showAtView:self.view];
}

#pragma mark - 裁剪背景音乐的回调 PLSClipAudioViewDelegate
// 裁剪背景音乐
- (void)clipAudioView:(PLSClipAudioView *)clipAudioView musicTimeRangeChangedTo:(CMTimeRange)musicTimeRange {
    self.backgroundAudioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(musicTimeRange.start)];
    self.backgroundAudioSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(musicTimeRange.duration)];
    
    // 从 CMTimeGetSeconds(musicTimeRange.start) 开始播放
    [self updateMusic:musicTimeRange volume:nil];
}

#pragma mark - 音量调节的回调 PLSAudioVolumeViewDelegate
// 调节视频和背景音乐的音量
- (void)audioVolumeView:(PLSAudioVolumeView *)volumeView movieVolumeChangedTo:(CGFloat)movieVolume musicVolumeChangedTo:(CGFloat)musicVolume {
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:movieVolume];
    self.backgroundAudioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:musicVolume];
    
    self.shortVideoEditor.volume = movieVolume;
    
    [self updateMusic:kCMTimeRangeZero volume:self.backgroundAudioSettings[PLSVolumeKey]];
}

#pragma mark - 音量调节
- (void)volumeChangeEvent:(id)sender {
    NSNumber *movieVolume = self.movieSettings[PLSVolumeKey];
    NSNumber *musicVolume = self.backgroundAudioSettings[PLSVolumeKey];

    PLSAudioVolumeView *volumeView = [[PLSAudioVolumeView alloc] initWithMovieVolume:[movieVolume floatValue] musicVolume:[musicVolume floatValue]];
    volumeView.delegate = self;
    [volumeView showAtView:self.view];
}

#pragma mark - 关闭原声
- (void)closeSoundButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        self.shortVideoEditor.volume = 0.0f;
    } else {
        self.shortVideoEditor.volume = 1.0f;
    }
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:self.shortVideoEditor.volume];
}

#pragma mark - 旋转视频
- (void)rotateVideoButtonEvent:(UIButton *)button {
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    if (![self checkMovieHasVideoTrack:asset]) {
        NSString *errorInfo = @"Error: movie has no videoTrack";
        NSLog(@"%s, %@", __func__, errorInfo);
        AlertViewShow(errorInfo);
        return;
    }
    
    self.videoLayerOrientation = [self.shortVideoEditor rotateVideoLayer];
    NSLog(@"videoLayerOrientation: %ld", (long)self.videoLayerOrientation);
}

#pragma mark - 添加文字、图片、涂鸦
- (void)addTextButtonEvent:(UIButton *)button {
    self.playButton.selected = YES;

    button.selected = !button.selected;
    if (button.selected) {
        [self showTextbar];
    } else {
        [self hideTextbar];
    }
}

- (void)addImageButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self showStickerbar];
    } else {
        [self hideStickerbar];
    }
}

- (void)showTextbar {
    [self.shortVideoEditor stopEditing];
    
    self.playButton.selected = YES;
    
    // 1. 创建贴纸
    NSString *imgName = @"sticker_t_0";
    UIImage *image = [UIImage imageNamed:imgName];
    PLSStickerView *stickerView = [[PLSStickerView alloc] initWithImage:image Type:StickerType_SubTitle];
    stickerView.delegate = self;
    // 气泡字幕需要计算文字的输入范围，每个气泡的展示区域不一样
    [stickerView calcInputRectWithImgName:imgName];
    
    _currentStickerView.select = NO;
    stickerView.select = YES;
    _currentStickerView = stickerView;
    
    // 2. 添加至stickerOverlayView上
    [self.stickerOverlayView addSubview:stickerView];
    
    // 3. 添加 timeLineItem 模型
    PLSTimeLineItem *item =[[PLSTimeLineItem alloc] init];
    item.target = stickerView;
    item.effectType = PLSTimeLineItemTypeDecal;
    item.startTime = CMTimeGetSeconds([self.shortVideoEditor currentTime]);
    CGFloat remainingTime = _mediaInfo.duration - item.startTime;
    item.endTime = remainingTime > 2 ? item.startTime + 2 : _mediaInfo.duration;
    
    [self.timelineView addTimelineItem:item];
    [self.timelineView editTimelineItem:item];
    
    stickerView.frame = CGRectMake((self.stickerOverlayView.frame.size.width - image.size.width * 0.5) * 0.5,
                                   (self.stickerOverlayView.frame.size.height - image.size.height * 0.5) * 0.5,
                                   image.size.width * 0.5, image.size.height * 0.5);
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:panGes];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:tapGes];
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:pinGes];
    [stickerView.dragBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAndRotateGestureRecognizerEvent:)]];
    
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTextEditing:)];
    doubleTapGes.numberOfTapsRequired = 2;
    [stickerView addGestureRecognizer:doubleTapGes];
}

- (void)hideTextbar {
    
}

- (void)startTextEditing:(UITapGestureRecognizer *)tapGes {
    _currentStickerView = (PLSStickerView *)[tapGes view];
    _currentStickerView.select = YES;
    [_currentStickerView becomeFirstResponder];
}

- (void)showStickerbar {
    if (!self.stickerBar) {
        self.stickerBar = [[PLSStickerBar alloc] initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT - PLS_EditToolboxView_HEIGHT - 175 - [self bottomFixSpace], PLS_SCREEN_WIDTH, 175) resourcePath:self.stickerPath];
        self.stickerBar.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
        self.stickerBar.delegate = self;
    }
    if(!self.stickerBar.superview) {
        [self.view addSubview:self.stickerBar];
    }
}

- (void)hideStickerbar {
    [self.stickerBar removeFromSuperview];
}

#pragma mark - PLSTimelineViewDelegate 时间线代理
/**
 回调拖动的item对象（在手势结束时发生）
 
 @param item timeline对象
 */
- (void)timelineDraggingTimelineItem:(PLSTimeLineItem *)item {
    
}

/**
 回调timeline开始被手动滑动
 */
- (void)timelineBeginDragging {
    
}

- (void)timelineDraggingAtTime:(CGFloat)time {
    // 确保精度达到0.001
    CMTime seekTime = CMTimeMakeWithSeconds(time, 1000);
    [self.shortVideoEditor seekToTime:seekTime completionHandler:^(BOOL finished) {
        
    }];
}

- (void)timelineEndDraggingAndDecelerate:(CGFloat)time {
    
}

- (void)timelineCurrentTime:(CGFloat)time duration:(CGFloat)duration {
    
}

#pragma mark - PLSStickerViewDelegate
- (void)stickerViewClose:(PLSStickerView *)stickerView {
    PLSTimeLineItem *item = [self.timelineView getTimelineItemWithOjb:stickerView];
    [self.timelineView removeTimelineItem:item];
}

#pragma mark - PLSStickerBarDelegate
- (void)stickerBar:(PLSStickerBar *)stickerBar didSelectImage:(UIImage *)image {
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;
    
    // 1. 创建贴纸
    PLSStickerView *stickerView = [[PLSStickerView alloc] initWithImage:image Type:StickerType_Sticker];
    stickerView.delegate = self;
    
    _currentStickerView.select = NO;
    stickerView.select = YES;
    _currentStickerView = stickerView;
    
    // 2. 添加至stickerOverlayView上
    [self.stickerOverlayView addSubview:stickerView];
    
    // 3. 添加 timeLineItem 模型
    PLSTimeLineItem *item = [[PLSTimeLineItem alloc] init];
    item.target = stickerView;
    item.effectType = PLSTimeLineItemTypeDecal;
    item.startTime = CMTimeGetSeconds([self.shortVideoEditor currentTime]);
    CGFloat remainingTime = _mediaInfo.duration - item.startTime;
    item.endTime = remainingTime > 2 ? item.startTime + 2 : _mediaInfo.duration;
    
    [self.timelineView addTimelineItem:item];
    [self.timelineView editTimelineItem:item];
    
    stickerView.frame = CGRectMake((self.stickerOverlayView.frame.size.width - image.size.width * 0.5) * 0.5,
                                   (self.stickerOverlayView.frame.size.height - image.size.height * 0.5) * 0.5,
                                   image.size.width * 0.5,
                                   image.size.height * 0.5);
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:panGes];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:tapGes];
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizerEvent:)];
    [stickerView addGestureRecognizer:pinGes];
    [stickerView.dragBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAndRotateGestureRecognizerEvent:)]];
}

- (void)moveGestureRecognizerEvent:(UIPanGestureRecognizer *)panGes {
    if ([[panGes view] isKindOfClass:[PLSStickerView class]]){
        CGPoint loc = [panGes locationInView:self.view];
        PLSStickerView *view = (PLSStickerView *)[panGes view];
        if (_currentStickerView.select) {
            if ([_currentStickerView pointInside:[_currentStickerView convertPoint:loc fromView:self.view] withEvent:nil]){
                view = _currentStickerView;
            }
        }
        if (!view.select) {
            return;
        }
        if (panGes.state == UIGestureRecognizerStateBegan) {
            _loc_in = [panGes locationInView:self.view];
            _ori_center = view.center;
        }
        
        CGFloat x;
        CGFloat y;
        x = _ori_center.x + (loc.x - _loc_in.x);
        
        y = _ori_center.y + (loc.y - _loc_in.y);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0 animations:^{
                view.center = CGPointMake(x, y);
            }];
        });
    }
}

- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)tapGes {
    if ([[tapGes view] isKindOfClass:[PLSStickerView class]]){
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = YES;
        
        PLSStickerView *view = (PLSStickerView *)[tapGes view];
        [self.timelineView editTimelineComplete];
        PLSTimeLineItem *item = [self.timelineView getTimelineItemWithOjb:view];
        
        if (view != _currentStickerView) {
            [self.timelineView editTimelineItem:item];
            
            _currentStickerView.select = NO;
            view.select = YES;
            _currentStickerView = view;
        }else{
            view.select = !view.select;
            if (view.select) {
                [self.timelineView editTimelineItem:item];
                _currentStickerView = view;
            }else{
                _currentStickerView = nil;
            }
        }
    }
}

- (void)pinchGestureRecognizerEvent:(UIPinchGestureRecognizer *)pinGes {
    if ([[pinGes view] isKindOfClass:[PLSStickerView class]]){
        PLSStickerView *view = (PLSStickerView *)[pinGes view];
        
        if (pinGes.state ==UIGestureRecognizerStateBegan) {
            view.oriTransform = view.transform;
        }
        
        if (pinGes.state ==UIGestureRecognizerStateChanged) {
            _curScale = pinGes.scale;
            CGAffineTransform tr = CGAffineTransformScale(view.oriTransform, pinGes.scale, pinGes.scale);
            
            view.transform = tr;
        }
        
        // 当手指离开屏幕时,将lastscale设置为1.0
        if ((pinGes.state == UIGestureRecognizerStateEnded) || (pinGes.state == UIGestureRecognizerStateCancelled)) {
            view.oriScale = view.oriScale * _curScale;
            pinGes.scale = 1;
        }
    }
}

- (void)scaleAndRotateGestureRecognizerEvent:(UIPanGestureRecognizer *)gesture {
    if (_currentStickerView.isSelected) {
        CGPoint curPoint = [gesture locationInView:self.view];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            _loc_in = [gesture locationInView:self.view];
        }
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            _currentStickerView.oriTransform = _currentStickerView.transform;
        }
        
        // 计算缩放
        CGFloat preDistance = [self getDistance:_loc_in withPointB:_currentStickerView.center];
        CGFloat curDistance = [self getDistance:curPoint withPointB:_currentStickerView.center];
        CGFloat scale = curDistance / preDistance;
        // 计算弧度
        CGFloat preRadius = [self getRadius:_currentStickerView.center withPointB:_loc_in];
        CGFloat curRadius = [self getRadius:_currentStickerView.center withPointB:curPoint];
        CGFloat radius = curRadius - preRadius;
        radius = - radius;
        CGAffineTransform transform = CGAffineTransformScale(_currentStickerView.oriTransform, scale, scale);
        _currentStickerView.transform = CGAffineTransformRotate(transform, radius);
        
        if (gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateCancelled) {
            _currentStickerView.oriScale = scale * _currentStickerView.oriScale;
        }
    }
}

// 距离
- (CGFloat)getDistance:(CGPoint)pointA withPointB:(CGPoint)pointB {
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    
    return sqrt(x*x + y*y);
}

// 角度
- (CGFloat)getRadius:(CGPoint)pointA withPointB:(CGPoint)pointB {
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    return atan2(x, y);
}

#pragma mark - 视频列表
- (void)videoListButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self loadVideoListView];
    } else {
        [self removeVideoListView];
    }
}

#pragma mark - 视频倍速
- (void)videoSpeedButtonEvent:(UIButton *)button {
    [self showSourceCollectionView];

    if (self.selectionViewIndex == 3) {
        return;
    }
    self.selectionViewIndex = 3;
    [self.editCollectionView reloadData];
}

#pragma mark - 视频倍速处理的响应事件
- (void)videoSpeedSeletor:(NSInteger)titleIndex {
    self.titleIndex = titleIndex;
    PLSVideoRecoderRateType rateType = PLSVideoRecoderRateNormal;
    switch (titleIndex) {
        case 0:
            rateType = PLSVideoRecoderRateTopSlow;
            break;
        case 1:
            rateType = PLSVideoRecoderRateSlow;
            break;
        case 2:
            rateType = PLSVideoRecoderRateNormal;
            break;
        case 3:
            rateType = PLSVideoRecoderRateFast;
            break;
        case 4:
            rateType = PLSVideoRecoderRateTopFast;
            break;
    }

    self.currentRateType = rateType;
    
    AVAsset *outputAsset = nil;

    // PLShortVideoAsset 初始化
    AVAsset *asset = self.originMovieSettings[PLSAssetKey];
    PLShortVideoAsset *shortVideoAsset = [[PLShortVideoAsset alloc] initWithAsset:asset];

    // 倍数处理
    outputAsset = [shortVideoAsset scaleTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) toRateType:rateType];

    // 处理后的视频信息、不做scale处理，会出现播放时长超过视频时长或者播放时长小于视频时长
    CGFloat rate = [self getRateNumberWithRateType:rateType];
    self.movieSettings[PLSAssetKey]  = outputAsset;
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.originMovieSettings[PLSDurationKey] floatValue] * rate];
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:[self.originMovieSettings[PLSStartTimeKey] floatValue] * rate];
    
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue]  * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);

    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    [self.shortVideoEditor replaceCurrentAssetWithAsset:outputAsset];
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
}

/// 根据速率配置相应倍速后的视频时长
- (CGFloat)getRateNumberWithRateType:(PLSVideoRecoderRateType)rateType {
    CGFloat scaleFloat = 1.0;
    switch (rateType) {
        case PLSVideoRecoderRateNormal:
            scaleFloat = 1.0;
            break;
        case PLSVideoRecoderRateSlow:
            scaleFloat = 1.5;
            break;
        case PLSVideoRecoderRateTopSlow:
            scaleFloat = 2.0;
            break;
        case PLSVideoRecoderRateFast:
            scaleFloat = 0.666667;
            break;
        case PLSVideoRecoderRateTopFast:
            scaleFloat = 0.5;
            break;
        default:
            break;
    }
    return scaleFloat;
}

#pragma mark - 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 下一步
- (void)nextButtonClick {
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;

    [self loadActivityIndicatorView];

    // 贴纸信息
    [self.stickerSettingsArray removeAllObjects];
    if ([self.timelineView getAllAddedItems].count != 0) {
        for (int i = 0; i < [self.timelineView getAllAddedItems].count; i++) {
            PLSTimeLineItem *item = [self.timelineView getAllAddedItems][i];
            
            NSMutableDictionary *stickerSettings = [[NSMutableDictionary alloc] init];
            PLSStickerView *stickerView = (PLSStickerView *)item.target;
            stickerView.hidden = NO;
            
            CGAffineTransform transform = stickerView.transform;
            CGFloat widthScale = sqrt(transform.a * transform.a + transform.c * transform.c);
            CGFloat heightScale = sqrt(transform.b * transform.b + transform.d * transform.d);
            CGSize viewSize = CGSizeMake(stickerView.bounds.size.width * widthScale, stickerView.bounds.size.height * heightScale);
            CGPoint viewCenter =  CGPointMake(stickerView.frame.origin.x + stickerView.frame.size.width / 2, stickerView.frame.origin.y + stickerView.frame.size.height / 2);
            CGPoint viewPoint = CGPointMake(viewCenter.x - viewSize.width / 2, viewCenter.y - viewSize.height / 2);
            
            stickerSettings[PLSStickerKey] = stickerView;
            stickerSettings[PLSSizeKey] = [NSValue valueWithCGSize:viewSize];
            stickerSettings[PLSPointKey] = [NSValue valueWithCGPoint:viewPoint];
            
            CGFloat rotation = atan2f(transform.b, transform.a);
            rotation = rotation * (180 / M_PI);
            stickerSettings[PLSRotationKey] = [NSNumber numberWithFloat:rotation];
            
            stickerSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:item.startTime];
            stickerSettings[PLSDurationKey] = [NSNumber numberWithFloat:(item.endTime - item.startTime)];
            stickerSettings[PLSVideoPreviewSizeKey] = [NSValue valueWithCGSize:self.stickerOverlayView.frame.size];
            stickerSettings[PLSVideoOutputSizeKey] = [NSValue valueWithCGSize:self.videoSize];
            
            [self.stickerSettingsArray addObject:stickerSettings];
        }
    }
    
    // 添加背景音乐信息
    [self.audioSettingsArray insertObject:self.backgroundAudioSettings atIndex:0];
    
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    exportSession.delegate = self;
    exportSession.isExportMovieToPhotosAlbum = YES;
//    // 设置视频的码率
//    exportSession.bitrate = 3000*1000;
//    // 设置视频的输出路径
//    exportSession.outputURL = [self getFileURL:@"outputMovie"];
    
    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize = self.videoSize;
    
    // 旋转视频
    exportSession.videoLayerOrientation = self.videoLayerOrientation;
    [exportSession addFilter:self.colorImagePath];
    [exportSession addMVLayerWithColor:self.colorURL alpha:self.alphaURL];
    
    __weak typeof(self) weakSelf = self;
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf joinNextViewController:url];
        });
    }];
    
    [exportSession setFailureBlock:^(NSError *error) {
        NSLog(@"Asset Export Failed: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            AlertViewShow(error);
        });
    }];
    
    [exportSession setProcessingBlock:^(float progress) {
        // 更新进度 UI
        NSLog(@"Asset Export Progress: %f", progress);
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
    }];
    
    [exportSession exportAsynchronously];
}
    
#pragma mark - 进入 Gif 制作页面
- (void)joinGifFormatViewController {
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    
    if (![self checkMovieHasVideoTrack:asset]) {
        NSString *errorInfo = @"Error: movie has no videoTrack";
        NSLog(@"%s, %@", __func__, errorInfo);
        AlertViewShow(errorInfo);
        return;
    }

    GifFormatViewController *gifFormatViewController = [[GifFormatViewController alloc] init];
    gifFormatViewController.asset = asset;
    [self presentViewController:gifFormatViewController animated:YES completion:nil];
}

#pragma mark - 完成视频合成跳转到下一页面
- (void)joinNextViewController:(NSURL *)url {
    [self removeActivityIndicatorView];
    
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.url = url;
    [self presentViewController:playViewController animated:YES completion:nil];
}

#pragma mark - 程序的状态监听
- (void)observerUIApplicationStatusForShortVideoEditor {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortVideoEditorWillResignActiveEvent:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortVideoEditorDidBecomeActiveEvent:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeObserverUIApplicationStatusForShortVideoEditor {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)shortVideoEditorWillResignActiveEvent:(id)sender {
    NSLog(@"[self.shortVideoEditor UIApplicationWillResignActiveNotification]");
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;
}

- (void)shortVideoEditorDidBecomeActiveEvent:(id)sender {
    NSLog(@"[self.shortVideoEditor UIApplicationDidBecomeActiveNotification]");
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
}

- (void)printTimeRange:(CMTimeRange)timeRange {
    printf("timeRange - ");
    printf("start: ");
    [self printTime:timeRange.start];
    printf(" , duration: ");
    [self printTime:timeRange.duration];
    printf("\n");
}

- (void)printTime:(CMTime)time {
    printf("{%lld / %d = %f}", time.value, time.timescale, time.value*1.0 / time.timescale);
}

- (UIColor *)colorWithName:(NSString *)name {
    UIColor *color = [UIColor greenColor];
    
    if ([name isEqualToString:@"古代韵味音效.m4r"]) {
        color = PLS_RGBCOLOR_ALPHA(254, 160, 29, 0.9);
    } else if ([name isEqualToString:@"清新鸟鸣音效.m4r"]) {
        color = PLS_RGBCOLOR_ALPHA(251, 222, 56, 0.9);
    } else if ([name isEqualToString:@"天使简约音效.m4r"]) {
        color = PLS_RGBCOLOR_ALPHA(98, 182, 254, 0.9);
    } else if ([name isEqualToString:@"跳动旋律音效.m4r"]) {
        color = PLS_RGBCOLOR_ALPHA(220, 92, 179, 0.9);
    }
    
    return color;
}

#pragma mark - 自定义文件的名称和存储路径
- (NSURL *)getFileURL:(NSString *)name {
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
    
    if (name != nil && ![name isEqualToString:@""]) {
        nowTimeStr = name;
    }
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:fileName];
    
    return fileURL;
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - dealloc
- (void)dealloc {
    self.shortVideoEditor.delegate = nil;
    self.shortVideoEditor = nil;
    
    self.reverser = nil;

    self.editCollectionView.dataSource = nil;
    self.editCollectionView.delegate = nil;
    self.editCollectionView = nil;
    self.filtersArray = nil;
    self.musicsArray = nil;
    self.videoSpeedArray = nil;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end

