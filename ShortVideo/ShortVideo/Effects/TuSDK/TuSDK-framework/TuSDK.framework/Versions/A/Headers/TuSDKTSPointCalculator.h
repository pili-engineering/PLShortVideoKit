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


+(float) Distance:(CGPoint)start end:(CGPoint)end;
+(CGPoint) Center:(CGPoint)start end:(CGPoint)end;
+(CGPoint) Cross:(CGPoint)aStart aEnd:(CGPoint)aEnd bStart:(CGPoint)bStart bEnd:(CGPoint)bEnd;
+(CGPoint) Extension:(CGPoint)start end:(CGPoint)end percentage:(float)percentage;
+(CGPoint) Extension:(CGPoint)start end:(CGPoint)end distance:(float)distance;

+(CGPoint) Percentage:(CGPoint)start end:(CGPoint)end percentage:(float)percentage;

+(CGRect)Circle:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3; // 计算三个点所包含的圆，返回值为(centerX, centerY, radius, radius)
+(CGPoint) Rotate:(CGPoint)point center:(CGPoint)center angle:(float)angle;
+(CGPoint) Vertical:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3;

+(CGPoint) Minus:(CGPoint)p1 p2:(CGPoint)p2;
+(CGPoint) Add:(CGPoint)p1 p2:(CGPoint)p2;

+(CGPoint) Real:(CGPoint)p1 size:(CGSize)size;
+(CGPoint) Normalize:(CGPoint)p1 size:(CGSize)size;

+(float) smoothstep:(float)a b:(float)b x:(float)x;


@end
