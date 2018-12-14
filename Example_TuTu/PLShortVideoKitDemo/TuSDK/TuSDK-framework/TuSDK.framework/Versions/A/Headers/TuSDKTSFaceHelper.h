//
//  TuSDKTSFaceHelper.h
//  TuSDK
//
//  Created by Clear Hu on 15/12/24.
//  Copyright © 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "SLGPUImage.h"

#pragma mark - TuSDKTSFaceFeature
/**
 *  人像信息 (百分比)
 */
@interface TuSDKTSFaceFeature : NSObject
@property (nonatomic) CGRect bounds;
@property (nonatomic) BOOL hasLeftEyePosition;
@property (nonatomic) CGPoint leftEyePosition;
@property (nonatomic) BOOL hasRightEyePosition;
@property (nonatomic) CGPoint rightEyePosition;
@property (nonatomic) BOOL hasMouthPosition;
@property (nonatomic) CGPoint mouthPosition;

@property (nonatomic) BOOL hasTrackingID;
@property (nonatomic) int trackingID;
@property (nonatomic) BOOL hasTrackingFrameCount;
@property (nonatomic) int trackingFrameCount;

@property (nonatomic) BOOL hasFaceAngle;
/*rollAngle*/
@property (nonatomic) float faceAngle;

@property (nonatomic) BOOL hasFaceYawAngle;
@property (nonatomic) float faceYawAngle;

@property (nonatomic) BOOL hasSmile;
@property (nonatomic) BOOL leftEyeClosed;
@property (nonatomic) BOOL rightEyeClosed;
@property (nonatomic) CMTime timestamp;
@end
#pragma mark - TuSDKTSFaceHelper
/**
 *  人像帮助类
 */
@interface TuSDKTSFaceHelper : NSObject
/**
 *  获取输出图像方向选项
 *
 *  @param position 相机位置
 *  @param orien 设备方向
 *
 *  @return 输出图像方向选项
 */
+ (NSDictionary *) featuresImageOptionsWithDevicePosition:(AVCaptureDevicePosition)position orien:(UIDeviceOrientation)orien;

/**
 *  获取人像百分比信息
 *
 *  @param faces    脸部信息
 *  @param rect     图像区域
 *  @param rotation 旋转方向
 *
 *  @return 人像百分比信息
 */
+ (NSArray<TuSDKTSFaceFeature *> *) transforFaces:(NSArray<CIFaceFeature*> *)faces
                                             rect:(CGRect)rect
                                         rotation:(LSQGPUImageRotationMode)rotation;

/**
 *  获取人像百分比信息
 *
 *  @param faces    脸部信息
 *  @param rotation 旋转方向
 *
 *  @return 人像百分比信息
 */
+ (NSArray<TuSDKTSFaceFeature *> *) transforAVFaces:(NSArray<AVMetadataFaceObject *> *)faces
                                           rotation:(LSQGPUImageRotationMode)rotation;

/**
 *  转换方向模式
 *
 *  @param rotation GPUImage方向
 *
 *  @return 图像方向
 */
+ (UIImageOrientation)convertGPURotation:(LSQGPUImageRotationMode)rotation;

/**
 Get real orientation without mirror
 
 @param rotation
 @return
 */
+ (int)getOriByGPURotation:(LSQGPUImageRotationMode)rotation;
@end
