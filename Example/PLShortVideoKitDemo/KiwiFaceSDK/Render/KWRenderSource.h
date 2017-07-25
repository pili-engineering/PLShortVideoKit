//
//  KWRenderSource.h
//  KiwiFaceKitDemo
//
//  Created by ChenHao on 2016/11/29.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "GPUImage.h"

@interface KWRenderSource : GPUImageOutput

- (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer withTimestamp:(NSTimeInterval)timestamp;

//- (void)updateOrientation;

@end
