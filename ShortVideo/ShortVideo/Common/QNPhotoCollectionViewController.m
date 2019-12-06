//
//  QNPhotoCollectionViewController.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNPhotoCollectionViewController.h"
#import "QNTranscodeViewController.h"
#import "QNPlayPuzzleViewController.h"

@interface QNPhotoCollectionViewController ()
//<
//QNSelectButtonViewDelegate
//>

@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) UIView *baseToolboxView;
@property (nonatomic, strong) UIView *editToolboxView;
@property (nonatomic, assign) BOOL isMovieLandscapeOrientation;

@property (nonatomic, strong) PLSImageVideoComposer *imageVideoComposer;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, assign) CGFloat imageDuration;

@end

@implementation QNPhotoCollectionViewController

static NSString * const reuseIdentifier = @"photoCell";

- (void)dealloc {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    self.imageVideoComposer = nil;
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self fetchAssetsWithMediaType:self.mediaType];
                    
                } else {
                    [self showAssetsDeniedMessage];
                }
            });
        }];
    } else if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusDenied) {
        [self showAssetsDeniedMessage];
    } else {
        // authorized
    }
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = ([UIScreen mainScreen].bounds.size.width / 4) - 1;
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.urls = [[NSMutableArray alloc] init];
        self.maxSelectCount = 1;
        self.mediaType = PHAssetMediaTypeVideo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.collectionView.frame;
    self.collectionView.frame = CGRectMake(rect.origin.x, rect.origin.y + 64, rect.size.width, rect.size.height - 64 - 140);
    
    [self setupBaseToolboxView];
    
    [self setupEditToolboxView];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    // Register cell classes
    [self.collectionView registerClass:[QNAssetCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = QN_RGBCOLOR(25, 24, 36);
     
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.collectionView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    press.minimumPressDuration = 0.15;
    [self.collectionView addGestureRecognizer:press];
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
        [self fetchAssetsWithMediaType:self.mediaType];
    }
}

- (void)setupBaseToolboxView {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QN_SCREEN_WIDTH, 64)];
    self.baseToolboxView.backgroundColor = QN_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.baseToolboxView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 44)];
    
    CGFloat space = 42;
    if (QN_iPhoneXSMAX || QN_iPhoneX || QN_iPhoneXR) {
        space = 48;
    }
    titleLabel.center = CGPointMake(QN_SCREEN_WIDTH / 2, space);
    titleLabel.text = @"相机胶卷";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.baseToolboxView addSubview:titleLabel];
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:QN_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    cancelButton.frame = CGRectMake(QN_SCREEN_WIDTH - 80, titleLabel.frame.origin.y, 80, 44);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:cancelButton];
    
    // 展示视频拼接的进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 200, 25)];
    self.progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    [self.baseToolboxView addSubview:self.progressLabel];
    
    // 展示视频拼接的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupEditToolboxView {
    self.editToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.collectionView.frame) + self.collectionView.frame.origin.y, QN_SCREEN_WIDTH, 140)];
    self.editToolboxView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.editToolboxView];
    
    // 分辨率模式：竖屏、横屏
//    NSArray *titleArray = @[@"竖屏", @"横屏"];
//    self.buttonView = [[QNSelectButtonView alloc]initWithFrame:CGRectMake(10, 5, 140, 30) defaultIndex:0];
//    self.buttonView.hidden = NO;
//    CGFloat countSpace = 200 / titleArray.count / 6;
//    self.buttonView.space = countSpace;
//    self.buttonView.staticTitleArray = titleArray;
//    self.buttonView.rateDelegate = self;
//    [self.editToolboxView addSubview:_buttonView];
    self.isMovieLandscapeOrientation = NO;
    
    // 下一步
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.editToolboxView.frame) - 100, 5, 90, 30)];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.nextButton.backgroundColor = [UIColor grayColor];
    self.nextButton.layer.cornerRadius = 4.0f;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.editToolboxView addSubview:self.nextButton];
    
    // 展示选中的视频的封面
    CGFloat height = ([UIScreen mainScreen].bounds.size.width / 5);
    self.dynamicScrollView = [[QNSampleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.editToolboxView.frame) - height - 10, CGRectGetWidth(self.editToolboxView.frame), height) withImages:nil];
    [self.editToolboxView addSubview:self.dynamicScrollView];
    
    if (self.mediaType == PHAssetMediaTypeImage) {
        // 处理图片转视频模块，就加个按钮来决定图片的持续时间
        UIButton *imageDurationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.editToolboxView.frame) - 230, 5, 90, 30)];
        [imageDurationButton setTitle:@"图片时长2秒" forState:UIControlStateNormal];
        [imageDurationButton setTitle:@"图片时长3秒" forState:UIControlStateSelected];
        imageDurationButton.selected = NO;
        [imageDurationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        imageDurationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        imageDurationButton.backgroundColor = [UIColor grayColor];
        imageDurationButton.layer.cornerRadius = 4.0f;
        imageDurationButton.layer.masksToBounds = YES;
        [imageDurationButton addTarget:self action:@selector(imageDurationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.editToolboxView addSubview:imageDurationButton];
        
        self.imageDuration = 2.0f; // 默认为 2 秒
    }
}

#pragma mark - button actions

- (void)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)buttonView:(QNSelectButtonView *)buttonView didSelectedTitleIndex:(NSInteger)titleIndex {
//    switch (titleIndex) {
//        case 0:
//            self.isMovieLandscapeOrientation = NO;
//            break;
//        case 1:
//            self.isMovieLandscapeOrientation = YES;
//            break;
//        default:
//            self.isMovieLandscapeOrientation = NO;
//            break;
//    }
//}

- (void)imageDurationButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.imageDuration = 3.0f;
    } else {
        self.imageDuration = 2.0f;
    }
}

- (void)nextButtonClick:(UIButton *)sender {
    
    if (0 == [self.dynamicScrollView selectedAssets].count) {
        NSString *message = [NSString string];
        if (_typeIndex == 0) {
            message = @"请至少选择一个视频！";
        } else {
            message = @"请至少选择一个视频或图片";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.urls removeAllObjects];
        for (PHAsset *asset in self.dynamicScrollView.selectedAssets) {
            NSURL *url = [asset movieURL];
            [self.urls addObject:url];
        }
        
        if (self.urls.count == 1) {
            NSString *message = [NSString string];
            if (_typeIndex == 0) {
                message = @"选择视频个数应大于 1！";
            } else {
                message = @"选择素材个数应大于 1！";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            if (_typeIndex == 1) {
                // 视频拼图
                if (self.urls.count == self.maxSelectCount) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频拼图" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        QNPlayPuzzleViewController *playPuzzleViewController = [[QNPlayPuzzleViewController alloc] init];
                        playPuzzleViewController.urls = self.urls;
                        playPuzzleViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self presentViewController:playPuzzleViewController animated:YES completion:nil];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:cancelAction];
                    [alert addAction:sureAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"请选择 %ld 个视频！", _maxSelectCount] preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:sureAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } else {
                // 素材拼接
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"素材拼接" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self samplesAppending];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - 素材拼接逻辑

- (void)samplesAppending {
    NSMutableArray *mediaItems = [NSMutableArray array];
    BOOL pureVideo = YES;
    for (NSInteger i = 0; i < self.dynamicScrollView.selectedAssets.count; i++) {
        PHAsset *asset = self.dynamicScrollView.selectedAssets[i];
        PLSComposeMediaItem *media = [[PLSComposeMediaItem alloc] init];

        if (asset.mediaType == PHAssetMediaTypeImage) {
            pureVideo = NO;
            __block BOOL isGIFImage = NO;
            NSArray *resourceList = [PHAssetResource assetResourcesForAsset:asset];
            [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAssetResource *resource = obj;
                if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
                    isGIFImage = YES;
                }
            }];
                                
            media.imageDuration = 3;
            if (isGIFImage) {
                media.mediaType = PLSMediaTypeGIF;
                media.loopCount = 3;
            } else {
                media.mediaType = PLSMediaTypeImage;
            }
            media.url = [asset getImageURL:asset];
        }
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            media.mediaType = PLSMediaTypeVideo;
            media.url = [asset movieURL];
        }
        [mediaItems addObject:media];
    }
    [self useImageVideosComposer:mediaItems pureVideo:pureVideo];
}

#pragma mark - 使用 PLSImageVideoComposer

- (void)useImageVideosComposer:(NSMutableArray *)mediaItems pureVideo:(BOOL)pureVideo{
    NSString *sizeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"qn_encode_size"];
    NSArray *sizeArray = [sizeString componentsSeparatedByString:@"x"];
    NSInteger width = [sizeArray[0] integerValue];
    NSInteger height = [sizeArray[1] integerValue];

    CGSize outputVideoSize = CGSizeZero;
    if (self.isMovieLandscapeOrientation) {
        if (width < height) {
            outputVideoSize = CGSizeMake(height, width);
        } else{
            outputVideoSize = CGSizeMake(width, height);
        }
    } else{
        if (width > height) {
            outputVideoSize = CGSizeMake(height, width);
        } else{
            outputVideoSize = CGSizeMake(width, height);
        }
    }
        
    self.imageVideoComposer = [[PLSImageVideoComposer alloc] init];
    self.imageVideoComposer.videoFramerate = 30;
    self.imageVideoComposer.mediaArrays = mediaItems;
    self.imageVideoComposer.videoSize = outputVideoSize;
   
    self.imageVideoComposer.disableTransition = NO;
    // 如果包含图片，码率设置稍大一点，否则图片切换的时间段容易产生花屏现象
    self.imageVideoComposer.bitrate = pureVideo ? 1024 * 1000 : 1500 * 1000;

    __weak typeof(self) weakSelf = self;
    
    [self.imageVideoComposer setProcessingBlock:^(float progress) {
        NSLog(@"process = %f", progress);
        [weakSelf setProgress:progress];
    }];
      
    [self.imageVideoComposer setCompletionBlock:^(NSURL * _Nonnull url) {
        NSLog(@"completion success！");
        [weakSelf removeActivityIndicatorView];
        
        QNTranscodeViewController *transcodeController = [[QNTranscodeViewController alloc] init];
        transcodeController.sourceURL = url;
        [weakSelf presentViewController:transcodeController animated:YES completion:nil];
    }];
      
    [self.imageVideoComposer setFailureBlock:^(NSError * _Nonnull error) {
        [weakSelf removeActivityIndicatorView];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sureAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];

    if (self.imageVideoComposer.disableTransition) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择拼接模式" message:@"同步优先：优先考虑拼接之后音视频的同步性，但是可能造成各个视频的拼接处播放的时候出现音频或者视频卡顿\n流畅优先：优先考虑拼接之后播放的流畅性，各个视频的拼接处不会出现音视频卡顿现象，但是可能造成音视频不同步\n视频优先：以每一段视频数据长度来决定每一段音频数据长度\n 音频优先：以每一段音频数据长度来决定每一段视频数据长度" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *syncAction = [UIAlertAction actionWithTitle:@"同步模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self loadActivityIndicatorView];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeSync;
            [self.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *smoothAction = [UIAlertAction actionWithTitle:@"流畅模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self loadActivityIndicatorView];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeSmooth;
            [self.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频优先" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self loadActivityIndicatorView];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeVideo;
            [self.imageVideoComposer startComposing];
        }];
        
        UIAlertAction *audioAction = [UIAlertAction actionWithTitle:@"音频优先" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self loadActivityIndicatorView];
            self.imageVideoComposer.composerPriorityType = PLSComposerPriorityTypeAudio;
            [self.imageVideoComposer startComposing];
        }];
        
        [alert addAction:syncAction];
        [alert addAction:smoothAction];
        [alert addAction:videoAction];
        [alert addAction:audioAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self loadActivityIndicatorView];
        [self.imageVideoComposer startComposing];
    }
}

#pragma mark - load/remove activity

- (void)loadActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

- (void)removeActivityIndicatorView {
    [self.activityIndicatorView removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
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

#pragma mark - view autorotate

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Assets

- (void)showAssetsDeniedMessage {
    NSString *title = NSLocalizedString(@"Enable Access", @"Title for an alert that lets the user know that they need to enable access to their photo library");
    NSString *message = NSLocalizedString(@"Access to your photo library can be enabled in the Settings app.", @"Message for an alert that lets the user know that they need to enable access to their photo library");
    NSString *cancel = NSLocalizedString(@"Cancel", @"Alert cancel button");
    NSString *settings = NSLocalizedString(@"Settings", @"Settings button");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:settings style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
       // 没有授权就跳转到 App 的设置页
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType {
    __weak __typeof(self) weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:mediaType options:fetchOptions];
        
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

#pragma mark - 选中的视频视图

- (void)updateScrollView:(PHAsset *)asset {
    if (asset) {
        [self.dynamicScrollView addAsset:asset];
    }
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
        if (indexPath) {
            PHAsset *asset = self.assets[indexPath.item];
            // 更新 scrollview
            [self updateScrollView:asset];
        }
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
        if (indexPath) {
            PHAsset *asset = self.assets[indexPath.item];
            
            [self.previewImageView removeFromSuperview];
            UIImageView *previewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            self.previewImageView = previewImageView;
            self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.previewImageView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:self.previewImageView];
            
            self.previewImageView.alpha = 0.0;
            [UIView animateWithDuration:0.1 animations:^{
                self.previewImageView.alpha = 1.0;
            }];
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize size = CGSizeMake(self.view.bounds.size.width * scale, self.view.bounds.size.height * scale);
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                if (self.previewImageView == previewImageView) {
                    self.previewImageView.image = result;
                }
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.previewImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.previewImageView removeFromSuperview];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QNAssetCollectionViewCell *cell = (QNAssetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    PHAsset *asset = self.assets[indexPath.item];
    cell.phAsset = asset;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
