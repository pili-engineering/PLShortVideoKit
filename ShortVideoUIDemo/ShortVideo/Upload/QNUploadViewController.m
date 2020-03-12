//
//  QNUploadViewController.m
//  ShortVideo
//
//  Created by hxiongan on 2019/5/13.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNUploadViewController.h"
#import "QNPlayerView.h"
#import "QNGradientView.h"

@interface QNUploadViewController ()
{
    id _timeObserver;
}

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) QNPlayerView *playerView;
@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) QNGradientView *topBarView;
@property (nonatomic, strong) PLShortVideoUploader *shortVideoUploader;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIProgressView *playingProgressView;
@property (nonatomic, strong) UILabel *playingTimeLabel;

@end

@implementation QNUploadViewController

- (void)dealloc {
    [self removeObserver];
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self play];
    [self addTimeObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self pause];
    [self removeTimeObserver];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTopBar];
    
    [self setupPlayer];
    
    [self addObserver];
}

- (void)setupTopBar {
    self.topBarView = [[QNGradientView alloc] init];
    self.topBarView.gradienLayer.colors = @[(__bridge id)[[UIColor colorWithWhite:0 alpha:.8] CGColor], (__bridge id)[[UIColor clearColor] CGColor]];
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_topLayoutGuide).offset(50);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [backButton setTintColor:UIColor.whiteColor];
    [backButton setImage:[UIImage imageNamed:@"qn_icon_close"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topBarView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 44));
        make.left.bottom.equalTo(self.topBarView);
    }];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setImage:[UIImage imageNamed:@"qn_save"] forState:(UIControlStateNormal)];
    [saveButton sizeToFit];
    [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topBarView addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView);
        make.right.equalTo(self.topBarView).offset(-10);
        make.height.equalTo(44);
        make.width.equalTo(saveButton.bounds.size.width);
    }];
    
    self.playingTimeLabel = [[UILabel alloc] init];
    self.playingTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.playingTimeLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
    self.playingTimeLabel.textColor = [UIColor lightTextColor];
    [self.topBarView addSubview:self.playingTimeLabel];
    
    self.playingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    [self.playingProgressView setTrackTintColor:UIColor.clearColor];
    [self.playingProgressView setProgressTintColor:QN_MAIN_COLOR];
    [self.topBarView addSubview:self.playingProgressView];
    
    [self.playingProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.topBarView);
        make.height.equalTo(2);
    }];
    
    [self.playingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topBarView);
        make.centerY.equalTo(backButton);
    }];
}

- (void)setupPlayer {
    self.asset = [AVAsset assetWithURL:self.url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerView = [[QNPlayerView alloc] init];
    self.playerView.player = self.player;
    
    [self.view insertSubview:self.playerView atIndex:0];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImage *playImg = [UIImage imageNamed:@"qn_play"];
    self.playImageView = [[UIImageView alloc] initWithImage:playImg];
    [self.playerView addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playerView);
        make.size.equalTo(playImg.size);
    }];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.playerView addGestureRecognizer:singleTap];
}

#pragma mark - play/pause

- (void)play {
    [self.playImageView scaleHideAnimation];
    [self.player play];
}

- (void)pause {
    [self.playImageView scaleShowAnimation];
    [self.player pause];
}

#pragma mark - add/remove observer

- (void)addObserver {
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)addTimeObserver {
    if (_timeObserver) return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    __weak typeof(self) weakSelf = self;
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(250, 1000) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float process = CMTimeGetSeconds(time) / CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.playingProgressView.progress = process;
        weakSelf.playingTimeLabel.text = [weakSelf formatTimeString:CMTimeGetSeconds(time)];
    }];
}

- (void)removeTimeObserver {
    if (_timeObserver) {
        [self.player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)info {
    [self pause];
}

- (void)playerToEnd:(NSNotification *)info {
    
    if (info.object == self.player.currentItem) {
        [self.player seekToTime:kCMTimeZero];
        [self play];
    }
}

#pragma mark - button actions

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSaveButton {
    [self.view showTip:@"视频已保存到相册"];
    UISaveVideoAtPathToSavedPhotosAlbum(self.url.path, nil, nil, nil);
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    if (self.player.rate > 0) {
        [self pause];
    } else {
        [self play];
    }
}

@end
