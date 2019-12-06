//
//  TuSDKFace.h
//  TuSDKFace
//
//  Created by Clear Hu on 16/3/10.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <CoreMedia/CoreMedia.h>
#import "TuSDKFaceImport.h"

#pragma mark - TuSDKFace

/** Video版本号 */
extern NSString * const lsqFaceVersion;

#define TUSDKFACE_MAX_NUM_FACES_SUPPORT         3
#define TUSDKFACE_LANDMARK_POINTS_SUPPORT       106

static int TUSDKFACE_LANDMARK_FILP_MAP[106] =
{
    32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    42, 41, 40, 39, 38, 37, 36, 35, 34, 33,
    43, 44, 45, 46,
    51, 50, 49, 48, 47,
    61, 60,59, 58, 63, 62,55, 54, 53, 52,57, 56,
    71, 70, 69, 68, 67, 66,65, 64,
    75, 76, 77, 72, 73, 74, 79, 78,
    81, 80, 83, 82, 90, 89, 88, 87, 86, 85, 84,
    95, 94, 93, 92, 91,
    100, 99, 98, 97, 96,
    103, 102, 101, 105, 104
};

/**
 *  人脸检测
 */
@interface TuSDKFace : NSObject

// 人脸检测
+ (TuSDKFace *)shared;

/** 设置检测框最小倍数 [取值范围: 0.1 < x < 0.5, 默认: 0.2] 值越大性能越高距离越近 */
+ (void) setDetectScale: (CGFloat) scale;

/**
 *  检测人脸并识别
 *
 *  @param image 输入图片
 *
 *  @return 返回查找到的人脸
 */
+ (NSArray<TuSDKFaceAligment *> *)markFaceWithImage:(UIImage *)image;

/**
 对GPU的帧数据检测人脸并识别

 @param buffer 帧数据
 @param width 宽度
 @param height 高度
 @param radian 设备旋转弧度
 @return 返回查找到的人脸
 */
+ (NSArray<TuSDKFaceAligment *> *)markFaceGL2Buffer:(uint8_t *)buffer width:(int)width height:(int)height radian:(float)radian;

/**
 对相机采集的帧数据检测人脸并识别
 
 @param buffer 帧数据(BGRA)
 @param width 宽度
 @param height 高度
 @param ori 朝向
 @param radian 设备旋转弧度
 @param flip 是否水平翻转
 
 @return 返回查找到的人脸
 */
+ (NSArray<TuSDKFaceAligment *> *)markFaceWithBGRABuffer:(uint8_t *)buffer
                                                   width:(int)width
                                                  height:(int)height
                                                  stride:(int)stride
                                                     ori:(float)ori
                                                  radian:(float)radian
                                                    flip:(BOOL)flip;

/**
 对灰度图数据检测人脸并识别
 
 @param buffer 灰度
 @param width 宽度
 @param height 高度
 @param ori 朝向
 @param radian 设备旋转弧度
 @param flip 是否水平翻转
 
 @return 返回查找到的人脸
 */
+ (NSArray<TuSDKFaceAligment *> *)markFaceWithGrayBuffer:(uint8_t *)buffer
                                                   width:(int)width
                                                  height:(int)height
                                                  stride:(int)stride
                                                     ori:(float)ori
                                                  radian:(float)radian
                                                    flip:(BOOL)flip;
@end
