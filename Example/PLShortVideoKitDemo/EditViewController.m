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
#import "PLShortVideoKit/PLShortVideoKit.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PLSColumnListView.h"
#import "PLSVideoEditingController.h"

// TuSDK mark
#import <TuSDK/TuSDK.h>
#import <TuSDKVideo/TuSDKVideo.h>
#import "EffectsView.h"
#import "EffectsTimeLineModel.h"
#import "SceneEffectTools.h"


#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_BaseToolboxView_HEIGHT 64


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
PLSVideoEditingControllerDelegate
>

// 水印
@property (strong, nonatomic) NSURL *watermarkURL;
@property (assign, nonatomic) CGSize watermarkSize;
@property (assign, nonatomic) CGPoint watermarkPosition;

// 视频的分辨率，设置之后影响编辑时的预览分辨率、导出的视频的的分辨率
@property (assign, nonatomic) CGSize videoSize;

// 编辑
@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;
// 编辑信息, movieSettings, audioSettings, watermarkSettings 为 outputSettings 的字典元素
@property (strong, nonatomic) NSMutableDictionary *outputSettings;
@property (strong, nonatomic) NSMutableDictionary *movieSettings;
@property (strong, nonatomic) NSMutableDictionary *audioSettings;
@property (strong, nonatomic) NSMutableDictionary *watermarkSettings;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *editToolboxView;
@property (strong, nonatomic) UIView *playToolboxView;

// 选取要编辑的功能点
@property (assign, nonatomic) NSInteger selectionViewIndex;
// 展示所有滤镜、音乐、MV、字幕列表的集合视图
@property (strong, nonatomic) UICollectionView *editCollectionView;
// 所有滤镜
@property (strong, nonatomic) PLSFilterGroup *filterGroup;
// 滤镜信息
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersArray;
@property (assign, nonatomic) NSInteger filterIndex;
@property (strong, nonatomic) NSString *colorImagePath;
// 音乐信息
@property (strong, nonatomic) NSMutableArray *musicsArray;
// MV信息
@property (strong, nonatomic) NSMutableArray *mvArray;
@property (strong, nonatomic) NSURL *colorURL;
@property (strong, nonatomic) NSURL *alphaURL;
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

// 视频旋转
@property (assign, nonatomic) PLSPreviewOrientation videoLayerOrientation;

// 添加文字、图片、涂鸦, 需要保存到编辑数据
@property (strong, nonatomic) PLSVideoEdit *videoEdit;
@property (assign, nonatomic) BOOL isNeedVideoEdit;

// 视频列表
@property (strong, nonatomic) PLSColumnListView *videoListView;

// 播放/暂停按钮，点击视频预览区域实现播放/暂停功能
@property (strong, nonatomic) UIButton *playButton;
// 视频进度条
@property (strong, nonatomic) UISlider *progressSlider;

// TuSDK mark - 视频总时长，进入页面时，需设置改参数
@property (assign, nonatomic) CGFloat videoTotalTime;

#pragma mark - TuSDK
// TuSDK mark
//滤镜处理类
@property (nonatomic, strong) TuSDKFilterProcessor *filterProcessor;
//当前获取的滤镜对象；
@property (nonatomic, strong) TuSDKFilterWrap *currentFilter;
// 滤镜列表
@property (nonatomic, strong) NSArray<NSString *> *videoEffects;
// 随机色数组
@property (nonatomic, strong) NSArray<UIColor *> *displayColors;
// 滤镜栏
@property (nonatomic, strong) EffectsView *effectsView;
// 视频处理进度 0~1
@property (nonatomic, assign) CGFloat videoProgress;
// 特效添加数组
@property (nonatomic, strong) NSMutableArray<EffectsTimeLineModel *> *effectsModels;
// 当前使用的特效model  视频合成时使用
@property (nonatomic, assign) NSInteger effectsIndex;
// 当前使用的特效code  视频合成时使用
@property (nonatomic, copy) NSString *currentCode;
// 正在切换滤镜 视频合成时使用
@property (nonatomic, assign) BOOL isSwitching;
// 将添加的视频特效在之后的预览过程中展现出来
@property (nonatomic, strong) SceneEffectTools *effectTools;

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
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark -- viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --------------------------
    [self setupBaseToolboxView];
    [self setupEditToolboxView];
    [self setupMergeToolboxView];
    
    // 编辑
    /* outputSettings 中的字典元素为 movieSettings, audioSettings, watermarkSettings */
    self.outputSettings = [[NSMutableDictionary alloc] init];
    self.movieSettings = [[NSMutableDictionary alloc] init];
    self.audioSettings = [[NSMutableDictionary alloc] init];
    self.watermarkSettings = [[NSMutableDictionary alloc] init];
    
    self.outputSettings[PLSMovieSettingsKey] = self.movieSettings;
    self.outputSettings[PLSAudioSettingsKey] = self.audioSettings;
    self.outputSettings[PLSWatermarkSettingsKey] = self.watermarkSettings;
    
    // 原始视频
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
    // 备份原始视频的信息
    self.originMovieSettings = [[NSMutableDictionary alloc] init];
    [self.originMovieSettings addEntriesFromDictionary:self.movieSettings];

    // 背景音乐
    self.audioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
    // 水印图片路径
    NSString *watermarkPath = [[NSBundle mainBundle] pathForResource:@"qiniu_logo" ofType:@".png"];
    UIImage *watermarkImage = [UIImage imageWithContentsOfFile:watermarkPath];
    self.watermarkURL = [NSURL URLWithString:watermarkPath];
    self.watermarkSize = watermarkImage.size;
    self.watermarkPosition = CGPointMake(10, 65);
    // 水印
    self.watermarkSettings[PLSURLKey] = self.watermarkURL;
    self.watermarkSettings[PLSSizeKey] = [NSValue valueWithCGSize:self.watermarkSize];
    self.watermarkSettings[PLSPointKey] = [NSValue valueWithCGPoint:self.watermarkPosition];
    
    // 视频编辑类
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset videoSize:CGSizeZero];
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    // 视频编辑时，添加水印
    [self.shortVideoEditor setWaterMarkWithImage:watermarkImage position:self.watermarkPosition];
    // 视频的分辨率，设置之后影响编辑时的预览分辨率、导出的视频的的分辨率
//    self.videoSize = CGSizeMake(544, 960);
    // 视频编辑时，改变预览分辨率
    self.shortVideoEditor.videoSize = self.videoSize;
    
    // 滤镜
    UIImage *coverImage = [self getVideoPreViewImage:self.movieSettings[PLSAssetKey]];
    self.filterGroup = [[PLSFilterGroup alloc] initWithImage:coverImage];
    
    // TuSDK mark 视频特效
    [self setupTuSDKFilter];

    // 视频预览
    [self setupPlayToolboxView];
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

#pragma mark -- 配置视图
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

- (void)setupEditToolboxView {
    self.editToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - PLS_BaseToolboxView_HEIGHT - PLS_SCREEN_WIDTH)];
    self.editToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.editToolboxView];
    
    UIScrollView *buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 35)];
    buttonScrollView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    buttonScrollView.contentSize = CGSizeMake(800, 35);
    buttonScrollView.contentOffset = CGPointMake(0, 0);
//    buttonScrollView.pagingEnabled = YES;
    buttonScrollView.bounces = YES;
    buttonScrollView.showsHorizontalScrollIndicator = NO;
    buttonScrollView.showsVerticalScrollIndicator = NO;
    [self.editToolboxView addSubview:buttonScrollView];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 162, 35)];
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.textAlignment = NSTextAlignmentLeft;
    hintLabel.textColor = [UIColor redColor];
    hintLabel.text = @"左右滑动体验更多功能按钮";
    [buttonScrollView addSubview:hintLabel];

    // 滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(177, 0, 35, 35);
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [filterButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:filterButton];
    
    // 选择背景音乐
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake(222, 0, 35, 35);
    [musicButton setTitle:@"音乐" forState:UIControlStateNormal];
    [musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    musicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [musicButton addTarget:self action:@selector(musicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:musicButton];

    // MV 特效
    UIButton *mvButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mvButton.frame = CGRectMake(267, 0, 35, 35);
    [mvButton setTitle:@"MV" forState:UIControlStateNormal];
    [mvButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mvButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [mvButton addTarget:self action:@selector(mvButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:mvButton];

    // 配音
    UIButton *audioDubButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioDubButton.frame = CGRectMake(312, 0, 35, 35);
    [audioDubButton setImage:[UIImage imageNamed:@"icon_dub"] forState:UIControlStateNormal];
    audioDubButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [audioDubButton addTarget:self action:@selector(dubAudioButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [buttonScrollView addSubview:audioDubButton];

    // 时光倒流
    self.reverserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reverserButton.frame = CGRectMake(357, 0, 35, 35);
    [self.reverserButton setImage:[UIImage imageNamed:@"Time_Machine_No_Reverser"] forState:UIControlStateNormal];
    [self.reverserButton setImage:[UIImage imageNamed:@"Time_Machine_Reverser"] forState:UIControlStateSelected];
    self.reverserButton.selected = NO;
    [self.reverserButton addTarget:self action:@selector(reverserButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:_reverserButton];
    
    // 制作Gif图
    UIButton *formGifButton = [UIButton buttonWithType:UIButtonTypeCustom];
    formGifButton.frame = CGRectMake(402, 0, 35, 35);
    [formGifButton setImage:[UIImage imageNamed:@"icon_gif"] forState:UIControlStateNormal];
    formGifButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [formGifButton addTarget:self action:@selector(formatGifButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:formGifButton];
    
    // 裁剪背景音乐
    UIButton *clipMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clipMusicButton.frame = CGRectMake(447, 0, 35, 35);
    [clipMusicButton setImage:[UIImage imageNamed:@"icon_trim"] forState:UIControlStateNormal];
    [clipMusicButton addTarget:self action:@selector(clipMusicButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:clipMusicButton];

    // 音量调节
    UIButton *volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    volumeButton.frame = CGRectMake(492, 0, 35, 35);
    [volumeButton setImage:[UIImage imageNamed:@"icon_volume"] forState:UIControlStateNormal];
    [volumeButton addTarget:self action:@selector(volumeChangeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:volumeButton];
    
    // 关闭原声
    UIButton *closeSoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeSoundButton.frame = CGRectMake(537, 0, 35, 35);
    [closeSoundButton setImage:[UIImage imageNamed:@"btn_sound"] forState:UIControlStateNormal];
    [closeSoundButton setImage:[UIImage imageNamed:@"btn_close_sound"] forState:UIControlStateSelected];
    [closeSoundButton addTarget:self action:@selector(closeSoundButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:closeSoundButton];
    
    // 视频旋转
    UIButton *rotateVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateVideoButton.frame = CGRectMake(582, 0, 35, 35);
    [rotateVideoButton setImage:[UIImage imageNamed:@"rotate"] forState:UIControlStateNormal];
    [rotateVideoButton addTarget:self action:@selector(rotateVideoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:rotateVideoButton];
    
    // 添加文字、图片、涂鸦
    UIButton *addTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addTextButton.frame = CGRectMake(627, 0, 35, 35);
    [addTextButton setImage:[UIImage imageNamed:@"btn_add_text"] forState:UIControlStateNormal];
    [addTextButton addTarget:self action:@selector(addTextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:addTextButton];
    
    // 视频列表
    UIButton *videoListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoListButton.frame = CGRectMake(672, 0, 60, 35);
    videoListButton.selected = NO;
    [videoListButton setTitle:@"视频列表" forState:UIControlStateNormal];
    [videoListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    videoListButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [videoListButton addTarget:self action:@selector(videoListButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:videoListButton];
    
    // TuSDK mark - 特效按钮
    UIButton *effectsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    effectsButton.frame = CGRectMake(742, 0, 35, 35);
    [effectsButton setTitle:@"特效" forState:UIControlStateNormal];
    [videoListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    effectsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [effectsButton addTarget:self action:@selector(effectsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonScrollView addSubview:effectsButton];

    // 倍数处理
    self.titleArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    self.titleIndex = 2;
    
    CGFloat rateTopSpace;
    CGFloat collectionViewTopSpace;

    if (PLS_SCREEN_HEIGHT > 568) {
        rateTopSpace = 46;
        collectionViewTopSpace = 94;
    } else{
        rateTopSpace = 37;
        collectionViewTopSpace = 75;
    }
    PLSRateButtonView *rateButtonView = [[PLSRateButtonView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 270, rateTopSpace, 260, 34) defaultIndex:self.titleIndex];
    rateButtonView.hidden = NO;
    CGFloat countSpace = 200 /self.titleArray.count / 6;
    rateButtonView.space = countSpace;
    rateButtonView.staticTitleArray = self.titleArray;
    rateButtonView.rateDelegate = self;
    [self.editToolboxView addSubview:rateButtonView];
    
    // 展示滤镜、音乐、字幕列表效果的 UICollectionView
    CGRect frame = self.editCollectionView.frame;
    self.editCollectionView.frame = CGRectMake(0, collectionViewTopSpace, frame.size.width, frame.size.height);
    [self.editToolboxView addSubview:self.editCollectionView];
    [self.editCollectionView reloadData];
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

- (void)setupPlayToolboxView {
    self.playToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH)];
    self.playToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.playToolboxView];
    
    self.shortVideoEditor.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
    self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.playToolboxView addSubview:self.shortVideoEditor.previewView];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(0, 30, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH - 60);
    self.playButton.center = self.shortVideoEditor.previewView.center;
    [self.playButton setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateSelected];
    [self.playToolboxView addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, PLS_SCREEN_WIDTH - 30, PLS_SCREEN_WIDTH - 80, 30)];
    self.progressSlider.minimumValue = 0.0f;
    self.progressSlider.maximumValue = CMTimeGetSeconds(self.shortVideoEditor.timeRange.duration);
    [self.progressSlider addTarget:self action:@selector(editorSeekEvent:) forControlEvents:UIControlEventValueChanged];
    [self.playToolboxView addSubview:self.progressSlider];
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

// TuSDK mark
#pragma mark -- TuSDK method
// 设置 TuSDK
- (void)setupTuSDKFilter {
    // 视频总时长
//    self.videoTotalTime = [self.movieSettings[PLSDurationKey] floatValue];
    self.videoTotalTime = CMTimeGetSeconds(self.shortVideoEditor.timeRange.duration);
    
    // TuSDK mark
    [self initEffectsView];
    
    // 传入图像的方向是否为原始朝向(相机采集的原始朝向)，SDK 将依据该属性来调整人脸检测时图片的角度。如果没有对图片进行旋转，则为 YES
    BOOL isOriginalOrientation = NO;
    self.filterProcessor = [[TuSDKFilterProcessor alloc] initWithFormatType:kCVPixelFormatType_32BGRA isOriginalOrientation:isOriginalOrientation];
    [self.filterProcessor setEnableLiveSticker:NO];
    self.filterProcessor.delegate = self;
    
    self.effectTools = [[SceneEffectTools alloc] init];
    self.effectTools.videoDuration = self.videoTotalTime;
}

// 初始化TuSDK滤镜选择栏
-(void)initEffectsView {
    [self initEffectsData];
    CGFloat filterViewHeight = self.editToolboxView.lsqGetSizeHeight - 35;
    self.effectsView = [[EffectsView alloc]initWithFrame:CGRectMake(0, self.view.lsqGetSizeHeight - filterViewHeight, self.baseToolboxView.lsqGetSizeWidth, filterViewHeight)];
    self.effectsView.backgroundColor =  PLS_RGBCOLOR(25, 24, 36);
    self.effectsView.effectEventDelegate = self;
    self.effectsView.effectsCode = self.videoEffects;
    [self.view addSubview:self.effectsView];
    self.effectsView.hidden = YES;
    
    // 撤销特效的按钮
    UIButton *revocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    revocationButton.frame = CGRectMake(self.effectsView.lsqGetSizeWidth - 40, 30, 30, 30);
    [revocationButton setImage:[UIImage imageNamed:@"btn_revocation"] forState:UIControlStateNormal];
    [revocationButton addTarget:self action:@selector(revocationButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.effectsView addSubview:revocationButton];
}

// 初始化相关数据
- (void)initEffectsData {
    self.videoEffects = @[@"LiveShake01", @"LiveMegrim01", @"EdgeMagic01", @"LiveFancy01_1", @"LiveSoulOut01", @"LiveSignal01"];
    self.displayColors = [self getRandomColorWithCount:self.videoEffects.count];
    self.effectsModels = [NSMutableArray new];
}

// 特效按钮点击事件
- (void)effectsButtonClick:(UIButton *)btn {
    self.effectsView.hidden = !self.effectsView.hidden;
}

// 隐藏特效的视图 view
- (void)setEffectsViewHidden {
    self.effectsView.hidden = YES;
}

// 清除已添加的所有特效
- (void)clearAllEffectsHistory {
    [self.effectsView.displayView removeAllSegment];
    [self.effectsModels removeAllObjects];
}

// 清除已添加的上一个特效
- (void)revocationButtonEvent:(UIButton *)button {
    if (self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = YES;
    }
    
    [self.effectsView.displayView removeLastSegment];
    [self.effectsModels removeLastObject];
    
    [self.effectTools removeLastEffect];
}

// 切换滤镜方法
- (void)switchEffectWithCode:(NSString *)effectCode {
    [self.filterProcessor switchFilterWithCode:effectCode];
    self.currentCode = effectCode;
}

// 重置标志位
- (void)resetPreviewVideoEffectsMark {
    [self.filterProcessor switchFilterWithCode:nil];
}

- (void)resetExportVideoEffectsMark {
    self.effectsIndex = 0;
    self.currentCode = nil;
    [self.filterProcessor switchFilterWithCode:nil];
}

// 合成时根据时间切换特效的逻辑
- (void)managerEffectsWithTimestamp:(CMTime)timestamp {
    CGFloat videoExportProgress = CMTimeGetSeconds(timestamp)/self.videoTotalTime;
    
    // TuSDK mark - 特效切换逻辑中，不包含特效覆盖以及时间叠加的判断，如需要此逻辑，可自行修改
    if (self.effectsIndex < self.effectsModels.count) {
        EffectsTimeLineModel *effect = self.effectsModels[self.effectsIndex];
        
        if (videoExportProgress >= effect.startProgress && self.currentCode != effect.effectsCode) {
            if (effect.isValid) {
                [self switchEffectWithCode:effect.effectsCode];
            }
        }
        
        if (videoExportProgress >= self.effectsModels[self.effectsIndex].endProgress && self.currentCode == effect.effectsCode) {
            self.effectsIndex ++;
            
            if (self.effectsIndex < self.effectsModels.count) {
                effect =self.effectsModels[self.effectsIndex];
                
                if (videoExportProgress >= effect.startProgress && effect.isValid) {
                    [self switchEffectWithCode:effect.effectsCode];
                } else {
                    // 判断是否可直接开始下一个特效
                    [self switchEffectWithCode:nil];
                }
            }else{
                [self switchEffectWithCode:nil];
            }
        }
    }
    
    if (videoExportProgress >= 1) {
        self.effectsIndex = 0;
    }
}

- (NSArray<UIColor *> *)getRandomColorWithCount:(NSInteger)count {
    NSMutableArray *colorArr = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        UIColor *color = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        [colorArr addObject:color];
    }
    return colorArr;
}

#pragma mark -- TuSDK 特效栏点击代理方法 effectEventDelegate
#pragma mark -- 开始添加视频特效
- (void)effectsSelectedWithCode:(NSString *)effectCode {
    // 启动视频预览
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
    
    if (self.videoProgress >= 1) {
        self.videoProgress = 0;
    }
    
    // 开启视频特效处理
    self.currentCode = effectCode;
    [self.filterProcessor switchFilterWithCode:effectCode];
   
    // 添加记录
    EffectsTimeLineModel *effectModel = [EffectsTimeLineModel new];
    effectModel.startProgress = self.videoProgress;
    effectModel.effectsCode = effectCode;
    [self.effectsModels addObject:effectModel];
    
    // 开始更新特效 UI
    [self.effectsView.displayView addSegmentViewBeginWithStartLocation:self.videoProgress WithColor:[self.displayColors objectAtIndex:[self.videoEffects indexOfObject:effectCode]]];
    
    // begin 和 end 成对调用
    [self.effectTools addEffectBegin:effectCode withProgress:self.videoProgress];
}

#pragma mark -- 停止添加视频特效
- (void)effectsEndWithCode:(NSString *)effectCode {
    if (self.currentCode) {
        // 停止视频预览
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = YES;
        
        // 结束视频特效处理
        self.currentCode = nil;
        [self.filterProcessor switchFilterWithCode:nil];
        
        // 修改结束时间
        EffectsTimeLineModel *effectModel = self.effectsModels.lastObject;
        if (effectModel) {
            effectModel.endProgress = self.videoProgress;
        }
        
        // 结束更新特效 UI
        [self.effectsView.displayView addSegmentViewEnd];
        
        // begin 和 end 成对调用
        [self.effectTools addEffectEnd:effectCode withProgress:self.videoProgress];
    }
}

#pragma mark -- TuSDKFilterProcessorDelegate

// 滤镜切换的回调
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor filterChanged:(TuSDKFilterWrap *)newFilter {
    // nothing
    NSLog(@"%s", __func__);
}
// TuSDK mark end

// 视频 seek 操作
- (void)editorSeekEvent:(UISlider *)slider {
    CMTime destTime = CMTimeMake(slider.value * 1e9, 1e9);
    
    NSLog(@"%s, line: %d, seek to time: %f", __func__, __LINE__, CMTimeGetSeconds(destTime));
    
    [self.shortVideoEditor seekToTime:destTime completionHandler:nil];
    
    self.videoProgress = CMTimeGetSeconds(destTime)/self.videoTotalTime;
}

#pragma mark -- 启动/暂停视频预览
- (void)playButtonClicked:(UIButton *)button {
    if (self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = YES;
    } else {
        [self.shortVideoEditor startEditing];
        self.playButton.selected = NO;
    }
}

#pragma mark -- 滤镜资源
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

#pragma mark -- 音乐资源
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

#pragma mark -- MV资源
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

#pragma mark -- 加载 collectionView 视图
- (UICollectionView *)editCollectionView {
    if (!_editCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(90, 105);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _editCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, layout.itemSize.height) collectionViewLayout:layout];
        _editCollectionView.backgroundColor = [UIColor clearColor];
        
        _editCollectionView.showsHorizontalScrollIndicator = NO;
        _editCollectionView.showsVerticalScrollIndicator = NO;
        [_editCollectionView setExclusiveTouch:YES];
        
        [_editCollectionView registerClass:[PLSEditVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class])];
        
        _editCollectionView.delegate = self;
        _editCollectionView.dataSource = self;
    }
    return _editCollectionView;
}

#pragma mark -- 获取音乐文件的封面
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

#pragma mark -- UICollectionView delegate  用来展示和处理 SDK 内部自带的滤镜、音乐、MV效果
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.selectionViewIndex == 0) {
        // 滤镜
        return self.filtersArray.count;
        
    } else if (self.selectionViewIndex == 1) {
        // 音乐
        return self.musicsArray.count;
        
    } else
        // MV
        return self.mvArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSEditVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class]) forIndexPath:indexPath];
    [cell setLabelFrame:CGRectMake(0, 0, 90, 15) imageViewFrame:CGRectMake(0, 15, 90, 90)];

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
    }
    
    return  cell;
}

#pragma mark -- 切换滤镜、背景音乐、MV 特效
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
            
            self.audioSettings[PLSURLKey] = [NSNull null];
            self.audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:0.f];
            self.audioSettings[PLSNameKey] = musicName;

        } else {
            
            NSDictionary *dic = self.musicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
            
            self.audioSettings[PLSURLKey] = musicUrl;
            self.audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self getFileDuration:musicUrl]];
            self.audioSettings[PLSNameKey] = musicName;
            
        }
        
        NSURL *musicURL = self.audioSettings[PLSURLKey];
        CMTimeRange musicTimeRange= CMTimeRangeMake(CMTimeMake([self.audioSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9), CMTimeMake([self.audioSettings[PLSDurationKey] floatValue] * 1e9, 1e9));
        NSNumber *musicVolume = self.audioSettings[PLSVolumeKey];
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
    }
}

#pragma mark -- 添加/更新 MV 特效、滤镜、背景音乐 等效果
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
     
     // 添加／移除 背景音乐
    [self.shortVideoEditor addMusic:musicURL timeRange:timeRange volume:volume];
}

- (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume {
    // 更新 背景音乐 的 播放时间区间、音量
    [self.shortVideoEditor updateMusic:timeRange volume:volume];
}

#pragma mark -- PLShortVideoEditorDelegate 编辑时处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    //此处可以做美颜/滤镜等处理
//    NSLog(@"%s, line:%d, timestamp:%f", __FUNCTION__, __LINE__, CMTimeGetSeconds(timestamp));
    
    // 更新编辑时的预览进度条
    self.progressSlider.value = CMTimeGetSeconds(timestamp);
    
    // TuSDK mark
    self.videoProgress = CMTimeGetSeconds(timestamp) / self.videoTotalTime;
    NSLog(@"isEditing:%d, timestamp: %f, videoProgress: %f", self.shortVideoEditor.isEditing, CMTimeGetSeconds(timestamp), self.videoProgress);
    
    CVPixelBufferRef tempPixelBuffer = pixelBuffer;
    
    tempPixelBuffer = [self.filterProcessor syncProcessPixelBuffer:pixelBuffer frameTime:timestamp];
    [self.filterProcessor destroyFrameData];
    [self.effectsView.displayView addSegmentViewMoveToLocation:self.videoProgress];
    self.effectsView.displayView.currentLocation = self.videoProgress;
    
    // TuSDK mark - 添加特效时，与预览是两个不同的逻辑，添加过程中返回 NO 特效不会进行切换
    if ([self.effectTools needSwitchEffectWithProgress:self.videoProgress]) {
        [self.filterProcessor switchFilterWithCode:[self.effectTools currentEffectCode]];
    }
    
    return tempPixelBuffer;
}

- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReadyToPlayForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange {
    // TuSDK mark
    self.videoProgress = 0.0;
    
    [self printTimeRange:timeRange];
    NSLog(@"%s, videoProgress: %f", __func__, self.videoProgress);
    
    self.playButton.selected = NO;
}

- (void)shortVideoEditor:(PLShortVideoEditor *)editor didReachEndForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange {
    // TuSDK mark
    self.videoProgress = 1.0;
    
    [self printTimeRange:timeRange];
    NSLog(@"%s, videoProgress: %f", __func__, self.videoProgress);

    // TuSDK mark - progress 为 1 时，也需要进行 effectCode 判断，因为添加过程中，effectsEndWithCode: 执行之前来限制正在添加的过程中不进行特效切换
    // TuSDK mark - 添加特效时，与预览是两个不同的逻辑，添加过程中返回 NO 特效不会进行切换
    if ([self.effectTools needSwitchEffectWithProgress:self.videoProgress]) {
        [self.filterProcessor switchFilterWithCode:[self.effectTools currentEffectCode]];
    }
    
    NSString *effectCode = self.currentCode;
//    [self effectsEndWithCode:self.currentCode];

    // 结束视频特效处理
    self.currentCode = nil;
    [self.filterProcessor switchFilterWithCode:nil];
    
    // 修改结束时间
    EffectsTimeLineModel *effectModel = self.effectsModels.lastObject;
    if (effectModel) {
        effectModel.endProgress = self.videoProgress;
    }
    
    // 结束更新特效 UI
    [self.effectsView.displayView addSegmentViewEnd];
    
    // begin 和 end 成对调用
    [self.effectTools addEffectEnd:effectCode withProgress:self.videoProgress];
}

#pragma mark --  PLSAVAssetExportSessionDelegate 合成视频文件给视频数据加滤镜效果的回调
- (CVPixelBufferRef)assetExportSession:(PLSAVAssetExportSession *)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    // 视频数据可用来做滤镜处理，将滤镜效果写入视频文件中
//    NSLog(@"%s, line:%d, timestamp:%f", __FUNCTION__, __LINE__, CMTimeGetSeconds(timestamp));

    // TuSDK mark
    [self managerEffectsWithTimestamp:timestamp];
    CVPixelBufferRef newPixelBuffer = [self.filterProcessor syncProcessPixelBuffer:pixelBuffer frameTime:timestamp];
    [self.filterProcessor destroyFrameData];
    
    return newPixelBuffer;
}

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 滤镜
- (void)filterButtonClick:(id)sender {
    [self setEffectsViewHidden];
    
    if (self.selectionViewIndex == 0) {
        return;
    }
    self.selectionViewIndex = 0;
    [self.editCollectionView reloadData];
}

#pragma mark -- 配音
- (void)dubAudioButtonEvent:(id)sender{
    [self setEffectsViewHidden];

    DubViewController *dubViewController = [[DubViewController alloc]init];
    dubViewController.movieSettings = self.movieSettings;
    dubViewController.delegate = self;
    [self presentViewController:dubViewController animated:YES completion:nil];
}

#pragma mark -- DubViewControllerDelegate 配音的回调
- (void)didOutputAsset:(AVAsset *)asset {
    NSLog(@"保存配音后的回调");
    
    self.movieSettings[PLSAssetKey] = asset;
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
    
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    [self.shortVideoEditor replaceCurrentAssetWithAsset:self.movieSettings[PLSAssetKey]];
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
}

#pragma mark -- 背景音乐
- (void)musicButtonClick:(id)sender {
    [self setEffectsViewHidden];

    if (self.selectionViewIndex == 1) {
        return;
    }
    self.selectionViewIndex = 1;
    [self.editCollectionView reloadData];
}

#pragma mark -- MV 特效
- (void)mvButtonClick:(id)sender {
    [self setEffectsViewHidden];

    if (self.selectionViewIndex == 2) {
        return;
    }
    self.selectionViewIndex = 2;
    [self.editCollectionView reloadData];
}

#pragma mark -- 制作Gif图
- (void)formatGifButtonEvent:(id)sender {
    [self setEffectsViewHidden];

    [self joinGifFormatViewController];
}

#pragma mark -- 时光倒流
- (void)reverserButtonEvent:(id)sender {
    [self setEffectsViewHidden];

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

#pragma mark -- 裁剪背景音乐
- (void)clipMusicButtonEvent:(id)sender {
    [self setEffectsViewHidden];

    CMTimeRange currentMusicTimeRange = CMTimeRangeMake(CMTimeMake([self.audioSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9), CMTimeMake([self.audioSettings[PLSDurationKey] floatValue] * 1e9, 1e9));
    
    PLSClipAudioView *clipAudioView = [[PLSClipAudioView alloc] initWithMuiscURL:self.audioSettings[PLSURLKey] timeRange:currentMusicTimeRange];
    clipAudioView.delegate = self;
    [clipAudioView showAtView:self.view];
}

#pragma mark -- 音量调节
- (void)volumeChangeEvent:(id)sender {
    [self setEffectsViewHidden];

    NSNumber *movieVolume = self.movieSettings[PLSVolumeKey];
    NSNumber *musicVolume = self.audioSettings[PLSVolumeKey];

    PLSAudioVolumeView *volumeView = [[PLSAudioVolumeView alloc] initWithMovieVolume:[movieVolume floatValue] musicVolume:[musicVolume floatValue]];
    volumeView.delegate = self;
    [volumeView showAtView:self.view];
}

#pragma mark -- 关闭原声
- (void)closeSoundButtonEvent:(UIButton *)button {
    [self setEffectsViewHidden];

    button.selected = !button.selected;
    
    if (button.selected) {
        self.shortVideoEditor.volume = 0.0f;
    } else {
        self.shortVideoEditor.volume = 1.0f;
    }
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:self.shortVideoEditor.volume];
}

#pragma mark -- 旋转视频
- (void)rotateVideoButtonEvent:(UIButton *)button {
    [self setEffectsViewHidden];

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

#pragma mark -- 添加文字、图片、涂鸦
- (void)addTextButtonEvent:(UIButton *)button {
    [self setEffectsViewHidden];
    
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    if (![self checkMovieHasVideoTrack:asset]) {
        NSString *errorInfo = @"Error: movie has no videoTrack";
        NSLog(@"%s, %@", __func__, errorInfo);
        AlertViewShow(errorInfo);
        return;
    }

    PLSVideoEditingController *videoEditingVC = [[PLSVideoEditingController alloc] init];
    videoEditingVC.videoLayerOrientation = self.videoLayerOrientation;
    videoEditingVC.delegate = self;
    if (self.videoEdit) {
        videoEditingVC.videoEdit = self.videoEdit;
    } else {
        AVAsset *asset = self.movieSettings[PLSAssetKey];
        CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
        CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
        CMTimeRange timeRange = CMTimeRangeMake(start, duration);
        [videoEditingVC setVideoAsset:asset timeRange:timeRange placeholderImage:nil];
    }
    
    [self presentViewController:videoEditingVC animated:YES completion:nil];
}

#pragma mark -- 视频列表
- (void)videoListButtonEvent:(UIButton *)button {
    [self setEffectsViewHidden];

    button.selected = !button.selected;
    if (button.selected) {
        [self loadVideoListView];
    } else {
        [self removeVideoListView];
    }
}

#pragma mark - PLSVideoEditingControllerDelegate 涂鸦、文字、贴纸效果的回调
- (void)VideoEditingController:(PLSVideoEditingController *)videoEditingVC didCancelPhotoEdit:(PLSVideoEdit *)videoEdit {
    [videoEditingVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)VideoEditingController:(PLSVideoEditingController *)videoEditingVC didFinishPhotoEdit:(PLSVideoEdit *)videoEdit {
    self.videoEdit = videoEdit;
    
    [videoEditingVC dismissViewControllerAnimated:YES completion:nil];
    
    // 重置视频的方向
    self.videoLayerOrientation = PLSPreviewOrientationPortrait;
    [self.shortVideoEditor resetVideoLayerOrientation];
    AVAsset *asset = nil;
    
    if (self.videoEdit && self.videoEdit.editFinalURL) {
        // 更新视频
        NSURL *url = self.videoEdit.editFinalURL;
        asset = [AVAsset assetWithURL:url];
        
        self.isNeedVideoEdit = YES;
        
    } else {
        // 更新视频
        asset = self.movieSettings[PLSAssetKey];
      
        self.isNeedVideoEdit = NO;
    }
    
    [self.shortVideoEditor replaceCurrentAssetWithAsset:asset];
    [self.shortVideoEditor startEditing];
    self.playButton.selected = NO;
}

#pragma mark -- PLSClipAudioViewDelegate 裁剪背景音乐 的 回调
// 裁剪背景音乐
- (void)clipAudioView:(PLSClipAudioView *)clipAudioView musicTimeRangeChangedTo:(CMTimeRange)musicTimeRange {
    self.audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(musicTimeRange.start)];
    self.audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(musicTimeRange.duration)];
    
    // 从 CMTimeGetSeconds(musicTimeRange.start) 开始播放
    [self updateMusic:musicTimeRange volume:nil];
}

#pragma mark -- PLSAudioVolumeViewDelegate 音量调节 的 回调
// 调节视频和背景音乐的音量
- (void)audioVolumeView:(PLSAudioVolumeView *)volumeView movieVolumeChangedTo:(CGFloat)movieVolume musicVolumeChangedTo:(CGFloat)musicVolume {
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:movieVolume];
    self.audioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:musicVolume];
    
    self.shortVideoEditor.volume = movieVolume;
    
    [self updateMusic:kCMTimeRangeZero volume:self.audioSettings[PLSVolumeKey]];
}

#pragma mark -- PLSRateButtonViewDelegate 倍速处理
- (void)rateButtonView:(PLSRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex {
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


    AVAsset *outputAsset = nil;
    if (self.videoEdit && self.videoEdit.editFinalURL) {
        NSURL *url = self.videoEdit.editFinalURL;
        AVAsset *asset = [AVAsset assetWithURL:url];
        
        // PLShortVideoAsset 初始化
        PLShortVideoAsset *shortVideoAsset = [[PLShortVideoAsset alloc] initWithAsset:asset];
        CMTime originStart = kCMTimeZero;
        CMTime originDuration = asset.duration;
        
        // 倍数处理
        outputAsset = [shortVideoAsset scaleTimeRange:CMTimeRangeMake(originStart, originDuration) toRateType:rateType];
        
        // 处理后的视频信息
        self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(kCMTimeZero)];
        
        self.isNeedVideoEdit = NO;
        
    } else {
        // PLShortVideoAsset 初始化
        PLShortVideoAsset *shortVideoAsset = [[PLShortVideoAsset alloc] initWithAsset:self.originMovieSettings[PLSAssetKey]];
        CMTime originStart = CMTimeMake([self.originMovieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
        CMTime originDuration = CMTimeMake([self.originMovieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
        
        // 倍数处理
        outputAsset = [shortVideoAsset scaleTimeRange:CMTimeRangeMake(originStart, originDuration) toRateType:rateType];
    }

    // 处理后的视频信息
    self.movieSettings[PLSAssetKey]  = outputAsset;
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(outputAsset.duration)];
    
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
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

#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;
    
    // TuSDK mark 导出带视频特效的视频时，先重置标记位
    [self resetExportVideoEffectsMark];

    [self loadActivityIndicatorView];
    
    if (self.isNeedVideoEdit) {
        // 说明加了文字、图片、涂鸦特效
        if (self.videoEdit && self.videoEdit.editFinalURL) {
            NSURL *url = self.videoEdit.editFinalURL;
            AVAsset *asset = [AVAsset assetWithURL:url];
            self.movieSettings[PLSAssetKey] = asset;
            self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
        }
    }

    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    exportSession.delegate = self;
    exportSession.isExportMovieToPhotosAlbum = YES;
    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize = self.videoSize;
    // 旋转视频
    exportSession.videoLayerOrientation = self.videoLayerOrientation;
    [exportSession addFilter:self.colorImagePath];
    [exportSession addMVLayerWithColor:self.colorURL alpha:self.alphaURL];
    
    __weak typeof(self) weakSelf = self;
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");

        // TuSDK mark 视频特效预览，先重置标记位
        [weakSelf resetPreviewVideoEffectsMark];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf joinNextViewController:url];
        });
    }];
    
    [exportSession setFailureBlock:^(NSError *error) {
        NSLog(@"Asset Export Failed: %@", error);

        // TuSDK mark 视频特效预览，先重置标记位
        [weakSelf resetPreviewVideoEffectsMark];
        
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
    
#pragma mark -- 进入 Gif 制作页面
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

#pragma mark -- 完成视频合成跳转到下一页面
- (void)joinNextViewController:(NSURL *)url {
    [self removeActivityIndicatorView];
    
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.url = url;
    [self presentViewController:playViewController animated:YES completion:nil];
}

#pragma mark -- 程序的状态监听
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

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- dealloc
- (void)dealloc {
    self.shortVideoEditor.delegate = nil;
    self.shortVideoEditor = nil;
    
    self.reverser = nil;

    self.editCollectionView.dataSource = nil;
    self.editCollectionView.delegate = nil;
    self.editCollectionView = nil;
    self.filtersArray = nil;
    self.musicsArray = nil;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end

