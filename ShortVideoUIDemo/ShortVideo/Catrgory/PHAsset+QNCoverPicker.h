//
//  PHAsset+QNCoverPicker.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (QNCoverPicker)

- (NSURL *)movieURL;

- (UIImage *)imageURL:(PHAsset *)phAsset targetSize:(CGSize)targetSize;

- (NSURL *)getImageURL:(PHAsset *)phAsset;

- (NSData *)getImageData:(PHAsset *)phAsset;

@end

NS_ASSUME_NONNULL_END
