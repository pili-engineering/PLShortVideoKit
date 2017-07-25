//
//  PLSUploaderResponInfo.h
//  PLShortVideoKit
//
//  Created by 何昊宇 on 2017/6/8.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLSUploaderResponseInfo : NSObject
/**
 *    状态码
 */
@property (readonly) int statusCode;

/**
 *    七牛服务器生成的请求ID，用来跟踪请求信息，如果使用过程中出现问题，请反馈此ID
 */
@property (nonatomic, copy, readonly) NSString * _Nullable reqId;

/**
 *    七牛服务器内部跟踪记录
 */
@property (nonatomic, copy, readonly) NSString * _Nullable xlog;

/**
 *    cdn服务器内部跟踪记录
 */
@property (nonatomic, copy, readonly) NSString * _Nullable xvia;

/**
 *    错误信息，出错时请反馈此记录
 */
@property (nonatomic, copy, readonly) NSError * _Nullable error;

/**
 *    服务器域名
 */
@property (nonatomic, copy, readonly) NSString * _Nullable host;

/**
 *    请求消耗的时间，单位 秒
 */
@property (nonatomic, readonly) double duration;

/**
 *    服务器IP
 */
@property (nonatomic, readonly) NSString * _Nullable serverIp;

/**
 *    客户端id
 */
@property (nonatomic, readonly) NSString * _Nullable id;

/**
 *    时间戳
 */
@property (readonly) UInt64 timeStamp;

/**
 *    是否取消
 */
@property (nonatomic, readonly, getter=isCancelled) BOOL canceled;

/**
 *    成功的请求
 */
@property (nonatomic, readonly, getter=isOK) BOOL ok;

/**
 *    是否网络错误
 */
@property (nonatomic, readonly, getter=isConnectionBroken) BOOL broken;

/**
 *    是否为 七牛响应
 */
@property (nonatomic, readonly, getter=isNotQiniu) BOOL notQiniu;

/**
 @abstract   PLSUploaderResponInfo 初始化方法
 
 @since      v1.0.4
 */

- (instancetype _Nullable)initWithStatusCode:(int)statusCode
                                       reqId:(NSString *_Nullable)reqId
                                        xlog:(NSString *_Nullable)xlog
                                        xvia:(NSString *_Nullable)xvia
                                       error:(NSError *_Nullable)error
                                        host:(NSString *_Nullable)host
                                    duration:(double)duration
                                    serverIp:(NSString *_Nullable)serverIp
                                          id:(NSString *_Nullable)id
                                   timeStamp:(UInt64)timeStamp
                                    canceled:(BOOL)canceled
                                          ok:(BOOL)ok
                                      broken:(BOOL)broken
                                    notQiniu:(BOOL)notQiniu;



@end
