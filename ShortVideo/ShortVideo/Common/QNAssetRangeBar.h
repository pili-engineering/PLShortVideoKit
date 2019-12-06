//
//  QNAssetRangeBar.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/15.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// 视频时间段选取类
@class  QNAssetRangeBar;
@protocol QNAssetRangeBarDelagete <NSObject>

- (void)assetRangeBar:(QNAssetRangeBar *)assetRangeBar didStartMove:(BOOL)isLeft;
- (void)assetRangeBar:(QNAssetRangeBar *)assetRangeBar movingToTime:(CMTime)time isLeft:(BOOL)isLeft;
- (void)assetRangeBar:(QNAssetRangeBar *)assetRangeBar didEndMoveWithSelectedTimeRange:(CMTimeRange)timeRange isLeft:(BOOL)isLeft ;

@end

@interface QNAssetRangeBar : UIView

@property (nonatomic, weak) id<QNAssetRangeBarDelagete> delegate;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, assign) CMTime startTime;
@property (nonatomic, assign) CMTime endTime;

- (void)setCurrentTime:(CMTime)currentTime;

+ (CGFloat)suitableHeight;

@end
