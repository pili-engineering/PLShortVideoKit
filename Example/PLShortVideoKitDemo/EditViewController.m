//
//  EditViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/4/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "EditViewController.h"
#import "PLSEditVideoCell.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PlayViewController.h"
#import "PLSAudioVolumeView.h"
#import "PLSClipAudioView.h"
#import "PLSFilterGroup.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Stalker.h"

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
PLSEditPlayerDelegate,
PLSAVAssetExportSessionDelegate
>

// 水印
@property (strong, nonatomic) NSURL *watermarkURL;
@property (assign, nonatomic) CGSize watermarkSize;
@property (assign, nonatomic) CGPoint watermarkPosition;

// 编辑
@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;
// 编辑信息, movieSettings, audioSettings, watermarkSettings 为 outputSettings 的字典元素
@property (strong, nonatomic) NSMutableDictionary *outputSettings;
@property (strong, nonatomic) NSMutableDictionary *movieSettings;
@property (strong, nonatomic) NSMutableDictionary *audioSettings;
@property (strong, nonatomic) NSMutableDictionary *watermarkSettings;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *editToolboxView;

// 所有滤镜
@property (strong, nonatomic) PLSFilterGroup *filterGroup;
// 展示所有滤镜的集合视图
@property (strong, nonatomic) UICollectionView *editVideoCollectionView;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersArray;
@property (assign, nonatomic) NSInteger filterIndex;

@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UICollectionView *musicCollectionView;
@property (strong, nonatomic) NSMutableArray *musicsArray;

// 视频
@property (strong, nonatomic) NSTimer *moviePlayTimeCheckerTimer;
@property (assign, nonatomic) CGFloat movieCurrentTime;

@end

@implementation EditViewController
{
    PlayViewController *playViewController;
}

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
    
    // 水印图片地址
    NSString *watermarkPath = [[NSBundle mainBundle] pathForResource:@"qiniu_logo" ofType:@".png"];
    UIImage *watermarkImage = [UIImage imageWithContentsOfFile:watermarkPath];
    self.watermarkURL = [NSURL URLWithString:watermarkPath];
    self.watermarkSize = watermarkImage.size;
    self.watermarkPosition = CGPointMake(10, 65);
    
    // 编辑
    /* outputSettings 中的字典元素为 movieSettings, audioSettings, watermarkSettings */
    self.outputSettings = [[NSMutableDictionary alloc] init];
    self.movieSettings = [[NSMutableDictionary alloc] init];
    self.audioSettings = [[NSMutableDictionary alloc] init];
    self.watermarkSettings = [[NSMutableDictionary alloc] init];
    self.outputSettings[PLSMovieSettingsKey] = self.movieSettings;
    self.outputSettings[PLSAudioSettingsKey] = self.audioSettings;
    self.outputSettings[PLSWatermarkSettingsKey] = self.watermarkSettings;
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];
    self.watermarkSettings[PLSURLKey] = self.watermarkURL;
    self.watermarkSettings[PLSSizeKey] = [NSValue valueWithCGSize:self.watermarkSize];
    self.watermarkSettings[PLSPointKey] = [NSValue valueWithCGPoint:self.watermarkPosition];
    
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset];
    self.shortVideoEditor.player.delegate = self;
    self.shortVideoEditor.player.loopEnabled = YES;
    self.shortVideoEditor.player.preview.frame = CGRectMake(0, 64, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
    self.shortVideoEditor.player.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.view addSubview:self.shortVideoEditor.player.preview];
    // 播放预览时，加水印
    [self.shortVideoEditor.player setWaterMarkWithImage:watermarkImage position:CGPointMake(10, 65)];
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1e9, 1e9);
    self.shortVideoEditor.player.timeRange = CMTimeRangeMake(start, duration);
    self.shortVideoEditor.audioPlayer.loopEnabled = YES;
    
    // 滤镜
    self.filterGroup = [[PLSFilterGroup alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // player
    [self.shortVideoEditor.player.stalker when:UIApplicationWillResignActiveNotification then:^(NSNotification *notification) {
        NSLog(@"[shortVideoEditor.player UIApplicationWillResignActiveNotification]");
        [self.shortVideoEditor.player pause];
    }];
    [self.shortVideoEditor.player.stalker when:UIApplicationDidBecomeActiveNotification then:^(NSNotification *notification) {
        NSLog(@"[shortVideoEditor.player, UIApplicationDidBecomeActiveNotification]");
        [self.shortVideoEditor.player play];
    }];
    // audioPlayer
    [self.shortVideoEditor.audioPlayer.stalker when:UIApplicationWillResignActiveNotification then:^(NSNotification *notification) {
        NSLog(@"[shortVideoEditor.audioPlayer UIApplicationWillResignActiveNotification]");
        [self.shortVideoEditor.audioPlayer pause];
    }];
    [self.shortVideoEditor.audioPlayer.stalker when:UIApplicationDidBecomeActiveNotification then:^(NSNotification *notification) {
        NSLog(@"[shortVideoEditor.audioPlayer, UIApplicationDidBecomeActiveNotification]");
        [self.shortVideoEditor.audioPlayer play];
    }];
    [self startPlaybackTimeChecker];
    [self.shortVideoEditor.player seekToTime:CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.shortVideoEditor.player play];
    [self.shortVideoEditor.audioPlayer play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shortVideoEditor.player.stalker unobserveAll];
    [self.shortVideoEditor.audioPlayer.stalker unobserveAll];
    [self stopPlaybackTimeChecker];
    [self.shortVideoEditor.player pause];
    [self.shortVideoEditor.audioPlayer pause];
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
    
    // 滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 20, 30, 30);
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.editToolboxView addSubview:filterButton];
    
    // 裁剪背景音乐
    UIButton *clipMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clipMusicButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 140, 0, 35, 35);
    [clipMusicButton setImage:[UIImage imageNamed:@"icon_trim"] forState:UIControlStateNormal];
    [self.editToolboxView addSubview:clipMusicButton];
    [clipMusicButton addTarget:self action:@selector(clipMusicButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // 音量调节
    UIButton *volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    volumeButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 100, 0, 35, 35);
    [volumeButton setImage:[UIImage imageNamed:@"icon_volume"] forState:UIControlStateNormal];
    [self.editToolboxView addSubview:volumeButton];
    [volumeButton addTarget:self action:@selector(volumeChangeEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // 关闭原声
    UIButton *closeSoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeSoundButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60, 0, 60, 35);
    [closeSoundButton setImage:[UIImage imageNamed:@"btn_sound"] forState:UIControlStateNormal];
    [closeSoundButton setImage:[UIImage imageNamed:@"btn_close_sound"] forState:UIControlStateSelected];
    [self.editToolboxView addSubview:closeSoundButton];
    [closeSoundButton addTarget:self action:@selector(closeSoundButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // 展示滤镜效果的 UICollectionView
    CGRect frame = self.editVideoCollectionView.frame;
    self.editVideoCollectionView.frame = CGRectMake(frame.origin.x,  CGRectGetMaxY(filterButton.frame), frame.size.width, frame.size.height);
    [self.editToolboxView addSubview:self.editVideoCollectionView];
    [self.editVideoCollectionView reloadData];
    
    // 音乐
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake(0, CGRectGetMaxY(self.editVideoCollectionView.frame) + 10, 30, 30);
    [musicButton setTitle:@"音乐" forState:UIControlStateNormal];
    [musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    musicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.editToolboxView addSubview:musicButton];

    // 展示音乐效果的 UICollectionView
    frame = self.musicCollectionView.frame;
    self.musicCollectionView.frame = CGRectMake(frame.origin.x, CGRectGetMaxY(musicButton.frame), frame.size.width, frame.size.height);
    [self.editToolboxView addSubview:self.musicCollectionView];
    [self.musicCollectionView reloadData];
    
    // 展示拼接视频的进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 110, 45)];
    self.progressLabel.textAlignment =  NSTextAlignmentLeft;
    self.progressLabel.textColor = [UIColor whiteColor];
    [self.editToolboxView addSubview:self.progressLabel];
    
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
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
                          @"audioName"  : @"None",
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

#pragma mark -- 加载 collectionView 视图
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

- (UICollectionView *)musicCollectionView {
    if (!_musicCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(65, 80);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _musicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, layout.itemSize.height) collectionViewLayout:layout];
        _musicCollectionView.backgroundColor = [UIColor clearColor];
        
        _musicCollectionView.showsHorizontalScrollIndicator = NO;
        _musicCollectionView.showsVerticalScrollIndicator = NO;
        [_musicCollectionView setExclusiveTouch:YES];
        
        [_musicCollectionView registerClass:[PLSEditVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class])];
        
        _musicCollectionView.delegate = self;
        _musicCollectionView.dataSource = self;
    }
    return _musicCollectionView;
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
    if (collectionView == self.editVideoCollectionView) {
        return self.filtersArray.count;
    }
    else
        return self.musicsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSEditVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class]) forIndexPath:indexPath];
    
    if (collectionView == self.editVideoCollectionView) {

        // 滤镜
        NSDictionary *filterInfoDic = self.filtersArray[indexPath.row];
        
        NSString *name = [filterInfoDic objectForKey:@"name"];
        NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
        
        cell.iconPromptLabel.text = name;
        cell.iconImageView.image = [UIImage imageWithContentsOfFile:coverImagePath];
        
        return  cell;

    }
    else {
        
        NSDictionary *dic = self.musicsArray[indexPath.row];
        NSString *musicName = [dic objectForKey:@"audioName"];
        NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
        UIImage *musicImage = [self musicImageWithMusicURL:musicUrl];

        cell.iconImageView.image = musicImage;
        cell.iconPromptLabel.text = musicName;
    }
    
    return  cell;
}

#pragma mark -- 切换背景音乐
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.editVideoCollectionView) {

        // 滤镜
        self.filterGroup.filterIndex = indexPath.row;
        
    }
    else {
        if (!indexPath.row) {
            // ****** 要特别注意此处，无音频 URL ******
            NSDictionary *dic = self.musicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            
            self.audioSettings[PLSURLKey] = [NSNull null];
            self.audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:0.f];
            self.audioSettings[PLSNameKey] = musicName;

            [self restart];

        } else {
            
            NSDictionary *dic = self.musicsArray[indexPath.row];
            NSString *musicName = [dic objectForKey:@"audioName"];
            NSURL *musicUrl = [dic objectForKey:@"audioUrl"];
            
            self.audioSettings[PLSURLKey] = musicUrl;
            self.audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            self.audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self getFileDuration:musicUrl]];
            self.audioSettings[PLSNameKey] = musicName;
            
            [self restart];
        }
    }
}

#pragma mark -- PLSClipAudioViewDelegate
// 裁剪背景音乐
- (void)clipAudioView:(PLSClipAudioView *)clipAudioView musicTimeRangeChangedTo:(CMTimeRange)musicTimeRange {
    self.audioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(musicTimeRange.start)];
    self.audioSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(musicTimeRange.duration)];
    
    // 从 CMTimeGetSeconds(musicTimeRange.start) 开始播放
    [self.shortVideoEditor.audioPlayer seekToTime:CMTimeMake(CMTimeGetSeconds(musicTimeRange.start) * 1e9, 1e9) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.shortVideoEditor.audioPlayer play];
}

#pragma mark -- PLSAudioVolumeViewDelegate
// 调节视频和背景音乐的音量
- (void)audioVolumeView:(PLSAudioVolumeView *)volumeView movieVolumeChangedTo:(CGFloat)movieVolume musicVolumeChangedTo:(CGFloat)musicVolume {
    
    self.shortVideoEditor.player.volume = movieVolume;
    self.shortVideoEditor.audioPlayer.volume = musicVolume;
    
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:movieVolume];
    self.audioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:musicVolume];
}

#pragma mark -- 视频／音频播放器重新播放
- (void)restart {
    // 影片
    [self.shortVideoEditor.player setItemByAsset:self.movieSettings[PLSAssetKey]];
    [self.shortVideoEditor.player seekToTime:CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    self.shortVideoEditor.player.volume = [self.movieSettings[PLSVolumeKey] floatValue];
    [self.shortVideoEditor.player play];
    
    // 音频重播
    [self.shortVideoEditor.audioPlayer setItemByUrl:[self checkNSNullType:self.audioSettings[PLSURLKey]]];
    [self.shortVideoEditor.audioPlayer play];
}

#pragma mark -- PLSPlayerDelegate 处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)player:(PLSEditPlayer *)player didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    
    PLSFilter *filter = self.filterGroup.currentFilter;
    pixelBuffer = [filter process:pixelBuffer];
    
    return pixelBuffer;
}

#pragma mark --  PLSAVAssetExportSessionDelegate 合成视频文件给视频数据加滤镜效果的回调
- (CVPixelBufferRef)assetExportSession:(PLSAVAssetExportSession *)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // 视频数据可用来做滤镜处理，将滤镜效果写入视频文件中
    
    PLSFilter *filter = self.filterGroup.currentFilter;
    pixelBuffer = [filter process:pixelBuffer];
    
    return pixelBuffer;
}

- (void)assetExportSession:(PLSFile *)file didOutputProgress:(CGFloat)progress {
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
}

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 裁剪背景音乐
- (void)clipMusicButtonEvent:(id)sender {
    CMTimeRange currentMusicTimeRange = CMTimeRangeMake(CMTimeMake([self.audioSettings[PLSStartTimeKey] floatValue] * 1e9, 1e9), CMTimeMake([self.audioSettings[PLSDurationKey] floatValue] * 1e9, 1e9));
    
    PLSClipAudioView *clipAudioView = [[PLSClipAudioView alloc] initWithMuiscURL:self.audioSettings[PLSURLKey] timeRange:currentMusicTimeRange];
    clipAudioView.delegate = self;
    [clipAudioView showAtView:self.view];
}

#pragma mark -- 音量调节
- (void)volumeChangeEvent:(id)sender {
    PLSAudioVolumeView *volumeView = [[PLSAudioVolumeView alloc] initWithMovieVolume:self.shortVideoEditor.player.volume musicVolume:self.shortVideoEditor.audioPlayer.volume];
    volumeView.delegate = self;
    [volumeView showAtView:self.view];
}

#pragma mark -- 关闭原声
- (void)closeSoundButtonEvent:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
        self.shortVideoEditor.player.volume = 0.0f;
    } else {
        self.shortVideoEditor.player.volume = 1.0f;
    }
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:self.shortVideoEditor.player.volume];
}

#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    [self.shortVideoEditor.player pause];
    [self.shortVideoEditor.audioPlayer pause];
    
    [self loadActivityIndicatorView];
    
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:self.shortVideoEditor.player.volume];
    self.audioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:self.shortVideoEditor.audioPlayer.volume];
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    exportSession.delegate = self;
        
    [exportSession exportAsynchronously];
    
    __weak typeof(self) weakSelf = self;
    
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf joinNextViewController:url object:weakSelf];
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

#pragma mark -- 完成视频合成跳转到下一页面
- (void)joinNextViewController:(NSURL *)url object:(id)obj {
    [obj removeActivityIndicatorView];
    
    playViewController = [[PlayViewController alloc] init];
    playViewController.url = url;
    [obj presentViewController:playViewController animated:YES completion:nil];
}

#pragma mark -- PlaybackTimeCheckerTimer
- (void)startPlaybackTimeChecker {
    [self stopPlaybackTimeChecker];
    
    self.moviePlayTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}

- (void)stopPlaybackTimeChecker {
    if (self.moviePlayTimeCheckerTimer) {
        [self.moviePlayTimeCheckerTimer invalidate];
        self.moviePlayTimeCheckerTimer = nil;
    }
}

- (void)onPlaybackTimeCheckerTimer {
    CMTime curTime = [self.shortVideoEditor.player currentTime];
    Float64 seconds = CMTimeGetSeconds(curTime);
    if (seconds < 0){
        seconds = 0; // this happens! dont know why.
    }
    self.movieCurrentTime = seconds;
    
    CGFloat startTime =  [self.movieSettings[PLSStartTimeKey] floatValue];
    CGFloat endTime = startTime + [self.movieSettings[PLSDurationKey] floatValue];
    
    if (self.movieCurrentTime >= endTime) {
        self.movieCurrentTime = startTime;
        [self seekVideoToPos:startTime];
    }
}

- (void)seekVideoToPos:(CGFloat)pos {
    self.movieCurrentTime = pos;
    CMTime time = CMTimeMakeWithSeconds(self.movieCurrentTime, self.shortVideoEditor.player.currentTime.timescale);
    NSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
    [self.shortVideoEditor.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- dealloc
- (void)dealloc {
    self.shortVideoEditor.player.delegate = nil;
    self.shortVideoEditor.player = nil;

    self.editVideoCollectionView.dataSource = nil;
    self.editVideoCollectionView.delegate = nil;
    self.editVideoCollectionView = nil;
    self.filtersArray = nil;
    
    self.musicCollectionView.dataSource = nil;
    self.musicCollectionView.delegate = nil;
    self.musicCollectionView = nil;
    self.musicsArray = nil;
    
    playViewController = nil;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    [self stopPlaybackTimeChecker];
}

@end

