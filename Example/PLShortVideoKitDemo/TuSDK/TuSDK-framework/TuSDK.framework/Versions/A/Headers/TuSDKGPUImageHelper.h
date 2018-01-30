//
//  TuSDKGPUImageHelper.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/17.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageImport.h"
/**
 *  GPUImage帮助类
 */
@interface TuSDKGPUImageHelper : NSObject
/**
 *  通过图片方向获取GPUImage方向
 *
 *  @param imageOrientation 图片方向
 *
 *  @return GPUImage方向
 */
+ (GPUImageRotationMode)rotationModeWithImageOrientation:(UIImageOrientation)imageOrientation;

/**
 通过GPUImage方向旋转归一化区域
 @param rect 归一化区域
 @param rotation GPUImage方向
 @return 旋转归一化区域
 */
+ (CGRect)rotationWithRect:(CGRect)rect rotation:(GPUImageRotationMode)rotation;

/**
 计算材质旋转坐标
 @param rotation GPUImage方向
 @param rect 归一化区域
 @param coordinates 顶点
 */
+ (void)textureWithRotation:(GPUImageRotationMode)rotation rect:(CGRect)rect coordinates:(GLfloat *)coordinates;

/**
 计算显示画面旋转坐标
 @param rotation GPUImage方向
 @param rect 归一化区域
 @param coordinates 顶点
 */
+ (void)displayWithRotation:(GPUImageRotationMode)rotation rect:(CGRect)rect coordinates:(GLfloat *)coordinates;
@end
