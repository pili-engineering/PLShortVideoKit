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
 设置输出尺寸
 设置输出 outputSize, 如果输出比例和原视频比例不一致时，将自动居中裁剪
 */
@property (nonatomic) CGSize outputSize;

/**
 设置比例不一致时是否自适应画布
 比例不一致时是否将视频自适应画布大小 默认：NO
 */
@property (nonatomic) BOOL aspectOutputRatioInSideCanvas;

/**
 设置画面显示区域 默认：（CGRectMake(0,0,1,1) 完整画面）相对于 textureSize/inputSize
 aspectOutputRatioInSideCanvas 为 NO 时可用
 */
@property (nonatomic) CGRect textureRect;



- (BOOL)calculate:(CGSize) textureSize orientation:(LSQGPUImageRotationMode) orientation verticesCoordinates:(GLfloat[]) verticesCoordinates textureCoorinates:(GLfloat[])textureBuffer;

@end
