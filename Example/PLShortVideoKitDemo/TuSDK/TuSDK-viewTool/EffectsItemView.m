//
//  EffectsItemView.m
//  TuSDKVideoDemo
//
//  Created by wen on 13/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "EffectsItemView.h"
#import <TuSDK/TuSDK.h>

@interface EffectsItemView (){
    // 滤镜名
    NSString *_viewName;
    
    // 事件响应与阴影显示button
    UIView *_EventView;
    
    // 滤镜名label
    UILabel *_titleLabel;
    
    // 图片显示IV
    UIImageView *_imageView;
}
@end


@implementation EffectsItemView

- (void)setViewInfoWith:(NSString *)imageName title:(NSString *)title  titleFontSize:(CGFloat)fontSize
{
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat ivWidth = viewHeight * 13/18;
    CGFloat titleHeight = 20;
    
    // 图片
    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = 3;
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    _imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    // title
    _titleLabel = [UILabel new];
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.adjustsFontSizeToFitWidth = true;
    _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _titleLabel.layer.cornerRadius = 3;
    [_imageView addSubview:_titleLabel];
    
    // 布局
    _imageView.frame = CGRectMake(0, 0, ivWidth, viewHeight);
    _titleLabel.frame = CGRectMake(0, viewHeight - titleHeight, ivWidth, titleHeight);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 事件响应以及边框button
    _EventView = [[UIView alloc]initWithFrame:_imageView.frame];
    _EventView.layer.cornerRadius = 3;
    [self addSubview:_EventView];
}


// 改变选中阴影色
- (void)refreshShadowColor:(UIColor *)color;{
    if (_EventView) {
        if (color) {
            _EventView.backgroundColor = color;
        }else{
            _EventView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)touchBeginEvent;
{
    if ([self.eventDelegate respondsToSelector:@selector(touchBeginWithSelectCode:)]) {
        [self.eventDelegate touchBeginWithSelectCode:_effectCode];
        [self refreshShadowColor:lsqRGBA(60, 60, 60, 0.6)];
    }
}

- (void)touchEndEvent;
{
    if ([self.eventDelegate respondsToSelector:@selector(touchEndWithSelectCode:)]) {
        [self.eventDelegate touchEndWithSelectCode:_effectCode];
        [self refreshShadowColor:nil];
    }
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [self touchBeginEvent];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [self touchEndEvent];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(_EventView.frame, point)) {
        [self touchEndEvent];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [self touchEndEvent];
}

@end
