//
//  TuSDKSkinFilterAPI.h
//  TuSDK
//
//  Created by wen on 06/06/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  TuSDKSkinFilterAPI Face Mark Result type
 */
typedef NS_ENUM(NSInteger, lsqSkinFilterFaceMarkResultType)
{
    /**
     * Succeed
     */
    lsqSkinFilterFaceMarkResultTypeSucceed,
    /**
     * Failed
     */
    lsqSkinFilterFaceMarkResultTypeFailed,
    
    /**
     * Failed : Multiple faces detected
     */
    lsqSkinFilterFaceMarkResultTypeFailedMultipleFacesDetected,
    
    /**
     * No face is detected
     */
    lsqSkinFilterFaceMarkResultTypeNoFaceDetected,
};

/**
 * lsqSkinFilterResultCompleteHandler
 */
typedef void(^lsqSkinFilterFaceMarkBlock)(lsqSkinFilterFaceMarkResultType);


@interface TuSDKSkinFilterAPI : NSObject

/**
 *  创建美颜滤镜 可调节参数：一键美颜、磨皮、美白、肤色、大眼、瘦脸
 */
+ (instancetype _Nonnull ) initSkinFilterWrap;


/**
 更改美颜中的参数值 非美颜滤镜次方法的调节不生效
 
 @param smoothing 润滑 0~1
 @param whitening 白皙 0~1
 @param skinColor 肤色 0~1  肤色0.5为正常原图色
 */
- (void)submitSkinFilterParameterWithSmoothing:(CGFloat)smoothing whitening:(CGFloat)whitening skinColor:(CGFloat)skinColor;

/**
 更改美颜中的参数值 非美颜滤镜次方法的调节不生效
 
 @param originImage 图片对象 请注意该对象用于
 @param smoothing 润滑 0~1
 @param whitening 白皙 0~1
 @param skinColor 肤色 0~1  肤色0.5为正常原图色
 @param eyeSize 大眼 0~1
 @param chinSize 瘦脸 0~1
 @param completeHandler 完成大脸瘦眼后的回调
 */
- (void)submitSkinFilterParameterWithImage:(nullable UIImage *)originImage smoothing:(CGFloat)smoothing whitening:(CGFloat)whitening skinColor:(CGFloat)skinColor eyeSize:(CGFloat)eyeSize chinSize:(CGFloat)chinSize faceMarkResultHandler:(lsqSkinFilterFaceMarkBlock _Nullable ) completeHandler;

/**
 更改美颜中的参数值 非美颜滤镜次方法的调节不生效
 
 @param smoothing 润滑 0~1
 @param whitening 白皙 0~1
 @param skinColor 肤色 0~1  肤色0.5为正常原图色
 @param eyeSize 大眼 0~1
 @param chinSize 瘦脸 0~1
 @param completeHandler 完成大脸瘦眼后的回调
 */
- (void)submitSkinFilterParameterWithSmoothing:(CGFloat)smoothing whitening:(CGFloat)whitening skinColor:(CGFloat)skinColor eyeSize:(CGFloat)eyeSize chinSize:(CGFloat)chinSize;

/**
 *  执行滤镜 并输出图形
 *
 *  @param image 输入图像
 *
 *  @return image 滤镜处理过的图像 (默认使用图像自身的方向属性)
 */
- (nullable UIImage *)processWithImage:(nullable UIImage *)image;

/**
 *  执行滤镜 并输出图形
 *
 *  @param image            输入图像
 *  @param imageOrientation 图像方向
 *
 *  @return image 滤镜处理过的图像
 */
- (nullable UIImage *)processWithImage:(nullable UIImage *)image orientation:(UIImageOrientation)imageOrientation;

/**
 取消处理
 */
- (void)cancelProcess;

/**
 *  销毁
 */
- (void)destroy;

@end
