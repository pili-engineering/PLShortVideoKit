//
//  PLSImageRotateProcessor.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/5/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>

/*!
 @class PLSImageRotateProcessor
 @brief 图片旋转录制帧处理类.
 */
@interface PLSImageRotateProcessor : NSObject

/*!
 @property backgroundSize
 @brief 返回最终生成图像的宽高.
 */
@property (nonatomic, readonly) CGSize backgroundSize;

/*!
 @property rotateFrame
 @brief 设置旋转图片的位置和大小，（相对于 backgroundSize）.
 */
@property (nonatomic, readonly) CGRect rotateFrame;

/*!
 @method setWantPixelSize:rotateFrame:backgroundPixelBuffer:rotatePixelBuffer:
 @brief 设置渲染信息.
 
 @param videoSize               最后生成的 CVPixelBufferRef 的宽高，即就是 pixelBufferWithAngel：返回 pixelbuffer 的宽高.
 @param rotateframe             旋转部分的frame，相对于 videoSize.
 @param backgroundPixelBuffer   背景图片.
 @param rotatePxielBuffer       旋转图片.
 */
- (void)setWantPixelSize:(CGSize)videoSize
             rotateFrame:(CGRect)rotateframe
   backgroundPixelBuffer:(CVPixelBufferRef __nonnull)backgroundPixelBuffer
       rotatePixelBuffer:(CVPixelBufferRef __nonnull)rotatePxielBuffer;

/*!
 @method pixelBufferWithAngel:
 @brief 传入一个角度，返回个旋转了 angle 的 buffer.
 
 @param angle 以弧度为单位的角度.
 */
- (CVPixelBufferRef __nullable)pixelBufferWithAngel:(float)angle;

@end
