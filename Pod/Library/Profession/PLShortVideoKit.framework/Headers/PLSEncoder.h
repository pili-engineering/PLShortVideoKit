//
//  PLSEncoder.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSVideoConfiguration.h"
#import "PLSAudioConfiguration.h"

@class PLSEncoder;

/*!
 @protocol PLSEncoderDelegate
 @brief 编码和写文件协议.
 */
@protocol PLSEncoderDelegate <NSObject>

/*!
 @method encoder:didStartRecordingToOutputFileAtURL:
 @brief 编码的时候的回调.
 
 @discussion 只有当前回调被调用之后，才能添加音视频帧，否则添加的音视频帧将会被忽略.
 
 @param encoder 实例.
 @param fileURL 写入的视频文件存放路径.
 */
- (void)encoder:(PLSEncoder *__nonnull)encoder didStartRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL;

/*!
 @method encoder:didFinishRecordingToOutputFileAtURL:
 @brief 编码和写文件完成的回调.
 
 @discussion 由于编码和写文件是异步操作，调用 stopEncoding 只是通知写文件结束，并不能立即结束写文件。因此只有当该回调回调的时候，才是真正的写文件结束.
 
 @param encoder 实例.
 @param outputFileURL 写入的视频文件存放路径.
 */
- (void)encoder:(PLSEncoder *__nonnull)encoder didFinishRecordingToOutputFileAtURL:(NSURL *__nonnull)outputFileURL;

@end

/*!
 @class PLSEncoder
 @brief 编码和写文件类.
 */
@interface PLSEncoder : NSObject

/*!
 @property isAccessCamera
 @brief 相机是否授权，如果相机没有授权，将会按照纯音频来写文件.
 */
@property (assign, nonatomic) BOOL isAccessCamera;

/*!
 @property delegate
 @brief 回调代理.
 */
@property (weak, nonatomic) __nullable id<PLSEncoderDelegate> delegate;

/*!
 @property isEncoding
 @brief 是否处理编码状态，只有当 isEncoding = YES 的时候，添加的音视频数据才会被接收.
 */
@property (assign, nonatomic) BOOL isEncoding;

/*!
 @property videoTransform
 @brief 视频的 CGAffineTransform 参数，可以通过该参数实现视频旋转.
 */
@property (assign, nonatomic) CGAffineTransform videoTransform;

/*!
 @property startRecordingTime
 @brief 视频开始录制的时间点，如果 AVAssetWriter 的 startSessionAtSourceTime 还未设置，则返回 kCMTimeInvalid
 */
@property (assign, nonatomic, readonly) CMTime startRecordingTime;

/*!
 @property outputFileType
 @brief 视频的文件类型，默认为 PLSFileTypeMPEG4(.mp4).
 
 @since      v1.6.0
 */
@property (assign, nonatomic) PLSFileType outputFileType;

/*!
 @method initWithVideoConfiguration:audioConfiguration:
 @brief 编码初始化方法.
 
 @param videoConfiguration 视频编码参数，如果为 nil 则会按照纯音频来处理.
 @param audioConfiguration 音频编码参数，如果问 nil 则会按照纯视频来处理.
 
 @return PLSEncoder 实例
 */
- (_Nonnull instancetype)initWithVideoConfiguration:(PLSVideoConfiguration * _Nullable)videoConfiguration audioConfiguration:(PLSAudioConfiguration * _Nullable)audioConfiguration;

/*!
 @method startEncodingToOutputFileURL:encodingDelegate:
 @brief 开始编码.
 
 @param outputFileURL 视频文件的存放地址.
 @param delegate 回调代理.
 */
- (void)startEncodingToOutputFileURL:(NSURL* __nonnull)outputFileURL encodingDelegate:(__nullable id<PLSEncoderDelegate>)delegate;

/*!
 @method stopEncoding
 @brief 结束编码和写文件，写文件完成之后会通过回调 encoder:didFinishRecordingToOutputFileAtURL 回调出来.
 */
- (void)stopEncoding;

/*!
 @method cancelEncoding
 @brief 取消编码和写文件，已经写入的文件会被自动删除.
 */
- (void)cancelEncoding;

/*!
 @method asyncEncode:isVideo:
 @brief 添加音视频帧. 注意此方法是异步执行
 
 @warning 只有当 isEncoding = YES 的时候，添加是音视频帧会被接收，否则会被忽略.
 
 @param sampleBuffer 音频/视频帧.
 @param isVideo 是否是视频帧.
 */
- (void)asyncEncode:(CMSampleBufferRef __nonnull)sampleBuffer isVideo:(BOOL)isVideo;

/*!
 @method reloadvideoConfiguration:
 @brief 更新视频编码参数.
 
 @warning 如果调用该方法的时候正在编码，则会在下次编码的时候生效，不影响当前正在编码和录制的文件.
 
 @param videoConfiguration 新的视频参数.
 */
- (void)reloadvideoConfiguration:(PLSVideoConfiguration *__nonnull)videoConfiguration;

/*!
 @method reloadAudioConfiguration:
 @brief 更新音频编码参数.
 
 @warning 如果调用该方法的时候正在编码，则会在下次编码的时候生效，不影响当前正在编码和录制的文件.
 
 @param audioConfiguration 新的音频编码参数.
 */
- (void)reloadAudioConfiguration:(PLSAudioConfiguration *__nonnull)audioConfiguration;
@end
