//
//  PHAsset+QNCoverPicker.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "PHAsset+QNCoverPicker.h"

@implementation PHAsset (QNCoverPicker)

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
