//
//  EffectsDisplayView.m
//  TuSDKVideoDemo
//
//  Created by wen on 13/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "EffectsDisplayView.h"
#import <TuSDK/TuSDK.h>

@interface EffectsDisplayView (){
    UIView *_currentLocationView;
    // 缩略图背景view
    UIView *_backView;
    // tag 数值的basic
    NSInteger _basicTag;
    // 最后一段添加的view的 tag 值
    NSInteger _lastViewTag;
    // 最后添加的view;
    UIView *_lastView;
}
@end

@implementation EffectsDisplayView
// 0 ~ 1.0
- (void)setCurrentLocation:(CGFloat)currentLocation
{
    // 设置当前位置
    if (currentLocation < 0) currentLocation = 0;
    if (currentLocation > 1) currentLocation = 1;
    
    if (_currentLocation != currentLocation) {
        _currentLocationView.center = CGPointMake(_backView.lsqGetOriginX + currentLocation*_backView.lsqGetSizeWidth, _currentLocationView.center.y);
    }
    _currentLocation = currentLocation;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomView];
    }
    return self;
}

- (void)initData;
{
    _basicTag = 400;
    _lastViewTag = _basicTag;
}

- (void)createCustomView
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, self.lsqGetSizeWidth - 20, self.lsqGetSizeHeight - 10)];
    _backView.clipsToBounds = true;
    _backView.layer.borderWidth = 2;
    _backView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_backView];
    
    // 当前时间进度条
    _currentLocationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, self.lsqGetSizeHeight)];
    _currentLocationView.center = CGPointMake(_backView.lsqGetOriginX, self.lsqGetSizeHeight/2);
    _currentLocationView.backgroundColor = [UIColor whiteColor];
    _currentLocationView.layer.cornerRadius = 2;
    [self addSubview:_currentLocationView];
    
}

- (BOOL)addSegmentViewBeginWithStartLocation:(CGFloat)startLocation WithColor:(UIColor *)color;
{
    if (startLocation>=1 || startLocation < 0) return NO;
    _lastViewTag ++;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((_backView.lsqGetSizeWidth)*startLocation, 0, 1, _backView.lsqGetSizeHeight)];
    view.tag = _lastViewTag;
    view.backgroundColor = color;
    [_backView addSubview:view];
    _lastView = view;
    return YES;
}
- (void)addSegmentViewEnd;
{
    _lastView = nil;
}

- (void)updateLastSegmentViewProgress:(CGFloat)currentLocation;
{
    if (_lastView) {
        [_lastView lsqSetSizeWidth:currentLocation*_backView.lsqGetSizeWidth - _lastView.lsqGetOriginX];
    }
}

- (void)removeAllSegment;
{
    [_backView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag > _basicTag) {
            [obj removeFromSuperview];
        }
    }];
    _lastViewTag = _basicTag;
}

// written by suntongmian, Pili Engineering, Qiniu Inc.
- (void)removeLastSegment;
{
    NSArray<UIView *> *subviews = _backView.subviews;
    
    UIView *obj = [subviews lastObject];
    if (obj) {
        if (obj.tag > _basicTag) {
            [obj removeFromSuperview];
        }
    }
    
    subviews = _backView.subviews;
    obj = [subviews lastObject];
    if (obj) {
        _lastViewTag = obj.tag;
    } else {
        _lastViewTag = _basicTag;
    }
}

@end
