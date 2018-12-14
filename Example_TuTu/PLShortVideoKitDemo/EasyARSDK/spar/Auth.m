//
//  Auth.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//  

#import "Auth.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Auth

static NSString *kDate = @"date";
static NSString *kAppKey = @"appKey";
static NSString *kSignature = @"signature";


/**
 SHA1加密
 
 @param str - 要加密的字符串
 @return 加密之后的字符串
 */
+ (NSString *)sha1Hex:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *res = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [res appendFormat:@"%02x", digest[i]];
    }
    return res;
}


/**
 加密，对字典里的元素和secret加密
 
 @param param - 字典，存放需要加密的信息，如时间戳、APPKey
 @param secret - 秘钥
 @return 经过SHA算法加密之后的字符串
 */
+ (NSString *)generateSignature:(NSDictionary *)param withSecret:(NSString *)secret {
    NSArray *keys = [[param allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *paramStr = [NSMutableString new];
    for (NSString *key in keys) {
        [paramStr appendString:key];
        [paramStr appendString:[param objectForKey:key]];
    }
    [paramStr appendString:secret];
    return [Auth sha1Hex:paramStr];
}


/**
 返回一个字典，其中键kDate对应时间，kAppKey对应APPKey，kSignature对应是时间、APPkey和secert加密之后的的字符串

 @param param - 参数字典
 @param key - APPKey
 @param secret - secret
 @return 处理之后的字典
 */
+ (NSDictionary *)signParam:(NSDictionary *)param withKey:(NSString *)key andSecret:(NSString *)secret {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:param];
    NSDateFormatter *df = [NSDateFormatter new];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    [res setObject:dateStr forKey:kDate];
    [res setObject:key forKey:kAppKey];
    [res setObject:[Auth generateSignature:res withSecret:secret] forKey:kSignature];
    return res;
}

@end
