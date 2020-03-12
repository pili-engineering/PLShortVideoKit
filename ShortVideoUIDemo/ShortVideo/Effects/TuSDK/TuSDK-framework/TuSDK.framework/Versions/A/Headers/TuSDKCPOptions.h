//
//  TuSDKCPOptions.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/6.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  组件选项
 */
@interface TuSDKCPOptions : NSObject

/**
 *  控制器类
 */
@property (nonatomic, strong) Class componentClazz;

/**
 *  组件选项
 *
 *  @return build 组件选项
 */
+ (instancetype)build;

/**
 *  初始化选项
 */
- (void)initOptions;

/**
 *  默认控制器类 (需要实现具体返回类对象)
 *
 *  @return defaultComponentClazz 默认控制器类
 */
-(Class)defaultComponentClazz;

/**
 *  组件实例
 *
 *  @return componentInstance 组件实例
 */
- (id)componentInstance;
@end
