//
//  TuSDKMediaTypes.h
//  TuSDKVideo
//
//  Created by sprint on 14/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - TuSDKMediaAssetExtractorStatus
/**
 媒体数据分离器状态枚举值

 - TuSDKMediaAssetExtractorStatusUnknown: 未知状态
 - TuSDKMediaAssetExtractorStatusReading: 正在读取数据
 - TuSDKMediaAssetExtractorStatusCompleted: 读取完成
 - TuSDKMediaAssetExtractorStatusPaused: 分离器已暂停
 - TuSDKMediaAssetExtractorStatusCancelled: 分离器被中途取消
 - TuSDKMediaAssetExtractorStatusFailed: 分离器创建失败
 */
typedef NS_ENUM(NSInteger, TuSDKMediaAssetExtractorStatus) {
    TuSDKMediaAssetExtractorStatusUnknown = 0,
    TuSDKMediaAssetExtractorStatusReading,
    TuSDKMediaAssetExtractorStatusCompleted,
    TuSDKMediaAssetExtractorStatusPaused,
    TuSDKMediaAssetExtractorStatusCancelled,
    TuSDKMediaAssetExtractorStatusFailed
};


#pragma mark - TuSDKMediaExportSessionStatus
/**
 导出数据状态枚举值

 - TuSDKMediaExportSessionStatusUnknown: 未知状态
 - TuSDKMediaExportSessionStatusExporting: 正在导出
 - TuSDKMediaExportSessionStatusCancelled: 导出时被中途取消
 - TuSDKMediaExportSessionStatusFailed: 导出失败
 - TuSDKMediaExportSessionStatusCompleted: 导出完成
 */
typedef NS_ENUM(NSInteger, TuSDKMediaExportSessionStatus) {
    TuSDKMediaExportSessionStatusUnknown = 0,
    TuSDKMediaExportSessionStatusExporting,
    TuSDKMediaExportSessionStatusRequestCancel,
    TuSDKMediaExportSessionStatusCancelled,
    TuSDKMediaExportSessionStatusFailed,
    TuSDKMediaExportSessionStatusCompleted,
};


#pragma mark - TuSDKMediaPlayerStatus

/**
 播放器状态枚举值

 - TuSDKMediaPlayerStatusUnknown: 未知状态
 - TuSDKMediaPlayerStatusFailed: 播放器播放失败
 - TuSDKMediaPlayerStatusReadyToPlay: 加载完成准备播放
 - TuSDKMediaPlayerStatusPlaying: 正在播放中
 - TuSDKMediaPlayerStatusPaused: 播放已暂停
 - TuSDKMediaPlayerStatusCompleted: 播放完成
 */
typedef NS_ENUM(NSInteger, TuSDKMediaPlayerStatus) {
    TuSDKMediaPlayerStatusUnknown = 0,
    TuSDKMediaPlayerStatusFailed = 1,
    TuSDKMediaPlayerStatusReadyToPlay = 2,
    TuSDKMediaPlayerStatusPlaying = 3,
    TuSDKMediaPlayerStatusPaused = 4,
    TuSDKMediaPlayerStatusCompleted = 5
};


#pragma mark - TuSDKMediaPlayerLoadStatus

/**
 播放器状态枚举值
 
 - TuSDKMediaPlayerLoadStatusUnknown: 未知状态
 - TuSDKMediaPlayerLoadStatusFailed: 播放器播放失败
 - TuSDKMediaPlayerLoadStatusLoading: 加载完成准备播放
 - TuSDKMediaPlayerLoadStatusCompleted: 播放完成
 */
typedef NS_ENUM(NSInteger, TuSDKMediaPlayerLoadStatus) {
    TuSDKMediaPlayerLoadStatusUnknown = 0,
    TuSDKMediaPlayerLoadStatusFailed = 1,
    TuSDKMediaPlayerLoadStatusLoading = 2,
    TuSDKMediaPlayerLoadStatusCompleted = 3
};
