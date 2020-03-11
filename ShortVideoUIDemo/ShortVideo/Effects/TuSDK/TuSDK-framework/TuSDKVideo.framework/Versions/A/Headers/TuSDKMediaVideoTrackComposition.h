//
//  TuSDKMediaVideoTrackComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/8.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaAssetInfo.h"
#import "TuSDKMediaVideoComposition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用以读取视频轨道数据
 @since v3.4.1
 */
@interface TuSDKMediaVideoTrackComposition : NSObject <TuSDKMediaVideoComposition>

/**
 根据视频轨道合成初始化 TuSDKMediaVideoTrackComposition

 @param inputAsset 视频资产
 @return TuSDKMediaVideoTrackComposition
 
 @since v3.4.1
 */
- (instancetype)initWithVideoAsset:(AVAsset *)inputAsset;

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
