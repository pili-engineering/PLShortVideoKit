//
//  TuSDKTSNSDictionary+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/23.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const lsqHttpHeader_Content_Disposition;
extern NSString * const lsqHttpHeader_Accept_Length;
extern NSString * const lsqHttpHeader_Content_Type;

/**
 *  HTTP头解析
 */
@interface NSDictionary(HttpHeader)
/**
 *  获取附件信息
 *
 *  @return 附件信息
 */
- (NSString *)lsqContentDisposition;

/**
 *  获取附件文件名
 *
 *  @return 附件文件名
 */
- (NSString *)lsqAttachmentFileName;
@end

/**
 *  序列化为JSON对象
 */
@interface NSDictionary(TuSDKTSJSONExtend)
/**
 *  转换为JSON数据对象
 *
 *  @return JSON数据对象
 */
- (NSData *)lsqJsonData;

/**
 *  转换为Json字符串
 *
 *  @return Json字符串
 */
- (NSString *)lsqJsonString;
@end