//
//  FUImageHelper.m
//  FULiveDemo
//
//  Created by L on 2018/8/3.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUImageHelper.h"

@implementation FUImageHelper

+ (void) convertUIImageToBitmapRGBA8:(UIImage *) image completionHandler:(void (^)(int32_t size, unsigned char * bits))completionHandler {
    
    CGImageRef imageRef = image.CGImage;
    
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];
    
    if(!context) {
        return ;
    }
    
    int32_t width = (int32_t)CGImageGetWidth(imageRef);
    int32_t height = (int32_t)CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    // Copy the data and release the memory (return memory allocated with new)
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    
    unsigned char *newBitmap = NULL;
    
    union i32c{
        int32_t i32v;
        unsigned char bytes[4];
    };
    
    union i32c cwidth;
    cwidth.i32v = width;
    union i32c cheight;
    cheight.i32v = height;
    if(bitmapData) {
        newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height + 8);
        newBitmap[0] =cwidth.bytes[0];
        newBitmap[1] =cwidth.bytes[1];
        newBitmap[2] =cwidth.bytes[2];
        newBitmap[3] =cwidth.bytes[3];
        newBitmap[4]=cheight.bytes[0];
        newBitmap[5] =cheight.bytes[1];
        newBitmap[6] =cheight.bytes[2];
        newBitmap[7] =cheight.bytes[3];
        
        if(newBitmap) {    // Copy the data
            for(int i = 8; i < bufferLength+8; ++i) {
                newBitmap[i] = bitmapData[i - 8];
            }
        }
        
        free(bitmapData);
        
    } else {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    
    CGContextRelease(context);
    
    completionHandler((size_t)bufferLength +8,newBitmap);
}

+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast);    // RGBA
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}


+ (unsigned char *)getRGBAWithImage:(UIImage *)image
{
    int RGBA = 4;
    
    CGImageRef imageRef = [image CGImage];
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *) malloc(width * height * sizeof(unsigned char) * RGBA);
    NSUInteger bytesPerPixel = RGBA;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return rawData;
}

+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height {
    
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,    // data provider
                                    NULL,        // decode
                                    YES,            // should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 kCGImageAlphaPremultipliedLast);
    
    UIImage *image = nil;
    
//    if(context == NULL) {
//        NSLog(@"Error context not created");
//        free(pixels);
//        
//        return nil ;
//    }
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        image = [UIImage imageWithCGImage:imageRef];
    }
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels != nil) {
        free(pixels);
    }
    return image;
}



+(CVPixelBufferRef) pixelBufferFromImage:(UIImage *)image {
    
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
                              };
    
    CVPixelBufferRef pxbuffer = NULL;
    CGFloat frameWidth = CGImageGetWidth(image.CGImage);
    CGFloat frameHeight = CGImageGetHeight(image.CGImage);
    CVReturn status = CVPixelBufferCreate(
                                          kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(
                                                 pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
    NSParameterAssert(context);
    
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameWidth, frameHeight), image.CGImage);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    //    CFRelease(rgbColorSpace) ;
    
    return pxbuffer;
}

+(UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    
    CGFloat SW = [UIScreen mainScreen].bounds.size.width;
    CGFloat SH = [UIScreen mainScreen].bounds.size.height;
    
    float width = CVPixelBufferGetWidth(pixelBufferRef);
    float height = CVPixelBufferGetHeight(pixelBufferRef);
    
    float dw = width / SW;
    float dh = height / SH;
    
    float cropW = width;
    float cropH = height;
    
    if (dw > dh) {
        cropW = SW * dh;
    }else
    {
        cropH = SH * dw;
    }
    
    CGFloat cropX = (width - cropW) * 0.5;
    CGFloat cropY = (height - cropH) * 0.5;
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(cropX, cropY,
                                                 cropW,
                                                 cropH)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    
    return image;
}

@end
