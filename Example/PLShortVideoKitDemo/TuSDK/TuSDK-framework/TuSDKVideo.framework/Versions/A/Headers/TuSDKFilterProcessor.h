//
//  TuSDKFilterProcessor.h
//  TuSDK
//
//  Created by Yanlin Qiu on 26/06/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKVideoCameraBase.h"

#pragma mark - TuSDKFilterProcessorDelegate

@class TuSDKFilterProcessor;
/**
 *  视频处理事件委托
 */
@protocol TuSDKFilterProcessorDelegate <NSObject>
/**
 *  滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param processor 视频处理对象
 *  @param newFilter 新的滤镜对象
 */
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor filterChanged:(TuSDKFilterWrap *)newFilter;

@end

#pragma mark - TuSDKFilterProcessor

/**
 滤镜引擎，实时处理帧数据，并返回处理的结果
 */
@interface TuSDKFilterProcessor : TuSDKFilterProcessorBase
{
    @protected
    
    /**
     *  输出画面分辨率，默认原始采样尺寸输出。
     *  如果设置了输出尺寸，则对画面进行等比例缩放，必要时进行裁剪，保证输出尺寸和预设尺寸一致。
     */
    CGSize _outputSize;
    
    // 设备当前朝向
    UIDeviceOrientation _deviceOrient;
    // 设备图像方向
    UIImageOrientation _imageOrient;
    // 设备视频方向
    AVCaptureVideoOrientation _videoOrientation;
    // 物理感应器方向所对应的视频transform
    CGAffineTransform _videoInputTransform;
}

/**
 *  是否开启动态贴纸 (默认: NO)
 */
@property (nonatomic) BOOL enableLiveSticker;

/**
 *  处理器事件委托
 */
@property (nonatomic, weak) id<TuSDKFilterProcessorDelegate> delegate;

/**
 *  输出 PixelBuffer 格式，可选: lsqFormatTypeBGRA | lsqFormatTypeYUV420F | lsqFormatTypeRawData
 *  默认:lsqFormatTypeBGRA
 */
@property (nonatomic) lsqFrameFormatType outputPixelFormatType;

/**
 *  是否调整输出方向，当 isOriginalOrientation 为 YES 时生效;  YES: 调整输出的buffer方向  NO：输出的buffer方向与输入保持一致
 *  默认:NO
 */
@property (nonatomic, assign) BOOL adjustOutputRotation;

/**
 *  用户界面方向 默认为：UIDeviceOrientationPortrait
 */
@property(readwrite, nonatomic) UIInterfaceOrientation interfaceOrientation;

/**
 *  初始化
 *
 *  支持： kCVPixelFormatType_420YpCbCr8BiPlanarFullRange | kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32BGRA
 *
 *  @param pixelFormatType          原始采样的pixelFormat Type
 *  @param isOriginalOrientation    传入图像的方向是否为原始朝向，SDK 将依据该属性来调整人脸检测时图片的角度。如果没有对图片进行旋转，则为 YES
 *  @param videoSize                输出尺寸
 *
 *  @return instance
 */
- (instancetype)initWithFormatType:(OSType)pixelFormatType
        isOriginalOrientation:(BOOL)isOriginalOrientation
               videoSize:(CGSize)outputSize;

/**
 Process a video sample and return result soon
 
 @param sampleBuffer sampleBuffer sampleBuffer Buffer to process
 @return Video PixelBuffer
 */
- (CVPixelBufferRef)syncProcessVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 Process pixelBuffer and return result soon
 
 @param pixelBuffer pixelBuffer
 @return PixelBuffer
 */
- (CVPixelBufferRef)syncProcessPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 Process pixelBuffer and return result soon
 
 @param pixelBuffer pixelBuffer
 @param frameTime frameTime
 @return PixelBuffer
 */
- (CVPixelBufferRef)syncProcessPixelBuffer:(CVPixelBufferRef)pixelBuffer frameTime:(CMTime)currentTime;

/**
 将 CVPixelBufferRef 数据从 srcPixelBuffer 复制到 destPixelBuffer
 
 @param pixelBuffer srcPixelBuffer
 @param pixelBuffer destPixelBuffer
 */
- (void)copyPixelBuffer:(CVPixelBufferRef)srcPixelBuffer dest:(CVPixelBufferRef) destPixelBuffer;

/**
 手动销毁帧数据
 */
- (void)destroyFrameData;

/**
 *  切换滤镜
 *
 *  @param code 滤镜代号
 *
 *  @return 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *)code;

#pragma mark - live sticker

/**
 *  显示一组动态贴纸。当显示一组贴纸时，会清除画布上的其它贴纸
 *
 *  @param groupSticker 动态贴纸对象
 */
- (void)showGroupSticker:(TuSDKPFStickerGroup *)groupSticker;

/**
 *  动态贴纸组是否已在使用
 *
 *  @param groupSticker 动态贴纸组对象
 *  @return 　是否使用
 */
- (BOOL)isGroupStickerUsed:(TuSDKPFStickerGroup *)groupSticker;

/**
 *  清除动态贴纸
 */
- (void)removeAllLiveSticker;

/** 设置检测框最小倍数 [取值范围: 0.1 < x < 0.5, 默认: 0.2] 值越大性能越高距离越近 */
- (void) setDetectScale: (CGFloat) scale;
#pragma mark - destory

/**
 *  销毁
 */
- (void)destory;
@end
