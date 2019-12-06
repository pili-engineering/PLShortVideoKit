//
//  QNMusicDecibelView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/22.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNMusicDecibelView.h"

@implementation QNMusicDecibelView

- (void)drawRect:(CGRect)rect {
    
    // 模拟音频分贝 view, 如果需要真实的分贝 view，可以使用一些开源的库
    static CGFloat percents[] = {.3, .4, .5, .6, .7, .8, .9};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.2 green:.8 blue:.2 alpha:1].CGColor);
    // 设置每一格的宽度
    CGFloat dbWidth = 3;
    CGContextSetLineWidth(context, dbWidth);
    // 设置填充 color
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGSize size = self.bounds.size;
    
    CGFloat space = 1;
    for (int x = space; x < (size.width - dbWidth); x += (space + dbWidth)) {
        
        CGFloat percent = percents[arc4random() % 7];
        
        CGFloat dbHeight = percent * size.height;
        CGContextMoveToPoint(context, x, (size.height - dbHeight) / 2);
        CGContextAddLineToPoint(context, x, (size.height + dbHeight) / 2);
        CGContextStrokePath(context);
    }
}

@end
