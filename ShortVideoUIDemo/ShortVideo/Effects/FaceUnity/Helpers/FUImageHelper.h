//
//  FUImageHelper.h
//  FULiveDemo
//
//  Created by L on 2018/8/3.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FUImageHelper : NSObject

+ (void) convertUIImageToBitmapRGBA8:(UIImage *) image completionHandler:(void (^)(int32_t size, unsigned char * bits))completionHandler ;
+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height ;

+(CVPixelBufferRef) pixelBufferFromImage:(UIImage *)image;


+(UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;
+ (unsigned char *)getRGBAWithImage:(UIImage *)image;
@end
