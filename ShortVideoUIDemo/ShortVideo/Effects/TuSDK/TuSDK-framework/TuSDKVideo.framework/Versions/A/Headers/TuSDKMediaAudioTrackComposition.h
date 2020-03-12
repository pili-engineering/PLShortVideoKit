//
//  TuSDKMediaAudioTrackComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/14.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaAudioComposition.h"
#import "TuSDKMediaAssetInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用以读取音频轨道数据
 
 @since v3.4.1
 */
@interface TuSDKMediaAudioTrackComposition : NSObject <TuSDKMediaAudioComposition>

/**
 根据视频轨道合成初始化 TuSDKMediaAudioTrackComposition
 
 @param inputAsset 音频资产
 @return TuSDKMediaAudioTrackComposition
 
 @since v3.4.1
 */
- (instancetype)initWithAudioAsset:(AVAsset *)inputAsset;

/**
 视频资产
 
 @since v3.4.1
 */
@property (nonatomic,readonly)AVAsset *inputAsset;

/**
 视频资产信息
 
 @since v3.4.1
 */
@property (nonatomic,readonly)TuSDKMediaAssetInfo *inputAssetInfo;

@end

NS_ASSUME_NONNULL_END
