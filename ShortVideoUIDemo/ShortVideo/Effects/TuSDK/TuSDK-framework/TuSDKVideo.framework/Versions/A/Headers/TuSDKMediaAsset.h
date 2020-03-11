//
//  TuSDKMediaAsset.h
//  TuSDKVideo
//
//  Created by sprint on 11/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaAssetInfo.h"

@interface TuSDKMediaAsset : NSObject

/**
 初始化资产切片对象
 
 @param inputAsset 输入的资产信息
 @param timeRange 裁剪区间
 @return TuSDKMediaAssetSlice
 @since v3.0.1
 */
- (instancetype _Nonnull )initWithAsset:(AVAsset *_Nonnull)inputAsset timeRange:(CMTimeRange)timeRange;

/**
 输入的资产信息
 @since v3.0.1
 */
@property (nonatomic,readonly)AVAsset *_Nonnull inputAsset;

/**
 获取视频信息，视频加载完成后可用
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaAssetInfo * _Nullable inputAssetInfo;

/**
 切片时间
 @since v3.0.1
 */
@property (nonatomic)CMTimeRange timeRange;

@end
