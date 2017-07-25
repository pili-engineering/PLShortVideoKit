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
    PLSFileTypeMPEG4,
    PLSFileTypeQuickTimeMovie
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

#endif


