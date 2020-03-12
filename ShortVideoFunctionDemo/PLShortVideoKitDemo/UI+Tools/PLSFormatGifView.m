//
//  PLSFormatGifView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/7/31.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSFormatGifView.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "UIImage+PLSClip.h"

@interface PLSFormatGifViewCell ()

@property (strong, nonatomic) UIImageView *scaledIamgeView;
    
@end

@implementation PLSFormatGifViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scaledIamgeView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:self.scaledIamgeView];
        
        self.selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.selectButton setImage:[UIImage imageNamed:@"btn_no_selected_pic"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"btn_selected_pic"] forState:UIControlStateSelected];
        [self.scaledIamgeView addSubview:_selectButton];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.rightMargin.mas_equalTo(-3);
            make.top.mas_equalTo(3);
        }];
    }
    return self;
}

- (void)setImageData:(UIImage *)imageData {
    _imageData = imageData;
    NSInteger cellSize = (NSInteger)(PLS_SCREEN_WIDTH - 5)/4;
    CGFloat height = imageData.size.height/imageData.size.width * cellSize;
    self.scaledIamgeView.frame = CGRectMake(0, 0, cellSize, height);
    self.scaledIamgeView.image = imageData;
}

@end

static NSString * const PLSFormatGifViewCellId = @"PLSFormatGifViewCellId";

@interface PLSFormatGifView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSURL *videoUrl; // 视频的 url
@property (strong, nonatomic) AVAsset *videoAsset; // 视频的 AVAsset
@property (nonatomic, assign) Float64 frameRate; // 帧率
@property (assign, nonatomic) Float64 minDuration; // 截取视频的最短时间
@property (assign, nonatomic) Float64 maxDuration; // 截取视频的最长时间
@property (nonatomic, assign) Float64 totalSeconds; // 总秒数
@property (nonatomic, assign) Float64 screenSeconds; // 当前屏幕显示的秒数
@property (assign, nonatomic) NSUInteger minImageCount;

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImages;
@property (nonatomic, strong) NSMutableArray *selectedImages;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *previewButton;



@end
@implementation PLSFormatGifView

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration {
    self = [super init];
    if (self) {
        _videoUrl = url;
        _minDuration = minDuration;
        _maxDuration = maxDuration;
        
        _videoAsset = [AVAsset assetWithURL:self.videoUrl];
        
        _minImageCount = maxDuration; // 视频关键帧间隔 1 秒
        
        [self initFramesView];
        [self initFramesData:_videoAsset];
    }
    return self;
}
    
- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration {
    self = [super init];
    if (self) {
        _videoAsset = asset;
        _minDuration = minDuration;
        _maxDuration = maxDuration;
        
        _minImageCount = maxDuration; // 视频关键帧间隔 1 秒
        
        [self initFramesView];
        [self initFramesData:_videoAsset];
    }
    return self;
}

- (void)initFramesView {
    self.frame = CGRectMake(0, 64, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - 64);
    self.backgroundColor = PLS_RGBCOLOR(25, 24, 36);

    [self addSubview:self.collectionView];
    [self addSubview:self.bottomView];
}

- (void)initFramesData:(AVAsset *)asset {
    CMTime cmtime = asset.duration;
    self.totalSeconds = CMTimeGetSeconds(cmtime);
    self.frameRate = [[asset tracksWithMediaType:AVMediaTypeVideo][0] nominalFrameRate];
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    NSUInteger imageCount = 0;
    if (self.totalSeconds <= self.maxDuration) {
        imageCount = _minImageCount;
        self.screenSeconds = self.totalSeconds;
    } else {
        imageCount = ceil(self.totalSeconds * _minImageCount / self.maxDuration);
        self.screenSeconds = self.maxDuration;
    }
    
    __weak typeof(self) weakSelf = self;
    [self getImagesCount:imageCount imageBackBlock:^(UIImage *image) {
        if (image) {
//            UIImage *scaledImg = [UIImage scaleImage:image maxDataSize:1024 * 20]; // 将图片压缩到最大20k进行显示
            UIImage *scaledImg = image; // 不压缩，按原画质显示
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionImages addObject:scaledImg];
                [weakSelf.collectionView reloadData];
            });
        }
    }];
}

- (void)getImagesCount:(NSUInteger)imageCount imageBackBlock:(void (^)(UIImage *))imageBackBlock {
    Float64 durationSeconds = self.totalSeconds;
    float fps = self.frameRate;
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    
    Float64 perFrames = totalFrames / imageCount; // 一共切imageCount张图
    Float64 frame = 0;
    
    CMTime timeFrame;
    while (frame < totalFrames) {
        timeFrame = CMTimeMake(frame, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
        
        frame += perFrames;
    }
    
    // 防止时间出现偏差
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    self.imageGenerator.appliesPreferredTrackTransform = YES;  // 截图的时候调整到正确的方向
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                break;
            case AVAssetImageGeneratorFailed:
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *displayImage = [UIImage imageWithCGImage:image];
                
                !imageBackBlock ? : imageBackBlock(displayImage);
            }
                break;
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSFormatGifViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PLSFormatGifViewCellId forIndexPath:indexPath];
    UIImage *imageData = self.collectionImages[indexPath.item];
    if ([_selectedImages containsObject:imageData]) {
        cell.selectButton.selected = YES;
    } else{
        cell.selectButton.selected = NO;
    }
    cell.imageData = imageData;
    cell.selectButton.tag = 100 + indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectImageClick:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *imageData = self.collectionImages[indexPath.item];
    NSInteger cellSize = (NSInteger)(PLS_SCREEN_WIDTH - 5)/4;
    CGFloat height = imageData.size.height/imageData.size.width * cellSize;
    return CGSizeMake(cellSize, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    PLSFormatGifViewCell *cell = (PLSFormatGifViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selectButton.selected = !cell.selectButton.selected;
    if (cell.selectButton.selected) {
        [self.selectedImages addObject:self.collectionImages[index]];
    } else{
        [self.selectedImages removeObject:self.collectionImages[index]];
    }
    [self previewButtonEnable];
}

- (void)selectImageClick:(UIButton *)selectButton {
    NSInteger index = selectButton.tag - 100;
    selectButton.selected = selectButton.selected;
    if (selectButton.selected) {
        [self.selectedImages addObject:self.collectionImages[index]];
    } else{
        [self.selectedImages removeObject:self.collectionImages[index]];
    }
    [self previewButtonEnable];
}

- (void)previewButtonEnable{
    self.countLabel.text = [NSString stringWithFormat:@"视频帧选中个数：%ld", _selectedImages.count];
    if (self.selectedImages.count < 2) {
        self.previewButton.enabled = NO;
    } else {
        self.previewButton.enabled = YES;
    }
    [self.collectionView reloadData];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(formatGifView:selectedArray:)]) {
        [self.delegate formatGifView:self selectedArray:self.selectedImages];
    }
    
}

- (void)previewButtonClick:(UIButton *)previewButton{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(formatGifView:previewArray:)]) {
        [self.delegate formatGifView:self previewArray:self.selectedImages];
    }
}

#pragma mark - 懒加载
- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 6, 180, 30)];
        countLabel.font = [UIFont systemFontOfSize:16];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.text = @"视频帧选中个数：0";
        _countLabel = countLabel;
    }
    return _countLabel;
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        UIButton *previewButton = [[UIButton alloc]initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 100, 6, 80, 30)];
        previewButton.enabled = NO;
        
        [previewButton setTitle:@"Gif 预览" forState:UIControlStateNormal];
        [previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [previewButton addTarget:self action:@selector(previewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _previewButton = previewButton;
    }
    return _previewButton;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, PLS_SCREEN_HEIGHT - 64 - 42, PLS_SCREEN_WIDTH, 42)];
        bottomView.backgroundColor = [UIColor blackColor];
        [bottomView addSubview:self.countLabel];
        [bottomView addSubview:self.previewButton];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

- (NSMutableArray *)collectionImages {
    if (!_collectionImages) {
        _collectionImages = [NSMutableArray array];
    }
    return _collectionImages;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        NSInteger cellSize = (NSInteger)(PLS_SCREEN_WIDTH - 5)/4;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(cellSize, cellSize);
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT - 64 - 42) collectionViewLayout:layout];
        self.collectionView.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[PLSFormatGifViewCell class] forCellWithReuseIdentifier:PLSFormatGifViewCellId];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)dealloc {
    if (self.imageGenerator) {
        [self.imageGenerator cancelAllCGImageGeneration];
        self.imageGenerator = nil;
    }
}

@end
