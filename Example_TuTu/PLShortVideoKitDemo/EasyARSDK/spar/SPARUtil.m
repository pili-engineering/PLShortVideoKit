//
//  SPARUtil.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//  

#import "SPARUtil.h"

@implementation SPARUtil

/**
 返回用户的 Support 路径
 
 @return 用户的 Support 的全路径
 */
+ (NSString *)getSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSLog(@"--whj@_@----supportPath:%@--",paths.firstObject);
    return [paths firstObject];
}

/**
 创建一个目录
 
 @param path - 路径
 @return 错误信息，若无错误，错误信息为空
 */
+ (NSError *)ensureDirectory:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    return error;
}

/**
 判断目录是否存在
 
 @param path - 目录路径
 @return Yes:已存在；No:不存在
 */
+ (bool)pathExists:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

/**
 删除文件
 
 @param path - 要移除文件的路径
 */
+ (void)deleteQuietly:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}


/**
 对含有中文的URL进行转码
 
 @param object - 要转码的url
 @return 转码后的url字符串
 */
+ (NSString *)urlEncode:(id)object {
    NSString *str = [NSString stringWithFormat:@"%@", object];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 拼接URL，将请求参数添加到 url 的后面用&连接起来，
 
 @param params - 请求参数
 @param endPoint - url
 @return 含有请求参数的URL字符串
 */
+ (NSString *)addQueryParam:(NSDictionary *)params toURL:(NSString *)endPoint {
    NSURLComponents *components = [NSURLComponents componentsWithString:endPoint];
    NSMutableArray *queryItems = [NSMutableArray new];
    for (NSString *key in params) {
        NSString *part = [NSString stringWithFormat:@"%@=%@",
                          [SPARUtil urlEncode:key], [SPARUtil urlEncode:params[key]]];
        [queryItems addObject:part];
    }
    NSString *queryString = [queryItems componentsJoinedByString:@"&"];
    components.query = queryString;
    NSURL *url = components.URL;
    return [url absoluteString];
}

/**
 将二进制数据转化成JSON字典
 
 @param jsonData -二进制数据
 @return json字典
 */
+ (NSDictionary *)jsonFromData:(NSData *)jsonData {
    if (!jsonData) return nil;

    NSError *error;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

/**
 将本地文件转化成字典
 
 @param fileName - 本地文件路径
 @return json字典
 */
+ (NSDictionary *)jsonFromFile:(NSString *)fileName {
    NSData *jsonData = [NSData dataWithContentsOfFile:fileName];
    return [SPARUtil jsonFromData:jsonData];
}


/**
 将json字符串转化成JSON字典
 
 @param jsonStr - json字符串
 @return json字典
 */
+ (NSDictionary *)jsonFromString:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [SPARUtil jsonFromData:jsonData];
}

/**
 将JSON字典转化成二进制数据
 
 @param dict - json字典
 @return 二进制数据
 */
+ (NSData *)dataFromJson:(NSDictionary *)dict {
    NSError *error;
    NSData *res = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

/**
 将JSON字典转化成JSON字符串
 
 @param dict -JSON字典
 @return JSON字符串
 */
+ (NSString *)stringFromJson:(NSDictionary *)dict {
    NSData *data = [SPARUtil dataFromJson:dict];
    if (!data) return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 将JSON字典写入到本地路径
 
 @param fileName - 文件路径
 @param dict - JSON字典
 */
+ (void)writeToFile:(NSString *)fileName fromJson:(NSDictionary *)dict {
    NSData *data = [SPARUtil dataFromJson:dict];
    if (!data) return;
    [data writeToFile:fileName atomically:YES];
}

@end
