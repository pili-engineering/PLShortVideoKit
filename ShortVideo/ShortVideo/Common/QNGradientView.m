//
//  QNGradientView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/17.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNGradientView.h"

@implementation QNGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradienLayer {
    return (CAGradientLayer *)self.layer;
}

@end
