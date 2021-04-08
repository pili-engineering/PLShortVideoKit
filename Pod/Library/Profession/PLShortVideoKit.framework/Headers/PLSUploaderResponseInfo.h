//
//  PLSUploaderResponInfo.h
//  PLShortVideoKit
//
//  Created by 何昊宇 on 2017/6/8.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class PLSUploaderResponseInfo
 @brief 上传完成的反馈信息
 */
@interface PLSUploaderResponseInfo : NSObject
/*!
 @property statusCode
 @brief    状态码
 */
@property (readonly) int statusCode;

/*!
 @property reqId
 @brief 七牛服务器生成的请求ID，用来跟踪请求信息，如果使用过程中出现问题，请反馈此ID
 */
@property (nonatomic, copy, readonly) NSString * _Nullable reqId;

/*!
@property reqId
@brief 七牛日志上报返回的 X_Log_Client_Id
 
@since v3.2.0
*/
@property (nonatomic, copy, readonly) NSString * _Nullable xClientId __deprecated_msg("Method deprecated in v3.2.3.");

/*!
 @property xlog
 @brief 七牛服务器内部跟踪记录
 */
@property (nonatomic, copy, readonly) NSString * _Nullable xlog;

/*!
 @property xvia
 @brief cdn服务器内部跟踪记录
 */
@property (nonatomic, copy, readonly) NSString * _Nullable xvia;

/*!
 @property error
 @brief 错误信息，出错时请反馈此记录
 */
@property (nonatomic, copy, readonly) NSError * _Nullable error;

/*!
 @property host
 @brief 服务器域名
 */
@property (nonatomic, copy, readonly) NSString * _Nullable host;

/*!
 @property duration
 @brief 请求消耗的时间，单位 秒
 */
@property (nonatomic, readonly) double duration __deprecated_msg("Method deprecated in v3.2.3.");

/*!
 @property serverIp
 @brief 服务器IP
 */
@property (nonatomic, readonly) NSString * _Nullable serverIp __deprecated_msg("Method deprecated in v3.2.0.");

/*!
 @property id
 @brief 客户端id
 */
@property (nonatomic, readonly) NSString * _Nullable id;

/*!
 @property timeStamp
 @brief 时间戳
 */
@property (readonly) UInt64 timeStamp;

/*!
 @property canceled
 @brief 是否取消
 */
@property (nonatomic, readonly, getter=isCancelled) BOOL canceled;

/*!
 @property ok
 @brief 成功的请求
 */
@property (nonatomic, readonly, getter=isOK) BOOL ok;

/*!
 @property broken
 @brief 是否网络错误
 */
@property (nonatomic, readonly, getter=isConnectionBroken) BOOL broken;

/*!
 @property notQiniu
 @brief 是否为 七牛响应
 */
@property (nonatomic, readonly, getter=isNotQiniu) BOOL notQiniu;

/*!
 @method initWithStatusCode:reqId:xlog:xvia:error:host:duration:serverIp:id:timeStamp:canceled:ok:broken:notQiniu:
 @abstract   PLSUploaderResponInfo 初始化方法
 
 @return PLSUploaderResponseInfo 实例
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
                                    notQiniu:(BOOL)notQiniu __deprecated_msg("Method deprecated in v3.2.0. Use `initWithStatusCode:reqId:xClientId:xlog:xvia:error:host:duration:id:timeStamp:canceled:ok:broken:notQiniu:`");


/*!
 @method initWithStatusCode:reqId:xClientId:xlog:xvia:error:host:duration:id:timeStamp:canceled:ok:broken:notQiniu:
 @abstract   PLSUploaderResponInfo 初始化方法
 
 @return PLSUploaderResponseInfo 实例
 @since      v3.2.0
 */

- (instancetype _Nullable)initWithStatusCode:(int)statusCode
                                       reqId:(NSString *_Nullable)reqId
                                   xClientId:(NSString *_Nullable)xClientId
                                        xlog:(NSString *_Nullable)xlog
                                        xvia:(NSString *_Nullable)xvia
                                       error:(NSError *_Nullable)error
                                        host:(NSString *_Nullable)host
                                    duration:(double)duration
                                          id:(NSString *_Nullable)id
                                   timeStamp:(UInt64)timeStamp
                                    canceled:(BOOL)canceled
                                          ok:(BOOL)ok
                                      broken:(BOOL)broken
                                    notQiniu:(BOOL)notQiniu __deprecated_msg("Method deprecated in v3.2.3. Use `initWithStatusCode:reqId:xlog:xvia:error:host:id:timeStamp:canceled:ok:broken:notQiniu:`");

/*!
 @method initWithStatusCode:reqId:xlog:xvia:error:host:id:timeStamp:canceled:ok:broken:notQiniu:
 @abstract   PLSUploaderResponInfo 初始化方法
 
 @return PLSUploaderResponseInfo 实例
 @since      v3.2.0
 */
- (instancetype _Nullable)initWithStatusCode:(int)statusCode
                                       reqId:(NSString *_Nullable)reqId
                                        xlog:(NSString *_Nullable)xlog
                                        xvia:(NSString *_Nullable)xvia
                                       error:(NSError *_Nullable)error
                                        host:(NSString *_Nullable)host
                                          id:(NSString *_Nullable)id
                                   timeStamp:(UInt64)timeStamp
                                    canceled:(BOOL)canceled
                                          ok:(BOOL)ok
                                      broken:(BOOL)broken
                                    notQiniu:(BOOL)notQiniu ;
@end
