//
//  PLShortVideoKitEnv.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/27.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSTypeDefines.h"

@interface PLShortVideoKitEnv : NSObject

/**
 @brief 初始化 StreamingSession 的运行环境，需要在 -application:didFinishLaunchingWithOptions: 方法下调用该方法，
 
 @warning 不调用该方法将导致 PLShortVideoKitEnv 对象无法初始化
 */
+(void)initEnv;

/**
 @brief 判断当前环境是否已经初始化
 
 @return 已初始化返回 YES，否则为 NO
 */
+(BOOL)isInited;

/*!
 @method     enableFileLogging
 @abstract   开启SDK内部写文件日志功能，以方便SDK支持团队定位您所遇到的问题。
 
 @note       日志文件存放位置为 App Container/Library/Caches/Pili-ShortVideo/Logs
 */
+ (void)enableFileLogging;

/*!
 @method     setLogLevel:
 @abstract   设置SDK内部输出日志的级别，默认为 PLShortVideoLogLevelWarning 级别。
 该方法设置的输出级别会分别同步到控制台与文件日志中。
 
 @warning    请确保不要在线上产品开启 PLShortVideoLogLevelVerbose 级别输出，这将影响产品性能。
 */
+ (void)setLogLevel:(PLShortVideoLogLevel)logLevel;

+ (NSString *)deviceID;

+ (void)setDeviceID:(NSString *)deviceID;

@end
