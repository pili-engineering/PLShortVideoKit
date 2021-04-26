//
//  PLSLog.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/27.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSDDLogMacros.h"
#import "PLSDDTTYLogger.h"
#import "PLSDDFileLogger.h"
#import "PLSTypeDefines.h"

/*!
 @brief PLShortVideoKit SDK 的日志级别
*/
extern PLSDDLogLevel plShortVideoDDLogLevel;

// Level Error
#define PLSLogError(...) PLSDDLogError(__VA_ARGS__)
// Level Warning
#define PLSLogWarn(...) PLSDDLogWarn(__VA_ARGS__)
// Level Info
#define PLSLogInfo(...) PLSDDLogInfo(__VA_ARGS__)
// Level Debug
#define PLSLogDebug(...) PLSDDLogDebug(__VA_ARGS__)
// Level Verbose
#define PLSLogVerbose(...) PLSDDLogVerbose(__VA_ARGS__)

// Level Error
#define PLSLogE(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, PLSDDLogFlagError, 0, PLSLogTag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
// Level Warning
#define PLSLogW(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, PLSDDLogFlagWarning, 0, PLSLogTag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
// Level Info
#define PLSLogI(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, PLSDDLogFlagInfo, 0, PLSLogTag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
// Level Debug
#define PLSLogD(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, PLSDDLogFlagDebug, 0, PLSLogTag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
// Level Verbose
#define PLSLogV(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, PLSDDLogFlagVerbose, 0, PLSLogTag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#if DEBUG
#define PLSLog(...)   PLSLogD(__VA_ARGS__)
#else
#define PLSLog(...)   PLSLogI(__VA_ARGS__)
#endif

/*!
 @brief 日志管理类
 */
@interface PLSLogger : NSObject

/*!
 @method   enableFileLogger
 @abstract 开启日志写入文件功能，默认写入级别为PLShortVideoLogLevelWarning及以上
 
 @note     日志文件存放位置为 App Container/Library/Caches/Pili-ShortVideo/Logs
 */
+ (void)enableFileLogger;

/*!
 @method     setLogLevel:
 @abstract   设置SDK内部输出日志的级别，默认为PLShortVideoLogLevelWarning级别。
 该方法设置的输出级别会分别同步到控制台与文件日志中。
 
 @warning    PLShortVideoLogLevelVerbose级别输出将极大影响产品性能。
 */
+ (void)setLogLevel:(PLShortVideoLogLevel)logLevel;

@end
