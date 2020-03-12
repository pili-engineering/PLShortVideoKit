//
//  TuSDKMediaExtractorSync.h
//  TuSDKVideo
//
//  Created by sprint on 28/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaSync.h"
#import "TuSDKMediaTimeSliceEntity.h"

@protocol TuSDKMediaExtractor;

/**
 TuSDKMediaExtractor 同步器
 @since      v3.0
 */
@protocol TuSDKMediaExtractorSync <NSObject,TuSDKMediaSync>

@required

/**
 同步多媒体数据 [解码后]

 @since      v3.0
 */
- (void)syncExtractor;

/**
 * 跳转到指定位置
 * @since  v3.0
 */
- (void)seekTo:(CMTime)outputTime;

@end


