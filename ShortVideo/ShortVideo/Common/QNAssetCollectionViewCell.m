//
//  QNAssetCollectionViewCell.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNAssetCollectionViewCell.h"

@implementation QNAssetCollectionViewCell

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
            self.imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
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
