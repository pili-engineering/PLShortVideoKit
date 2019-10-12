//
//  VideoMixViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/4/18.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "VideoMixViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "EditViewController.h"
#import "PLSPlayerView.h"
#import "VideoSelectViewController.h"

@interface VideoMixViewController ()
{
    PLSMixMediaItem *_mediaItems[4];
    id _timeObserver;
}

@property (strong, nonatomic) PLSMultiVideoMixer *mulitVideoMixer;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) PLSPlayerView *playerView;
@property (strong, nonatomic) UIProgressView *processView;
@property (strong, nonatomic) UIButton *leftAddButton;
@property (strong, nonatomic) UIButton *rightAddButton;

@end

@implementation VideoMixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"单击屏幕播放或暂停";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.view addGestureRecognizer:tap];

    self.playerView = [[PLSPlayerView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:self.playerView atIndex:0];

    [self setupvideoMixRecorder];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:alphaView];
    
    _processView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, alphaView.bounds.size.width, 3)];
    [alphaView addSubview:_processView];
    
    UISegmentedControl *playModeSegment = [[UISegmentedControl alloc] initWithItems:@[@"一起播放", @"一个一个放"]];
    [playModeSegment addTarget:self action:@selector(playModeChange:) forControlEvents:(UIControlEventValueChanged)];
    [playModeSegment sizeToFit];
    playModeSegment.selectedSegmentIndex = 0;
    playModeSegment.center = CGPointMake(alphaView.bounds.size.width / 2, alphaView.bounds.size.height / 2);
    [alphaView addSubview:playModeSegment];
    
    for (int i = 0; i < self.urls.count; i ++) {
        
        UISlider *volumeSlider = [[UISlider alloc] init];
        volumeSlider.frame = CGRectMake(40, 80 + i * (volumeSlider.frame.size.height + 10), self.view.bounds.size.width - 80, volumeSlider.frame.size.height);
        [volumeSlider addTarget:self action:@selector(sliderChange:) forControlEvents:(UIControlEventValueChanged)];
        volumeSlider.maximumValue = 1.0;
        volumeSlider.minimumValue = 0.0;
        volumeSlider.tag = i;
        [self.view addSubview:volumeSlider];
        [volumeSlider setValue:1.0 animated:NO];
        
        UILabel *minLabel = [[UILabel alloc] init];
        minLabel.textColor = [UIColor whiteColor];
        minLabel.text = @"0.0";
        minLabel.font = [UIFont systemFontOfSize:12];
        [minLabel sizeToFit];
        minLabel.center = CGPointMake(volumeSlider.frame.origin.x - minLabel.bounds.size.width/2, volumeSlider.center.y);
        [self.view addSubview:minLabel];
        
        UILabel *maxLabel = [[UILabel alloc] init];
        maxLabel.textColor = [UIColor whiteColor];
        maxLabel.text = @"1.0";
        maxLabel.font = [UIFont systemFontOfSize:12];
        [maxLabel sizeToFit];
        maxLabel.center = CGPointMake(volumeSlider.frame.origin.x + volumeSlider.frame.size.width + maxLabel.bounds.size.width/2, volumeSlider.center.y);
        [self.view addSubview:maxLabel];
    }
}

- (void)sliderChange:(UISlider *)slider {
    _mediaItems[slider.tag].volume = slider.value;
    [self.mulitVideoMixer setMediaVolume:self.player.currentItem media:_mediaItems[slider.tag]];
}

- (void)singleTap {
    if ([self.activityIndicatorView isAnimating]) {
        return;
    }
    
    if (0 == self.player.rate) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)nextButtonClick {
    
    self.mulitVideoMixer.outputURL = [self getFileURL];
    
    __weak typeof(self) weakSelf = self;
    if (nil == self.mulitVideoMixer.completionBlock) {
        self.mulitVideoMixer.completionBlock = ^(NSURL *url) {
            
            [weakSelf hideWating];
            
            // 设置音视频、水印等编辑信息
            NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
            // 待编辑的原始视频素材
            NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
            AVAsset *asset = [AVAsset assetWithURL:url];
            plsMovieSettings[PLSURLKey] = url;
            plsMovieSettings[PLSAssetKey] = asset;
            plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.0];
            plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
            plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
            outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
            
            EditViewController *videoEditViewController = [[EditViewController alloc] init];
            videoEditViewController.settings = outputSettings;
            videoEditViewController.filesURLArray = @[url];
            videoEditViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:videoEditViewController animated:YES completion:nil];
        };
        self.mulitVideoMixer.failureBlock = ^(NSError *error) {
            [weakSelf hideWating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
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


- (void)viewDidDisappear:(BOOL)animated {
    [self.player pause];
    [self.mulitVideoMixer cancelExport];
    [self removeTimeObserver];
    
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addObserver];
}

- (void)setupvideoMixRecorder {
    
    self.mulitVideoMixer = [[PLSMultiVideoMixer alloc] init];
    self.mulitVideoMixer.frameRate = 25;
    
    CGRect videoframes[4];
    
    if (2 == self.urls.count) {
        self.mulitVideoMixer.videoSize = CGSizeMake(720, 640);
        videoframes[0] = CGRectMake(0, 0, 360, 640);
        videoframes[1] = CGRectMake(360, 0, 360, 640);
    } else if (3 == self.urls.count) {
        self.mulitVideoMixer.videoSize = CGSizeMake(720, 640+360);
        videoframes[0] = CGRectMake(0, 0, 720, 360);
        videoframes[1] = CGRectMake(0, 360, 360, 640);
        videoframes[2] = CGRectMake(360, 360, 360, 640);
    } else if (4 == self.urls.count) {
        self.mulitVideoMixer.videoSize = CGSizeMake(720, 1280);
        videoframes[0] = CGRectMake(0, 0, 360, 640);
        videoframes[1] = CGRectMake(360, 0, 360, 640);
        videoframes[2] = CGRectMake(0, 640, 360, 640);
        videoframes[3] = CGRectMake(360, 640, 360, 640);
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

-(void)addObserver {
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc %@", self.description);
}

@end
