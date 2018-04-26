//
//  TuSDKTSNSArray+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/7.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数组帮助类
 */
@interface NSArray(TuSDKTSNSArrayExtend)
/**
 *  分割数组分组
 *
 *  @param groupSize 分组大小
 *
 *  @return 返回分组数组
 */
- (NSArray *)lsqSplitForGroupsize:(NSUInteger)groupSize;

/**
 *  数组元素顺序反转
 *
 *  @return 倒序的数组
 */
- (NSArray *)lsqReverse;

@end
