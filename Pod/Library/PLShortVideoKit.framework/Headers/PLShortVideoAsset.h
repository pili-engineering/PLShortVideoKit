//
//  PLShortVideoAsset.h
//  PLShortVideoKit
//
//  Created by 冯文秀 on 2017/9/26.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

@interface PLShortVideoAsset : NSObject

/**
 @brief 实例初始化方法
 
 @since      v1.6.0
 */
- (instancetype _Nullable )initWithURL:(NSURL *_Nullable)url;

/**
 @brief 实例初始化方法
 
 @since      v1.6.0
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nullable)asset;

/**
 @brief 返回倍速处理后的视频
 *
 * @param timeRange 倍速处理时间段
 *
 * @param rateType 倍速处理的类型
 *
 
 @since      v1.8.0
 */
- (AVAsset *_Nonnull)scaleTimeRange:(CMTimeRange)timeRange toRateType:(PLSVideoRecoderRateType)rateType;

/**
 @brief 返回倍速处理后的视频
 *
 * @param sourceAsset 需要倍速处理的视频，为 nil 时，默认使用 PLShortVideoAsset 初始化传入的视频数据
 *
 * @param timeRange 倍速处理时间段
 *
 * @param rateType 倍速处理的类型
 *
 
 @since      v1.6.0
 */
- (AVAsset *_Nonnull)scaleAsset:(AVAsset *_Nullable)sourceAsset timeRange:(CMTimeRange)timeRange rateType:(PLSVideoRecoderRateType)rateType __deprecated_msg("Method deprecated in v1.8.0. Use `scaleTimeRange: toRateType:`");

/**
 @brief 返回倍速处理后的视频. 将 timeRangeArray 第 n 个元素的 timeRange 按照 rateTypeArray 第 n 个元素的 rateType 进行变速， timeRangeArray 没有包含到的时间段按照原速处理, 两个数组的元素必须相等并且数组不能为空数组
 *
 * @param timeRangeArray 倍速处理时间段数组，包含 NSValue(CMTimeRange) 元素的数组，时间段不能重复且单调递增
 *
 * @param rateTypeArray  倍速处理的类型数组，包含 NSNumber(PLSVideoRecoderRateType) 元素的数组，
 *
 
 @since      v1.15.0
 */
- (AVAsset *_Nonnull)scaleTimeRanges:(NSArray *)timeRangeArray toRateTypes:(NSArray *)rateTypeArray;

/**
 @brief 返回拼接好的视频
 *
 * @param assetArray AVAsset 数组
 *
 
 @since      v1.6.0
 */
- (AVAsset *_Nonnull)appendAssetArray:(NSArray<AVAsset *> *_Nonnull)assetArray;

@end
