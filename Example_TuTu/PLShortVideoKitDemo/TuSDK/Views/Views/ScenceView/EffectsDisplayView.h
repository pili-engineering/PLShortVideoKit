//
//  EffectsDisplayView.h
//  TuSDKVideoDemo
//
//  Created by wen on 13/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectsDisplayView : UIView

// 当前位置 0~1.0
@property (nonatomic, assign) CGFloat currentLocation;

- (BOOL)addSegmentViewBeginWithStartLocation:(CGFloat)startLocation WithColor:(UIColor *)color;
- (void)addSegmentViewEnd;
- (void)updateLastSegmentViewProgress:(CGFloat)currentLocation;

- (void)removeAllSegment;
- (void)removeLastSegment; // written by suntongmian, Pili Engineering, Qiniu Inc.

@end
