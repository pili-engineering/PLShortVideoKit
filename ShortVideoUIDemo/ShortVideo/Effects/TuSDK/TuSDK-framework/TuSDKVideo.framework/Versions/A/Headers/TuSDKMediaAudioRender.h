//
//  TuSDKMediaAudioRender.h
//  TuSDKVideo
//
//  Created by sprint on 19/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 音频渲染接口
 @since  v3.0
 */
@protocol TuSDKMediaAudioRender <NSObject>

@required

/**
 渲染一帧音频

 @param sampleBuffer  解码音频数据
 @return 渲染后的音频数据
 */
- (CMSampleBufferRef)renderAudioSampleBufferRef:(CMSampleBufferRef)sampleBuffer;

@end
