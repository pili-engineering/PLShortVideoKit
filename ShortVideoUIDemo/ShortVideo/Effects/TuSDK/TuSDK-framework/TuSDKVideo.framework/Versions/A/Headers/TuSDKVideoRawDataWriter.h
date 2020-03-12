//
//  TuSDKVideoRawDataWriter.h
//  TuSDKVideo
//
//  Created by Yanlin on 8/1/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoSourceProtocol.h"
#import <libyuv/libyuv.h>

#pragma mark - TuSDKVideoRawDataWriterDelegate

@protocol TuSDKVideoRawDataWriterDelegate <NSObject>

@optional
/**
 *  获取滤镜处理后的帧数据, pixelFormatType 为 lsqFormatTypeBGRA 或 lsqFormatTypeYUV420F 时调用
 *
 *  @param pixelBuffer CVPixelBufferRef对象
 *  @param frameTime   Frame time
 */
- (void)onVideoBufferData:(CVPixelBufferRef)pixelBuffer time:(CMTime)frameTime;

/**
 *  获取滤镜处理后的帧原始数据, pixelFormatType 为 lsqFormatTypeRawData 时调用
 *
 *  @param bytes       帧原始数据
 *  @param bytesPerRow bytesPerRow
 *  @param imageSize   尺寸
 *  @param frameTime   Frame time
 */
- (void)onVideoRawData:(unsigned char *)bytes bytesPerRow:(NSUInteger)bytesPerRow imageSize:(CGSize)imageSize time:(CMTime)frameTime;

@end

#pragma mark - TuSDKVideoRawDataWriter
/**
 *  视频流输出处理
 */

@interface TuSDKVideoRawDataWriter : NSObject <TuSDKVideoOutputWriter, SLGPUImageInput>
{
    @protected
    
    SLGPUImageFramebuffer *firstInputFramebuffer, *outputFramebuffer, *retainedFramebuffer;
    
    // YUV
    uint8_t* yBytes;
    uint8_t* uvBytes;
    
    /**
     *  录制状态
     */
    BOOL _isRecording;
    
    BOOL _hasReadFromTheCurrentFrame;
    
    lsqFrameFormatType _pixelFormatType;
}

/**
 *  视频数据输出代理
 */
@property (nonatomic, assign) id<TuSDKVideoRawDataWriterDelegate> writerDelegate;

@property (nonatomic) BOOL enabled;

/**
 *  录制状态
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 *  相机对象
 */
@property (nonatomic, assign) id<TuSDKVideoCameraInterface> camera;

/**
 *  输出 PixelBuffer 格式，可选: lsqFormatTypeBGRA | lsqFormatTypeYUV420F | lsqFormatTypeRawData
 *  默认:lsqFormatTypeBGRA
 */
@property (nonatomic) lsqFrameFormatType pixelFormatType;

/**
 *  设置输出尺寸
 *
 *  @param mOutputSize CGSize对象
 */
- (void)setOutputSize:(CGSize)mOutputSize;

/**
 *  输出尺寸
 *
 *  @return 
 */
- (CGSize)outputSize;

- (void)lockFramebufferForReading;

- (void)unlockFramebufferAfterReading;

- (GLubyte *)rawBytesForImage;

- (NSUInteger)bytesPerRowInOutput;

/**
 *  生成 Planar PixelBuffer
 *
 *  @param frameSize 尺寸
 *
 *  @return Planar PixelBuffer
 */
- (CVPixelBufferRef)genereateYUVData:(CGSize)frameSize;

@end
