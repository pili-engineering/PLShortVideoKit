//
//  SLGLYUVTextureProgram.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/13.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "SLGLProgram.h"
#import "TuSDKTextureCoordinateCropBuilder.h"

NS_ASSUME_NONNULL_BEGIN

/**
 YUV 纹理绘制程序
 @since v3.1.2
 */
@interface SLGLYUVTextureProgram : SLGLProgram

- (instancetype)initWithFullYUVRange:(BOOL)fullYUVRange;

/**
 设置材质坐标计算接口
 
 @since 3.1.2
 */
@property (nonatomic) TuSDKTextureCoordinateCropBuilder *textureCoordinateBuilder;


@property (nonatomic) GLfloat *preferredConversion;
@property (nonatomic,readonly) BOOL isFullYUVRange;


/**
 输入的图像大小
 @since v3.1.2
 */
@property (nonatomic) CGSize inputTextureSize;

/**
 输入方向
 
 @since 3.1.2
 */
@property (nonatomic) LSQGPUImageRotationMode inputRotation;

/**
 绘制 YUV 纹理
 
 @param luminanceTexture luminance 亮度纹理
 @param chrominanceTexture chrominance 色度纹理

 @since v3.1.2
 */
- (void)drawLuminanceTexture:(GLuint)luminanceTexture chrominanceTexture:(GLuint)chrominanceTexture;


@end

NS_ASSUME_NONNULL_END
