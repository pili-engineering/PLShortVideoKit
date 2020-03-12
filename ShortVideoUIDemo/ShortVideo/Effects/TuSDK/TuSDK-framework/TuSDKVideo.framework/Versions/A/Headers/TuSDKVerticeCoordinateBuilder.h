//
//  TuSDKVerticeCoordinateBuilder.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TuSDKOpenGLAssistant.h"


@protocol TuSDKVerticeCoordinateBuilder

/**
 设置输出 outputSize, 如果输出比例和原视频比例不一致时，将自动居中裁剪
 
 @param outputSize 输出尺寸
 */
- (void)setOutputSize:(CGSize)outputSize;

/**
 设置输出 outputSize, 如果输出比例和原视频比例不一致时，自动缩放视频大小，视频不会被裁剪

 @param outputSize 输出尺寸
 @param enableClip 比例不一致时是否将视频缩放
 */
- (void)setOutputSize:(CGSize)outputSize enableClip:(BOOL)enableClip;

- (BOOL)calculate:(CGSize) size orientation:(LSQGPUImageRotationMode) orientation verticesCoordinates:(GLfloat[]) verticesCoordinates textureCoorinates:(GLfloat[])textureBuffer;

@end
