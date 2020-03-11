//
//  UIImage+PLSClip.m
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "UIImage+PLSClip.h"

@implementation UIImage (PLSClip)

- (void)imageOrginalRect:(CGRect)orginalRect clipRect:(CGRect)clipRect completeBlock:(void (^)(UIImage *))imageBackBlock {
    CGSize orginalSize = orginalRect.size;
    UIGraphicsBeginImageContextWithOptions(orginalSize, NO, [UIScreen mainScreen].scale);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:clipRect];
    [path addClip];
    
    [self drawInRect:clipRect];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    !imageBackBlock ? : imageBackBlock(resultImg);
}

+ (UIImage *)scaleImage:(UIImage *)image maxDataSize:(NSUInteger)dataSize {
    if (image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData.length > dataSize) {
            float scaleSize = (dataSize/1.0)/(imageData.length);
            scaleSize = 0.9 * sqrtf(scaleSize);
            return [self scaleImage:image toScale:scaleSize maxDataSize:dataSize];
        } else {
            return image;
        }
    } else {
        return nil;
    }
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize maxDataSize:(NSUInteger)dataSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize - 1, image.size.height * scaleSize - 1));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
    if (imageData.length > dataSize) {
        float scale = (dataSize / 1.0) / (imageData.length);
        scale = 0.9 * sqrtf(scale);
        return [self scaleImage:scaledImage toScale:scale maxDataSize:dataSize];
    }
    return scaledImage;
}

@end

