//
//  TuSDKTextureCoordinateCropBuilder.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "TuSDKVideoImport.h"

#import "TuSDKVerticeCoordinateBuilder.h"

typedef struct
{
    /** 对齐倍数 */
    NSUInteger multiple;
    /** 是否取最接近的最大值 */
    BOOL max;
    /** 是否取最接近值 */
    BOOL near;
    
} TuSDKTextureSizeAlign;

/** 使用2的倍数最小值 eg: 529->528 */
const static TuSDKTextureSizeAlign Align2MultipleMin = {2, NO, NO};
/** 使用4的倍数最小值 eg: 529->528 or 531->528 or 530->528 */
const static  TuSDKTextureSizeAlign Align4MultipleMin = {4, NO, NO};
/** 使用8的倍数最小值 eg: 529->528 or 535->528 or 532->528 */
const static  TuSDKTextureSizeAlign Align8MultipleMin = {8, NO, NO};
/** 使用16的倍数最小值 eg: 529->528 or 543->528 or 536->528 */
const static  TuSDKTextureSizeAlign Align16MultipleMin = {16, NO, NO};


/** 使用2的倍数最大值 eg: 529->530 */
const static  TuSDKTextureSizeAlign Align2MultipleMax = {2, true, NO};
/** 使用4的倍数最大值 eg: 529->532 or 531->532 or 530->532 */
const static  TuSDKTextureSizeAlign Align4MultipleMax = {4, true, NO};
/** 使用8的倍数最大值 eg: 529->536 or 535->536 or 532->536 */
const static  TuSDKTextureSizeAlign Align8MultipleMax = {6, true, NO};
/** 使用16的倍数最大值 eg: 529->544 or 543->544 or 536->544 */
const static  TuSDKTextureSizeAlign Align16MultipleMax = {8, true, NO};


/** 使用4的倍数最接近值，如果为中间值取最小值 eg: 529->528 or 531->532 or 530->528 */
const static  TuSDKTextureSizeAlign Align4MultipleNearOrMin = {4, NO, YES};
/** 使用8的倍数最接近值，如果为中间值取最小值 eg: 529->528 or 535->536 or 532->528 */
const static  TuSDKTextureSizeAlign Align8MultipleNearOrMin = {8, NO, YES};
 /** 使用16的倍数最接近值，如果为中间值取最小值 eg: 529->528 or 543->544 or 536->528 */
const static  TuSDKTextureSizeAlign Align16MultipleNearOrMin = {16, NO, YES};

/** 使用4的倍数最接近值，如果为中间值取最大值 eg: 529->528 or 531->532 or 530->532 */
const static  TuSDKTextureSizeAlign Align4MultipleNearOrMax = {4, YES, YES};
/** 使用8的倍数最接近值，如果为中间值取最大值 eg: 529->528 or 535->536 or 530->536 */
const static  TuSDKTextureSizeAlign Align8MultipleNearOrMax = {8, YES, YES};
/** 使用16的倍数最接近值，如果为中间值取最大值 eg: 529->528 or 543->544 or 530->544 */
const static  TuSDKTextureSizeAlign Align16MultipleNearOrMax = {16, YES, YES};


/***
 * 对齐数据
 * @param side 边长
 * @return 对齐数据
 */
static NSUInteger align2(NSUInteger side,TuSDKTextureSizeAlign align)
{
    // 小于倍数不处理
    if (side < align.multiple) return side;
    
    NSUInteger minSide = side - side % align.multiple;
    // 等于倍数不处理
    if (side == minSide) return side;
    
    NSUInteger maxSide = minSide + align.multiple;
    NSUInteger result = align.max ? maxSide : minSide;
    
    // 返回倍数的最大或最小值
    if (!align.near) return result;
    
    // 计算最接近数
    NSUInteger minReduce = ABS(side - minSide);
    NSUInteger maxReduce = ABS(side - maxSide);
    
    // 中间数返回指定最大或最小值
    if (minReduce == maxReduce) return result;
    // 接近最大值
    else if (minReduce > maxReduce) return maxSide;
    return minSide;
}

/***
 * 对齐数据
 * @param size 长宽
 * @return 对齐数据
 */
 static CGSize align(CGSize size,TuSDKTextureSizeAlign align)
{
    if (MIN(size.width,size.height) < align.multiple) return size;
    
    return CGSizeMake(align2(size.width,align), align2(size.height,align));
}

@interface TuSDKTextureCoordinateCropBuilder : NSObject <TuSDKVerticeCoordinateBuilder>

@end
