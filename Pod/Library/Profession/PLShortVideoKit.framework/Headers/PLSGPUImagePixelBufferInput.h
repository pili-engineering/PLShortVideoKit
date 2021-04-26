//
//  PLSGPUImagePixelBufferInput.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/4/14.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSGPUImageOutput.h"

// from https://github.com/YuAo/YUGPUImageCVPixelBufferInput
// Only kCVPixelFormatType_32BGRA is supported currently.

@interface PLSGPUImagePixelBufferInput : PLSGPUImageOutput

- (BOOL)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (BOOL)processPixelBuffer:(CVPixelBufferRef)pixelBuffer frameTime:(CMTime)frameTime;

- (BOOL)processPixelBuffer:(CVPixelBufferRef)pixelBuffer frameTime:(CMTime)frameTime completion:(void (^)(void))completion;

@end
