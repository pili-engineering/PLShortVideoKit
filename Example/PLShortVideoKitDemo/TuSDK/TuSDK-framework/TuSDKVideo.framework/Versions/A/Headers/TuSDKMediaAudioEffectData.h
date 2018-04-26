//
//  TuSDKMediaAudioEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaEffectData.h"

/**
 video 背景音乐特效
 */
@interface TuSDKMediaAudioEffectData : TuSDKMediaEffectData

/**
 本地音频地址
*/
@property (nonatomic,readonly,copy) NSURL *audioURL;

/**
 音频音量
 */
@property (nonatomic, assign) CGFloat audioVolume;


/**
 初始化方法
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL;

@end
