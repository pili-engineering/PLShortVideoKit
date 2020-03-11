//
//  QNPlayPuzzleViewController.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNPlayPuzzleViewController.h"
#import "QNTranscodeViewController.h"
#import "QNPlayerView.h"
#import "QNGradientView.h"

@interface QNPlayPuzzleViewController ()
{
    PLSMixMediaItem *_mediaItems[4];
    id _timeObserver;
}

@property (nonatomic, strong) QNGradientView *gradientBar;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) PLSMultiVideoMixer *mulitVideoMixer;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) QNPlayerView *playerView;
@property (nonatomic, strong) UIProgressView *processView;
@property (nonatomic, strong) UIButton *leftAddButton;
@property (nonatomic, strong) UIButton *rightAddButton;

@property (nonatomic, strong) UIView *volumeView;

@end

@implementation QNPlayPuzzleViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc %@", self.description);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player pause];
    [self.mulitVideoMixer cancelExport];
    [self removeTimeObserver];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addObserver];
    [self.player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTitleBar];
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.view addGestureRecognizer:tap];

    self.playerView = [[QNPlayerView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:self.playerView atIndex:0];

    [self setupvideoMixRecorder];
    [self setupVideoInfoView];
}

- (void)setupTitleBar {
    self.gradientBar = [[QNGradientView alloc] init];
    self.gradientBar.gradienLayer.colors = @[(__bridge id)[[UIColor colorWithWhite:0 alpha:.8] CGColor], (__bridge id)[[UIColor clearColor] CGColor]];
    [self.view addSubview:self.gradientBar];
    [self.gradientBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_topLayoutGuide).offset(50);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [backButton setTintColor:UIColor.whiteColor];
    [backButton setImage:[UIImage imageNamed:@"qn_icon_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(getBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.gradientBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 44));
        make.left.bottom.equalTo(self.gradientBar);
    }];
    
    UIButton *nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [nextButton setTintColor:UIColor.whiteColor];
    [nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.gradientBar addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(64, 44));
        make.right.bottom.equalTo(self.gradientBar);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor lightTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"视频拼图";
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.titleLabel sizeToFit];
    [self.gradientBar addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gradientBar);
        make.centerY.equalTo(nextButton);
    }];
}

- (void)setupvideoMixRecorder {
    
    self.mulitVideoMixer = [[PLSMultiVideoMixer alloc] init];
    self.mulitVideoMixer.frameRate = 25;
    
    CGRect videoframes[4];
    NSArray *sizeArray = [self getEncodeVideoSize];
    NSInteger width = [sizeArray[0] integerValue];
    NSInteger height = [sizeArray[1] integerValue];
    self.mulitVideoMixer.videoSize = CGSizeMake(width, height);

    if (2 == self.urls.count) {
        videoframes[0] = CGRectMake(0, 0, width/2, height);
        videoframes[1] = CGRectMake(width/2, 0, width/2, height);
    } else if (3 == self.urls.count) {
        videoframes[0] = CGRectMake(0, 0, width, height/3*1);
        videoframes[1] = CGRectMake(0, height/3*1, width/2, height/3*2);
        videoframes[2] = CGRectMake(width/2, height/3*1, width/2, height/3*2);
    } else if (4 == self.urls.count) {
        videoframes[0] = CGRectMake(0, 0, width/2, height/2);
        videoframes[1] = CGRectMake(width/2, 0, width/2, height/2);
        videoframes[2] = CGRectMake(0, height/2, width/2, height/2);
        videoframes[3] = CGRectMake(width/2, height/2, width/2, height/2);
    }
    
    for (int i = 0; i < _urls.count; i ++) {
        _mediaItems[i] = [[PLSMixMediaItem alloc] init];
        _mediaItems[i].videoFrame = videoframes[i];
        _mediaItems[i].zIndex = i;
        _mediaItems[i].mediaURL = _urls[i];
        _mediaItems[i].fillMode = PLSVideoFillModePreserveAspectRatioAndFill;
        [self.mulitVideoMixer addMedia:_mediaItems[i]];
    }
    
    [self refreshPlayer];
}

- (void)setupVideoInfoView {
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:alphaView];
    
    self.processView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, alphaView.bounds.size.width, 3)];
    [alphaView addSubview:_processView];
    
    UISegmentedControl *playModeSegment = [[UISegmentedControl alloc] initWithItems:@[@"一起播放", @"一个一个放"]];
    [playModeSegment addTarget:self action:@selector(playModeChange:) forControlEvents:(UIControlEventValueChanged)];
    [playModeSegment sizeToFit];
    playModeSegment.selectedSegmentIndex = 0;
    playModeSegment.tintColor = QN_MAIN_COLOR;
    playModeSegment.center = CGPointMake(alphaView.bounds.size.width / 2, alphaView.bounds.size.height / 2);
    [alphaView addSubview:playModeSegment];
    
    self.volumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_volumeView];
    
    CGFloat height = 0;
    for (int i = 0; i < self.urls.count; i ++) {
        
        UISlider *volumeSlider = [[UISlider alloc] init];
        volumeSlider.frame = CGRectMake(40, i * (volumeSlider.frame.size.height + 10), self.view.bounds.size.width - 80, volumeSlider.frame.size.height);
        [volumeSlider addTarget:self action:@selector(sliderChange:) forControlEvents:(UIControlEventValueChanged)];
        volumeSlider.maximumValue = 1.0;
        volumeSlider.minimumValue = 0.0;
        volumeSlider.tag = i;
        [self.volumeView addSubview:volumeSlider];
        [volumeSlider setValue:1.0 animated:NO];
        
        height += (volumeSlider.frame.size.height + 10);
        
        UILabel *minLabel = [[UILabel alloc] init];
        minLabel.textColor = [UIColor whiteColor];
        minLabel.text = @"0.0";
        minLabel.font = [UIFont systemFontOfSize:12];
        [minLabel sizeToFit];
        minLabel.center = CGPointMake(volumeSlider.frame.origin.x - minLabel.bounds.size.width/2, volumeSlider.center.y);
        [self.volumeView addSubview:minLabel];
        
        UILabel *maxLabel = [[UILabel alloc] init];
        maxLabel.textColor = [UIColor whiteColor];
        maxLabel.text = @"1.0";
        maxLabel.font = [UIFont systemFontOfSize:12];
        [maxLabel sizeToFit];
        maxLabel.center = CGPointMake(volumeSlider.frame.origin.x + volumeSlider.frame.size.width + maxLabel.bounds.size.width/2, volumeSlider.center.y);
        [self.volumeView addSubview:maxLabel];
    }
    
    self.volumeView.frame = CGRectMake(0, 80, QN_SCREEN_WIDTH, height);
}

#pragma mark - actions

- (void)sliderChange:(UISlider *)slider {
    _mediaItems[slider.tag].volume = slider.value;
    [self.mulitVideoMixer setMediaVolume:self.player.currentItem media:_mediaItems[slider.tag]];
}

- (void)singleTap {
    if ([self.activityIndicatorView isAnimating]) {
        return;
    }
    
    if (self.volumeView.hidden) {
        self.volumeView.hidden = NO;
    } else {
        self.volumeView.hidden = YES;
    }
}

- (void)nextButtonClick {
    
    self.mulitVideoMixer.outputURL = [self getFileURL];
    
    __weak typeof(self) weakSelf = self;
    if (nil == self.mulitVideoMixer.completionBlock) {
        self.mulitVideoMixer.completionBlock = ^(NSURL *url) {
            
            [weakSelf hideWating];
            
            QNTranscodeViewController *transcodeViewController = [[QNTranscodeViewController alloc] init];
            transcodeViewController.sourceURL = url;
            transcodeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:transcodeViewController animated:YES completion:nil];
        };
        self.mulitVideoMixer.failureBlock = ^(NSError *error) {
            [weakSelf hideWating];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:sureAction];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        self.mulitVideoMixer.processingBlock = ^(float progress) {
            [weakSelf setProgress:progress];
        };
    }
    
    [self.player pause];
    [self showWating];
    [self.mulitVideoMixer startExport];
    
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

#pragma mark - observer

- (void)addObserver {
    [self removeTimeObserver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    __weak typeof(self) weakSelf = self;
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float process = CMTimeGetSeconds(time) / CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.processView.progress = process;
    }];
}

- (void)removeTimeObserver {
    if (_timeObserver) {
        [self.player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
}

#pragma mark - player

- (void)playerToEnd:(NSNotification *)info {
    if (info.object == self.player.currentItem) {
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
}

- (void)playModeChange:(UISegmentedControl *)segment {
    
    NSArray<PLSMixMediaItem *> *allMedias = [self.mulitVideoMixer getAllMedia];
    
    if (0 == segment.selectedSegmentIndex) {
        
        for (int i = 0; i < allMedias.count; i ++) {
            PLSMixMediaItem *media = allMedias[i];
            media.startTime = kCMTimeZero;
            media.loop = YES;
        }
        self.mulitVideoMixer.duration = kCMTimeZero;//use default
        
    } else if (1 == segment.selectedSegmentIndex) {
        
        CMTime totalDuration = kCMTimeZero;
        for (int i = 0; i < allMedias.count; i ++) {
            PLSMixMediaItem *media = allMedias[i];
            media.startTime = totalDuration;
            media.loop = NO;
            totalDuration = CMTimeAdd(totalDuration, media.duration);
        }
        
        self.mulitVideoMixer.duration = totalDuration;
    }
    
    [self refreshPlayer];
}

- (void)refreshPlayer {
    
    [self removeTimeObserver];
    
    NSError *error = nil;
    AVPlayerItem *playerItem = [self.mulitVideoMixer getPlayerItem:&error];
    if (playerItem) {
        if (self.player) {
            [self.player replaceCurrentItemWithPlayerItem:playerItem];
        } else {
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            self.playerView.player = self.player;
        }
    } else {
        NSLog(@"error = %@", error);
    }
    
    [self addObserver];
}

- (void)getBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
