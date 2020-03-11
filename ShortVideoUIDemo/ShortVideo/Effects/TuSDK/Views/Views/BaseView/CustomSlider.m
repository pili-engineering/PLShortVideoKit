//
//  CustomSlider.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/28.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CustomSlider.h"
//#import "UIImage+Demo.h"

@interface CustomSlider ()

@property (nonatomic, assign) CGPoint touchBeginPoint;

@end

@implementation CustomSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    [self setThumbImage:[self.class circleImageWithSize:CGSizeMake(18, 18) color:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.tintColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (touches.count > 1) return;
    _touchBeginPoint = [touches.anyObject locationInView:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (touches.count > 1) return;
    CGPoint touchEndPoint = [touches.anyObject locationInView:self];
    if (!CGPointEqualToPoint(touchEndPoint, _touchBeginPoint)) {
        _touchBeginPoint = CGPointZero;
        return;
    }
    CGFloat value = touchEndPoint.x / self.bounds.size.width;
    [self setValue:value animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

+ (UIImage *)circleImageWithSize:(CGSize)size color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
