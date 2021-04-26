//
//  PLSPixelBufferProcessor.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>

/*!
 @class      PLSPixelBufferProcessor
 @abstract   PLSPixelBufferProcessor 用于对图像进行裁剪和缩放
 
 @since      v1.0.0
 */
@interface PLSPixelBufferProcessor : NSObject

/*!
 @typedef PLSPixelAspectMode
 
 @brief 当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式
 */
typedef enum
{
    /// 保持原图比例并嵌入新图来填充
    PLSPixelAspectModeFit,
    
    /// 保持原图比例并将新图填充满
    PLSPixelAspectModeFill
} PLSPixelAspectMode;

/*!
 @property sourceRect
 
 @brief 需要从原始图片中裁剪出来的部分的位置和大小
 */
@property (nonatomic, assign) CGRect sourceRect;

/*!
 @property destRect
 
 @brief 裁剪出来的部分放置在新图之中的位置和大小
 */
@property (nonatomic, assign) CGRect destRect;

/*!
 @property destFrameSize
 
 @brief 新图的整体画幅大小
 */
@property (nonatomic, assign) CGSize destFrameSize;

/*!
 @property aspectMode
 
 @brief 当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式
 */
@property (nonatomic, assign) PLSPixelAspectMode aspectMode;

/*!
 @method initWithSourceRect:destRect:destFrameSize:aspectMode
 @brief 初始化一个 PLSPixelBufferProcessor 对象
 
 @param sourceRect    需要从原始图片中裁剪出来的部分的位置和大小
 @param destRect      裁剪出来的部分放置在新图之中的位置和大小
 @param destFrameSize 新图的整体画幅大小
 @param aspectMode    当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式
 
 @return 初始化后的 PLSPixelBufferProcessor 对象
 */
- (instancetype)initWithSourceRect:(CGRect)sourceRect destRect:(CGRect)destRect destFrameSize:(CGSize)destFrameSize aspectMode:(PLSPixelAspectMode)aspectMode;

/*!
 @method processPixelBuffer:
 @brief 用于处理图像的接口
 
 @param sourceBuffer 原始图片的对象
 
 @return 处理之后的 CVPixelBufferRef 对象
 
 @discussion 使用该接口进行图像处理需要注意的是，为了保持图像处理的效率，减小开销，该类内部会持有一个 CVPixelBufferRef 并在每次都会返回该对象，因此在每次调用之后请确认对返回的数据已经使用完毕再进行下一次调用，否则会出现非预期的问题
 */
- (CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)sourceBuffer;

@end
