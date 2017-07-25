//
//  KWBeautifyFilter2.h
//  ASRSticker
//
//  Created by ChenHao on 16/8/3.
//  Copyright © 2016年 Sobrr. All rights reserved.
//

#import "GPUImageFilter.h"
#import "KWRenderProtocol.h"

/**
 Grading adjustment beauty
 */
@interface KWBeautifyFilter : GPUImageFilter<KWRenderProtocol>
{
//    GLfloat levelUniform;
}
// 1 ~ 3, default 1
@property (readwrite, nonatomic) NSUInteger level;

- (void)setBeautifyLevel:(float)level1;

@property (nonatomic, readonly) BOOL needTrackData;

@end
