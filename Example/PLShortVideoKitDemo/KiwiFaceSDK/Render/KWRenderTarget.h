//
//  FTRenderTarget.h
//  KiwiFaceKitDemo
//
//  Created by ChenHao on 2016/11/29.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageContext.h"


@interface KWRenderTarget : NSObject <GPUImageInput>
{
    GPUImageRotationMode _inputRotation;
}


/**
 是否开启，YES：开启，绘制回源pixelBuffer（需传给renderTarget）
 */
@property (nonatomic) BOOL enabled;

@property (nonatomic, unsafe_unretained) CVPixelBufferRef renderTarget;

- (void)releaseManager;

@end
