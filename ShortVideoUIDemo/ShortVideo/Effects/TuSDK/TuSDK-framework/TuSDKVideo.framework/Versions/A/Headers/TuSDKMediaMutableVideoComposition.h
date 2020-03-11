//
//  TuSDKMediaMutableVideoComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/14.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaMutableComposition.h"
#import "TuSDKMediaVideoComposition.h"
#import "TuSDKMediaAssetInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 支持多个视频合成项组合.

 [addComposition:id<TuSDKMediaComposition> 只支持添加 TuSDKMediaVideoComposition 合成物 ]
 
 @since v3.4.1
 */
@interface TuSDKMediaMutableVideoComposition : TuSDKMediaMutableComposition <TuSDKMediaVideoComposition>



@end

NS_ASSUME_NONNULL_END
