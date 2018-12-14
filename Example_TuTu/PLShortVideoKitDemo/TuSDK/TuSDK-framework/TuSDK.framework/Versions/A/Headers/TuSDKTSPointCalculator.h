//
//  PointCalc.h
//  TuSDK
//
//  Created by tutu on 2018/8/20.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PointCalc : NSObject

/**
 * 求两点距离
 */
+(float) distance:(CGPoint)start end:(CGPoint)end;

/**
 * 求两点中心点
 */
+(CGPoint) center:(CGPoint)start end:(CGPoint)end;

/**
 * 求相交点
 */
+(CGPoint)crossPoint:(CGPoint) aStart aEnd:(CGPoint)aEnd bStart:(CGPoint)bStart bEnd:(CGPoint) bEnd;

+ (float) calcVectorProduct:(CGPoint)P1 P2:(CGPoint)P2 P3:(CGPoint)P3 P4:(CGPoint)P4;
/**
 * 求延长点
 */
+(CGPoint) increase:(CGPoint)start end:(CGPoint)end distance:(float)distance;

/**
 * 求两点距离百分比延长点
 */
+(CGPoint)increasePercentage:(CGPoint)start end:(CGPoint)end percentage:(float)percentage;

/**
 * 求两点间距离开始点
 */
+(CGPoint) pointOf:(CGPoint)start end:(CGPoint)end dis:(float)dis;

/**
 * 求两点间距离开始点
 */
+(CGPoint) pointOfPercentage:(CGPoint)start end:(CGPoint) end  percentage:(float) percentage ;

/**
 * 求三点相交点延长点
 *
 * @param start        开始点
 * @param end          结束点
 * @param center       圆心点
 * @param s2eDisPercen 开始点到结束点距离百分比
 * @param newDis       延长点与圆心点距离
 * @return 相交点延长点
 */
+(CGPoint) crossPoint:(CGPoint)start end:(CGPoint)end center:(CGPoint)center  s2eDisPercen:(float)s2eDisPercen newDis:(float)newDis;


/**
 * 求垂直交点
 *
 * @param start 开始点
 * @param end   结束点
 * @param third 交点线
 * @return 垂直交点
 */
+(CGPoint)crossPoint:(CGPoint)start end:(CGPoint)end third:(CGPoint)third;

/**
 * 以中心点缩放
 *
 * @param points 输入点
 * @param center 中心点
 * @param scale  缩放比例
 */
+(void) scalePoint:(CGPoint*) points size:(int)size center:(CGPoint)center scale:(float)scale ;

+(void) disPoints:(CGPoint*)ps size:(int)size center:(CGPoint)center dis:(float) dis;




/**
 * 计算瘦脸
 *
 * @param center 中心点
 * @param points 输入点
 * @param indexs 索引列表
 * @param scale  缩放比例
 */
+(void) scaleChinPoint:(CGPoint*)points indexs:(int*)indexs center:(CGPoint)center scale:(float)scale ;
/**
 * 计算瘦脸
 *
 * @param center 中心点
 * @param points 输入点
 * @param indexs 索引列表
 * @param scale  缩放比例
 */
+(void) scaleChinPoint2:(CGPoint*)points indexs:(int*)indexs idxSize:(int)size center:(CGPoint)center scale:(float) scale;

/**
 * 计算大眼
 *
 * @param center 中心点
 * @param points 输入点
 * @param scale  缩放比例
 */
+(void) scaleEyeEnlargePoint:(CGPoint*)points center:(CGPoint)center scale:(float) scale;


/**
 * 整体移动点
 */
+(void) movePoints:(CGPoint*)points size:(int)size center:(CGPoint)center scale:(float) scale;
/**
 * 移动眉毛 根据眼睛中心外扩
 */
+(void) moveEyeBrow:(CGPoint*)points size:(int)size center:(CGPoint)center scale:(float)scale;

/**
 * 计算眉弓
 */
+(void) calcArchEyebrow:(CGPoint*)points center:(CGPoint) center scale:(float) scale ;

/**
 * 求平滑数
 */
+(float) smoothstep:(float)a b:(float)b x:(float)x;

/**
 * cot 等于临边比对边
 * cot 90°=0
 * x3=（x1cotA2+x2cotA1+y2-y1）/（cotA1+cotA2）
 * y3=（y1cotA2+y2cotA1+x1-x2）/（cotA1+cotA2）
 */
+(void)rotatePoints:(CGPoint*)points size:(int)size center:(CGPoint)center value:(float)value;

/**
 * 细眉
 */
+(void)scaleJaw:(CGPoint*)points center:(CGPoint)center  scale:(float)scale;
@end
