//
//  TuSDKTSString+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 14/12/15.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  字符串帮助类
 */
@interface NSString (TuSDKTSStringExtend)

/**
 *  获取本地化字符串
 *
 *  @param key 键名
 *
 *  @return 本地化字符串
 */
+ (NSString*)lsqLocalizedString:(NSString*)key;

/**
 *  base64编码
 *
 *  @param str 输入字符串
 *
 *  @return base64编码
 */
+ (NSString*)lsqBase64encode:(NSString*)str;

/**
 *  base64编码
 *
 *  @return base64编码
 */
- (NSString*)lsqBase64encode;

/**
 *  判断字符串是否为空
 *
 *  @param str 输入字符串
 *
 *  @return 判断字符串是否为空
 */
+(Boolean) lsqIsEmptyOrNull:(NSString *) str;

/**
 *  UUID
 *
 *  @return UUID
 */
+ (NSString*)lsqUUID;

/**
 *  返回对应容量单位数
 *
 *  @param byte 字节总数
 *
 *  @return 对应容量单位数
 */
+ (NSString *)lsqStringForByte:(unsigned long long)byte;

/**
 *  返回 OSType 对应的4位字符串
 *
 *  @param type OSType
 *
 *  @return 对应的字符串
 */
+ (NSString *)lsqStringFromOSType:(OSType)type;

/**
 *  编码URL
 *
 *  @return 编码URL
 */
- (NSString*)lsqEncodeAsURIComponent;

/**
 *  编码HTML
 *
 *  @return 编码HTML
 */
- (NSString*)lsqEscapeHTML;

/**
 *  解码HTML
 *
 *  @return 解码HTML
 */
- (NSString*)lsqUnescapeHTML;

/**
 *  MD5编码
 *
 *  @return MD5编码
 */
- (NSString *) lsqMd5;

/**
 *  添加字符串省略号
 *
 *  @param length 输出的字符串长度
 *
 *  @return 添加字符串省略号
 */
- (NSString*)lsqSubstringLinefeed:(NSUInteger)length;

/**
 *  删除字符串头尾空格
 *
 *  @return 删除字符串头尾空格
 */
- (NSString *)lsqTrim;

/**
 *  使用正则匹配子字符串
 *
 *  @param regular 正则表达式
 *
 *  @return 子字符串集合
 */
- (NSMutableArray *)lsqSubstringByRegular:(NSString *)regular;

/**
 *  反转字符串
 *
 *  @return 反转字符串
 */
- (NSString *)lsqReverse;

/**
 *  获取字符串的hex
 *
 *  @return 字符串的hex
 */
- (NSString *)lsqHexString;

/**
 *  Hex转10进制数字
 *
 *  @return 10进制数字
 */
- (NSUInteger)lsqHexToDecimal;

/**
 *  转换为Json对象
 *
 *  @return Json对象
 */
- (id)lsqToJson;

/**
 *  转换为 unsigned long long
 *
 *  @return unsigned long long
 */
- (unsigned long long)lsqUnsignedLongLongValue;

/**
 *  转换为 NSUInteger
 *
 *  @return NSUInteger
 */
- (NSUInteger)lsqUnsignedIntegerValue;

/**
 *  根据给定的限制内容，获得该字符串对应的最优Size
 *
 *  @return CGSize
 */
- (CGSize)lsqColculateTextSizeWithFont:(UIFont *)textFont maxWidth:(CGFloat)maxWidth maxHeihgt:(CGFloat)maxHeight;

/**
 *  根据给定的限制内容，以及文本样式，获得该字符串对应的最优Size
 *
 *  @return CGSize
 */
- (CGSize)lsqColculateTextSizeWithAttributs:(NSDictionary *)Attribute maxWidth:(CGFloat)maxWidth maxHeihgt:(CGFloat)maxHeight;

@end
