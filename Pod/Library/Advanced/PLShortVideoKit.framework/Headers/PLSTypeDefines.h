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

/*!
 @typedef    PLSAuthorizationStatus
 @abstract   设备授权状态。
 
 @since      v1.0.0
 */
typedef enum {
    /// 还没有确定是否授权
    PLSAuthorizationStatusNotDetermined = 0,
    /// 设备受限，一般在家长模式下设备会受限
    PLSAuthorizationStatusRestricted,
    /// 拒绝授权
    PLSAuthorizationStatusDenied,
    /// 已授权
    PLSAuthorizationStatusAuthorized
} PLSAuthorizationStatus;

/*!
 @typedef    PLSVideoFillModeType
 @abstract   视频预览填充模式。
 
 @since      v1.0.0
 */
typedef enum {
    /// Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
    PLSVideoFillModeStretch,
    
    /// Maintains the aspect ratio of the source image, adding bars of the specified background color
    PLSVideoFillModePreserveAspectRatio,
    
    /// Maintains the aspect ratio of the source image, zooming in on its center to fill the view
    PLSVideoFillModePreserveAspectRatioAndFill
} PLSVideoFillModeType;

/*!
 @typedef    PLSPreviewOrientation
 @abstract   预览视图的方向。
 
 @since      v1.3.0
 */
typedef enum {
    PLSPreviewOrientationPortrait           = 0,
    PLSPreviewOrientationPortraitUpsideDown = 1,
    PLSPreviewOrientationLandscapeRight     = 2,
    PLSPreviewOrientationLandscapeLeft      = 3,
} PLSPreviewOrientation;

/*!
 @typedef    PLSVideoRecoderRateType
 @abstract   视频拍摄速率。

 @since      v1.4.0
 */
typedef enum {
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
    
} PLSVideoRecoderRateType;

#pragma mark - Audio SampleRate

/*!
 @typedef    PLSAudioSampleRate
 @abstract   音频编码采样率。
 
 @discussion 音频编码采样率 和 音频编码的码率直接相关。下表为码率推荐表：
 
 |================================================================|<br>
 |     采样率 Hz      |  推荐码率（单声道）bps |   推荐码率 (双声道) bps |<br>
 |================================================================|<br>
 |       48000       |        64*1000      |      128*1000        |<br>
 |----------------------------------------------------------------|<br>
 |       44100       |        64*1000      |      128*1000        |<br>
 |----------------------------------------------------------------|<br>
 |       22050       |        32*1000      |      64*1000         |<br>
 |----------------------------------------------------------------|<br>
 |       16000       |        32*1000      |      64*1000         |<br>
 |----------------------------------------------------------------|<br>
 |       11025       |        32*1000      |      32*1000         |<br>
 |----------------------------------------------------------------|<br>
 更多详细的码率设置，可以参考如下网页：
 http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#Bitrate_Modes
 
 @since      v1.0.0
 */
typedef enum {
    /**
     @brief   PLSAudioSampleRate_48000Hz 48000Hz 音频编码采样率
     */
    PLSAudioSampleRate_48000Hz = 48000,
    
    /**
     @brief   PLSAudioSampleRate_44100Hz 44100Hz 音频编码采样率
     */
    PLSAudioSampleRate_44100Hz = 44100,
    
    /**
     @brief   PLSAudioSampleRate_22050Hz 22050Hz 音频编码采样率
     */
    PLSAudioSampleRate_22050Hz = 22050,
    
    /**
     @brief   PLSAudioSampleRate_16000Hz 16000Hz 音频编码采样率
     
     @since      v1.16.0
     */
    PLSAudioSampleRate_16000Hz = 16000,
    
    /**
     @brief   PLSAudioSampleRate_11025Hz 11025Hz 音频编码采样率
     */
    PLSAudioSampleRate_11025Hz = 11025,
    
} PLSAudioSampleRate;

#pragma mark - Audio BitRate

/*!
 @typedef    PLSAudioBitRate
 @abstract   音频编码码率。
 
 @since      v1.0.0
 */
typedef enum {
    
    /**
     @brief   PLSAudioBitRate_32Kbps 32Kbps 音频码率
     
     @since      v1.16.0
     */
    PLSAudioBitRate_32Kbps = 32000,
    
    /**
     @brief   PLSAudioBitRate_64Kbps 64Kbps 音频码率
     */
    PLSAudioBitRate_64Kbps = 64000,
    
    /**
     @brief   PLSAudioBitRate_96Kbps 96Kbps 音频码率
     */
    PLSAudioBitRate_96Kbps = 96000,
    
    /**
     @brief   PLSAudioBitRate_128Kbps 128Kbps 音频码率
     */
    PLSAudioBitRate_128Kbps = 128000,
    
    /**
     @brief   PLSAudioBitRate_192Kbps 192Kbps 音频码率
     */
    PLSAudioBitRate_192Kbps = 192000,
    
    /**
     @brief   PLSAudioBitRate_256Kbps 256Kbps 音频码率
     
     @since      v1.16.0
     */
    PLSAudioBitRate_256Kbps = 256000,
    
} PLSAudioBitRate;

#pragma mark - Video File Type

/*!
 @typedef PLSFileType
 
 @abstract 视频格式
 
 @since      v1.0.5
 */
typedef enum {
    PLSFileTypeMPEG4, // .mp4
    PLSFileTypeQuickTimeMovie, // .mov
    PLSFileTypeM4A, // .m4a
} PLSFileType;

#pragma mark - Video File Preset

/*!
 @typedef PLSFilePreset
 
 @abstract 视频分辨率
 
 @since      v1.0.5
 */
typedef enum {
    PLSFilePresetLowQuality,
    PLSFilePresetMediumQuality,
    PLSFilePresetHighestQuality,
    PLSFilePreset640x480,
    PLSFilePreset960x540,
    PLSFilePreset1280x720,
    PLSFilePreset1920x1080,
} PLSFilePreset;

#pragma mark - Video File Transition Animation

/*!
 @typedef PLSTransitionType
 
 @abstract 视频转场动画效果
 
 @since      v1.7.0
 */
typedef enum {
    PLSTransitionTypeFade    = 0, // 淡入淡出
} PLSTransitionType;

/*!
 @typedef PLSComposerPriorityType

 @abstract 多个视频拼接的时候，采用的拼接策略: 由于视频文件的音频通道和视频通道时长不一定相等（其实总是不相等,只是相差时间很短），
           在多个视频拼接为一个视频的时候，音视频通道的总时长相差会变大，这可能不是开发者想要的结果。因此提供几种模式供开发者选择
 
 @since      v1.14.0
 */
typedef enum {
    
    /**
     @brief 以拼接之后，单个视频时间段内音视频同步优先，这是默认模式：这种模式的好处是无论拼接多少个文件，总是能保证拼
     接后的文件音视频是同步的，不好之处是拼接处可能会有音频的卡顿
    */
    PLSComposerPriorityTypeSync = 0,
    
    /**
     @brief 以拼接之后，音视频播放连续性优先：这种模式的好处是无论拼接多少个文件，总是能保证拼接后的文件播放是流畅的，
     不好之处是可能引起音视频不同步
     */
    PLSComposerPriorityTypeSmooth,
    
    /**
     @brief 以拼接的文件视频通道长度为准，当参与拼接文件的音频通道时长比视频通道时长长的时候，将多出的音频数据丢弃掉。
     当视音频通道时长比视频通道时长短的视频，则将音频通道补齐和视频通道一样长。当一段视频中，音频数据和视频数据时长相
     差较大（超过 0.1 秒）时，不建议使用这种模式
     
     @since      v1.16.0
     */
    PLSComposerPriorityTypeVideo,
    
    /**
     @brief 以拼接的文件音频通道长度为准，当参与拼接文件的视频通道时长比音频通道时长长的时候，将多出的视频数据丢弃掉。
     当视频通道时长比音频通道时长短的视频，则将视频通道补齐和音频通道一样长。当一段视频中，音频数据和视频数据时长相差
     较大（超过 0.1 秒）时，不建议使用这种模式
     
     @since      v1.16.0
     */
    PLSComposerPriorityTypeAudio,
} PLSComposerPriorityType;

/*!
 @typedef PLSWaterMarkType
 
 @abstract 水印的类型
 
 @since      v1.15.0
 */
typedef enum {
    
    // 静态水印，比如：PNG、JPG 等静态图片
    PLSWaterMarkTypeStatic = 0,
    
    // GIF 水印
    PLSWaterMarkTypeGif,
} PLSWaterMarkType;

/*!
 @typedef PLSMediaType
 
 @abstract 媒体类型
 
 @since      v1.16.0
 */
typedef enum {
    
    // 图片
    PLSMediaTypeImage = 0,
    // 视频
    PLSMediaTypeVideo,
    // GIF
    PLSMediaTypeGIF,
} PLSMediaType;


/*!
 @typedef    PLShortVideoLogLevel
 @abstract   短视频日志级别。
 @since      v2.1.0
 */
typedef enum {
    // No logs
    PLShortVideoLogLevelOff       = 0,
    // Error logs only
    PLShortVideoLogLevelError,
    // Error and warning logs
    PLShortVideoLogLevelWarning,
    // Error, warning and info logs
    PLShortVideoLogLevelInfo,
    // Error, warning, info and debug logs
    PLShortVideoLogLevelDebug,
    // Error, warning, info, debug and verbose logs
    PLShortVideoLogLevelVerbose,
} PLShortVideoLogLevel;


/*!
 @typedef    PLSAuthenticationResult
 @abstract   SDK 授权状态查询。
 @since      v1.16.1
 */
typedef enum {
    // 还没有确定是否授权
    PLSAuthenticationResultNotDetermined = 0,
    // 未授权
    PLSAuthenticationResultDenied,
    // 已成功
    PLSAuthenticationResultAuthorized
} PLSAuthenticationResult;

#endif


