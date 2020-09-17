//
//  MovieTransCodeViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/7/12.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MovieTransCodeViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import <Masonry/Masonry.h>
#import "PLSSelectionView.h"
#import "EditViewController.h"

#define PLS_BaseToolboxView_HEIGHT 64


typedef enum : NSUInteger {
    enumPanPositionTopLeft,
    enumPanPositionTopRight,
    enumPanPositionBottomLeft,
    enumPanPositionBottomRight,
    enumPanPositionCenter,
} EnumPanPosition;

@interface MovieTransCodeViewController ()
<
PLSSelectionViewDelegate,
PLShortVideoEditorDelegate
>

// 视图
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;

// 选取转码质量
@property (strong, nonatomic) PLSSelectionView *selectionView;

// 视频旋转
@property (assign, nonatomic) PLSPreviewOrientation rotateOrientation;

// 编辑
@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;
// 要编辑的视频的信息
@property (strong, nonatomic) NSMutableDictionary *movieSettings;

// 客户端转码，能压缩视频的大小 + 剪辑视频
@property (assign, nonatomic) PLSFilePreset transcoderPreset;
@property (assign, nonatomic) float bitrate;
@property (strong, nonatomic) PLShortVideoTranscoder *shortVideoTranscoder;

@property (strong, nonatomic) UIView *maxScopeView;
@property (strong, nonatomic) UIImageView *scopeView;

@property (strong, nonatomic) AVAsset *asset;
@property (assign, nonatomic) EnumPanPosition enumTapPosition;

@end

@implementation MovieTransCodeViewController

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
    
    [self setupSelectionView];
    
    [self setupScopeCutView];
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
    self.shortVideoEditor.previewView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH + 145);
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
    titleLabel.text = @"转码";
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
    
    // 展示转码的进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 200, 45)];
    self.progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    [self.baseToolboxView addSubview:self.progressLabel];
    
    // 展示转码的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupSelectionView {
    CGFloat rotateViewTopSpace;
    if (PLS_SCREEN_HEIGHT > 568) {
        rotateViewTopSpace = PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH + 5 + 145;
    } else{
        rotateViewTopSpace = PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH + 145;
    }
    
    self.selectionView = [[PLSSelectionView alloc] initWithFrame:CGRectMake(0, rotateViewTopSpace, PLS_SCREEN_WIDTH, 35) lineWidth:1 lineColor:[UIColor blackColor]];
    self.selectionView.backgroundColor = [UIColor redColor];
    [self.selectionView setItemsWithTitle:[NSArray arrayWithObjects:@"Medium", @"Highest", @"480P", @"540P", @"720P", @"1080P", nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor blackColor] normalTitleColor:[UIColor blackColor] selectTitleColor:[UIColor whiteColor] titleTextSize:15 selectItemNumber:3];
    self.selectionView.delegate = self;
    self.selectionView.layer.cornerRadius = 5.0;
    [self.view addSubview:self.selectionView];
    
    self.transcoderPreset = PLSFilePreset960x540; // 默认, 对应 selectItemNumber:3
    self.bitrate = 3000 * 1000; // 设置码率
    
    // 视频旋转
    UIButton *rotateVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateVideoButton.frame = CGRectMake(PLS_SCREEN_WIDTH/2 - 50, self.selectionView.frame.origin.y + 38, 100, 36);
    [rotateVideoButton setTitle:@"旋转视频" forState:UIControlStateNormal];
    [rotateVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rotateVideoButton.titleLabel.font = [UIFont systemFontOfSize:16];
    rotateVideoButton.layer.cornerRadius = 5;
    rotateVideoButton.layer.borderWidth = 1;
    rotateVideoButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [rotateVideoButton addTarget:self action:@selector(rotateVideoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateVideoButton];
}

- (void)setupScopeCutView {
    self.maxScopeView = [[UIView alloc] init];
    [self.shortVideoEditor.previewView addSubview:self.maxScopeView];
    self.maxScopeView.frame = [PLShortVideoTranscoder videoDisplay:self.asset bounds:self.shortVideoEditor.previewView.bounds rotate:self.rotateOrientation];
    
    self.scopeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scope_image"]];
    self.scopeView.userInteractionEnabled = YES;
    self.scopeView.layer.borderWidth = 1;
    self.scopeView.layer.borderColor = [UIColor redColor].CGColor;
    self.scopeView.frame = self.maxScopeView.bounds;
    [self.maxScopeView addSubview:self.scopeView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self.scopeView addGestureRecognizer:panGesture];
}

// 加载视频转码的动画
- (void)loadActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

// 移除视频转码的动画
- (void)removeActivityIndicatorView {
    [self.activityIndicatorView removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint transPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
    [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view];

    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
    
            CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
            CGFloat edgeWidth = self.scopeView.bounds.size.width / 3;
            CGFloat edgeHeight = self.scopeView.bounds.size.height / 3;
            if (point.x <= edgeWidth && point.y <= edgeHeight) {
                self.enumTapPosition = enumPanPositionTopLeft;
            } else if (point.x <= edgeWidth && point.y >= self.scopeView.bounds.size.height - edgeHeight) {
                self.enumTapPosition = enumPanPositionBottomLeft;
            } else if (point.x >= self.scopeView.bounds.size.width - edgeWidth && point.y <= edgeHeight) {
                self.enumTapPosition = enumPanPositionTopRight;
            } else if (point.x >= self.scopeView.bounds.size.width - edgeWidth && point.y >= self.scopeView.bounds.size.height - edgeHeight) {
                self.enumTapPosition = enumPanPositionBottomRight;
            } else {
                self.enumTapPosition = enumPanPositionCenter;
            }
            break;
            
        }
        case UIGestureRecognizerStateChanged: {
            
            CGRect rect = self.scopeView.frame;
            CGRect maxRect = self.maxScopeView.bounds;
            
            switch (self.enumTapPosition) {
                case enumPanPositionTopLeft: {
                    transPoint.x = MIN(transPoint.x, rect.size.width);
                    transPoint.y = MIN(transPoint.y, rect.size.height);
                    if (rect.origin.x + transPoint.x < 0) {
                        transPoint.x =  - rect.origin.x;
                    }
                    if (rect.origin.y + transPoint.y < 0) {
                        transPoint.y =  - rect.origin.y;
                    }
                    rect = CGRectMake(rect.origin.x + transPoint.x, rect.origin.y + transPoint.y, rect.size.width - transPoint.x, rect.size.height - transPoint.y);
                }
                    break;
                    
                case enumPanPositionTopRight: {
                    transPoint.x = MIN(maxRect.size.width - rect.size.width - rect.origin.x, transPoint.x);
                    transPoint.x = MAX(-rect.size.width, transPoint.x);
                    transPoint.y = MIN(transPoint.y, rect.size.height);
                    if (rect.origin.y + transPoint.y < 0) {
                        transPoint.y = -rect.origin.y;
                    }
                    rect = CGRectMake(rect.origin.x, rect.origin.y + transPoint.y, rect.size.width + transPoint.x, rect.size.height - transPoint.y);
                }
                    break;
                case enumPanPositionBottomLeft: {
                    transPoint.x = MIN(transPoint.x, rect.size.width);
                    if (rect.origin.x + transPoint.x < 0) {
                        transPoint.x =  - rect.origin.x;
                    }
                    transPoint.y = MAX(-rect.size.height, transPoint.y);
                    transPoint.y = MIN(maxRect.size.height - rect.size.height - rect.origin.y, transPoint.y);
                    
                    rect = CGRectMake(rect.origin.x + transPoint.x, rect.origin.y, rect.size.width - transPoint.x, rect.size.height + transPoint.y);
                }
                    break;
                case enumPanPositionBottomRight: {
                    transPoint.x = MIN(maxRect.size.width - rect.origin.x - rect.size.width, transPoint.x);
                    transPoint.y = MIN(maxRect.size.height - rect.origin.y - rect.size.height, transPoint.y);
                    transPoint.x = MAX(-rect.size.width, transPoint.x);
                    transPoint.y = MAX(-rect.size.height, transPoint.y);
                    
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + transPoint.x, rect.size.height + transPoint.y);
                }
                    break;
                case enumPanPositionCenter: {
                    rect = CGRectMake(rect.origin.x + transPoint.x, rect.origin.y + transPoint.y, rect.size.width, rect.size.height);
                    rect.origin.x = MAX(rect.origin.x, 0);
                    rect.origin.x = MIN(maxRect.size.width - rect.size.width, rect.origin.x);
                    rect.origin.y = MAX(rect.origin.y, 0);
                    rect.origin.y = MIN(maxRect.size.height - rect.size.height, rect.origin.y);
                }
                    break;
            }
            self.scopeView.frame = rect;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -- PLSSelectionViewDelegate
- (void)selectionView:(PLSSelectionView *)selectionView didSelectedItemNumber:(NSInteger)number {
    if (selectionView == self.selectionView) {
        // bitrate 可以根据业务的实际需求设置为相应的值，以下 bitrate 的取值仅供参考
        // 如果 bitrate 的值大于原始视频的视频码率，SDK 在内部会重置 bitrate 的值为原始视频的视频码率。
        switch (number) {
            case 0:
            {
                self.transcoderPreset = PLSFilePresetMediumQuality;
                self.bitrate = 3000 * 1000;
            }
                break;
            case 1:
            {
                self.transcoderPreset = PLSFilePresetHighestQuality;
                self.bitrate = 6000 * 1000;

            }
                break;
            case 2:
            {
                self.transcoderPreset = PLSFilePreset640x480;
                self.bitrate = 2000 * 1000;
            }
                break;
            case 3:
            {
                self.transcoderPreset = PLSFilePreset960x540;
                self.bitrate = 3000 * 1000;
            }
                break;
            case 4:
            {
                self.transcoderPreset = PLSFilePreset1280x720;
                self.bitrate = 4000 * 1000;
            }
                break;
            case 5:
            {
                self.transcoderPreset = PLSFilePreset1920x1080;
                self.bitrate = 6000 * 1000;
            }
                break;
                
            default:
            {
                self.transcoderPreset = PLSFilePreset960x540;
                self.bitrate = 3000 * 1000;
            }
                break;
        }
    }
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
    
    self.rotateOrientation = [self.shortVideoEditor rotateVideoLayer];
    NSLog(@"videoLayerOrientation: %ld", (long)self.rotateOrientation);
    
    
    self.maxScopeView.frame = [PLShortVideoTranscoder videoDisplay:self.asset bounds:self.shortVideoEditor.previewView.bounds rotate:self.rotateOrientation];
    self.scopeView.frame = self.maxScopeView.bounds;
    self.shortVideoTranscoder.videoSelectedRect = CGRectZero;
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
    [self loadActivityIndicatorView];
    
    [self movieTransCodeAction];
}

#pragma mark -- 开始视频转码动作
- (void)movieTransCodeAction {
    [self.shortVideoEditor stopEditing];
    
    // 比如选取起始时间为 start, 时长为 duration 的视频区域来转码输出
    CGFloat start = [self.movieSettings[PLSStartTimeKey] floatValue];
    CGFloat duration = [self.movieSettings[PLSDurationKey] floatValue];
    
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(start * 1000, 1000), CMTimeMake(duration * 1000, 1000));

    self.shortVideoTranscoder = [[PLShortVideoTranscoder alloc] initWithURL:self.url];
    self.shortVideoTranscoder.outputFileType = PLSFileTypeMPEG4;
    self.shortVideoTranscoder.outputFilePreset = self.transcoderPreset;
    self.shortVideoTranscoder.bitrate = self.bitrate;
    self.shortVideoTranscoder.timeRange = timeRange;
    self.shortVideoTranscoder.rotateOrientation = self.rotateOrientation;
//    self.shortVideoTranscoder.outputURL = [self getFileURL:@"videoTranscoder-outputURL"]; // 自定义视频的存放地址
//    self.shortVideoTranscoder.videoHardwareType = PLSVideoHardwareTypeHEVC;
    
    CGRect maxRect = self.maxScopeView.bounds;
    if (CGRectEqualToRect(maxRect, self.scopeView.frame)) {
        self.shortVideoTranscoder.videoSelectedRect = CGRectZero;
    } else {
        CGSize videoSize = [self.asset pls_videoSize];
        if (PLSPreviewOrientationLandscapeLeft == self.rotateOrientation ||
            PLSPreviewOrientationLandscapeRight == self.rotateOrientation) {
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
        CGFloat scale = videoSize.width / maxRect.size.width;
        
        CGRect cutPixelFrame = CGRectMake(
                                          (self.scopeView.frame.origin.x - maxRect.origin.x) * scale,
                                          (self.scopeView.frame.origin.y - maxRect.origin.y) * scale,
                                          self.scopeView.frame.size.width * scale,
                                          self.scopeView.frame.size.height * scale
                                          );
        self.shortVideoTranscoder.videoSelectedRect = cutPixelFrame;
        self.shortVideoTranscoder.destVideoSize = CGSizeMake(cutPixelFrame.size.width, cutPixelFrame.size.height);
        self.shortVideoTranscoder.videoFrameRate = 25;
        
        NSLog(@"设置剪裁区域:%@", NSStringFromCGRect(cutPixelFrame));
        NSLog(@"设置导出宽高:%@", NSStringFromCGSize(self.shortVideoTranscoder.destVideoSize));
    }

    __weak typeof(self) weakSelf = self;
    [self.shortVideoTranscoder setCompletionBlock:^(NSURL *url){

        NSLog(@"transCoding successd, url: %@", url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            weakSelf.progressLabel.text = @"";
            
            NSString *beforeTranscodingSize = [NSString stringWithFormat:@"%.2f", [weakSelf fileSize:weakSelf.url]];
            NSString *afterTranscodingSize = [NSString stringWithFormat:@"%.2f", [weakSelf fileSize:url]];
            
            NSLog(@"%@-->%@", beforeTranscodingSize, afterTranscodingSize);
            
            // 设置音视频、水印等编辑信息
            NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
            // 待编辑的原始视频素材
            NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
            AVAsset *asset = [AVAsset assetWithURL:url];
            plsMovieSettings[PLSURLKey] = url;
            plsMovieSettings[PLSAssetKey] = asset;
            plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
            plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
            plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
            outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
            
            EditViewController *videoEditViewController = [[EditViewController alloc] init];
            videoEditViewController.settings = outputSettings;
            videoEditViewController.filesURLArray = @[url];
            videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:videoEditViewController animated:YES completion:nil];
        });
    }];
    
    [self.shortVideoTranscoder setFailureBlock:^(NSError *error){
        
        NSLog(@"transCoding failed: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AlertViewShow(error);

            [weakSelf removeActivityIndicatorView];
            weakSelf.progressLabel.text = @"";
        });
    }];
    
    [self.shortVideoTranscoder setProcessingBlock:^(float progress){
        // 更新压缩进度的 UI
        NSLog(@"transCoding progress: %f", progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"转码进度%d%%", (int)(progress * 100)];
        });
    }];
    
    [self.shortVideoTranscoder startTranscoding];
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
    
    self.selectionView = nil;
    
    self.shortVideoTranscoder = nil;
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
