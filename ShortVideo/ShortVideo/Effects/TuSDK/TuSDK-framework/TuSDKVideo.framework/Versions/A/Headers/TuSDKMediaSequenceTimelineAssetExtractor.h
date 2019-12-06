//
//  TuSDKMediaSequenceTimelineAssetExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 29/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaAssetTimeline.h"
#import "TuSDKMediaTimelineExtractor.h"
#import "TuSDKMediaAssetExtractor.h"
#import "TuSDKMediaExtractorSync.h"

/**
 序列读取媒体数据,不支持倒序读取
 
 @since v3.0
 */
@interface TuSDKMediaSequenceTimelineAssetExtractor : TuSDKMediaAssetExtractor <TuSDKMediaTimelineExtractor>

@end
