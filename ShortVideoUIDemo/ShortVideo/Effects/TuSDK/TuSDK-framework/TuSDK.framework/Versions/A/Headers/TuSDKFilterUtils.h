//
//  TuSDKFilterUtils.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/27.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTSBundle.h"

/**
 *  滤镜帮助类
 */
@interface TuSDKFilterUtils : NSObject

/**
 *  获取材质
 *
 *  @param name 材质名称
 *
 *  @return image 获取材质
 */
+ (UIImage *)textureBundleWithName:(NSString *)name;
@end
