//
//  PLSTypeDefines.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#ifndef PLCameraStreamingKit_PLTypeDefines_h
#define PLCameraStreamingKit_PLTypeDefines_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#if defined(__cplusplus)
#define PLS_EXPORT extern "C"
#else
#define PLS_EXPORT extern
#endif


// post with userinfo @{@"state": @(state)}. always posted via MainQueue.
extern NSString *PLSCameraAuthorizationStatusDidGetNotificaiton;
extern NSString *PLSMicrophoneAuthorizationStatusDidGetNotificaiton;

extern NSString *PLSCameraDidStartRunningNotificaiton;
extern NSString *PLSMicrophoneDidStartRunningNotificaiton;

/**
 @typedef    PLSAuthorizationStatus
 @abstract   设备授权状态。
 
 @since      v1.0.0
 */
typedef NS_ENUM(NSUInteger, PLSAuthorizationStatus) {
    /// 还没有确定是否授权
    PLSAuthorizationStatusNotDetermined = 0,
    /// 设备受限，一般在家长模式下设备会受限
    PLSAuthorizationStatusRestricted,
    /// 拒绝授权
    PLSAuthorizationStatusDenied,
    /// 已授权
    PLSAuthorizationStatusAuthorized
};

/**
 @typedef    PLSVideoFillModeType
 @abstract   视频预览填充模式。
 
 @since      v1.0.0
 */
typedef enum {
    /**
     @brief Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
     */
    PLSVideoFillModeStretch,
    
    /**
     @brief Maintains the aspect ratio of the source image, adding bars of the specified background color
     */
    PLSVideoFillModePreserveAspectRatio,
    
    /**
     @brief Maintains the aspect ratio of the source image, zooming in on its center to fill the view
     */
    PLSVideoFillModePreserveAspectRatioAndFill
} PLSVideoFillModeType;

/**
 @typedef    PLSPreviewOrientation
 @abstract   预览视图的方向。
 
 @since      v1.3.0
 */
typedef NS_ENUM(NSInteger, PLSPreviewOrientation) {
    PLSPreviewOrientationPortrait           = 0,
    PLSPreviewOrientationPortraitUpsideDown = 1,
    PLSPreviewOrientationLandscapeRight     = 2,
    PLSPreviewOrientationLandscapeLeft      = 3,
};

/**
 @typedef    PLSVideoRecoderRateType
 @abstract   视频拍摄速率。

 @since      v1.4.0
 */
typedef NS_ENUM(NSInteger, PLSVideoRecoderRateType) {
    /**
     @brief Maintains the video recoder rate normal, 1x
     */
    PLSVideoRecoderRateNormal = 0,
    
    /**
     @brief Maintains the video recoder rate slow, 0.667x
     */
    PLSVideoRecoderRateSlow,
    
    /**
     @brief Maintains the video recoder rate very slow, 0.5x
     */
    PLSVideoRecoderRateTopSlow,
    
    /**
     @brief Maintains the video recoder rate fast, 1.5x
     */
    PLSVideoRecoderRateFast,
    
    /**
     @brief Maintains the video recoder rate very fast, 2x
     */
    PLSVideoRecoderRateTopFast
};

#pragma mark - Audio SampleRate

/**
 @typedef    PLSAudioSampleRate
 @abstract   音频编码采样率。
 
 @constant   PLSAudioSampleRate_48000Hz 48000Hz 音频编码采样率
 @constant   PLSAudioSampleRate_44100Hz 44100Hz 音频编码采样率
 @constant   PLSAudioSampleRate_22050Hz 22050Hz 音频编码采样率
 @constant   PLSAudioSampleRate_11025Hz 11025Hz 音频编码采样率
 
 @since      v1.0.0
 */
typedef NS_ENUM(NSUInteger, PLSAudioSampleRate) {
    PLSAudioSampleRate_48000Hz = 48000,
    PLSAudioSampleRate_44100Hz = 44100,
    PLSAudioSampleRate_22050Hz = 22050,
    PLSAudioSampleRate_11025Hz = 11025,
};

#pragma mark - Audio BitRate

/**
 @typedef    PLSAudioBitRate
 @abstract   音频编码码率。
 
 @constant   PLSAudioBitRate_64Kbps 64Kbps 音频码率
 @constant   PLSAudioBitRate_96Kbps 96Kbps 音频码率
 @constant   PLSAudioBitRate_128Kbps 128Kbps 音频码率
 
 @since      v1.0.0
 */
typedef enum {
    PLSAudioBitRate_64Kbps = 64000,
    PLSAudioBitRate_96Kbps = 96000,
    PLSAudioBitRate_128Kbps = 128000,
} PLSAudioBitRate;

#pragma mark - Video File Type

/**
 @abstract 视频格式
 
 @since      v1.0.5
 */
typedef NS_ENUM(NSUInteger, PLSFileType) {
    PLSFileTypeMPEG4, // .mp4
    PLSFileTypeQuickTimeMovie, // .mov
    PLSFileTypeM4A, // .m4a
};

#pragma mark - Video File Preset

/**
 @abstract 视频分辨率
 
 @since      v1.0.5
 */
typedef NS_ENUM(NSUInteger, PLSFilePreset) {
    PLSFilePresetLowQuality,
    PLSFilePresetMediumQuality,
    PLSFilePresetHighestQuality,
    PLSFilePreset640x480,
    PLSFilePreset960x540,
    PLSFilePreset1280x720,
    PLSFilePreset1920x1080,
};

#pragma mark - Video File Transition Animation

/**
 @abstract 视频转场动画效果
 
 @since      v1.7.0
 */
typedef NS_ENUM(NSUInteger, PLSTransitionType) {
    PLSTransitionTypeFade    = 0, // 淡入淡出
};

#endif


