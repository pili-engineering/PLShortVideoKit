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

 @param width 宽度
 @param height 高度
 @param radian 设备旋转弧度
 @return 返回查找到的人脸
 */
+ (NSArray<TuSDKFaceAligment *> *)markFaceGL2WithWidth:(int)width height:(int)height radian:(float)radian;

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
