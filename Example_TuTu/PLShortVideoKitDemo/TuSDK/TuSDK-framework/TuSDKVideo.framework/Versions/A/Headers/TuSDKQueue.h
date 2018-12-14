//
//  TuSDKQueue.h
//  TuSDKVideo
//
//  Created by sprint on 13/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  数据队列
  @since      v3.0
 */
@interface TuSDKQueue : NSObject

/**
 初始化队列

 @param capacity 队列容量
 @return 队列实例
 @since      v3.0
 */
-(instancetype)initWithCapacity:(CFIndex)capacity;

/**
 取出首元素 并从队列中删除
 
 @return 返回首元素
 @since      v3.0
 */
- (const void*)poll;

/**
 取出首元素
 
 @return 返回首元素
 @since      v3.0
 */
- (const void*)peek;

/**
 获取最后一个元素

 @return 返回尾元素
 @since      v3.0
 */
- (const void*)last;

/**
 将数据放入队尾
 
 @param value 数据
 @since      v3.0
 */
- (void)put:(const void*)value;

/**
 将一个数组的元素依次放入队尾
 
 @param array 数组对象
 @since      v3.0
 */
- (void)putArray:(CFArrayRef)array;

/**
 获取队列size

 @return 队列数量
 @since      v3.0
 */
- (CFIndex)size;

/**
 当前队里是否有数据

 @return true/false
 @since      v3.0
 */
- (BOOL)isEmpty;

/**
 清空数据
 @since      v3.0
 */
- (void)clear;

@end
