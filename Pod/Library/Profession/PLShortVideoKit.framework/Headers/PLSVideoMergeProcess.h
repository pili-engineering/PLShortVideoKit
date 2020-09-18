//
//  PLSVideoMergeProcess.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/4/26.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSTypeDefines.h"
#import <CoreVideo/CoreVideo.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(c_array) (sizeof((c_array))/sizeof((c_array)[0]))
#endif

/*!
 @define MAX_MIX_COUNT
 @brief 单次支持的最大合并图片张数
 */
#define MAX_MIX_COUNT 9

GLuint loaderShader(const char* strShaderDesc, GLenum shaderType);
GLuint createProgram(const char* strVertexDesc, const char* strFragmentDesc);

/*!
 class PLSVideoMergeProcess
 @brief 多张图片合并，最大支持 9 张
 */
@interface PLSVideoMergeProcess : NSObject
{
    EAGLContext *_context;
    
    GLuint _vbo_vertext;
    GLuint _vbo_element;
    
    GLuint _vbo_textures[MAX_MIX_COUNT];
    CGSize _pixelBufferSizes[MAX_MIX_COUNT];
    CGRect _videoFrames[MAX_MIX_COUNT];
    
    GLuint _watermark_vbo_texture;
    
    NSRecursiveLock *_lock;
    
    CGRect _waterMarkFrame;
    UIImage *_waterMarkImage;
    BOOL _waterMarkUpdate;
}

/*!
 @property destVideoSize
 @brief 合并之后的图片大小
 */
@property (nonatomic, readonly) CGSize destVideoSize;

 /*!
  @method setWaterMark:waterMarkPosition:
  @brief 设置水印
  
  @param waterMark 水印图片
  @param position 水印左上角的顶点
  */
- (void)setWaterMark:(UIImage *)waterMark waterMarkPosition:(CGPoint)position;

/*!
 @method setDestVideoSize:
 @brief 设置合并之后的图片大小
 
 @param destVideoSize 合并之后的图片大小
 */
- (void)setDestVideoSize:(CGSize)destVideoSize;

/*!
 @method setVideoFrame:index:
 @brief 设置合并图片的位置和大小
 
 @param frame 图片的位置和大小
 @param index 图片的索引
 */
- (void)setVideoFrame:(CGRect)frame index:(int)index;

/*!
 @method reloadTextCoorBuffer:
 @brief 重新加载纹理顶点信息
 
 @param index 设置的图片索引
 */
- (void)reloadTextCoorBuffer:(int)index;

/*!
 @method mergeVideoWithPixelBuffers:count:
 @brief 合并多张图片
 
 @param pixelBuffer 多张图片数组的首图
 @param bufferCount 合并的图片张数
 
 @return 返回由 pixelBuffer 中的图片合并之后的图片
 */
- (CVPixelBufferRef)mergeVideoWithPixelBuffers:(CVPixelBufferRef *)pixelBuffer count:(int)bufferCount;

/*!
 @method lumaTextureForPixelBuffer:textureCache:
 @brief 使用 luma 数据创建纹理
 
 @param pixelBuffer NV12/I420 格式的 CVPixelBufferRef
 @param textureCache TextureCache
 
 @return 返回由 pixelBuffer 中的 luma 数据创建得到的纹理
 */
- (CVOpenGLESTextureRef)lumaTextureForPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                     textureCache:(CVOpenGLESTextureCacheRef)textureCache;

/*!
 @method chromaTextureForPixelBuffer:textureCache:
 @brief 使用 chroma 数据创建纹理
 
 @param pixelBuffer NV12 格式的 CVPixelBufferRef
 @param textureCache TextureCache
 
 @return 返回由 pixelBuffer 中的 chroma 数据创建得到的纹理
 */
- (CVOpenGLESTextureRef)chromaTextureForPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                       textureCache:(CVOpenGLESTextureCacheRef)textureChahe;;

/*!
 @method rgb32TextureForPixelBuffer:textureCache:
 @brief 使用 32BGRA 数据创建纹理
 
 @param pixelBuffer 32BGRA 格式的 CVPixelBufferRef
 @param textureCache TextureCache
 
 @return 返回由 pixelBuffer 中的 BGRA 数据创建得到的纹理
 */
- (CVOpenGLESTextureRef)rgb32TextureForPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                      textureCache:(CVOpenGLESTextureCacheRef)textureCache;
@end
