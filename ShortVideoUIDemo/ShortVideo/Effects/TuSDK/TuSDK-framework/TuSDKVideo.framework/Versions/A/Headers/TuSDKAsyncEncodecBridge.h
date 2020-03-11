//
//  TuSDKAsyncEncodecBridge.h
//  TuSDKEva
//
//  Created by KK on 2019/11/14.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "TuSDKVideoImport.h"

NS_ASSUME_NONNULL_BEGIN

@class TuSDKAsyncShader;
/// 编码中间FBO的管理
@interface TuSDKEncodecFBOManager : NSObject

+ (TuSDKEncodecFBOManager *)shader;

/**
 fbos
 @since v3.5.0
 */
@property (nonatomic, strong) NSMutableArray *cacheFBOs;

/** 输出尺寸 */
@property (nonatomic, assign) CGSize outputSize;

/** 渲染队列、FBO创建队列 */
@property (nonatomic) dispatch_queue_t renderQueue;

/** context */
@property (nonatomic, strong) EAGLContext *renderContext;

/** cache */
@property(nonatomic) CVOpenGLESTextureCacheRef renderCoreVideoTextureCache;

/** renderShader */
@property (nonatomic, strong) TuSDKAsyncShader *renderShader;

/**
 清空FBO, 切记，不能在渲染或者导出的过程中调用它，调用它后不能立马进行导出等操作，需要1-2s的缓冲不然会有首帧黑帧的出现
 @since v3.5.0
 */
- (void)destoryFBO;

@end


@class TuSDKAsyncEncodecBridge;
@protocol TuSDKAsyncEncodecBridgeDelegate <NSObject>

// 将渲染好的数据给到编码器
- (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer outputTime:(CMTime)frameTime;

@end

#pragma mark - 桥接器
@interface TuSDKAsyncEncodecBridge: NSObject<SLGPUImageInput>

/** 代理 */
@property (nonatomic, weak) id<TuSDKAsyncEncodecBridgeDelegate> delegate;

/** 是否异步编码 */
@property (nonatomic, assign) BOOL isAsyncEncodec;

/** 是否渲染完成 */
@property (nonatomic, assign) BOOL isRendecCompleted;

/** 渲染队列 */
@property (nonatomic, readonly) dispatch_queue_t renderQueue;

/** 异步编码队列 */
@property (nonatomic, readonly) dispatch_queue_t asyncEncodecQueue;

/// 启动编码
/// @param handler 编码完成回调
- (void)activeEncodecWithCompletionHandler:(void (^)(void))handler;

/** size */
@property (nonatomic, assign) CGSize outputSize;

/** size */
@property (nonatomic, assign) CGSize inputSize;


#pragma mark - 水印
/**
 设置水印图片
 */
@property (nonatomic, retain) UIImage *waterMarkImage;

/**
 *  裁剪区域
 */
@property(readwrite, nonatomic) CGRect cropRegion;

/**
 *  输出区域
 */
@property (nonatomic) CGRect outputRegion;

/** 输入方向 */
@property (nonatomic, assign) LSQGPUImageRotationMode inputRotation;

/** 输出方向 */
@property (nonatomic, assign) LSQGPUImageRotationMode outputRotation;

/** 水印位置 */
@property (nonatomic, assign) lsqWaterMarkPosition waterMarkPosition;

/**
  记录当前的视频方向，用来调整水印
 */
@property(nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/** 是否是裁剪视频 */
@property (nonatomic, assign) BOOL isCutVideo;


/// 查看下FBO的缓存情况，是否需要及时清理
- (void)checkCacheFBO;

@end

NS_ASSUME_NONNULL_END
