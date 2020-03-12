//
//  TuSDKOpenGLAssistant_h

//  TuSDKVideo
//
//  Created by sprint on 09/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#ifndef TuSDKOpenGLAssistant_h
#define TuSDKOpenGLAssistant_h
#import "TuSDKGPUImageHelper.h"

/** 正常角度不旋转 */
static GLfloat lsqNoRotationTextureCoordinates[] = {
    0.0f, 0.0f,1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f,};
/** 旋转270度 */
static GLfloat lsqRotateLeftTextureCoordinates[] = {
    1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, };
/** 旋转90度 */
static GLfloat lsqRotateRightTextureCoordinates[] = {
    0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f, };
/** 垂直镜像 */
static GLfloat lsqVerticalFlipTextureCoordinates[] = {
    0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, };
/** 水平镜像 */
static GLfloat lsqHorizontalFlipTextureCoordinates[] = {
    1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, };
/** 旋转90度垂直镜像 */
static GLfloat lsqRotateRightVerticalFlipTextureCoordinates[] = {
    0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, 1.0f, };
/** 旋转90度水平镜像 */
static GLfloat lsqRotateRightHorizontalFlipTextureCoordinates[] = {
    1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, };
/** 旋转180度 */
static GLfloat lsqRotate180TextureCoordinates[] = {
    1.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, };

/** 材质绘制顶点 */
static GLfloat lsqImageVertices[] = {
    -1.0f, -1.0f, 1.0f, -1.0f, -1.0f, 1.0f, 1.0f, 1.0f, };


/***
 * 根据方向获取坐标信息
 * @param rotationMode 方向
 * @return 坐标信息
 */
static GLfloat* textureCoordinatesFromOrientation(LSQGPUImageRotationMode rotationMode)
{
    
    switch (rotationMode) {
        case LSQKGPUImageRotateLeft:
            return lsqRotateLeftTextureCoordinates;
        case LSQKGPUImageRotateRight:
            return lsqRotateRightTextureCoordinates;
        case LSQKGPUImageFlipVertical:
            return lsqVerticalFlipTextureCoordinates;
        case LSQKGPUImageFlipHorizonal:
            return lsqHorizontalFlipTextureCoordinates;
        case LSQKGPUImageRotateRightFlipVertical:
            return lsqRotateRightVerticalFlipTextureCoordinates;
        case LSQKGPUImageRotateRightFlipHorizontal:
            return lsqRotateRightHorizontalFlipTextureCoordinates;
        case LSQKGPUImageRotate180:
            return lsqRotate180TextureCoordinates;
        case LSQKGPUImageNoRotation:
        default:
            return lsqNoRotationTextureCoordinates;
    }
}

/** 计算旋转坐标*/
static void rotateCoordinates(LSQGPUImageRotationMode rotation, GLfloat* textureCoordinates)
{
    GLfloat t[] = {textureCoordinates[0], textureCoordinates[1], textureCoordinates[2], textureCoordinates[3], textureCoordinates[4],textureCoordinates[5], textureCoordinates[6], textureCoordinates[7]};
    
    switch (rotation)
    {
        case LSQKGPUImageFlipHorizonal:
            textureCoordinates[0] = t[2];
            textureCoordinates[1] = t[3];
            textureCoordinates[2] = t[0];
            textureCoordinates[3] = t[1];
            textureCoordinates[4] = t[6];
            textureCoordinates[5] = t[7];
            textureCoordinates[6] = t[4];
            textureCoordinates[7] = t[5];
            break;
        case LSQKGPUImageFlipVertical:
            
            textureCoordinates[0] = t[4];
            textureCoordinates[1] = t[5];
            textureCoordinates[2] = t[6];
            textureCoordinates[3] = t[7];
            textureCoordinates[4] = t[0];
            textureCoordinates[5] = t[1];
            textureCoordinates[6] = t[2];
            textureCoordinates[7] = t[3];
            
            break;
        case LSQKGPUImageRotateLeft:
            
            textureCoordinates[0] = t[2];
            textureCoordinates[1] = t[3];
            textureCoordinates[2] = t[6];
            textureCoordinates[3] = t[7];
            textureCoordinates[4] = t[0];
            textureCoordinates[5] = t[1];
            textureCoordinates[6] = t[4];
            textureCoordinates[7] = t[5];
            
            
            break;
        case LSQKGPUImageRotateRight:
            
            textureCoordinates[0] = t[4];
            textureCoordinates[1] = t[5];
            textureCoordinates[2] = t[0];
            textureCoordinates[3] = t[1];
            textureCoordinates[4] = t[6];
            textureCoordinates[5] = t[7];
            textureCoordinates[6] = t[2];
            textureCoordinates[7] = t[3];
            
            
            break;
        case LSQKGPUImageRotateRightFlipVertical:
            
            textureCoordinates[0] = t[0];
            textureCoordinates[1] = t[1];
            textureCoordinates[2] = t[4];
            textureCoordinates[3] = t[5];
            textureCoordinates[4] = t[2];
            textureCoordinates[5] = t[3];
            textureCoordinates[6] = t[6];
            textureCoordinates[7] = t[7];
            
            break;
        case LSQKGPUImageRotateRightFlipHorizontal:
            
            textureCoordinates[0] = t[6];
            textureCoordinates[1] = t[7];
            textureCoordinates[2] = t[2];
            textureCoordinates[3] = t[3];
            textureCoordinates[4] = t[4];
            textureCoordinates[5] = t[5];
            textureCoordinates[6] = t[0];
            textureCoordinates[7] = t[1];
            
            
            break;
        case LSQKGPUImageRotate180:
            
            textureCoordinates[0] = t[6];
            textureCoordinates[1] = t[7];
            textureCoordinates[2] = t[4];
            textureCoordinates[3] = t[5];
            textureCoordinates[4] = t[2];
            textureCoordinates[5] = t[3];
            textureCoordinates[6] = t[0];
            textureCoordinates[7] = t[1];
            
            break;
        case LSQKGPUImageNoRotation:
        default:
            break;
    }
    
}

#endif /* TuSDKOpenGLAssistant_h */

