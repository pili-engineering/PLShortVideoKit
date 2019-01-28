//
//  ViewRecordViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2018/4/28.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ViewRecordViewController.h"
#import "PLSDeleteButton.h"
#import "PLSProgressBar.h"
#import "EditViewController.h"
#import "PLSRateButtonView.h"
#import "FLAnimatedImage.h"
#import "PLShortVideoKit/PLShortVideoKit.h"

#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_RGBCOLOR_ALPHA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewRecordViewController ()
<
PLSRateButtonViewDelegate,
PLShortVideoRecorderDelegate
>

@property (strong, nonatomic) PLSVideoConfiguration *catpuredViewVideoConfiguration;
@property (strong, nonatomic) PLSAudioConfiguration *audioConfiguration;
@property (strong, nonatomic) PLShortVideoRecorder *shortVideoRecorder;

// 素材
@property (strong, nonatomic) UIView *movieMakeView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) NSInteger imageIndex;
@property (strong, nonatomic) NSMutableArray *audioArray;
@property (strong, nonatomic) FLAnimatedImageView *gifView;

@property (strong, nonatomic) UIView *recordToolboxView;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) PLSDeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *endButton;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UILabel *durationLabel;

@property (strong, nonatomic) PLSRateButtonView *rateButtonView;
@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) NSInteger titleIndex;

@end

@implementation ViewRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    [self setupMovieMakeView];
    
    [self setupRecordToolboxView];
    
    [self setupShortVideoRecorder];
}

// 短视频录制核心类设置
- (void)setupShortVideoRecorder {
    // SDK 的版本信息
    NSLog(@"PLShortVideoRecorder versionInfo: %@", [PLShortVideoRecorder versionInfo]);
    
    self.catpuredViewVideoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    self.catpuredViewVideoConfiguration.position = AVCaptureDevicePositionFront;
    self.catpuredViewVideoConfiguration.videoFrameRate = 25;
    self.catpuredViewVideoConfiguration.averageVideoBitRate = 3000*1000;
    self.catpuredViewVideoConfiguration.videoSize = CGSizeMake(544, 960);
    self.catpuredViewVideoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    
    self.shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithCatpuredViewVideoConfiguration:self.catpuredViewVideoConfiguration audioConfiguration:self.audioConfiguration];
    self.shortVideoRecorder.delegate = self;
    self.shortVideoRecorder.maxDuration = 20; // 设置最长录制时长
    self.shortVideoRecorder.outputFileType = PLSFileTypeMPEG4;
    self.shortVideoRecorder.catpuredView = self.movieMakeView; // 录制 movieMakeView 视图
}

- (void)setupMovieMakeView {
    self.movieMakeView = [[UIView alloc] init];
    self.movieMakeView.frame = self.view.bounds;
    self.movieMakeView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.movieMakeView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.movieMakeView.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.hidden = YES;
    [self.movieMakeView addSubview:self.imageView];
    
    self.gifView = [[FLAnimatedImageView alloc] init];
    self.gifView.frame = self.movieMakeView.bounds;
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    [self.movieMakeView addSubview:self.gifView];

    if ([self isGif:self.selectedAssets.firstObject]) {
        self.imageView.hidden = YES;
        self.gifView.hidden = NO;
        [self loadGifFromAsset:self.selectedAssets.firstObject];
        
    } else {
        self.imageView.hidden = NO;
        self.gifView.hidden = YES;
        self.imageView.image = [self imageFromAsset:self.selectedAssets.firstObject targetSize:CGSizeMake(544, 960)];
    }
}

- (void)setupRecordToolboxView {
    self.recordToolboxView = [[UIView alloc] init];
    self.recordToolboxView.frame = self.view.bounds;
    self.recordToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordToolboxView];
    
    // 视频录制进度条
    self.progressBar = [[PLSProgressBar alloc] initWithFrame:CGRectMake(0, 5, PLS_SCREEN_WIDTH, 8)];
    [self.recordToolboxView addSubview:self.progressBar];
    
    // 显示已录制的时长
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.frame = CGRectMake(0, 0, 130, 40);
    self.durationLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, self.progressBar.bounds.origin.y + self.progressBar.bounds.size.height + 40 / 2);
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.shortVideoRecorder.getTotalDuration];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.recordToolboxView addSubview:self.durationLabel];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:backButton];
    
    // 下一步
    self.endButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.endButton setTintColor:[UIColor whiteColor]];
    [self.endButton setImage:[UIImage imageNamed:@"btn_bar_next_a"] forState:UIControlStateNormal];
    [self.endButton setImage:[UIImage imageNamed:@"btn_bar_next_b"] forState:UIControlStateHighlighted];
    [self.endButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.endButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    self.endButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.endButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.endButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.endButton.enabled = NO;
    [self.recordToolboxView addSubview:self.endButton];
    
    // 切换下一张图片
    UIButton *nextImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextImageButton.frame = CGRectMake((PLS_SCREEN_WIDTH - 46) / 2.0, PLS_SCREEN_HEIGHT - 200 - 4, 46, 46);
    [nextImageButton setTitle:@"下一张" forState:UIControlStateNormal];
    nextImageButton.titleLabel.font = [UIFont systemFontOfSize:12];
    nextImageButton.backgroundColor = [UIColor grayColor];
    nextImageButton.layer.borderWidth = 1.0f;
    nextImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [nextImageButton addTarget:self action:@selector(nextImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:nextImageButton];
    
    // 切换下一个音效
    self.audioArray = [[NSMutableArray alloc] init];
    NSMutableArray *audioNameArray = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *jsonPath = [bundlePath stringByAppendingString:@"/pls_multi_musics.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"load internal filters json error: %@", error);
    
    NSArray *jsonArray = [dicFromJson objectForKey:@"musics"];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *music = jsonArray[i];
        NSString *musicName = [music objectForKey:@"name"];
        NSString *path = [[NSBundle mainBundle] pathForResource:musicName ofType:nil];
        [self.audioArray addObject:path];
        [audioNameArray addObject:musicName];
    }
    [audioNameArray addObject:@"关闭音效"];
    
    for (int i = 0; i < audioNameArray.count; i++) {
        UIButton *nextAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextAudioButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 90, 120 + i * 45, 80, 35);
        [nextAudioButton setTitle:audioNameArray[i] forState:UIControlStateNormal];
        nextAudioButton.titleLabel.font = [UIFont systemFontOfSize:12];
        nextAudioButton.backgroundColor = [UIColor grayColor];
        nextAudioButton.layer.borderWidth = 1.0f;
        nextAudioButton.layer.borderColor = [UIColor whiteColor].CGColor;
        nextAudioButton.tag = 12000 + i;
        [nextAudioButton addTarget:self action:@selector(nextAudioButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordToolboxView addSubview:nextAudioButton];
    }
    
    
    
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
    center.x = CGRectGetWidth([UIScreen mainScreen].bounds) - 60;
    self.deleteButton = [PLSDeleteButton getInstance];
    self.deleteButton.style = PLSDeleteButtonStyleNormal;
    self.deleteButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 60, PLS_SCREEN_HEIGHT - 80, 50, 50);
    self.deleteButton.center = center;
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.deleteButton];
    self.deleteButton.hidden = YES;
    
    // 倍速拍摄
    self.titleArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    self.rateButtonView = [[PLSRateButtonView alloc] initWithFrame:CGRectMake(40, self.recordButton.frame.origin.y - 34 - 2, PLS_SCREEN_WIDTH - 80, 34) defaultIndex:2];
    self.rateButtonView.hidden = NO;
    self.titleIndex = 2;
    CGFloat countSpace = 200 /self.titleArray.count / 6;
    self.rateButtonView.space = countSpace;
    self.rateButtonView.staticTitleArray = self.titleArray;
    self.rateButtonView.rateDelegate = self;
    [self.recordToolboxView addSubview:self.rateButtonView];
}

- (BOOL)isGif:(PHAsset *)phAsset {
    BOOL isGif = NO;
    NSString *fileName =[phAsset valueForKey:@"filename"];
    NSString *fileExtension = [fileName pathExtension];
    if ([fileExtension isEqualToString:@"GIF"] || [fileExtension isEqualToString:@"gif"]) {
        isGif = YES;
    }
    return isGif;
}

- (UIImage *)imageFromAsset:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    __block UIImage *image = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageForAsset:phAsset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];

    return image;
}

- (void)loadGifFromAsset:(PHAsset *)phAsset {
    __block NSURL *url = nil;
    
    NSArray *resourceList = [PHAssetResource assetResourcesForAsset:phAsset];
    [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetResource *resource = obj;
        PHAssetResourceRequestOptions *option = [[PHAssetResourceRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
            NSLog(@"gif");
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageFilePath = [path stringByAppendingPathComponent:resource.originalFilename];
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:imageFilePath]  options:option completionHandler:^(NSError * _Nullable error) {
                url = [NSURL fileURLWithPath:imageFilePath];
                
                FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:url]];
                self.gifView.animatedImage = image;
            }];
            
        } else {
            NSLog(@"jepg");
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.shortVideoRecorder startCaptureSession];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shortVideoRecorder stopCaptureSession];
}

// 返回
- (void)backButtonEvent:(id)sender {
    [self cancelRecording];
}

// 下一步
- (void)nextButtonEvent:(id)sender {
    
    if ([self.shortVideoRecorder isRecording]) return;
    
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [self.shortVideoRecorder getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);
    
    AVAsset *movieAsset = self.shortVideoRecorder.assetRepresentingAllFiles;

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

// 下一张图片
- (void)nextImageButtonEvent:(id)sender {
    self.imageIndex++;
    if (self.imageIndex >= self.selectedAssets.count) {
        self.imageIndex = 0;
    }
    
    if ([self isGif:self.selectedAssets[self.imageIndex]]) {
        self.imageView.hidden = YES;
        self.gifView.hidden = NO;

        [self loadGifFromAsset:self.selectedAssets[self.imageIndex]];

    } else {
        self.imageView.hidden = NO;
        self.gifView.hidden = YES;
        self.gifView.animatedImage = nil; // 停止 GIF 动画

        CATransition *transition = [CATransition animation];
        transition.duration = 2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.imageView.layer addAnimation:transition forKey:@"imageViewAnimation"];
        self.imageView.image = [self imageFromAsset:self.selectedAssets[self.imageIndex] targetSize:CGSizeMake(544, 960)];
    }
}

// 下一个音效
- (void)nextAudioButtonEvent:(UIButton *)button {
    NSInteger tag = button.tag;
    NSInteger index = tag - 12000;
    
    if (index == self.audioArray.count) {
        [self.shortVideoRecorder mixAudio:nil playEnable:NO];
        
        return;
    }
    
    [self.shortVideoRecorder mixAudio:[NSURL fileURLWithPath:self.audioArray[index]] playEnable:YES];
}

// 录制视频
- (void)recordButtonEvent:(id)sender {
    if (self.shortVideoRecorder.isRecording) {
        [self.shortVideoRecorder stopRecording];
    } else {
        // 方式1
        // 录制的视频的存放地址由 SDK 内部自动生成
        [self.shortVideoRecorder startRecording];

//        // 方式2
//        // fileURL 录制的视频的存放地址，该参数可以在外部设置，录制的视频会保存到该位置
//        [self.shortVideoRecorder startRecording:[self getFileURL]];
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

// 结束录制
- (void)endButtonEvent:(id)sender {
    [self nextButtonEvent:nil];
}

// 取消录制
- (void)cancelRecording {
    [self.shortVideoRecorder cancelRecording];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PLSRateButtonViewDelegate 倍速录制回调

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

#pragma mark -- PLShortVideoRecorderDelegate 视频录制回调

// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
    
    self.endButton.enabled = NO;
    [self.progressBar addProgressView];
    [_progressBar startShining];
}

// 正在录制的过程中
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [_progressBar setLastProgressToWidth:fileDuration / self.shortVideoRecorder.maxDuration * _progressBar.frame.size.width];
    
//    self.endButton.enabled = (totalDuration >= self.shortVideoRecorder.minDuration);
    self.deleteButton.hidden = YES;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 删除了某一段视频
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"delete fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    self.endButton.enabled = totalDuration >= self.shortVideoRecorder.minDuration;
    
    if (totalDuration <= 0.0000001f) {
        self.deleteButton.hidden = YES;
    }
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    [_progressBar stopShining];
    
    self.deleteButton.hidden = NO;
    self.endButton.enabled = YES;
    
    if (totalDuration >= self.shortVideoRecorder.maxDuration) {
        [self endButtonEvent:nil];
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);
    
    [self nextButtonEvent:nil];
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc {

}

@end
