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
#import "ViewRecordViewController.h"
#import "EditViewController.h"

#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
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
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        
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

- (UIImage *)imageURL:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    __block UIImage *image = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    // 设置 resizeMode = PHImageRequestOptionsResizeModeExact， 否则返回的图片大小不一定是设置的 targetSize
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    // 设置 deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat，是保证 resultHandler 值回调一次，否则可能回回调多次，只有最后一次返回的图片大小等于设置的 targetSize
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageForAsset:phAsset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    
    return image;
}


- (NSURL *)getImageFilePath {
    
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@.JPG", cacheFolder, nowTimeStr];
    return [NSURL fileURLWithPath:urlString];
    
}

- (NSURL *)getImageURL:(PHAsset *)phAsset {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    __block NSURL *url = nil;
    __weak typeof(self) weakSelf = self;
    [manager requestImageDataForAsset:phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (imageData) {
            // 这里需要重新将图片数据写到 App 可以访问的目录，不然直接使用 info 中的 url，可能会获取不到图片数据
            url = [weakSelf getImageFilePath];
            [[NSFileManager defaultManager] createFileAtPath:url.path contents:imageData attributes:nil];
        }
    }];
    
    return url;
}

- (NSData *)getImageData:(PHAsset *)phAsset {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    __block NSData *data = nil;
    [manager requestImageDataForAsset:phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        data = imageData;
    }];
    
    return data;
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
        self.durationLabel = [[UILabel alloc] init];
        self.durationLabel.text = @"00:00";
        self.durationLabel.textColor = UIColor.whiteColor;
        if ([UIFont respondsToSelector:@selector(monospacedDigitSystemFontOfSize:weight:)]) {
            self.durationLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
        } else {
            self.durationLabel.font = [UIFont systemFontOfSize:12];
        }
        [self.durationLabel sizeToFit];
        self.durationLabel.frame = CGRectMake(3, frame.size.height - self.durationLabel.bounds.size.height - 3, self.durationLabel.bounds.size.width, self.durationLabel.bounds.size.height);
        [self.contentView addSubview:self.durationLabel];
        self.durationLabel.hidden = YES;
        
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = [UIFont systemFontOfSize:12];
        self.infoLabel.numberOfLines = 3;
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.text = @"00\n00\n00";
        [self.infoLabel sizeToFit];
        self.infoLabel.text = @"";
        self.infoLabel.frame = CGRectMake(3, 3, self.contentView.bounds.size.width - 3, self.infoLabel.bounds.size.height);
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.infoLabel.bounds.size.height + 3);
        gradientLayer.colors = @[
                                 (__bridge id)[[UIColor colorWithWhite:.0 alpha:.5] CGColor],
                                 (__bridge id)[[UIColor clearColor] CGColor]
                                 ];
        [self.contentView.layer addSublayer:gradientLayer];
        [self.contentView addSubview:self.infoLabel];
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


- (NSString *)videoInfoWithAVAsset:(AVAsset *)asset {
    NSString *videoInfo = @"Get Nothing";
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count) {
        AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        CGSize videoSize = videoTrack.naturalSize;
        
        CGAffineTransform transform = videoTrack.preferredTransform;
        NSInteger degree = round(atan2(transform.b, transform.a) * (180.0 / M_PI));
        NSInteger width = round(videoSize.width);
        NSInteger height = round(videoSize.height);
        
        int bitrate = videoTrack.estimatedDataRate / 1000;
        videoInfo = [NSString stringWithFormat:@"%ldx%ld %ld°\n%0.2f fps\n%d kbps",
                     (long)width, (long)height, (long)degree, videoTrack.nominalFrameRate, bitrate];
    }
    return videoInfo;
}

- (void)setPhAsset:(PHAsset *)phAsset {
    if (_phAsset != phAsset) {
        _phAsset = phAsset;
        self.localIdentifier = phAsset.localIdentifier;
        
        [self cancelImageRequest];
        
        if (_phAsset) {
            if (PHAssetMediaTypeVideo == phAsset.mediaType) {
                self.durationLabel.hidden = NO;
                int duration = round(phAsset.duration);
                self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", duration / 60, duration % 60];
            } else {
                self.durationLabel.hidden = YES;
            }
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
            self.imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:phAsset
                                                                             targetSize:size
                                                                            contentMode:PHImageContentModeAspectFill
                                                                                options:options
                                                                          resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                              if ([self.localIdentifier isEqualToString:phAsset.localIdentifier] ) {
                                                                                  self.imageView.image = result;
                                                                              }
                                                                          }];
            
            // Video indicator
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.localIdentifier isEqualToString:phAsset.localIdentifier]) {
                            self.infoLabel.text = [self videoInfoWithAVAsset:asset];
                        }
                    });
                }];
            } else {
                self.infoLabel.text = [NSString stringWithFormat:@"%lux%lu",(unsigned long)phAsset.pixelWidth, (unsigned long)phAsset.pixelHeight];
            }
        }
    }
}

@end

#pragma mark -- 选择视频的控制器
#pragma mark -- PhotoAlbumViewController

@interface PhotoAlbumViewController () <UIAlertViewDelegate, PLSRateButtonViewDelegate>

@property (strong, nonatomic) UIImageView *previewImageView;

@property (strong, nonatomic) NSMutableArray *urls;
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *editToolboxView;
@property (assign, nonatomic) BOOL isMovieLandscapeOrientation;

@property (strong, nonatomic) PLSImageToMovieComposer *imageToMovieComposer;
@property (strong, nonatomic) PLSMovieComposer *movieComposer;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;

@property (assign, nonatomic) CGFloat imageDuration;

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
        self.mediaType = PHAssetMediaTypeVideo;
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
        [self fetchAssetsWithMediaType:self.mediaType];
    }
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

- (void)setupBaseToolboxView {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 64)];
    self.baseToolboxView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self.view addSubview:self.baseToolboxView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 64)];
    if (iPhoneX_SERIES) {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 48);
    } else {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    }
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
    cell.phAsset = asset;
    
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

#pragma mark -- imageDurationButtonClicked
- (void)imageDurationButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.imageDuration = 3.0f;
    } else {
        self.imageDuration = 2.0f;
    }
}

#pragma mark -- 下一步
- (void)nextButtonClick:(UIButton *)sender {
    // 视频选择器视图中图片、视频的选取数目可以做限制的，限制为1个、多个、不限
    if (self.dynamicScrollView.selectedAssets.count > 0) {
        if (self.mediaType == PHAssetMediaTypeImage) {
            // 图片合成为视频
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片处理" delegate:self cancelButtonTitle:@"view录制" otherButtonTitles:@"合成视频", nil];
            alertView.tag = 10001;
            [alertView show];
            
        } else if (self.mediaType == PHAssetMediaTypeVideo) {
            [self.urls removeAllObjects];
            for (PHAsset *asset in self.dynamicScrollView.selectedAssets) {
                NSURL *url = [asset movieURL];
                [self.urls addObject:url];
            }
            
            if (self.urls.count == 1) {
                // 视频转码
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"视频转码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 10002;
                [alertView show];
                
            }else {
                // 多个视频拼接 或者 单个视频转码 都可以用 PLSMovieComposer
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"视频拼接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 10003;
                [alertView show];
            }
        }
    }
}

#pragma mark -- UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // 检测是否授权访问相册，没有授权就跳转到 App 的设置页
    if (10001 != alertView.tag && 10002 != alertView.tag && 10003 != alertView.tag && 10004 != alertView.tag) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (10001 == alertView.tag) {
        if (1 == buttonIndex) {
            // 图片合成为视频
            [self imageToMovieEvent];
        } else if (0 == buttonIndex) {
            // view录制
            [self viewRecordEvent];
        }
        
    } else if (10002 == alertView.tag) {
        if (1 == buttonIndex) {
            // 视频转码
            [self movieTransCodeEvent];
        } else if (0 == buttonIndex) {
            // 直接进入编辑页面
            [self joinEditViewController:self.urls[0]];
        }
        
    } else if (10003 == alertView.tag) {
        if (1 == buttonIndex) {
            
            NSString *message = @"同步优先：优先考虑拼接之后音视频的同步性，但是可能造个各个视频的拼接处播放的时候出现音频或者视频卡顿\n流畅优先：优先考虑拼接之后播放的流畅性，各个视频的拼接处不会出现音视频卡顿现象，但是可能造成音视频不同步\n视频优先：以每一段视频数据长度来决定每一段音频数据长度\n 音频优先：以每一段音频数据长度来决定每一段视频数据长度";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"同步优先", @"流畅优先",@"视频优先", @"音频优先", nil];
            alert.tag = 10004;
            
            [alert show];
        }
    } else if (10004 == alertView.tag) {
        // 多个视频拼接 或者 单个视频转码 都可以用 PLSMovieComposer
        if (0 == buttonIndex) {
            [self movieComposerEvent:PLSComposerPriorityTypeSync];
        } else if (1 == buttonIndex ) {
            [self movieComposerEvent:PLSComposerPriorityTypeSmooth];
        } else if (2 == buttonIndex) {
            [self movieComposerEvent:PLSComposerPriorityTypeVideo];
        } else {
            [self movieComposerEvent:PLSComposerPriorityTypeAudio];
        }
    }
}

// 直接进入编辑页面
- (void)joinEditViewController:(NSURL *)url {
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
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

//#define USE_IMAGE

// 图片合成为视频
- (void)imageToMovieEvent {
    [self.urls removeAllObjects];
    for (PHAsset *asset in self.dynamicScrollView.selectedAssets) {
#ifdef USE_IMAGE
        UIImage *image = [asset imageURL:asset targetSize:CGSizeMake(544, 960)];
        [self.urls addObject:image];
#else
        NSURL *url = [asset getImageURL:asset];
        if (url) {
            [self.urls addObject:url];
        }
#endif
    }
    
    [self loadActivityIndicatorView];
    
    __weak typeof(self)weakSelf = self;
#ifdef USE_IMAGE
    self.imageToMovieComposer = [[PLSImageToMovieComposer alloc] initWithImages:self.urls];
#else
    self.imageToMovieComposer = [[PLSImageToMovieComposer alloc] initWithImageURLs:self.urls];
#endif
    if (self.isMovieLandscapeOrientation) {
        self.imageToMovieComposer.videoSize = CGSizeMake(960, 544);
    } else {
        self.imageToMovieComposer.videoSize = CGSizeMake(544, 960);
    }
    
    // Warning：在这之前一定要给 self.imageDuration 赋值，不然就会 crash。
    // 在 - (void)setupEditToolboxView 里设置了 self.imageDuration = 2.0f;，self.imageDuration 的值的改变通过 - (void)imageDurationButtonClicked:(UIButton *)sender 事件。
    self.imageToMovieComposer.imageDuration = self.imageDuration;
    
    [self.imageToMovieComposer setCompletionBlock:^(NSURL *url) {
        NSLog(@"imageToMovieComposer ur: %@", url);
        
        [weakSelf removeActivityIndicatorView];
        weakSelf.progressLabel.text = @"";
        
        MovieTransCodeViewController *transCodeViewController = [[MovieTransCodeViewController alloc] init];
        transCodeViewController.url = url;
        [weakSelf presentViewController:transCodeViewController animated:YES completion:nil];
    }];
    [self.imageToMovieComposer setFailureBlock:^(NSError *error) {
        NSLog(@"imageToMovieComposer failed");
        AlertViewShow(error);

        [weakSelf removeActivityIndicatorView];
        weakSelf.progressLabel.text = @"";
    }];
    [self.imageToMovieComposer setProcessingBlock:^(float progress) {
        NSLog(@"imageToMovieComposer progress: %f", progress);
        
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"合成进度%d%%", (int)(progress * 100)];
    }];
    
    [self.imageToMovieComposer startComposing];
}

// view 录制
- (void)viewRecordEvent {
    ViewRecordViewController *viewRecordViewController = [[ViewRecordViewController alloc] init];
    viewRecordViewController.selectedAssets = self.dynamicScrollView.selectedAssets;
    [self presentViewController:viewRecordViewController animated:YES completion:nil];
}

// 视频转码
- (void)movieTransCodeEvent {
    MovieTransCodeViewController *transCodeViewController = [[MovieTransCodeViewController alloc] init];
    transCodeViewController.url = self.urls[0];
    [self presentViewController:transCodeViewController animated:YES completion:nil];
}

// 多个视频拼接 或者 单个视频转码 都可以用 PLSMovieComposer
- (void)movieComposerEvent:(PLSComposerPriorityType)type {
    [self loadActivityIndicatorView];
    
    __weak typeof(self)weakSelf = self;
    self.movieComposer = [[PLSMovieComposer alloc] initWithUrls:self.urls];
    self.movieComposer.composerPriorityType = type;
#if 1
    if (self.isMovieLandscapeOrientation) {
        self.movieComposer.videoSize = CGSizeMake(960, 540);
    } else {
        self.movieComposer.videoSize = CGSizeMake(540, 960);
    }
#else
    // 不设置 videoSize 的情形下，以第1个视频的分辨率为参照进行拼接
#endif
    
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
        AlertViewShow(error);

        [weakSelf removeActivityIndicatorView];
        weakSelf.progressLabel.text = @"";
        
    }];
    [self.movieComposer setProcessingBlock:^(float progress){
        NSLog(@"movieComposer progress: %f", progress);
        
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"拼接进度%d%%", (int)(progress * 100)];
    }];
    
    [self.movieComposer startComposing];
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
    
    self.imageToMovieComposer = nil;
    self.movieComposer = nil;
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end

