//
//  ImageVideoMixViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/10/30.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ImageVideoMixViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "EditViewController.h"

@interface ImageVideoMixViewController ()

@property (strong, nonatomic) PLSImageVideoComposer *imageVideoComposer;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UISwitch *transitionSwitch;
@property (strong, nonatomic) UISwitch *musicSwitch;

@end

@implementation ImageVideoMixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rateButtonView removeFromSuperview];
    
    self.transitionSwitch = [[UISwitch alloc] init];
    [self.transitionSwitch setOn:YES];
    [self.nextButton.superview  addSubview:self.transitionSwitch];
    
    self.musicSwitch = [[UISwitch alloc] init];
    [self.musicSwitch setOn:NO];
    [self.nextButton.superview  addSubview:self.musicSwitch];
    
    CGRect rc = self.nextButton.frame;
    self.transitionSwitch.frame = CGRectMake(rc.origin.x - self.transitionSwitch.bounds.size.width - 10, rc.origin.y, self.transitionSwitch.bounds.size.width, rc.size.height);
    rc = self.transitionSwitch.frame;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = @"转场开关";
    [label sizeToFit];
    label.center = CGPointMake(rc.origin.x - label.bounds.size.width/2 - 5, self.transitionSwitch.center.y);
    [self.nextButton.superview addSubview:label];
    
    rc = label.frame;
    rc = CGRectMake(rc.origin.x - 10 - self.musicSwitch.bounds.size.width, self.transitionSwitch.frame.origin.y, self.musicSwitch.bounds.size.width, self.musicSwitch.bounds.size.height);
    self.musicSwitch.frame = rc;
    
    UILabel *musicLabel = [[UILabel alloc] init];
    musicLabel.font = [UIFont systemFontOfSize:12];
    musicLabel.textColor = [UIColor whiteColor];
    musicLabel.text = @"背景音乐";
    [musicLabel sizeToFit];
    musicLabel.center = CGPointMake(rc.origin.x - musicLabel.bounds.size.width/2 - 5, self.transitionSwitch.center.y);
    [self.nextButton.superview addSubview:musicLabel];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.imageVideoComposer stopComposing];
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)showWating {
    if (nil == self.activityIndicatorView) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        self.activityIndicatorView.center = self.view.center;
        [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    
    [self.view addSubview:self.activityIndicatorView];
    if (![self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView startAnimating];
    }
}

- (void)hideWating {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
    [self.activityIndicatorView removeFromSuperview];
    [self.progressLabel removeFromSuperview];
    self.progressLabel.text = @"";
}

- (void)setProgress:(CGFloat)progress {
    
    if (nil == self.progressLabel) {
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 200, 45)];
        self.progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
        self.progressLabel.textAlignment =  NSTextAlignmentCenter;
        self.progressLabel.textColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.progressLabel];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
}

- (void)nextButtonClick:(UIButton *)sender {
    
    if (0 == [self.dynamicScrollView selectedAssets].count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请至少选择一个视频或图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    CGSize outputVideoSize = CGSizeMake(540, 960);
    
    BOOL pureVideo = YES;
    
    NSMutableArray *mediaItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dynamicScrollView.selectedAssets.count; i ++) {
        PHAsset *asset = [self.dynamicScrollView.selectedAssets objectAtIndex:i];
        if (PHAssetMediaTypeVideo == asset.mediaType) {
            PLSComposeMediaItem *media = [[PLSComposeMediaItem alloc] init];
            media.mediaType = PLSMediaTypeVideo;
            if (arc4random() % 2) {
                NSLog(@"Video use asset");
                media.asset = [AVAsset assetWithURL:asset.movieURL];
            } else {
                media.url = [asset movieURL];
                NSLog(@"Video use url");
            }
            [mediaItems addObject:media];
        } else if (PHAssetMediaTypeImage == asset.mediaType) {
            
            pureVideo = NO;
            
            __block BOOL isGIFImage = NO;
            NSArray *resourceList = [PHAssetResource assetResourcesForAsset:asset];
            [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAssetResource *resource = obj;
                if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
                    isGIFImage = YES;
                }
            }];
            
            PLSComposeMediaItem *media = [[PLSComposeMediaItem alloc] init];
            
            media.imageDuration = MAX(3, arc4random_uniform(8));
            if (isGIFImage) {
                media.mediaType = PLSMediaTypeGIF;
                if (arc4random() % 2) {
                    media.url = [asset getImageURL:asset];
                    NSLog(@"GIF url");
                } else {
                    media.gifImageData = [asset getImageData:asset];
                    NSLog(@"GIF data");
                }
                media.loopCount = MAX(1, arc4random_uniform(3));
            } else {
                media.mediaType = PLSMediaTypeImage;
                if (arc4random() % 2) {
                    media.image = [asset imageURL:asset targetSize:outputVideoSize];
                    NSLog(@"IMAGE use image");
                } else {
                    media.url = [asset getImageURL:asset];
                    NSLog(@"IMAGE use url");
                }
            }
            [mediaItems addObject:media];
        }
    }
    
    self.imageVideoComposer = [[PLSImageVideoComposer alloc] init];
    self.imageVideoComposer.videoFramerate = 30;
    self.imageVideoComposer.mediaArrays = mediaItems;
    self.imageVideoComposer.videoSize = outputVideoSize;
    self.imageVideoComposer.disableTransition = !self.transitionSwitch.isOn;
    // 如果包含图片，码率设置稍大一点，否则图片切换的时间段容易产生花屏现象
    self.imageVideoComposer.bitrate = pureVideo ? 1024 * 1000 : 1500 * 1000;
    if (self.musicSwitch.isOn) {
        self.imageVideoComposer.musicURL = [[NSBundle mainBundle] URLForResource:@"Whistling_Down_the_Road" withExtension:@"m4a"];
        self.imageVideoComposer.musicVolume = 1.0;
        self.imageVideoComposer.movieVolume = 1.0;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.imageVideoComposer setProcessingBlock:^(float progress) {
        NSLog(@"process = %f", progress);
        [weakSelf setProgress:progress];
    }];
    
    [self.imageVideoComposer setCompletionBlock:^(NSURL * _Nonnull url) {
        NSLog(@"completion");
        [weakSelf hideWating];
        
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
        [weakSelf presentViewController:videoEditViewController animated:YES completion:nil];
        
    }];
    
    [self.imageVideoComposer setFailureBlock:^(NSError * _Nonnull error) {
        [weakSelf hideWating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];

    if (self.imageVideoComposer.disableTransition) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择拼接模式" message:@"同步优先：优先考虑拼接之后音视频的同步性，但是可能造个各个视频的拼接处播放的时候出现音频或者视频卡顿\n流畅优先：优先考虑拼接之后播放的流畅性，各个视频的拼接处不会出现音视频卡顿现象，但是可能造成音视频不同步\n视频优先：以每一段视频数据长度来决定每一段音频数据长度\n 音频优先：以每一段音频数据长度来决定每一段视频数据长度" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *syncAction = [UIAlertAction actionWithTitle:@"同步模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self showWating];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeSync;
            [self.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *smoothAction = [UIAlertAction actionWithTitle:@"流畅模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self showWating];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeSmooth;
            [self.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频优先" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self showWating];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeVideo;
            [self.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *audioAction = [UIAlertAction actionWithTitle:@"音频优先" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self showWating];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeAudio;
            [self.imageVideoComposer startComposing];
        }];
        
        [alert addAction:syncAction];
        [alert addAction:smoothAction];
        [alert addAction:videoAction];
        [alert addAction:audioAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self showWating];
        [self.imageVideoComposer startComposing];
    }
}

- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType {
    __weak __typeof(self) weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [assets addObject:obj];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weak.assets = assets;
            [weak.collectionView reloadData];
        });
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc %@", self.description);
}
@end
