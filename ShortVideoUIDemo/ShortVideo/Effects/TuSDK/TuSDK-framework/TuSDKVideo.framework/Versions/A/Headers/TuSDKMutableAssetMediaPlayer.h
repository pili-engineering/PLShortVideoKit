//
//  TuSDKMutableAssetMediaPlayer.h
//  TuSDKVideo
//
//  Created by sprint on 12/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaPlayer.h"

/**
 多文件播放器接口
 
 @since  v3.0.1
 */
@protocol TuSDKMutableAssetMediaPlayer <TuSDKMediaPlayer>

/**
 获取支持的最大数量

 @return NSUInteger
 @since  v3.0.1
 */
- (NSUInteger)maxInputSize;

/**
 添加 TuSDKMediaAsset
 
 @param mediaAssets NSArray<TuSDKMediaAsset *> *
 @return 是否添加成功
 @since v3.0.1
 */
- (BOOL)addInputMediaAssets:(NSArray<TuSDKMediaAsset *> *_Nonnull)mediaAssets;

/**
 移除 TuSDKMediaAsset
 
 @param mediaAssets NSArray<TuSDKMediaAsset *> *
 @return 是否添加成功
 @since v3.0.1
 */
- (BOOL)removeInputMediaAssets:(NSArray<TuSDKMediaAsset *> *_Nonnull)mediaAssets;

/**
 移除所有输入的资产文件
 
 @return 是否移除成功
 @since v3.0.1
 */
- (BOOL)removeAllInputMediaAssets;

@end
