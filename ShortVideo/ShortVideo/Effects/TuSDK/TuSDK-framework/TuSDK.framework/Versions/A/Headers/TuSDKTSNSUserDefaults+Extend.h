//
//  TuSDKNSUserDefaults+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/19.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据共享扩展
 */
@interface NSUserDefaults(TuSDKNSUserDefaultsExtend)

/**
 *  保存共享缓存
 *
 *  @param key   缓存键
 *  @param value 缓存值 如果为空将删除缓存
 */
+ (void)lsqSaveKey:(NSString *)key value:(id)value;

/**
 *  加载缓存数据
 *
 *  @param key 缓存键
 *
 *  @return 缓存数据
 */
+ (id)lsqLoadForKey:(NSString *)key;
@end
