//
//  TuSDKVideoDataOutputBase.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 22/12/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoSourceProtocol.h"

extern NSString *const kTuVideoGPUImageColorSwizzlingFragmentShaderString;

#pragma mark - TuSDKVideoDataOutputBase

@interface TuSDKVideoDataOutputBase : NSObject <TuSDKVideoOutputWriter>
{
    SLGPUImageContext *_movieWriterContext;
    
    LSQGPUImageRotationMode _inputRotation;
    
    @protected
    
    GLuint movieFramebuffer, movieRenderbuffer;
    
    // 渲染输出对象
    CVPixelBufferRef _renderTarget;
    
    // Texture
    CVOpenGLESTextureRef _renderTexture;
    
    BOOL _isRecording;
    
    BOOL _encodingLiveVideo;
    
    // 输出帧尺寸
    CGSize _videoSize;
    
    lsqWaterMarkPosition _waterMarkPosition;
    
    // 帧缓冲对象
    SLGPUImageFramebuffer *firstInputFramebuffer;
}


@property (nonatomic) BOOL enabled;

/**
 *  录制状态
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 *  是否实时视频流，默认: YES
 */
@property (nonatomic) BOOL encodingLiveVideo;

/**
 *  输出尺寸
 */
@property (nonatomic) CGSize outputSize;

/**
 *  输出区域
 */
@property (nonatomic) CGRect outputRegion;

/**
 *  相机对象
 */
@property (nonatomic, assign) id<TuSDKVideoCameraInterface> camera;

#pragma mark - waterMark
/**
 设置水印图片
 */
@property (nonatomic, retain) UIImage *waterMarkImage;

/**
 水印位置，默认 lsqWaterMarkBottomRight 若视频有位置相关旋转 应在设置videoOrientation后调用该setter方法；
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

/**
  记录当前的视频方向，用来调整水印
 */
@property(nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

#pragma mark - FitlerProcessor only
/**
 输出方向 (默认: kGPUImageNoRotation)
 */
@property (nonatomic) LSQGPUImageRotationMode outputRotation;

- (void)initGLContext;

- (void)initGLProgram;

- (void)renderAtInternalSizeUsingFramebuffer:(SLGPUImageFramebuffer *)inputFramebufferToUse;

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;

#pragma mark - Frame rendering

- (void)createDataFBO;


#pragma mark - Recording
/**
 *  开始视频录制
 */
- (void)startRecording;

/**
 *  完成视频录制
 */
- (void)finishRecording;

/**
 *  终止录制
 */
- (void)cancelRecording;
@end
