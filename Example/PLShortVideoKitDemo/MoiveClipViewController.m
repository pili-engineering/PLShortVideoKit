//
//  MoiveClipViewController.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/9/18.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MoiveClipViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSClipMovieView.h"
#import <Masonry/Masonry.h>
#import "EditViewController.h"

#define PLS_BaseToolboxView_HEIGHT 64


typedef enum : NSUInteger {
    enumPanPositionTopLeft,
    enumPanPositionTopRight,
    enumPanPositionBottomLeft,
    enumPanPositionBottomRight,
    enumPanPositionCenter,
} EnumPanPosition;

@interface MoiveClipViewController ()
<
PLSClipMovieViewDelegate,
PLShortVideoEditorDelegate
>

// 视图
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;

// 选取需要的视频段
@property (strong, nonatomic) PLSClipMovieView *clipMovieView;


// 编辑
@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;
// 要编辑的视频的信息
@property (strong, nonatomic) NSMutableDictionary *movieSettings;

@property (strong, nonatomic) AVAsset *asset;
@end

@implementation MoiveClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // --------------------------
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    // --------------------------
    // 编辑类
    [self setupShortVideoEditor];
    
    // 配置工具视图
    [self setupBaseToolboxView];
    
    [self setupClipMovieView];
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

#pragma mark - 编辑类
- (void)setupShortVideoEditor {
    // 待编辑的原始视频素材
    self.movieSettings = [[NSMutableDictionary alloc] init];
    AVAsset *asset = [AVAsset assetWithURL:self.url];
    self.movieSettings[PLSURLKey] = self.url;
    self.movieSettings[PLSAssetKey] = asset;
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    
    // 剪裁使用到
    self.asset = asset;
    
    // 视频编辑类
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset videoSize:CGSizeZero];
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    
    // 视频的预览视图
    self.shortVideoEditor.previewView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - 64 - 145);
    [self.view addSubview:self.shortVideoEditor.previewView];
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
    backButton.frame = CGRectMake(0, 20, 80, 44);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 44)];
    if (iPhoneX_SERIES) {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 58);
    } else {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 42);
    }
    titleLabel.text = @"剪辑";
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
    nextButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 20, 80, 44);
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:nextButton];
}

- (void)setupClipMovieView {
    CGFloat duration = [self getFileDuration:self.url];
    self.clipMovieView = [[PLSClipMovieView alloc] initWithMovieURL:self.url minDuration:2.0f maxDuration:duration];
    self.clipMovieView.delegate = self;
    [self.view addSubview:self.clipMovieView];
    [self.clipMovieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(145);
    }];
}

#pragma mark - PLSClipMovieView delegate
- (void)didStartDragView {
    
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime {
    CGFloat start = CMTimeGetSeconds(leftTime);
    CGFloat end = CMTimeGetSeconds(rightTime);
    CGFloat duration = end - start;
    
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:start];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:duration];
    
    self.shortVideoEditor.timeRange = CMTimeRangeMake(leftTime, CMTimeSubtract(rightTime, leftTime));
    [self.shortVideoEditor startEditing];
}

- (void)clipFrameView:(PLSClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling {
    self.view.userInteractionEnabled = !scrolling;
}

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

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    outputSettings[PLSMovieSettingsKey] = self.movieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.filesURLArray = @[_url];
    videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
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

#pragma mark -- 计算文件的大小，单位为 M
- (CGFloat)fileSize:(NSURL *)url {
    return [[NSData dataWithContentsOfURL:url] length] / 1024.00 / 1024.00;
}

#pragma mark -- 获取视频／音频文件的总时长
- (CGFloat)getFileDuration:(NSURL*)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:opts];
    
    CMTime duration = asset.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    
    return durationSeconds;
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
}

- (void)shortVideoEditorDidBecomeActiveEvent:(id)sender {
    NSLog(@"[self.shortVideoEditor UIApplicationDidBecomeActiveNotification]");
    [self.shortVideoEditor startEditing];
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
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
