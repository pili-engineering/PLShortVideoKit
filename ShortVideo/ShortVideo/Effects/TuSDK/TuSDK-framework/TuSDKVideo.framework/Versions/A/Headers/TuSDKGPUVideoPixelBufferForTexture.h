//
//  TuSDKGPUVideoPixelBufferForTexture.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMediaAssetInfo.h"
#import "TuSDKAssetVideoDecoder.h"
#import "TuSDKTextureCoordinateCropBuilder.h"

/**
 PixelBuffer 上传到 GPU
 @since 3.0
 */
@interface TuSDKGPUVideoPixelBufferForTexture : SLGPUImageOutput <TuSDKSampleBufferInput>
{
    CGSize _outputSize;
}

/**
 输入的画面方向
 @since 3.0
 */
@property (nonatomic) LSQGPUImageRotationMode inputRotation;

/**
 输出的画面方向
 @since 3.0
 */
@property (nonatomic) LSQGPUImageRotationMode outputRotation;

/**
 * 输入的采样数据类型
 * 支持： kCVPixelFormatType_420YpCbCr8BiPlanarFullRange | kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32BGRA
 *  @since 3.0
 */
@property (nonatomic) OSType inputPixelFormatType;

/**
 输入的视频宽高
 @since 3.0
 */
@property (nonatomic,readonly) CGSize inputSize;

/**
 设置输出 outputSize, 如果输出比例和原视频比例不一致时，自动缩放视频大小，视频不会被裁剪
 @since 3.4.2
 */
@property (nonatomic)CGSize outputSize;

/**
 设置比例不一致时是否自适应画布
 比例不一致时是否将视频自适应画布大小 默认：NO
 @since 3.4.2
 */
@property (nonatomic)BOOL aspectOutputRatioInSideCanvas;

/**
 设置画面显示区域 默认：（CGRectMake(0,0,1,1) 完整画面） aspectOutputRatioInSideCanvas
 aspectOutputRatioInSideCanvas 为 NO 时可用
 @since 3.4.2
 */
@property (nonatomic) CGRect textureRect;

@end
