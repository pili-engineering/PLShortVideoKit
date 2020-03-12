//
//  PLSClipMovieView.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <PLShortVideoKit/PLShortVideoKit.h>

@interface UIView (PLSExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (assign, nonatomic) CGPoint origion;

@end


@interface PLSClipMovieViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *imageData;

@end


@class PLSClipMovieView;
@protocol PLSClipMovieViewDelegate <NSObject>

@optional
- (void)didStartDragView;
- (void)clipFrameView:(PLSClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime;

/**
 *  判断clipFrameView中的scrollview是否正在滚动
 *
 *  @param clipFrameView 当前裁剪view
 *  @param scrolling  是否正在滚动
 */
- (void)clipFrameView:(PLSClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling;

@end

@interface PLSClipMovieView : UIView

@property (nonatomic, weak) id<PLSClipMovieViewDelegate> delegate;

- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration;

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration;

- (void)resetProgressBarMode;

- (void)setProgressBarPoisionWithSecond:(Float64)second;

@end

