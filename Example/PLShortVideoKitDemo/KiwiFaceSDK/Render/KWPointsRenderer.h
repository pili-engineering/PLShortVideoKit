//
//  KWPointsRenderer.h
//  KiwiFaceKitDemo
//
//  Created by ChenHao on 2016/11/26.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "KWRenderProtocol.h"
#import "GPUImage.h"

/**
 points of renderer class
 */
@interface KWPointsRenderer : GPUImageFilter <KWRenderProtocol>

@property (nonatomic, copy) NSArray<NSArray *> *faces;

@end
