//
//  PLSGLKView.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>
#import <OpenGLES/EAGL.h>
#import "PLSTypeDefines.h"

/*!
 @typedef    PLSGLKRotationMode.
 @abstract   渲染的方向设置
 @since      v1.0.0
 */
typedef enum {
    PLSGLKNoRotation,
    PLSGLKRotateLeft,
    PLSGLKRotateRight,
    PLSGLKFlipVertical,
    PLSGLKFlipHorizonal,
    PLSGLKRotateRightFlipVertical,
    PLSGLKRotateRightFlipHorizontal,
    PLSGLKRotate180
} PLSGLKRotationMode;

/*!
 @class PLSGLKView
 @brief 视频渲染 View
 */
@interface PLSGLKView : UIView

/*!
 @property previewOrientation
 @brief 视频渲染方向
 */
@property (assign, nonatomic) PLSGLKRotationMode previewOrientation;

 /*!
  @property fillMode
  @brief 当视频宽高和渲染 View 宽高比例不一样的时候，填充模式
  */
@property (nonatomic, assign) PLSVideoFillModeType fillMode;

/*!
 @property context
 @brief 获取 OpenGL ES 上下文
 */
@property (nonatomic, strong, readonly) EAGLContext *context;

/*!
 @method initWithFrame:eaglContext
 @brief 带 OpenGL ES 上下文的初始化方法
 
 @param frame frame
 @param context OpenGL ES 上下文，如无特殊需求建议传 nil
 */
- (instancetype)initWithFrame:(CGRect)frame eaglContext:(EAGLContext *)context;

/*!
 @method displayPixelBuffer:
 @brief 渲染视频帧
 
 @param pixelBuffer 带渲染的视频帧，kCVPixelFormatType_32BGRA 格式
 */
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
