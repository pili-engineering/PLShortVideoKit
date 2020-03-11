//
//  TuSDKMediaCompositionMoviePlayer.h
//  TuSDKVideo
//
//  Created by sprint on 11/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKMediaAsset.h"
#import "TuSDKMediaTimelineAssetMoviePlayer.h"
#import "TuSDKMutableAssetMediaPlayer.h"

/**
 AVMutableComposition 播放器
 @since v3.0.1
 */
@interface TuSDKMediaMutableAssetMoviePlayer : TuSDKMediaTimelineAssetMoviePlayer <TuSDKMutableAssetMediaPlayer>

/**
 构建一个视频播放器
 
 @param preview 预览视图
 @return TuSDKMediaMutableAssetMoviePlayer
 @since      v3.0.1
 */
- (instancetype _Nullable)initWithPreview:(UIView *_Nonnull)preview;

/**
 构建一个视频播放器
 
 @param inputMediaAssets 输入的资产列表
 @param preview 预览视图
 @return TuSDKMediaMutableAssetMoviePlayer
 @since      v3.0.1
 */
- (instancetype _Nullable)initWithMediaAssets:(NSArray<TuSDKMediaAsset *> *_Nonnull)inputMediaAssets preview:(UIView *_Nonnull)preview;

/**
 输入的资产列表
 
 @since      v3.0.1
 */
@property (nonatomic,readonly) NSArray<TuSDKMediaAsset *> * _Nonnull inputMediaAssets;

@end
