//
//  EffectsTimeLineModel.m
//  PLShortVideoKitDemo
//
//  Created by wen on 21/12/2017.
//  Copyright © 2017 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "EffectsTimeLineModel.h"

@implementation EffectsTimeLineModel

- (BOOL)isValid;
{
    if (_effectsCode == nil) return NO;
    if (_startProgress < 0 || _endProgress > 1) return NO;
    if (_startProgress >= _endProgress) return NO;
    
    return YES;
}

@end
