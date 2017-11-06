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

#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)


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
PLSAVAssetExportSessionDelegate
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
//时光倒流
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


@end

@implementation EditViewController

#pragma mark -- 获取视频／音频文件的总时长
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

#pragma mark -- viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --------------------------
    [self setupBaseToolboxView];
    [self setupEditToolboxView];
    [self setupMergeToolboxView];
    
    // 视频的分辨率，设置之后影响编辑时的预览分辨率、导出的视频的的分辨率
    self.videoSize = CGSizeMake(544, 960);
    
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
    self.originMovieSettings = [[NSMutableDictionary alloc] init];
    [self.originMovieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];

   
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset videoSize:CGSizeZero];
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    self.shortVideoEditor.previewView.frame = CGRectMake(0, 64, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
    self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.view addSubview:self.shortVideoEditor.previewView];
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    // 视频编辑时，添加水印
    [self.shortVideoEditor setWaterMarkWithImage:watermarkImage position:self.watermarkPosition];
    // 视频编辑时，改变预览分辨率
    self.shortVideoEditor.videoSize = self.videoSize;
    
    // 滤镜
    self.filterGroup = [[PLSFilterGroup alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self observerUIApplicationStatusForShortVideoEditor];
    
    [self.shortVideoEditor startEditing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObserverUIApplicationStatusForShortVideoEditor];
    
    [self.shortVideoEditor stopEditing];
}

#pragma mark -- 配置视图
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
    titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
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
    self.editToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - 64 - PLS_SCREEN_WIDTH)];
    self.editToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.editToolboxView];
    
    UIScrollView *buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 35)];
    buttonScrollView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    buttonScrollView.contentSize = CGSizeMake(582, 35);
    buttonScrollView.contentOffset = CGPointMake(0, 0);
    buttonScrollView.pagingEnabled = YES;
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

    
    // 倍数处理
    self.titleArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    self.titleIndex = 2;
    PLSRateButtonView *rateButtonView = [[PLSRateButtonView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 270, 40, 260, 34) defaultIndex:self.titleIndex];
    rateButtonView.hidden = NO;
    CGFloat countSpace = 200 /self.titleArray.count / 6;
    rateButtonView.space = countSpace;
    rateButtonView.staticTitleArray = self.titleArray;
    rateButtonView.rateDelegate = self;
    [self.editToolboxView addSubview:rateButtonView];
    
    // 展示滤镜、音乐、字幕列表效果的 UICollectionView
    CGRect frame = self.editCollectionView.frame;
    self.editCollectionView.frame = CGRectMake(0, 80, frame.size.width, frame.size.height);
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

#pragma mark -- 滤镜资源
- (NSArray<NSDictionary *> *)filtersArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // 滤镜
    for (NSDictionary *filterInfoDic in self.filterGroup.filtersInfo) {
        NSString *name = [filterInfoDic objectForKey:@"name"];
        NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
        
        NSDictionary *dic = @{
                              @"name"            : name,
                              @"coverImagePath"  : coverImagePath
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

#pragma mark -- UICollectionView delegate  用来展示和处理 SDK 内部自带的滤镜效果
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
        
        cell.iconPromptLabel.text = name;
        cell.iconImageView.image = [UIImage imageWithContentsOfFile:coverImagePath];
        
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
    
    [self.shortVideoEditor addMVLayerWithColor:self.colorURL alpha:self.alphaURL];
}

- (void)addFilter:(NSString *)colorImagePath {
    // 添加／移除 滤镜
    self.colorImagePath = colorImagePath;
    
    [self.shortVideoEditor addFilter:self.colorImagePath];
}
     
 - (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume {
     // 添加／移除 背景音乐
    [self.shortVideoEditor addMusic:musicURL timeRange:timeRange volume:volume];
}

- (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume {
    // 更新 背景音乐 的 播放时间区间、音量
    [self.shortVideoEditor updateMusic:timeRange volume:volume];
}

#pragma mark -- PLShortVideoEditorDelegate 编辑时处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    
    return pixelBuffer;
}

#pragma mark --  PLSAVAssetExportSessionDelegate 合成视频文件给视频数据加滤镜效果的回调
- (CVPixelBufferRef)assetExportSession:(PLSAVAssetExportSession *)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // 视频数据可用来做滤镜处理，将滤镜效果写入视频文件中
    
    return pixelBuffer;
}

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 滤镜
- (void)filterButtonClick:(id)sender {
    if (self.selectionViewIndex == 0) {
        return;
    }
    self.selectionViewIndex = 0;
    [self.editCollectionView reloadData];
}

#pragma mark -- 配音
- (void)dubAudioButtonEvent:(id)sender{
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
}

#pragma mark -- 背景音乐
- (void)musicButtonClick:(id)sender {
    if (self.selectionViewIndex == 1) {
        return;
    }
    self.selectionViewIndex = 1;
    [self.editCollectionView reloadData];
}

#pragma mark -- MV 特效
- (void)mvButtonClick:(id)sender {
    if (self.selectionViewIndex == 2) {
        return;
    }
    self.selectionViewIndex = 2;
    [self.editCollectionView reloadData];
}

#pragma mark -- 制作Gif图
- (void)formatGifButtonEvent:(id)sender {
    [self joinGifFormatViewController];
}

#pragma mark -- 时光倒流
- (void)reverserButtonEvent:(id)sender {
    [self.shortVideoEditor stopEditing];
    
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
    }];
    
    [self.reverser setFailureBlock:^(NSError *error){
        [weakSelf removeActivityIndicatorView];

        NSLog(@"reverser effect, error: %@",error);
        
        weakSelf.movieSettings[PLSAssetKey] = weakSelf.inputAsset;
        
        [weakSelf.shortVideoEditor replaceCurrentAssetWithAsset:weakSelf.movieSettings[PLSAssetKey]];
        [weakSelf.shortVideoEditor startEditing];
    }];
    
    [self.reverser setProcessingBlock:^(float progress) {
        NSLog(@"reverser effect, progress: %f", progress);
    }];
    
    [self.reverser startReversing];
}

#pragma mark -- 裁剪背景音乐
- (void)clipMusicButtonEvent:(id)sender {
    CMTimeRange currentMusicTimeRange = CMTimeRangeMake(CMTimeMake([self.audioSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9), CMTimeMake([self.audioSettings[PLSDurationKey] floatValue] * 1e9, 1e9));
    
    PLSClipAudioView *clipAudioView = [[PLSClipAudioView alloc] initWithMuiscURL:self.audioSettings[PLSURLKey] timeRange:currentMusicTimeRange];
    clipAudioView.delegate = self;
    [clipAudioView showAtView:self.view];
}

#pragma mark -- 音量调节
- (void)volumeChangeEvent:(id)sender {
    NSNumber *movieVolume = self.movieSettings[PLSVolumeKey];
    NSNumber *musicVolume = self.audioSettings[PLSVolumeKey];

    PLSAudioVolumeView *volumeView = [[PLSAudioVolumeView alloc] initWithMovieVolume:[movieVolume floatValue] musicVolume:[musicVolume floatValue]];
    volumeView.delegate = self;
    [volumeView showAtView:self.view];
}

#pragma mark -- 关闭原声
- (void)closeSoundButtonEvent:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
        self.shortVideoEditor.volume = 0.0f;
    } else {
        self.shortVideoEditor.volume = 1.0f;
    }
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:self.shortVideoEditor.volume];
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
    
    /// PLShortVideoAsset 初始化
    PLShortVideoAsset *shortVideoAsset = [[PLShortVideoAsset alloc]initWithAsset:self.originMovieSettings[PLSAssetKey]];
    CMTime originStart = CMTimeMake([self.originMovieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime originDuration = CMTimeMake([self.originMovieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
    
    /// 倍数处理
    AVAsset *outputAsset = [shortVideoAsset scaleAsset:self.originMovieSettings[PLSAssetKey] timeRange:CMTimeRangeMake(originStart, originDuration) rateType:rateType];
    
    /// 处理后的视频信息
    CGFloat scaleFloat = [self getRateNumberWithRateType:rateType];
    self.movieSettings[PLSAssetKey]  = outputAsset;
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.originMovieSettings[PLSDurationKey] floatValue] * scaleFloat];
    
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    [self.shortVideoEditor replaceCurrentAssetWithAsset:outputAsset];
    [self.shortVideoEditor startEditing];
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

    [self loadActivityIndicatorView];

    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    exportSession.delegate = self;
    exportSession.isExportMovieToPhotosAlbum = YES;
    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize = self.videoSize;
    [exportSession addFilter:self.colorImagePath];
    [exportSession addMVLayerWithColor:self.colorURL alpha:self.alphaURL];
    [exportSession exportAsynchronously];
    
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
        });
    }];
    
    [exportSession setProcessingBlock:^(float progress) {
        // 更新进度 UI
        NSLog(@"Asset Export Progress: %f", progress);
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
    }];
}
    
#pragma mark -- 进入 Gif 制作页面
- (void)joinGifFormatViewController {
    AVAsset *asset = self.movieSettings[PLSAssetKey];

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
}

- (void)shortVideoEditorDidBecomeActiveEvent:(id)sender {
    NSLog(@"[self.shortVideoEditor UIApplicationDidBecomeActiveNotification]");
    [self.shortVideoEditor startEditing];
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

