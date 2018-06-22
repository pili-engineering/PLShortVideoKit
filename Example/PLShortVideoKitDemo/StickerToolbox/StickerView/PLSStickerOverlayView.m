//
//  PLSStickerOverlayView.m
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSStickerOverlayView.h"

@implementation PLSStickerOverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    __block UIView *responseView = nil;
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint subPoint = [subView convertPoint:point fromView:self];
        UIView *resultView = [subView hitTest:subPoint withEvent:event];
        if (resultView) {
            responseView = resultView;
            *stop = YES;
        }
    }];
    return responseView ? responseView : nil;
}

@end
