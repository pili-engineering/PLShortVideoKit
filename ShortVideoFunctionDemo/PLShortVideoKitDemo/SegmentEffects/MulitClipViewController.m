//
//  MulitClipViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#ifndef MAS_SHORTHAND_GLOBALS
    #define MAS_SHORTHAND_GLOBALS
#endif

#import "MulitClipViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import <Masonry.h>
#import "PhotoAlbumViewController.h"
#import "MovieTransCodeViewController.h"
#import "PLSClipMulitMediaView.h"
#import "PLSSelectionView.h"
#import "PLSPlayerView.h"
#import "TransitionViewController.h"
#import "EditViewController.h"

#define TransitionVideoFolder @"transition_mp4"
#define RangeVideoFolder @"range_mp4"

@interface MulitClipViewController ()
<
PLSClipMulitMediaViewDelegate,
TransitionViewControllerDelegate
>
{
    id<NSObject>  _timeObserverToken;
}
// 播放器
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) PLSPlayerView *playerView;

// 选取需要的视频段
@property (strong, nonatomic) PLSClipMulitMediaView *clipView;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;

@property (strong, nonatomic) NSMutableArray *avassetArray;

@property (assign, nonatomic) BOOL isNeedResume;

@property (strong, nonatomic) NSMutableArray <PLSRangeMedia *> *transcodingArray;

@property (strong, nonatomic) PLSRangeMovieExport *movieExport;

@property (assign, nonatomic) PLSVideoFillModeType fillMode;
@end

@implementation MulitClipViewController

- (void)dealloc {
    [self removeTimeObserver];
    [self removeObserver];
    
    NSLog(@"dealloc %@", self.description);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transcodingArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.nextButton.hidden = YES;
    self.titleLabel.text = @"单击屏幕播放/暂停";
    self.fillMode = PLSVideoFillModePreserveAspectRatioAndFill;

    [self setupClipView];
    
    [self setupPlayerView];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithRed:141.0/255 green:141.0/255 blue:142.0/255 alpha:1] forState:UIControlStateHighlighted];
    deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteButton addTarget:self.clipView action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.nextButton);
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPlayerView)];
    [self.playerView addGestureRecognizer:singleTap];
    self.playerView.player = self.player;
    
    UIButton *fillModeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [fillModeButton setTitle:@"fillMode" forState:(UIControlStateNormal)];
    [fillModeButton sizeToFit];
    fillModeButton.center = CGPointMake(self.view.center.x, self.titleLabel.center.y + 40);
    [self.view addSubview:fillModeButton];
    
    [fillModeButton addTarget:self action:@selector(clickFillMode:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addObserver];
}

- (void)clickFillMode:(UIButton *)button {
    if (PLSVideoFillModePreserveAspectRatioAndFill == self.fillMode) {
        self.fillMode = PLSVideoFillModePreserveAspectRatio;
        [button setTitle:@"fitMode" forState:(UIControlStateNormal)];
    } else {
        self.fillMode = PLSVideoFillModePreserveAspectRatioAndFill;
        [button setTitle:@"fillMode" forState:(UIControlStateNormal)];
    }
    self.clipView.fillMode = self.fillMode;
}

- (void)setupClipView {
    self.clipView = [[PLSClipMulitMediaView alloc] init];
    self.clipView.delegate = self;
    self.clipView.fillMode = self.fillMode;
    [self.view addSubview:self.clipView];
    
    [self.clipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.height.equalTo(140);
    }];
    
    if (self.avassetArray) {
        [self.clipView setAssetArray:self.avassetArray];
    }
}

- (void)setupPlayerView {
    self.playerView = [[PLSPlayerView alloc] init];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.baseToolboxView.mas_bottom);
        make.bottom.equalTo(self.clipView.mas_top);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeTimeObserver];
    [self.player pause];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addTimeObserver];
}

- (NSURL *)transitionVideoURL {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *transitionFolder = [documentsDirectory stringByAppendingPathComponent:TransitionVideoFolder];
    BOOL isDir = NO;
    NSError *error = nil;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:transitionFolder isDirectory:&isDir] && isDir)) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:transitionFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            NSLog(@"!!!====创建文件夹错误====!!!");
            return nil;
        }
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmssmmm"];
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@.mp4", transitionFolder, [format stringFromDate:[NSDate date]]];

    return [NSURL fileURLWithPath:videoPath];
}

- (NSURL *)editVideoURL {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *transitionFolder = [documentsDirectory stringByAppendingPathComponent:RangeVideoFolder];
    BOOL isDir = NO;
    NSError *error = nil;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:transitionFolder isDirectory:&isDir] && isDir)) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:transitionFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            NSLog(@"!!!====创建文件夹错误====!!!");
            return nil;
        }
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmssmmm"];
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@.mp4", transitionFolder, [format stringFromDate:[NSDate date]]];

    return [NSURL fileURLWithPath:videoPath];
}

+ (dispatch_queue_t)setupPlayerQueue {
    static dispatch_queue_t playerQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerQueue = dispatch_queue_create("mulit.player.init", DISPATCH_QUEUE_SERIAL);
    });
    return playerQueue;
}

- (void)singleTapPlayerView {
    if (0 == self.player.rate) {
        [self.player setRate:1];
    } else {
        [self.player setRate:0];
    }
}

- (void)setupClipMovieView {
    
}

static int KVOcontext = 0;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != &KVOcontext) return;
    
    if ([keyPath isEqualToString:@"player.status"]) {
        NSNumber *num = change[NSKeyValueChangeNewKey];
        if (AVPlayerStatusReadyToPlay == [num integerValue]) {
//            [self.player play];
        }
    }
}

- (void)addObserver {
    [self addObserver:self forKeyPath:@"player.status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:&KVOcontext];
}

- (void)removeObserver {
    [self removeObserver:self forKeyPath:@"player.status"];
}

- (void)addTimeObserver {
    [self removeTimeObserver];
    
//    if (nil == _timeObserverToken) {
        __weak typeof(self) weakSelf = self;
        _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf.clipView setPlayPosition:time];
        }];
//    }
}

- (void)removeTimeObserver {
    @synchronized (self) {
        if (_timeObserverToken) {
            [self.player removeTimeObserver:_timeObserverToken];
            _timeObserverToken = nil;
        }
    }
}

- (void)setupPlayerWithItem:(AVPlayerItem *)playItem {
    
    [self removeTimeObserver];
    self.player = [AVPlayer playerWithPlayerItem:playItem];
    [self addTimeObserver];
    
    dispatch_main_sync_safe(^{
        self.playerView.player = self.player;
    });
}

- (void)setPhAssetArray:(NSMutableArray<PHAsset *> *)phAssetArray {
    _phAssetArray = phAssetArray;
    
    dispatch_async([self.class setupPlayerQueue],^{
        
        if (!self.avassetArray) {
            self.avassetArray = [[NSMutableArray alloc] init];
        } else {
            [self.avassetArray removeAllObjects];
        }
        
        if (self.phAssetArray.count) {
            for (int i = 0; i < self.phAssetArray.count; i ++) {
                AVAsset *asset = [AVURLAsset assetWithURL:[BaseViewController movieURL:self.phAssetArray[i]]];
                if (asset) {
                    [self.avassetArray addObject:asset];
                }
            }
        } else if (self.urlArray.count) {
            for (int i = 0; i < self.urlArray.count; i ++) {
                AVAsset *asset = [AVURLAsset assetWithURL:self.urlArray[i]];
                if (asset) {
                    [self.avassetArray addObject:asset];
                }
            }
        }
        
        if (self.clipView) {
            self.clipView.assetArray = self.avassetArray;
        }
    });
}

// PLSClipMulitMediaViewDelegate
- (void)clipScrollViewWillBeginDragging:(PLSClipMulitMediaView *)clipView {
    self.isNeedResume = self.player.rate >= 1;
    [self.player pause];
}

- (void)clipScrollViewWillEndDragging:(PLSClipMulitMediaView *)clipView {
    if (self.isNeedResume) {
//        [self.player play];
    }
}

- (void)clipView:(PLSClipMulitMediaView *)clipView refreshPlayItem:(AVPlayerItem *)playItem {
    [self setupPlayerWithItem:playItem];
}

- (void)clipView:(PLSClipMulitMediaView *)clipView seekToTime:(CMTime)seekTime {
    [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {}];
}

- (void)clipView:(PLSClipMulitMediaView *)clipView insertVideoWithAsset:(AVAsset *)asset{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择添加" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *transitionAction = [UIAlertAction actionWithTitle:@"文字转场" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        TransitionViewController *transitionController = [[TransitionViewController alloc] init];
        transitionController.backgroundVideoURL = [(AVURLAsset *)asset URL];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:transitionController];
        transitionController.delegate = self;
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:transitionAction];
//    [alert addAction:videoAction];
//    [alert addAction:imageAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clipView:(PLSClipMulitMediaView *)clipView finishClip:(NSArray<PLSRangeMedia *> *)mediaArray {
    
    if (0 == mediaArray.count) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    self.movieExport = [[PLSRangeMovieExport alloc] initWithRangeMedia:mediaArray];
    self.movieExport.outURL = [self editVideoURL];
//    self.movieExport.outputFilePreset = PLSFilePresetHighestQuality;
    self.movieExport.outputVideoSize = CGSizeMake(540, 960);
    self.movieExport.fillMode = self.fillMode;
    self.movieExport.bitrate = 1500 * 1000;
    
    [self showWating];
    
    __weak typeof(self) weakSelf = self;
    if (nil == self.movieExport.completionBlock) {
        self.movieExport.completionBlock = ^(NSURL *url) {
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
        self.movieExport.failureBlock = ^(NSError *error) {
            [weakSelf hideWating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        };
        self.movieExport.processingBlock = ^(float progress) {
            [weakSelf setProgress:progress];
        };
    }
    
    [self.movieExport startExport];
}

- (void)transitionViewController:(TransitionViewController *)transitionController transitionMedia:(NSURL *)transitionURL {

    NSURL *videoURL = [self transitionVideoURL];
    BOOL result = [[NSFileManager defaultManager] moveItemAtPath:transitionURL.path toPath:videoURL.path error:nil];
    if (!result) {
        NSLog(@"!!!====保存文件错误====!!!");
        return;
    }
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    if (asset) {
        [self.clipView addTransition:asset];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
