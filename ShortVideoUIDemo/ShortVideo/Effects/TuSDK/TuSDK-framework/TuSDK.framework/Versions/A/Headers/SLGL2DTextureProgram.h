//
//  SLGL2DTextureProgram.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/13.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "SLGLProgram.h"
#import "TuSDKTextureCoordinateCropBuilder.h"

NS_ASSUME_NONNULL_BEGIN

/**
 2D 纹理绘制
 @since v3.1.2
 */
@interface SLGL2DTextureProgram : SLGLProgram

/**
 设置材质坐标计算接口
 
 @since 3.1.2
 */
@property (nonatomic) TuSDKTextureCoordinateCropBuilder *textureCoordinateBuilder;

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
 绘制 2D 纹理

 @param texture 2D 纹理
 @since v3.1.2
 */
- (void)drawTexture:(GLuint)texture;

@end

NS_ASSUME_NONNULL_END
