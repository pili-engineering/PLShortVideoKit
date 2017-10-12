//
//  GPUImageSquareFaceFilter.h
//  KiwiFaceKitDemo
//
//  Created by ChenHao on 2016/11/30.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "GPUImage.h"
#import "KWRenderProtocol.h"

/**
 SquareFace of distorting mirror
 */
@interface SquareFaceDistortionFilter : GPUImageFilter <KWRenderProtocol>

/**
 The center about which to apply the distortion, with a default of (0.5, 0.5)
 */
@property(nonatomic) CGPoint center;

@property(nonatomic, copy) NSArray<NSArray *> *faces;

@end
