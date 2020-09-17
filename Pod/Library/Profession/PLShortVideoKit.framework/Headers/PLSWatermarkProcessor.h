//
//  PLSWatermarkProcessor.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>
#import "PLSTypeDefines.h"

/*!
 @class      PLSWatermarkProcessor
 @abstract   PLSWatermarkProcessor 用于给 BGRA32 图像添加镜像和水印
 
 @since      v1.0.0
 */
@interface PLSWatermarkProcessor : NSObject

/*!
 @method setWatermarkImage:
 @brief 设置水印图片
 
 @param image 水印图片，如果 image = nil，则表示移除水印
 */
- (void)setWatermarkImage:(UIImage*)image;

/*!
 @method setWatermarkImage:alpha
 @brief 设置水印图片
 
 @param image 水印图片，如果 image = nil，则表示移除水印
 @param alpha 水印图片的 alpha 值
 */
- (void)setWatermarkImage:(UIImage*)image alpha:(CGFloat)alpha;

/*!
 @method setGifWatermarkData:alpha:videoFrameRate:
 @brief 设置 gif 水印数据
 
 @param gifData gif 水印数据
 @param alpha 水印的 alpha 值
 @param videoFrameRate 视频的帧率
 
 @warning gif 的帧率一般比视频的帧率低，因此内部会对 gif 进行插帧操作，需要设置的视频帧率接近真实的视频帧率，否则生成的视频会出现 gif 水印的播放比视频快或者慢
 */
- (void)setGifWatermarkData:(NSData *)gifData alpha:(CGFloat)alpha videoFrameRate:(CGFloat)videoFrameRate;

/*!
 @method setWatermarkDisplaySize:position:
 @brief 设置水印图片的大小，位置
 
 @param size 水印的大小
 @param position 水印的位置
 
 @warning 如果设置的水印宽高和水印图片的宽高不一致的时候，水印会被拉伸
 */
- (void)setWatermarkDisplaySize:(CGSize)size position:(CGPoint)position;

/*!
 @method setWatermarkDisplaySize:position:rotateAngle
 @brief 设置水印图片的大小，位置，旋转角度
 
 @param angle 水印的旋转角度（单位：弧度）
 
 @see setWatermarkDisplaySize:position:
 */
- (void)setWatermarkDisplaySize:(CGSize)size position:(CGPoint)position rotateAngle:(CGFloat)angle;

/*!
 @method process:
 @brief 用于处理图像的接口
 
 @param pixelBuffer 原始图像的对象
 
 @return 处理之后的 CVPixelBufferRef 对象
 
 @discussion 使用该接口进行图像处理需要注意的是，为了保持图像处理的效率，减小开销，该类内部会持有一个 CVPixelBufferRef 并在每次都会返回该对象，因此在每次调用之后请确认对返回的数据已经使用完毕再进行下一次调用，否则会出现非预期的问题
 */
- (CVPixelBufferRef)process:(CVPixelBufferRef)pixelBuffer;

@end
