//
//  TuSDKMediaAssetInfo.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKAudioInfo.h"
#import "TuSDKVideoInfo.h"


/**
 视频信息
 @since 2.2.0
 */
@interface TuSDKMediaAssetInfo : NSObject

/**
 根据 AVAsset 初始化 TuSDKMediaAssetInfo

 @param asset 资产信息
 @return TuSDKMediaAssetInfo
 @since v3.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/**
 视频轨道信息
 @since v3.0
 */
@property (nonatomic,readonly)AVAsset *asset;

/**
 视频轨道信息
 @since v2.2.0
 */
@property (nonatomic,readonly)TuSDKVideoInfo *videoInfo;

/**
 音频轨道信息
 @since v2.2.0
 */
@property (nonatomic,readonly)TuSDKAudioInfo *audioInfo;

/**
 异步加载视频信息
 
 @param asset AVAsset
 @since v2.2.0
 */
- (void)loadSynchronouslyForAssetInfo:(AVAsset *)asset;


@end



