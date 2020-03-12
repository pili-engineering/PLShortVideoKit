//
//  QNRecordingProgress.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/9.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNRecordingProgress.h"

@interface QNRecordingProgress ()
{
    CGFloat _barHeight;
}

@property (nonatomic, strong) NSMutableArray *progressViewArray;

@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UIImageView *progressIndicator;

@property (nonatomic, strong) NSTimer *shiningTimer;

@property (nonatomic, readwrite) QNProgressStyle style;

@end

@implementation QNRecordingProgress

- (void)dealloc {
    _progressViewArray = nil;
    _barView = nil;
    _progressIndicator = nil;
    [_shiningTimer invalidate];
    _shiningTimer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _barHeight = frame.size.height;
        _style = QNProgressStyleNormal;
        [self initalize];
    }
    return self;
}

- (void)initalize {
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.1];
    self.progressViewArray = [[NSMutableArray alloc] init];
    
    //barView
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _barHeight)];
    _barView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.1];
    [self addSubview:_barView];
    
    //最短分割线
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, _barHeight)];
    intervalView.backgroundColor = [UIColor blackColor];
    [_barView addSubview:intervalView];
    
    //indicator
    self.progressIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, _barHeight)];
    _progressIndicator.backgroundColor = [UIColor clearColor];
    _progressIndicator.image = [UIImage imageNamed:@"progressbar_front.png"];
    [self addSubview:_progressIndicator];
}

- (UIView *)getProgressView {
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, _barHeight)];
    progressView.backgroundColor = [UIColor whiteColor];
    progressView.autoresizesSubviews = YES;
    
    return progressView;
}

- (void)refreshIndicatorPosition {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        _progressIndicator.center = CGPointMake(0, self.frame.size.height / 2);
        return;
    }
    
    _progressIndicator.center = CGPointMake(MIN(lastProgressView.frame.origin.x + lastProgressView.frame.size.width, self.frame.size.width - _progressIndicator.frame.size.width / 2 + 2), self.frame.size.height / 2);
}

- (void)onTimer:(NSTimer *)timer {
    [UIView animateWithDuration:.3 animations:^{
        self.progressIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            self.progressIndicator.alpha = 1;
        }];
    }];
}

#pragma mark - method

- (void)startShining {
    self.shiningTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stopShining {
    [_shiningTimer invalidate];
    self.shiningTimer = nil;
    _progressIndicator.alpha = 1;
}

- (void)addProgressView {
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    
    if (lastProgressView) {
        CGRect frame = lastProgressView.frame;
        frame.size.width -= 1;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + 1;
    }
    
    UIView *newProgressView = [self getProgressView];
    [self setView:newProgressView toOriginX:newProgressX];
    
    [_barView addSubview:newProgressView];
    
    [_progressViewArray addObject:newProgressView];
}

- (void)setLastProgressToWidth:(CGFloat)width {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [self setView:lastProgressView toSizeWidth:width];
    [self refreshIndicatorPosition];
}

- (void)setLastProgressToStyle:(QNProgressStyle)style {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    switch (style) {
        case QNProgressStyleNormal:
        {
            lastProgressView.backgroundColor = [UIColor whiteColor];
            _progressIndicator.hidden = YES;
        }
            break;
        case QNProgressStyleDelete:
        {
            lastProgressView.backgroundColor = [UIColor redColor];
            _progressIndicator.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)deleteLastProgress {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [lastProgressView removeFromSuperview];
    [_progressViewArray removeLastObject];
    
    _progressIndicator.hidden = NO;
    
    [self refreshIndicatorPosition];
}

- (void)deleteAllProgress {
    while (_progressViewArray.count) {
        UIView *progressView = _progressViewArray.lastObject;
        [progressView removeFromSuperview];
        [_progressViewArray removeLastObject];
    }
    _progressIndicator.hidden = NO;
    [self refreshIndicatorPosition];
    
}

- (void)setView:(UIView *)view toSizeWidth:(CGFloat)width {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

- (void)setView:(UIView *)view toOriginX:(CGFloat)x {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

- (void)setView:(UIView *)view toOriginY:(CGFloat)y {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

- (void)setView:(UIView *)view toOrigin:(CGPoint)origin {
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}

@end

