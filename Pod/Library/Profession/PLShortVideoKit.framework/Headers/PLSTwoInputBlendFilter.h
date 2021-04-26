//
//  PLSTwoInputBlendFilter.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/9/4.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSRenderEngine.h"

@interface PLSTwoInputBlendFilter : PLSGPUImageTwoInputFilter
{
    GLint mixUniform;
}

// Mix ranges from 0.0 (only image 1) to 1.0 (only image 2), with 1.0 as the normal level
@property(readwrite, nonatomic) CGFloat mix;

@end
