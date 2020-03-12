//
//  TuSDKMediaExportSession.h
//  TuSDKVideo
//
//  Created by sprint on 04/08/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/**
 媒体数据导出协议
 @since     v3.0
 */
@protocol TuSDKMediaExportSession <NSObject>

/**
 开始导出
 @since     v3.0
 */
- (void)startRecording DEPRECATED_MSG_ATTRIBUTE("Pelease use startExport");

/**
 完成导出
 @since     v3.0
 */
- (void)stopRecording DEPRECATED_MSG_ATTRIBUTE("Pelease use stopExport");

/**
 取消导出
 @since     v3.0
 */
- (void)cancelRecording DEPRECATED_MSG_ATTRIBUTE("Pelease use cancelExport");

/**
 开始导出
 @since     v3.1.0
 */
- (void)startExport;

/**
 完成导出
 @since     v3.1.0
 */
- (void)stopExport;

/**
 取消导出
 @since     v3.1.0
 */
- (void)cancelExport;

/**
 销毁
 @since v3.0
 */
- (void)destory;

/**
 根据设备判断是否支持输入4k视频
 
 @return true/false
 @since v3.0
 */
+ (BOOL)supportedInput4K;

@end
