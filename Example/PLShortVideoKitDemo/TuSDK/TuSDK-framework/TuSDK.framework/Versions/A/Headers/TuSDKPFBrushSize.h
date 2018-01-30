//
//  TuSDKPFBrushSize.h
//  TuSDK
//
//  Created by Yanlin on 11/9/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  笔刷旋转类型
 */
typedef NS_ENUM(NSInteger, lsqBrushSize)
{
    /**
     * 小
     */
    lsqSmallBrush = 1,
    /**
     * 中
     */
    lsqMediumBrush,
    /**
     * 大
     */
    lsqLargeBrush,
};


@interface TuSDKPFBrushSize : NSObject

/**
 *  下一个可用的笔刷尺寸
 *
 *  @param currentSize 当前尺寸
 *
 *  @return 笔刷尺寸
 */
+ (lsqBrushSize) nextBrushSize:(lsqBrushSize) currentSize;

/**
 *  尺寸对应的名称
 *
 *  @param size 尺寸
 *
 *  @return 名称
 */
+ (NSString *) nameForSize:(lsqBrushSize)size;

@end
