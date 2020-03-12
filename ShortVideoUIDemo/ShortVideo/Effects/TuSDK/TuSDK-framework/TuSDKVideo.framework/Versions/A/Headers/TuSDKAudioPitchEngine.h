//
//  TuSdkAudioPitchEngine.h
//  TuSDKVideo
//
//  Created by tutu on 2018/7/30.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKAudioEngine.h"

/**
 * 声音处理类型
 * @since v3.0
 */
typedef NS_ENUM(NSUInteger, TuSDKSoundPitchType) {
    // 正常
    TuSDKSoundPitchNormal,
    // 怪兽
    TuSDKSoundPitchMonster,
    // 大叔
    TuSDKSoundPitchUncle,
    // 女生
    TuSDKSoundPitchGirl,
    // 萝莉
    TuSDKSoundPitchLolita,
};

@protocol TuSDKAudioPitchEngineDelegate;

@interface TuSDKAudioPitchEngine : NSObject <TuSDKAudioEngine>

/**
 * 改变音频音调 [速度设置将失效]
 * pitch 0 > pitch [大于1时声音升调，小于1时为降调]
 * @since v3.0
 */
@property (nonatomic) TuSDKSoundPitchType pitchType;

/**
 * 改变音频播放速度 [变速不变调, 音调设置将失效]
 * speed 0 > speed
 * @since v3.0
 */
@property (nonatomic) float speed;

/**
 * TuSDKAudioPitchEngineDelegate
 * @since v3.0
 */
@property (nonatomic, weak) id<TuSDKAudioPitchEngineDelegate> delegate;

/**
 * TuSDKAudioPitchEngine初始化
 * @param inputInfo 音频输入样式
 * @return TuSDKAudioPitchEngine
 * @since v3.0
 */
- (instancetype)initWithInputAudioInfo:(TuSDKAudioTrackInfo *)inputInfo;

@end

#pragma mark - TuSDKAudioPitchEngineDelegate

@protocol TuSDKAudioPitchEngineDelegate

/**
 * 输出音频数据
 * @param output CMSampleBufferRef
 * @param autoRelease 是否释放output
 * @since v3.0
 */
- (void)pitchEngine:(TuSDKAudioPitchEngine *)pitchEngine syncAudioPitchOutputBuffer:(CMSampleBufferRef)output autoRelease:(BOOL *)autoRelease;

@end
