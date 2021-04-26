//
//  PLSCVPixelBufferRotateProcessor.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/5/30.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSPixelBufferProcessor.h"
#import "PLSTypeDefines.h"

/*!
 @typedef PLSGLRotateProcessorType
 @brief 旋转类型枚举值、每次只能设置其中的某一种情况，不能同时使用多种（比如不能设置 FlipVertical 了再叠加设置 Degree90，以最后设置的值为准）
 */
typedef enum : NSUInteger {
    PLSGLRotateProcessorTypeNone,
    PLSGLRotateProcessorTypeDegree90,
    PLSGLRotateProcessorTypeDegree180,
    PLSGLRotateProcessorTypeDegree270,
    PLSGLRotateProcessorTypeFlipVertical,
    PLSGLRotateProcessorTypeFlipHorizonal,
} PLSGLRotateProcessorType;

/*!
 @class PLSCVPixelBufferRotateProcessor
 @brief 对 kCVPixelFormatType_32BGRA 格式图片进行旋转、缩放处理
 */
@interface PLSCVPixelBufferRotateProcessor : NSObject

/*!
 @property rotateType
 @brief 旋转类型
 
 @warning 注意：如果设置为 PLSGLRotateProcessorTypeDegree90 或者 PLSGLRotateProcessorTypeDegree270，
        内部会自动调整一下 sourceRect，destRect 和 destFrameSize 的值。比如 destRect 设置为 {10, 30, 100, 200},
        最终得到的结果为 {30, 10, 200, 100}
 */
@property (nonatomic, assign) PLSGLRotateProcessorType rotateType;

/*!
 @property aspectMode
 @brief 当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式
 */
@property (nonatomic, assign) PLSVideoFillModeType aspectMode;

/*!
 @property sourceRect
 @brief 需要从原始图片中裁剪出来的部分的位置和大小
 */
@property (nonatomic, assign, readonly) CGRect sourceRect;

/*!
 @property destRect
 @brief 裁剪出来的部分放置在新图之中的位置和大小
 */
@property (nonatomic, assign, readonly) CGRect destRect;

/*!
 @property destFrameSize
 @brief 新图的整体画幅大小
 */
@property (nonatomic, assign, readonly) CGSize destFrameSize;

/*!
 @method setSourceRect:destRect:destFrameSize:
 @brief 设置剪裁和缩放信息
 
 @param sourceRect    需要从原始图片中裁剪出来的部分的位置和大小
 @param destRect      裁剪出来的部分放置在新图之中的位置和大小
 @param destFrameSize 新图的整体画幅大小
 */
- (void)setSourceRect:(CGRect)sourceRect destRect:(CGRect)destRect destFrameSize:(CGSize)destFrameSize;

/*!
 @method process:
 @brief 图片剪裁和缩放
 
 @param pixelBuffer   待剪裁的原始图片
 
 @return pixelBuffer  新的图片
 
 @warning 使用该接口进行图像处理需要注意的是，为了保持图像处理的效率，减小开销，该类内部会持有一个 CVPixelBufferRef 并在每次都会返回该对象，因此在每次调用之后请确认对返回的数据已经使用完毕再进行下一次调用，否则会出现非预期的问题
 */
- (CVPixelBufferRef)process:(CVPixelBufferRef)pixelBuffer;

@end
