//
//  PLSVersionInfo.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2019/2/12.
//  Copyright © 2019年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class PLSVersionInfo
 @brief SDK 版本信息获取
 */
@interface PLSVersionInfo : NSObject

/*!
 @method versionInfo
 @brief 获取 SDK 版本信息，包含主版本号和 git 版本号
 
 @return 返回版本信息
 */
+ (NSString *__nonnull)versionInfo;

@end
