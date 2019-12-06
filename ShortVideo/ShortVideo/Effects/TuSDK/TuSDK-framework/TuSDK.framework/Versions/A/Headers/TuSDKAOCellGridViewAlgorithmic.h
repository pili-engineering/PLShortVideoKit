//
//  TuSDKAOCellGridViewAlgorithmic.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/2.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  网格视图算法
 */
@interface TuSDKAOCellGridViewAlgorithmic : NSObject
/**
 *  网格宽高
 */
@property (nonatomic, readonly) CGFloat size;

/**
 *  网格间距
 */
@property (nonatomic, readonly) CGFloat space;

/**
 *  起始网格左边距
 */
@property (nonatomic, readonly) CGFloat spaceStart;

/**
 *  网格数量
 */
@property (nonatomic, readonly) NSUInteger count;

/**
 *  创建网格视图算法
 *
 *  @param width  视图宽度
 *  @param size   期望的宽高
 *  @param space  期望的间距
 *
 *  @return self 网格视图算法
 */
+ (instancetype)initWithViewWidth:(CGFloat)width desireSize:(CGFloat)size space:(CGFloat)space;
@end
