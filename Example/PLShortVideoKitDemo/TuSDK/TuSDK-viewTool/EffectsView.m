//
//  EffectsView.m
//  TuSDKVideoDemo
//
//  Created by wen on 13/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "EffectsView.h"
#import "EffectsItemView.h"
#import <TuSDK/TuSDK.h>

@interface EffectsView()<EffectsItemViewEventDelegate> {
    // 视图布局
    // 滤镜滑动scroll
    UIScrollView *_effectsScroll;
    // 参数栏背景view
    UIView *_paramBackView;
    
    // 美颜按钮
    UIButton *_clearFilterBtn;
    // 美颜的边框view
    UIView *_clearFilterBorderView;
    
}
@end

@implementation EffectsView

- (void)setProgress:(CGFloat)progress;
{
    _progress = progress;
    _displayView.currentLocation = _progress;
}
- (void)setEffectsCode:(NSArray<NSString *> *)effectsCode;
{
    _effectsCode = effectsCode;
    [self createCustomView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)createCustomView
{
    _displayView = [[EffectsDisplayView alloc]initWithFrame:CGRectMake(10, 15, self.lsqGetSizeWidth - 70, 60)];
    [self addSubview:_displayView];

    CGFloat effectItemHeight = 0.44*self.lsqGetSizeHeight;
    CGFloat effectItemWidth = effectItemHeight * 13/18;
    CGFloat offsetX = effectItemWidth + 10 + 7;
    CGFloat bottom = self.lsqGetSizeHeight/15;
    CGRect effectsScrollFrame = CGRectMake(10, self.lsqGetSizeHeight - effectItemHeight - bottom, self.bounds.size.width - 20, effectItemHeight);
    
    // 创建滤镜scroll
    _effectsScroll = [[UIScrollView alloc]initWithFrame:effectsScrollFrame];
    _effectsScroll.showsHorizontalScrollIndicator = false;
    _effectsScroll.bounces = false;
    [self addSubview:_effectsScroll];
    
    // 滤镜view配置参数
    CGFloat centerX = effectItemWidth/2;
    CGFloat centerY = _effectsScroll.lsqGetSizeHeight/2;
    
    // 创建滤镜view
    CGFloat itemInterval = 7;
    for (int i = 0; i < _effectsCode.count; i++) {
        EffectsItemView *basicView = [EffectsItemView new];
        basicView.frame = CGRectMake(0, 0, effectItemWidth, effectItemHeight);
        basicView.center = CGPointMake(centerX, centerY);
        NSString *title = [NSString stringWithFormat:@"lsq_filter_%@", _effectsCode[i]];
        NSString *imageName = [NSString stringWithFormat:@"lsq_filter_thumb_%@",_effectsCode[i]];
        [basicView setViewInfoWith:imageName title:NSLocalizedString(title,@"特效") titleFontSize:12];
        basicView.eventDelegate = self;
        basicView.effectCode = _effectsCode[i];
        [_effectsScroll addSubview:basicView];

        centerX += effectItemWidth + itemInterval;
    }
    _effectsScroll.contentSize = CGSizeMake(centerX - effectItemWidth/2, _effectsScroll.bounds.size.height);
}

#pragma mark - EffectsItemViewEventDelegate

- (void)touchBeginWithSelectCode:(NSString *)effectCode;
{
    if ([self.effectEventDelegate respondsToSelector:@selector(effectsSelectedWithCode:)]) {
        [self.effectEventDelegate effectsSelectedWithCode:effectCode];
    }
}

- (void)touchEndWithSelectCode:(NSString *)effectCode;
{
    if ([self.effectEventDelegate respondsToSelector:@selector(effectsEndWithCode:)]) {
        [self.effectEventDelegate effectsEndWithCode:effectCode];
    }
}



@end


