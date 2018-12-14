//
//  PLSAssetImageGenerator.m
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSAssetImageGenerator.h"

@interface PLSAssetImageGenerator ()

@property (nonatomic, strong) NSMutableArray<PLSAssetInfo *> *assets;
@property (nonatomic, assign) BOOL shouldCancel;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation PLSAssetImageGenerator

- (instancetype)init {
    self = [super init];
    if (self) {
        _assets = [NSMutableArray array];
        _imageCount = 8;
        _outputSize = CGSizeMake(50, 50);
        _duration = 0;
    }
    return self;
}

- (void)addVideoWithAsset:(AVAsset *)asset startTime:(CGFloat)startTime duration:(CGFloat)duration animDuration:(CGFloat)animDuration {
    PLSAssetInfo *info = [[PLSAssetInfo alloc] init];
    info.asset = asset;
    info.duration = duration;
    info.animDuration = animDuration;
    info.startTime = startTime;
    info.type = PLSAssetInfoTypeVideo;
    [_assets addObject:info];
    _duration += [info realDuration];
}

- (void)generateWithCompleteHandler:(void(^)(UIImage *))handler {
    _shouldCancel = NO;
    _queue = dispatch_queue_create("com.pls.thumb.generator", NULL);
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        CGFloat step = weakSelf.duration / weakSelf.imageCount;
        CGFloat currentDuration = 0;
        int index = 0;
        for (PLSAssetInfo *info in weakSelf.assets) {
            CGFloat duration = [info realDuration];
            currentDuration += duration;
            int count = currentDuration / step;
            for (int i = index; i < count; i++) {
                CGFloat time = i * step - (currentDuration - duration);
                UIImage *image = [info captureImageAtTime:time outputSize:weakSelf.outputSize];
                handler(image);
                if (weakSelf.shouldCancel)
                    break;
            }
            index = count;
            if (weakSelf.shouldCancel)
                break;
        }
    });
}

- (void)cancel {
    _shouldCancel = YES;
}

@end


#pragma mark - PLSAssetInfo Class

@interface PLSAssetInfo ()

@property (nonatomic, strong) AVAssetImageGenerator *generator;

@end

@implementation PLSAssetInfo

- (void)dealloc {
    NSLog(@"PLSAssetInfo dealloc");
}

- (CGFloat)realDuration {
    return _duration - _animDuration;
}

- (UIImage *)captureImageAtTime:(CGFloat)time outputSize:(CGSize)outputSize {
    return [self imageFromVideoWithOutputSize:outputSize atTime:time];
}

- (UIImage *)imageFromVideoWithOutputSize:(CGSize)outputSize atTime:(CGFloat)atTime {
    if (!_generator) {
        _generator = [[AVAssetImageGenerator alloc] initWithAsset:[self composition]];
        _generator.maximumSize = outputSize;
        _generator.appliesPreferredTrackTransform = YES;
        _generator.requestedTimeToleranceAfter = kCMTimeZero;
        _generator.requestedTimeToleranceBefore = kCMTimeZero;
    }
    if (atTime < 0) {
        atTime = 0;
    }
    CMTime time = CMTimeMake(atTime * 1000, 1000);
    CGImageRef image = [_generator copyCGImageAtTime:time actualTime:NULL error:nil];
    UIImage *picture = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return picture;
}


- (AVComposition *)composition {
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAsset *asset = _asset;
    AVAssetTrack *assetTrackVideo = nil;
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetTrackVideo = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if (assetTrackVideo) {
        CMTime start = CMTimeMake((_startTime - _animDuration) * 1000, 1000);
        CMTime duration = assetTrackVideo.timeRange.duration;
        if (_duration) {
            duration = CMTimeMake(_duration * 1000, 1000);
        }
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(start, duration) ofTrack:assetTrackVideo atTime:kCMTimeZero error:nil];
        compositionVideoTrack.preferredTransform = assetTrackVideo.preferredTransform;
        return composition;
    }
    return nil;
}

@end

