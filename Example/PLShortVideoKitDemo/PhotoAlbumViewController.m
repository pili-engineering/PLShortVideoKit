//
//  PhotoAlbumViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import "MovieTransCodeViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSRateButtonView.h"

#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)


#pragma mark -- PLSScrollView

@implementation PLSScrollView
{
    float singleWidth;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
}

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageViews = [NSMutableArray arrayWithCapacity:images.count];
        self.images = images;
        singleWidth = ([UIScreen mainScreen].bounds.size.width / 5);
        
        self.selectedAssets = [[NSMutableArray alloc] init];
        
        // 创建底部滑动视图
        [self initScrollView];
        [self initViews];
    }
    return self;
}

- (void)initScrollView {
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
}

- (void)initViews {
    for (int i = 0; i < self.images.count; i++) {
        UIImage *image = self.images[i];
        [self createImageViews:i image:image];
    }
    self.scrollView.contentSize = CGSizeMake(self.images.count * singleWidth, self.scrollView.frame.size.height);
}

- (void)createImageViews:(NSUInteger)i image:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake(singleWidth*i + singleWidth * 0.1, singleWidth * 0.1, singleWidth * 0.8, self.scrollView.frame.size.height * 0.8);
    imgView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imgView];
    [self.imageViews addObject:imgView];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"btn_banner_a"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(- 20, - 20, 60, 60);
    deleteButton.backgroundColor = [UIColor clearColor];
    [imgView addSubview:deleteButton];
}

// 获取view在imageViews中的位置
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view {
    UIImageView *originImageView = (UIImageView *)view;
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *otherImageView = self.imageViews[i];
        if (otherImageView != originImageView) {
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

- (void)deleteAction:(UIButton *)button {
    UIImageView *imageView = (UIImageView *)button.superview;
    __block NSUInteger index = [self.imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = self.scrollView;
    
    [self.selectedAssets removeObjectAtIndex:index];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (NSUInteger i = index + 1; i < self.imageViews.count; i++) {
                UIImageView *otherImageView = self.imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
        } completion:^(BOOL finished) {
            [self.imageViews removeObject:imageView];
            if (self.imageViews.count > 5) {
                weakScroll.contentSize = CGSizeMake(singleWidth*self.imageViews.count, _scrollView.frame.size.height);
            }
        }];
    }];
}

- (void)addAsset:(PHAsset *)asset {
    [self.selectedAssets addObject:asset];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width / 5);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(width * scale, width * scale);
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                // 设置的 options 可能会导致该回调调用两次，第一次返回你指定尺寸的图片，第二次将会返回原尺寸图片
                                                if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0){
                                                    // Do something with the FULL SIZED image
                                                    
                                                    [self addImage:result];
                                                    
                                                } else {
                                                    // Do something with the regraded image
                                                    
                                                }
                                            }];
}

- (void)addImage:(UIImage *)image {
    [self createImageViews:self.imageViews.count image:image];
    
    self.scrollView.contentSize = CGSizeMake(singleWidth*self.imageViews.count, self.scrollView.frame.size.height);
    if (self.imageViews.count > 5) {
        [self.scrollView setContentOffset:CGPointMake((self.imageViews.count-5)*singleWidth, 0) animated:YES];
    }
}

- (void)deleteImage:(UIImage *)image {
    
}


@end


#pragma mark -- PHAsset (PLSImagePickerHelpers)

@implementation PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL {
    __block NSURL *url = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    if (self.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            url = urlAsset.URL;
    
            dispatch_semaphore_signal(semaphore);
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return url;
}

@end


#pragma mark -- PLSAssetCell

@implementation PLSAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageRequestID = PHInvalidImageRequestID;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.imageView.bounds = self.bounds;
}

- (void)prepareForReuse {
    [self cancelImageRequest];
    self.imageView.image = nil;
}

- (void)cancelImageRequest {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        self.imageRequestID = PHInvalidImageRequestID;
    }
}

- (void)setAsset:(PHAsset *)asset {
    if (_asset != asset) {
        _asset = asset;
        
        [self cancelImageRequest];
        
        if (_asset) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
            self.imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:_asset
                                                                             targetSize:size
                                                                            contentMode:PHImageContentModeAspectFill
                                                                                options:options
                                                                          resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                              if (_asset == asset) {
                                                                                  self.imageView.image = result;
                                                                              }
                                                                          }];
        }
        
    }
}

@end

#pragma mark -- 选择视频的控制器
#pragma mark -- PhotoAlbumViewController

@interface PhotoAlbumViewController () <UIAlertViewDelegate, PLSRateButtonViewDelegate>

@property (strong, nonatomic) NSArray *assets;
@property (strong, nonatomic) UIImageView *previewImageView;

@property (strong, nonatomic) NSMutableArray *urls;
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *editToolboxView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) PLSRateButtonView *rateButtonView;
@property (assign, nonatomic) BOOL isMovieLandscapeOrientation;
@property (strong, nonatomic) PLSScrollView *dynamicScrollView;

@property (strong, nonatomic) PLSMovieComposer *movieComposer;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation PhotoAlbumViewController

static NSString * const reuseIdentifier = @"Cell";

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --------------------------
    
    CGRect rect = self.collectionView.frame;
    self.collectionView.frame = CGRectMake(rect.origin.x, rect.origin.y + 64, rect.size.width, rect.size.height - 64 - 140);
    
    [self setupBaseToolboxView];
    
    [self setupEditToolboxView];
    
    // --------------------------
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[PLSAssetCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.collectionView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    press.minimumPressDuration = 0.15;
    [self.collectionView addGestureRecognizer:press];
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
        [self fetchAssets];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self fetchAssets];
                    
                    
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

- (void)setupBaseToolboxView {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 64)];
    self.baseToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.baseToolboxView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 64)];
    titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    titleLabel.text = @"相机胶卷";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.baseToolboxView addSubview:titleLabel];
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    cancelButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:cancelButton];
    
    // 展示视频拼接的进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 200, 45)];
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
    self.editToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT - 140, PLS_SCREEN_WIDTH, 140)];
    self.editToolboxView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.editToolboxView];
    
    // 分辨率模式：竖屏、横屏
    NSArray *titleArray = @[@"竖屏", @"横屏"];
    self.rateButtonView = [[PLSRateButtonView alloc]initWithFrame:CGRectMake(10, 5, 140, 30) defaultIndex:0];
    self.rateButtonView.hidden = NO;
    CGFloat countSpace = 200 / titleArray.count / 6;
    self.rateButtonView.space = countSpace;
    self.rateButtonView.staticTitleArray = titleArray;
    self.rateButtonView.rateDelegate = self;
    [self.editToolboxView addSubview:self.rateButtonView];
    
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
    self.dynamicScrollView = [[PLSScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.editToolboxView.frame) - height - 10, CGRectGetWidth(self.editToolboxView.frame), height) withImages:nil];
    [self.editToolboxView addSubview:self.dynamicScrollView];
}

#pragma mark - Assets

- (void)showAssetsDeniedMessage {
    NSString *title = NSLocalizedString(@"Enable Access", @"Title for an alert that lets the user know that they need to enable access to their photo library");
    NSString *message = NSLocalizedString(@"Access to your photo library can be enabled in the Settings app.", @"Message for an alert that lets the user know that they need to enable access to their photo library");
    NSString *cancel = NSLocalizedString(@"Cancel", @"Alert cancel button");
    NSString *settings = NSLocalizedString(@"Settings", @"Settings button");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:settings, nil];
    [alert show];
}

- (void)fetchAssets {
    __weak __typeof(self) weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
        
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSAssetCell *cell = (PLSAssetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    PHAsset *asset = self.assets[indexPath.item];
    cell.asset = asset;
    
    return cell;
}

#pragma mark --- 选中的视频的视图
- (void)updateScrollView:(PHAsset *)asset {
    if (asset) {
//        if (self.dynamicScrollView.selectedAssets.count < self.maxSelectCount) {
            [self.dynamicScrollView addAsset:asset];
//        }
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
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:size
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:options
                                                    resultHandler:^(UIImage *result, NSDictionary *info) {
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

#pragma mark - 按钮的响应事件
#pragma mark -- 返回
- (void)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 竖屏、横屏分辨率
#pragma mark -- PLSRateButtonViewDelegate
- (void)rateButtonView:(PLSRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex{
    switch (titleIndex) {
        case 0:
            self.isMovieLandscapeOrientation = NO;
            break;
        case 1:
            self.isMovieLandscapeOrientation = YES;
            break;
        default:
            self.isMovieLandscapeOrientation = NO;
            break;
    }
}

#pragma mark -- 下一步
- (void)nextButtonClick:(UIButton *)sender {
    [self.urls removeAllObjects];
    
    for (PHAsset *asset in self.dynamicScrollView.selectedAssets) {
        NSURL *url = [asset movieURL];
        [self.urls addObject:url];
    }
    
    // 视频选择器视图中视频的选取数目可以做限制的，限制为1个、多个、不限
    if (self.urls.count > 0) {
        if (self.urls.count == 1) {
            MovieTransCodeViewController *transCodeViewController = [[MovieTransCodeViewController alloc] init];
            transCodeViewController.url = self.urls[0];
            [self presentViewController:transCodeViewController animated:YES completion:nil];
        }
        else {
            [self loadActivityIndicatorView];

            __weak typeof(self)weakSelf = self;
            self.movieComposer = [[PLSMovieComposer alloc] initWithUrls:self.urls];
            if (self.isMovieLandscapeOrientation) {
                self.movieComposer.videoSize = CGSizeMake(960, 544);
            } else {
                self.movieComposer.videoSize = CGSizeMake(544, 960);
            }
            self.movieComposer.videoFrameRate = 25;
            self.movieComposer.outputFileType = PLSFileTypeMPEG4;
            
            [self.movieComposer setCompletionBlock:^(NSURL *url) {
                NSLog(@"movieComposer ur: %@", url);

                [weakSelf removeActivityIndicatorView];
                weakSelf.progressLabel.text = @"";
                
                MovieTransCodeViewController *transCodeViewController = [[MovieTransCodeViewController alloc] init];
                transCodeViewController.url = url;
                [weakSelf presentViewController:transCodeViewController animated:YES completion:nil];
            }];
            [self.movieComposer setFailureBlock:^(NSError *error) {
                NSLog(@"movieComposer failed");

                [weakSelf removeActivityIndicatorView];
                weakSelf.progressLabel.text = @"";

            }];
            [self.movieComposer setProcessingBlock:^(float progress){
                NSLog(@"movieComposer progress: %f", progress);
                
                weakSelf.progressLabel.text = [NSString stringWithFormat:@"拼接进度%d%%", (int)(progress * 100)];
            }];
            
            [self.movieComposer startComposing];
        }
    }
}

// 加载拼接视频的动画
- (void)loadActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

// 移除拼接视频的动画
- (void)removeActivityIndicatorView {
    [self.activityIndicatorView removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
}

#pragma mark -- view autorotate
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    
    self.movieComposer = nil;
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end

