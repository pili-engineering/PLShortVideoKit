//
//  PLSUtilFunctions.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#ifndef PLGCDUtils_h
#define PLGCDUtils_h

#import <stdio.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "PLSTypeDefines.h"
#include <mach/mach_time.h>

/*!
 @define PLSDegreeToRadians
 @brief 角度转换为弧度
 */
#define PLSDegreeToRadians(x) (M_PI * x / 180.0)

/*!
 @define PLSRadiansTodegree
 @brief 弧度转换为角度
 */
#define PLSRadiansTodegree(x) (180.0 * x / M_PI)

/*!
 @typedef    PLSPreviewRenderType
 @abstract   视频渲染方式。
 
 @since      v1.4.1
 */
typedef enum {
    PLSPreviewRenderTypeGLKView,
    PLSPreviewRenderTypeGPUImageView,
    PLSPreviewRenderTypeDoubleCapture,         //ahx add for double capture
} PLSPreviewRenderType;

/*!
@typedef PLSTransitionDirection

@abstract 视频转场动画方向，仅支持允许设置方向的转场动画

@since      v3.2.0
*/
typedef enum {
    PLSTransitionDirectionRight           = 0, // 右
    PLSTransitionDirectionLeft            = 1, // 左
    PLSTransitionDirectionTop             = 2, // 上
    PLSTransitionDirectionBottom          = 3, // 下
} PLSTransitionDirection;

/*!
 @function PLSDispactchSetSpecific
 @brief 给队列设置唯一的上下文
 
 @param queue 要设置的 queue
 @param key 设置给队列上下文的值
 */
void PLSDispactchSetSpecific(dispatch_queue_t queue, const void *key);

/*!
 @function PLSDispatchSync
 @brief 同步添加任务到队列
 
 @param queue 任务添加的接收队列
 @param key 队列的上下文关键字
 @param block 待添加到队列的任务
 */
void PLSDispatchSync(dispatch_queue_t queue, const void *key, dispatch_block_t block);

/*!
 @function PLSDispatchAsync
 @brief 异步添加任务到队列
 
 @param queue 任务添加的接收队列
 @param key 队列的上下文关键字
 @param block 待添加到队列的任务
 */
void PLSDispatchAsync(dispatch_queue_t queue, const void *key, dispatch_block_t block);

/*!
 @function PLSCreateSampleBufferFromCVPixelBuffer
 @brief 将 CVPixelBufferRef 转换为 CMSampleBufferRef
 
 @param pixelBuffer 待转的 CVPixelBufferRef
 @param info 时间戳信息
 
 @return CMSampleBufferRef 视频帧
 @warning 返回的 CMSampleBufferRef 需要调用者释放，否则会出现内存泄漏
 */
CMSampleBufferRef PLSCreateSampleBufferFromCVPixelBuffer(CVPixelBufferRef pixelBuffer, CMSampleTimingInfo info);

/*!
 @function PLSCreateCVPixelBufferFromImageWithSize
 @brief 将 UIImage 转换为指定像素的 CVPixelBufferRef
 
 @param image 待转的图片
 @param destSize 需要转换为大多的 CVPixelBufferRef
 
 @return CVPixelBufferRef 视频帧
 @warning 返回的 CVPixelBufferRef 需要调用者释放，否则会出现内存泄漏
 @discussion 该函数在将图片转换为 CVPixelBufferRef 的时候，不会对图片的 transform 进行修正
 */
CVPixelBufferRef  PLSCreateCVPixelBufferFromImageWithSize(UIImage *image, CGSize destSize);

/*!
 @function PLSCreateCVPixelBufferFromImage
 @brief 将 UIImage 转换为 CVPixelBufferRef
 
 @param image 待转的图片
 
 @return CVPixelBufferRef 视频帧
 @warning 返回的 CVPixelBufferRef 需要调用者释放，否则会出现内存泄漏
 @discussion 该该函数在将图片转换为 CVPixelBufferRef 的时候，不会对图片的 transform 进行修正，转换后的 CVPixelBufferRef 的宽高等于图片宽高
 @see PLSCreateCVPixelBufferFromImageWithSize
 */
CVPixelBufferRef  PLSCreateCVPixelBufferFromImage(UIImage *image);

/*!
 @function PLSCreateCVPixelBufferFromImageWithFixTransform
 @brief 将 UIImage 转换为 CVPixelBufferRef
 
 @param image 待转的图片
 
 @return CVPixelBufferRef 视频帧
 @warning 返回的 CVPixelBufferRef 需要调用者释放，否则会出现内存泄漏
 @discussion 该函数在将图片转换为 CVPixelBufferRef 的时候，会对图片的 transform 进行修正，转换后的 CVPixelBufferRef 的宽高等于图片宽高
 */
CVPixelBufferRef  PLSCreateCVPixelBufferFromImageWithFixTransform(UIImage *image);

/*!
 @function PLSTransformWithImage
 @brief 获取图片的 CGAffineTransform
 
 @param image 图片
 
 @return  图片的 CGAffineTransform
 */
CGAffineTransform PLSTransformWithImage(UIImage *image);

/*!
 @function PLSNeedSupportMuseBaseProcessor
 @brief  检查美颜功能是否支持
 @return  支持美颜返回 YES
 */
BOOL PLSNeedSupportMuseBaseProcessor(void);

/*!
 @function PLSGetFileSavePath
 @brief   获取一个新的视频存放路径
 @return  视频存放路径
 */
NSString* PLSGetFileSavePath(NSString *fileType);

/*!
 @function PLSGetFileMergePath
 @brief   获取一个新的视频存放路径
 @return  视频存放路径
 */
NSString* PLSGetFileMergePath(NSString *fileType);

/*!
 @function PLSGetUploaderPath
 @brief   获取一个新的上传视频存放路径
 @return  视频存放路径
 */
NSString* PLSGetUploaderPath(void);

/*!
 @function PLSGetGifComposerPath
 @brief   获取一个新的 GIF 图存放路径
 @return  GIF 图存放路径
 */
NSString* PLSGetGifComposerPath(NSString *name);

/*!
 @function PLSGetReverserPath
 @brief   获取一个新的时光倒流视频存放路径
 @return  视频存放路径
 */
NSString* PLSGetReverserPath(NSString *name, NSString *fileType);

/*!
 @function PLSGetQosPath
 @brief   工具函数
 @return  路径
 */
NSString* PLSGetQosPath(void);

/*!
 @function PLSGetAppleFileType
 @brief   根据 PLSFileType 返回对应的 Apple 媒体文件类型
 @return  Apple 对媒体文件类型
 */
NSString* PLSGetAppleFileType(PLSFileType fileType);

/*!
 @function PLSGetFileExtension
 @brief   根据 PLSFileType 返回对应的文件扩展名
 @return  文件扩展名
 */
NSString* PLSGetFileExtension(PLSFileType fileType);

/*!
 @function PLSComputeBitAlign
 @brief   将整数按照某个值对其
 
 @param   x 待对其的整数
 @param   y 对其值
 
 @return  对其后的整数
 @discussion 比如 x = 540，y = 16，对其之后的值为 544
 */
int PLSComputeBitAlign(int x, int y);

/*!
 @function PLSGetUptimeInNanosecondWithMachTime
 @brief   时间转换工具
 @return  转换后的时间值
 */
uint64_t PLSGetUptimeInNanosecondWithMachTime(uint64_t machTime);

/*!
 @function PLSFixAssetFrameRate
 @brief   帧率修正
 
 @param   asset 包含视频通道的 AVAsset 对象
 @param   wantFrameRate 期望导出视频的帧率值
 
 @discussion 部分视频的 r_frame_rate 和 avg_frame_rate 不相等，这两个对应 AVAssetTrack 中的 minFrameDuration 和 nominalFrameRate。视频的真实帧率大多以 avg_frame_rate 为准。但是在 iOS 中，AVMutableVideoCompositio 的 frameDuration 如果使用 nominalFrameRate 来计算，即: 1.0/nominalFrameRate. 会导致导出之后的视频的帧率下降，如果 frameDuration = minFrameDuration，则导出之后的视频能保持原视频的帧率。不知道这个个什么情况。 因此当遇到这种  r_frame_rate 和 avg_frame_rate 值相差较大的时候，对视频帧率进行一下调整。
 
    举例：如果一个视频
 
    minFrameDuration = CMTimeMake(1, 30);
    nominalFrameRate = 25;
 
    如果使用
 
    CMTime frameDuration = CMTimeMake(1, 25);
 
    作为 AVMutableVideoComposition 的 frameDuration
 
    AVMutableVideoComposition *mvc = [AVMutableVideoComposition videoComposition];
    mvc.frameDuration = frameDuration;
 
    那么使用 AVAssetReaderVideoCompositionOutput 读取到的视频帧率只有 20 fps 左右，会导致导出的视频只有 20 fps。为什么会这样目前没有搞明白，如果使用 minFrameDuration 作为 AVMutableVideoComposition 的 frameDuration，则导出的视频就和原视频帧率一样
 
    mvc.frameDuration = minFrameDuration;
 
 @return  转换后的帧率值
 */
float PLSFixAssetFrameRate(AVAsset *asset, float wantFrameRate);

/*!
 @function getGifImageInfoWithData
 @brief 获取 GIF 图的基本信息
 
 @param inImageSource GIF 图的 source 数据
 @param outDuration GIF 图的时长
 @param outImageCount GIF 图包含的图片总数
 @param outFrameRate GIF 图的帧率
 */
void PLSGetGifImageInfoWithSource(CGImageSourceRef _Nonnull inImageSource, float * _Nullable outDuration, int * _Nullable outImageCount, float * _Nullable outFrameRate);

/*!
 @function getGifImageInfoWithURL
 @brief 获取 GIF 图的基本信息
 
 @param inURL GIF 图的存放地址
 @param outDuration GIF 图的时长
 @param outImageCount GIF 图包含的图片总数
 @param outFrameRate GIF 图的帧率
 */
void PLSGetGifImageInfoWithURL(NSURL * _Nonnull inURL, float * _Nullable outDuration, int * _Nullable outImageCount, float *_Nullable outFrameRate);

/*!
 @function getGifImageInfoWithData
 @brief 获取 GIF 图的基本信息
 
 @param inData GIF 图的数据
 @param outDuration GIF 图的时长
 @param outImageCount GIF 图包含的图片总数
 @param outFrameRate GIF 图的帧率
 */
void PLSGetGifImageInfoWithData(NSData * _Nonnull inData, float * _Nullable outDuration, int * _Nullable outImageCount, float * _Nullable outFrameRate);

#endif /* PLGCDUtils_h */
