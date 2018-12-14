//
//  TuSDKTSMath.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/12.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - TuSDKTSMath
/**
 *  算法扩展
 */
@interface TuSDKTSMath : NSObject
/**
 *  角度转换为弧度
 *  在求sin ,cos 以及别的三角函数的时候,传入的参数是弧度值,所以需要把角度转换为弧度后再计算
 *
 *  @param degrees 角度
 *
 *  @return 弧度
 */
+ (CGFloat)radianFromDegrees:(CGFloat)degrees;

/**
 *  弧度转换为角度
 *
 *  @param radian 弧度
 *
 *  @return 角度
 */
+ (CGFloat)degreesFromRadian:(CGFloat)radian;

/**
 *  浮点数取模
 *
 *  @param numberFloat 浮点数
 *  @param modulus     模
 *
 *  @return 浮点数取模
 */
+ (CGFloat)numberFloat:(CGFloat)numberFloat modulus:(NSInteger)modulus;

/**
 * 计算两个点之间的距离
 *
 * @param endPoint
 *            结束点
 * @param startPoint
 *            开始点
 * @return distanceOfEndPoint
 */
+ (CGFloat)distanceOfEndPoint:(CGPoint)ePoint startPoint:(CGPoint)sPoint;

/**
 * 计算两个点之间的距离
 *
 * @param x1
 * @param y1
 * @param x2
 * @param y2
 * @return distanceOfPoint
 */
+ (CGFloat)distanceOfPointX1:(CGFloat)x1 y1:(CGFloat)y1 pointX2:(CGFloat)x2 y2:(CGFloat)y2;

/**
 *  计算与中心点的角度
 *
 *  @param point 当前点
 *  @param center 中心点
 *
 *  @return 与中心点的角度
 */
+ (CGFloat)degreesWithPoint:(CGPoint)point center:(CGPoint)center;

/**
 * 围绕原点旋转
 *
 * @param point
 *            坐标点
 * @param degree
 *            旋转角度
 * @return
 */
+ (CGPoint)rotationPoint:(CGPoint)point toDegree:(CGFloat)degree;

/**
 *  计算旋转后的最小外接矩形坐标
 *
 *  @param cPoint 中心点坐标
 *  @param size   缩放后的大小
 *  @param degree 旋转角度
 *
 *  @return 旋转后的最小外接矩形坐标
 */
+ (CGRect)minEnclosingRectangle:(CGPoint)cPoint size:(CGSize)size degree:(CGFloat)degree;
@end
