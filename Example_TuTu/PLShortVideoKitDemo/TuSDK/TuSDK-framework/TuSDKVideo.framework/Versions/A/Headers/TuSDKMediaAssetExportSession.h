//
//  TuSDKMediaAssetExportSession.h
//  TuSDKVideo
//
//  Created by sprint on 04/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaExportSession.h"

/**
 Asset 导出协议
 @since v3.0
 */
@protocol TuSDKMediaAssetExportSession <NSObject,TuSDKMediaExportSession>

/**
 根据 AVAsset 初始化 ExprotSession
 
 @param asset 媒体数据源
 @return TuSDKMediaAssetExportSession
 @since v3.0
 */
- (instancetype _Nonnull)initWithInputAsset:(AVAsset *_Nullable)asset;


@end
