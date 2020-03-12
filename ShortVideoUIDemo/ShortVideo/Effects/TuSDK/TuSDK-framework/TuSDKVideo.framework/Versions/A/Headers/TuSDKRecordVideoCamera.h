//
//  TuSDKRecordVideoCamera.h
//  TuSDKVideo
//
//  Created by Yanlin on 3/9/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoCameraBase.h"
#import "TuSDKMoiveFragment.h"
#import "TuSDKVideoQuality.h"
#import "TuSDKRecordVideoMode.h"

#pragma mark - TuSDKRecordVideoCameraDelegate

@class TuSDKRecordVideoCamera;
/**
 *  相机事件委托
 */
@protocol TuSDKRecordVideoCameraDelegate <TuSDKVideoCameraDelegate>
/**
 *  视频录制完成
 *
 *  @param camerea 相机
 *  @param result  TuSDKVideoResult 对象
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea result:(TuSDKVideoResult *)result;

/**
 *  视频录制出错
 *
 *  @param camerea 相机
 *  @param error   错误对象
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea failedWithError:(NSError*)error;

@optional

/**
 *  续拍、变速这两种情况下需要对视频进行时间切片分段、变速处理，该情况下为了提升用户体验可以提供进度条展示
 *  其他情况下，保存都是瞬时完成
 *  @param camerea 相机
 *  @param progress 保存的进度progress
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea saveProgressChanged:(CGFloat)progress;


/**
 *  录制进度改变
 *
 *  @param camerea      相机
 *  @param progress     当前进度
 *  @param durationTime 当前录制时长
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea recordProgressChanged:(CGFloat) progress durationTime:(CGFloat) durationTime;

/**
 *  录制状态改变
 *
 *  @param camerea      相机
 *  @param state        当前录制状态
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea recordStateChanged:(lsqRecordState) state;

@end

#pragma mark - TuSDKRecordVideoCamera

/**
 *  视频录制相机 (采集 + 处理 + 录制)
 */
@interface TuSDKRecordVideoCamera : TuSDKVideoCameraBase

/**
 *  初始化相机
 *
 *  @param sessionPreset  相机分辨率
 *  @param cameraPosition 相机设备标识 （前置或后置）
 *  @param view           相机显示容器视图
 *
 *  @return 相机对象
 */
+ (instancetype)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition cameraView:(UIView *)view;

/**
 *  相机事件委托
 */
@property (nonatomic, weak) id<TuSDKRecordVideoCameraDelegate> videoDelegate;

/**
 *  录制视频的总时长. 达到指定时长后，自动停止录制 (默认0，如设置为 0，则需要手动终止)
 */
@property (nonatomic, assign) Float64 maxRecordingTime;

/**
 *  录制视频的最小时长
 */
@property (nonatomic, assign) Float64 minRecordingTime;

/**
    默认最小可用空间 50M
 */
@property (nonatomic, assign) Float64 minAvailableSpaceBytes;

/**
 *  保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 *  保存到系统相册的相册名称
 */
@property (nonatomic, copy) NSString *saveToAlbumName;

/**
 *  录制的视频文件格式（默认:lsqFileTypeQuickTimeMovie）
 */
@property (nonatomic, assign) lsqFileType fileType;

/**
 *  录制模式 默认:lsqRecordModeNormal (lsqRecordModeNormal: 正常模式, lsqRecordModeKeep: 续拍模式,支持断点续拍）
 */
@property (nonatomic, assign) lsqRecordMode recordMode;

/**
 *  变速模式 默认:lsqSpeedMode_Normal (标准模式)
 */
@property (nonatomic, assign) lsqSpeedMode speedMode;

/**
 设置音频变声器类型 默认：lsqSoundPitchNormal
 
 @since v3.0.1
 */
@property (nonatomic, assign) lsqSoundPitch soundPitch;

/**
 *  相机当前状态
 */
@property (nonatomic, assign) lsqRecordState videoCameraStatue;

/**
 *  输出视频的画质，主要包含码率、压缩级别等参数 (默认为空，采用系统设置)
 */
@property (nonatomic, strong) TuSDKVideoQuality *videoQuality;

/**
 验证当前相机状态是否可以切换比例
 @since 2.2.0
 */
@property (nonatomic,readonly) BOOL canChangeRatio;

/**
 *  开始视频录制
 */
- (void)startRecording;

/**
 *  完成视频录制 返回录制结果
 */
- (void)finishRecording;

/**
 *  终止录制
 */
- (void)cancelRecording;

/**
 *  是否正在录制
 *
 *  @return BOOL YES 正在录制
 */
- (BOOL)isRecording;

#pragma mark - 续拍模式

/**
 *  暂停视频录制
 */
- (void)pauseRecording;

/**
 * 已录制的视频片段数量
 *
 * @return NSUInteger
 */
- (NSUInteger)movieFragmentSize;

/**
 * 删除最后一个视频片段
 * 
 * @return TuSDKTimeRange
 */
- (TuSDKTimeRange *)popMovieFragment;

/**
 * 获取最后一个视频片段
 *
 * @return TuSDKTimeRange
 */
- (TuSDKTimeRange *)lastMovieFragment;

@end
