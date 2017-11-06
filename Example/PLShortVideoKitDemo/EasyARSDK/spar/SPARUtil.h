//
//  SPARUtil.h
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//  文件操作的工具类

#import <Foundation/Foundation.h>

@interface SPARUtil : NSObject

+ (NSString *)getSupportDirectory;
+ (NSError *)ensureDirectory:(NSString *)path;
+ (bool)pathExists:(NSString *)path;
+ (void)deleteQuietly:(NSString *)path;
+ (NSString *)addQueryParam:(NSDictionary *)params toURL:(NSString *)endPoint;

+ (NSDictionary *)jsonFromFile:(NSString *)fileName;
+ (NSDictionary *)jsonFromString:(NSString *)jsonStr;

+ (NSString *)stringFromJson:(NSDictionary *)dict;
+ (void)writeToFile:(NSString *)fileName fromJson:(NSDictionary *)dict;

@end
