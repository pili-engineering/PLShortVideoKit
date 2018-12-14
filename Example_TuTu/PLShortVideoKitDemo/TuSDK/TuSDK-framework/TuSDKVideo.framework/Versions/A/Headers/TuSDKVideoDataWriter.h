//
//  TuSDKVideoDataWriter.h
//  TuSDKGeeV1
//
//  Created by Yanlin on 2/16/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import "TuSDKVideoDataOutputBase.h"
#import <libyuv/libyuv.h>

/**
 帧数据结果

 @param pixelBuffer 处理后的帧数据
 @param frameTime 时间戳
 */
typedef void (^VideoFrameDataBlock)(CVPixelBufferRef pixelBuffer, CMTime frameTime);

/**
 帧数据结果
 
 @param texture 处理后的texture
 */
typedef void (^VideoFrameTextureBlock)(GLuint texture);

#pragma mark - TuSDKVideoWriterDelegate

@protocol TuSDKVideoDataWriterDelegate <NSObject>

@optional
/**
 *  获取滤镜处理后的帧缓冲数据
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

#pragma mark - TuSDKVideoDataWriter
/**
 *  视频流输出处理
 */
@interface TuSDKVideoDataWriter : TuSDKVideoDataOutputBase
{
    
}

/**
 *  视频数据输出代理
 */
@property (nonatomic, assign) id<TuSDKVideoDataWriterDelegate> writerDelegate;

/**
 *  输出 PixelBuffer 格式，可选: lsqFormatTypeBGRA | lsqFormatTypeYUV420F | lsqFormatTypeRawData
 *  默认:lsqFormatTypeBGRA
 */
@property (nonatomic) lsqFrameFormatType pixelFormatType;

/**
 帧数据输出回调
 */
@property (nonatomic, strong) VideoFrameDataBlock frameDataBlock;

/**
 帧数据输出回调
 */
@property (nonatomic, strong) VideoFrameTextureBlock frameTextureBlock;

/**
 自动回收帧数据 (默认: YES)
 */
@property (nonatomic) BOOL autoReleaseFrameData;

/**
 手动销毁帧数据，配合 autoReleaseFrameData = NO 使用
 */
- (void)destroyFrameData;

@end
