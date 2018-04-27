//
//  TuSDKTSNSData+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/7.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据扩展
 */
@interface NSData(TuSDKTSNSDataExtend)
/**
 *  获取MD5
 *
 *  @return 获取MD5
 */
- (NSString *)lsqMd5;

/**
 *  获取指定位置的数据
 *
 *  @param postion 范围
 *
 *  @return 数据
 */
- (Byte)lsqGetByteWithPostion:(NSUInteger)postion;

/**
 *  使用AES/CBC/PKCS7Padding 256位加密
 *
 *  @param key 秘钥
 *
 *  @return 解密数据
 */
- (NSData *)lsqEncryptAES256CBCPKCS7PaddingWithKey:(NSString *)key;

/**
 *  使用AES/CBC/PKCS7Padding 256位解密
 *
 *  @param key 秘钥
 *
 *  @return 解密数据
 */
- (NSData *)lsqDecryptAES256CBCPKCS7PaddingWithKey:(NSString *)key;

/**
 *  解析base64字符串
 *
 *  @param string base64编码字符串
 *
 *  @return 解析base64数据
 */
+ (NSData *)lsqDataFromBase64String:(NSString*)str;

/**
 *  base64编码
 *
 *  @param str 输入字符串
 *
 *  @return base64编码
 */
- (NSString* )lsqBase64encode;
@end
