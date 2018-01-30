//
//  TuSDKLiveRTCProcessor.h
//  TuSDKVideo
//
//  Created by Yanlin on 8/23/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKLiveVideoProcessor.h"
#import "TuSDKVideoImport.h"

/**
 *  视频直播实时处理，通过方法获取同步数据
 */
@interface TuSDKLiveRTCProcessor : TuSDKLiveVideoProcessor

/**
 *  获取处理后的pixelBuffer
 *
 *  @return
 */
- (CVPixelBufferRef)getOutputPixelBuffer;

/**
 *  获取处理后的帧数据
 *
 *  @return
 */
- (uint8_t *)getOutputRawData;

@end
