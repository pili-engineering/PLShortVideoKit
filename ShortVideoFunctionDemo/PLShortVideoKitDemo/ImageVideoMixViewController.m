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
#import "TransitionPreViewController.h"

@interface ImageVideoMixViewController ()
<
PLSScrollViewDelegate
>

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
    
    self.dynamicScrollView.delegate = self;
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
            media.transitionDuration = 1.0;
            media.transitionType = [self.dynamicScrollView.selectedTypes[i] intValue];
            media.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(5 * 1000, 1000));
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
            media.transitionDuration = 1.0;
            media.transitionType = [self.dynamicScrollView.selectedTypes[i] intValue];
            
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
        
    self.imageVideoComposer.disableTransition = NO;
    self.imageVideoComposer.useGobalTransition = NO;
    [self startPreview];
}

#pragma mark - PLScrollViewDelegate

- (void)scrollView:(PLSScrollView *)columnListView didClickIndex:(NSInteger)index button:(UIButton *)button{
    __weak typeof(self)weakSelf = self;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择转场效果" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
    UIAlertAction *fadeAction = [UIAlertAction actionWithTitle:@"淡入淡出" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeFade)];
        [button setTitle:@"淡入淡出" forState:UIControlStateNormal];
    }];
    [alert addAction:fadeAction];

            
    /********* OpenGL *********/
    UIAlertAction *gradualBlackAction = [UIAlertAction actionWithTitle:@"闪黑" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeFadeBlack)];
        [button setTitle:@"闪黑" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *gradualWhiteAction = [UIAlertAction actionWithTitle:@"闪白" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeFadeWhite)];
        [button setTitle:@"闪白" forState:UIControlStateNormal];
    }];
    
    [alert addAction:gradualWhiteAction];
    [alert addAction:gradualBlackAction];
              
    UIAlertAction *circularCropAction = [UIAlertAction actionWithTitle:@"圆形" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeCircularCrop)];
        [button setTitle:@"圆形" forState:UIControlStateNormal];
    }];
    [alert addAction:circularCropAction];
    
    // 飞入 上下左右
    UIAlertAction *sliderUpAction = [UIAlertAction actionWithTitle:@"从上飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderUp)];
        [button setTitle:@"从上飞入" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *sliderDownAction = [UIAlertAction actionWithTitle:@"从下飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderDown)];
        [button setTitle:@"从下飞入" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *sliderLeftAction = [UIAlertAction actionWithTitle:@"从左飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderLeft)];
        [button setTitle:@"从左飞入" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *sliderRightAction = [UIAlertAction actionWithTitle:@"从右飞入" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeSliderRight)];
        [button setTitle:@"从右飞入" forState:UIControlStateNormal];
    }];
    
    [alert addAction:sliderUpAction];
    [alert addAction:sliderDownAction];
    [alert addAction:sliderLeftAction];
    [alert addAction:sliderRightAction];
              
    // 擦除 上下左右
    UIAlertAction *wipeUpAction = [UIAlertAction actionWithTitle:@"从上擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeUp)];
        [button setTitle:@"从上擦除" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *wipeDownAction = [UIAlertAction actionWithTitle:@"从下擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeDown)];
        [button setTitle:@"从下擦除" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *wipeLeftAction = [UIAlertAction actionWithTitle:@"从左擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeLeft)];
        [button setTitle:@"从左擦除" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *wipeRightAction = [UIAlertAction actionWithTitle:@"从右擦除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeWipeRight)];
        [button setTitle:@"从右擦除" forState:UIControlStateNormal];
    }];
    
    [alert addAction:wipeUpAction];
    [alert addAction:wipeDownAction];
    [alert addAction:wipeLeftAction];
    [alert addAction:wipeRightAction];
        
    UIAlertAction *noneAction = [UIAlertAction actionWithTitle:@"无" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dynamicScrollView.selectedTypes replaceObjectAtIndex:index withObject:@(PLSTransitionTypeNone)];
        [button setTitle:@"无" forState:UIControlStateNormal];
    }];
        
    [alert addAction:noneAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)startPreview {
    __weak typeof(self)weakSelf = self;

    [self showWating];
    
    [self.imageVideoComposer setPreviewBlock:^(AVPlayerItem *playerItem) {
        [weakSelf hideWating];
        if (playerItem) {
            [weakSelf enterTransitionPreviewWithPlayerItem:playerItem];
        } else{
            NSLog(@"playItem is nil!");
        }
    }];
    
    [self.imageVideoComposer setPreviewFailureBlock:^(NSError *error) {
        [weakSelf hideWating];
        NSLog(@"ImageVideoMixControllrt: imageVideoComposer preview failed error - %@", error.localizedDescription);
    }];
        
    [self.imageVideoComposer previewVideoByPlayerItem];
}


// 进入预览界面
- (void)enterTransitionPreviewWithPlayerItem:(AVPlayerItem *)playerItem {
    TransitionPreViewController *transitionPreviewController = [[TransitionPreViewController alloc] init];
    transitionPreviewController.playerItem = playerItem;
    transitionPreviewController.imageVideoComposer = self.imageVideoComposer;
    transitionPreviewController.images = self.dynamicScrollView.images;
    transitionPreviewController.types = self.dynamicScrollView.selectedTypes;
    [self presentViewController:transitionPreviewController animated:YES completion:nil];
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
