//
//  TuSDKVideoRTCDataWriter.h
//  TuSDKVideo
//
//  Created by Yanlin on 8/23/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoRawDataWriter.h"

@interface TuSDKVideoRTCDataWriter : TuSDKVideoRawDataWriter

/**
 *  获取PixelBuffer，在 processVideoSampleBuffer / processPixelBuffer 方法之后调用。
 *
 *  @return 经过处理的帧
 */
- (CVPixelBufferRef)getPixelBuffer;

@end
