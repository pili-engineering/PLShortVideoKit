//
//  PLSClipMulitMediaView.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/2.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLShortVideoKit/PLShortVideoKit.h"

@class PLSRangeMedia;
@class PLSClipMulitMediaView;
@protocol PLSClipMulitMediaViewDelegate
<
NSObject
>

- (void)clipScrollViewWillBeginDragging:(PLSClipMulitMediaView *)clipView;

- (void)clipScrollViewWillEndDragging:(PLSClipMulitMediaView *)clipView;

- (void)clipView:(PLSClipMulitMediaView *)clipView seekToTime:(CMTime)seekTime;

- (void)clipView:(PLSClipMulitMediaView *)clipView insertVideoWithAsset:(AVAsset *)asset;

- (void)clipView:(PLSClipMulitMediaView *)clipView refreshPlayItem:(AVPlayerItem *)playItem;

- (void)clipView:(PLSClipMulitMediaView *)clipView finishClip:(NSArray<PLSRangeMedia *> *)mediaArray;

@end

@interface PLSClipMulitMediaView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<PLSClipMulitMediaViewDelegate> delegate;

@property (nonatomic, strong) NSArray<AVAsset *> *assetArray;

@property (assign, nonatomic) PLSVideoFillModeType fillMode;


// 设置播放进度
- (void)setPlayPosition:(CMTime)playPositon;

// 添加转场字母
- (void)addTransition:(AVAsset *)asset;

// 删除某一段
- (void)deleteAction;

@end
