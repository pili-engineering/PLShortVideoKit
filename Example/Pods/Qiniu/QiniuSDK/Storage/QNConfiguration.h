//
//  QNConfiguration.h
//  QiniuSDK
//
//  Created by bailong on 15/5/21.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNRecorderDelegate.h"

/**
 *    断点上传时的分块大小
 */
extern const UInt32 kQNBlockSize;

/**
 *    转换为用户需要的url
 *
 *    @param url  上传url
 *
 *    @return 根据上传url算出代理url
 */
typedef NSString * (^QNUrlConvert)(NSString *url);

@class QNConfigurationBuilder;
@class QNZone;
/**
 *    Builder block
 *
 *    @param builder builder实例
 */
typedef void (^QNConfigurationBuilderBlock)(QNConfigurationBuilder *builder);

@interface QNConfiguration : NSObject

/**
 *    存储区域
 */
@property (copy, nonatomic, readonly) QNZone *zone;

/**
 *    断点上传时的分片大小
 */
@property (readonly) UInt32 chunkSize;

/**
 *    如果大于此值就使用断点上传，否则使用form上传
 */
@property (readonly) UInt32 putThreshold;

/**
 *    上传失败的重试次数
 */
@property (readonly) UInt32 retryMax;

/**
 *    超时时间 单位 秒
 */
@property (readonly) UInt32 timeoutInterval;

/**
 *    是否使用 https，默认为 YES
 */
@property (nonatomic, assign) BOOL useHttps;

@property (nonatomic, readonly) id<QNRecorderDelegate> recorder;

@property (nonatomic, readonly) QNRecorderKeyGenerator recorderKeyGen;

@property (nonatomic, readonly) NSDictionary *proxy;

@property (nonatomic, readonly) QNUrlConvert converter;


@property (readonly) BOOL disableATS;

+ (instancetype)build:(QNConfigurationBuilderBlock)block;

@end

typedef void (^QNPrequeryReturn)(int code);

@class QNUpToken;
@class QNZoneInfo;

@interface QNZone : NSObject

@property (nonatomic, strong) NSArray<NSString *> *upDomainList;
@property (nonatomic, strong) QNZoneInfo *zoneInfo;

/**
 *    默认上传服务器地址列表
 */
- (void)preQuery:(QNUpToken *)token
              on:(QNPrequeryReturn)ret;

- (NSString *)up:(QNUpToken *)token
         isHttps:(BOOL)isHttps
    frozenDomain:(NSString *)frozenDomain;

@end

@interface QNZoneInfo : NSObject

@property (readonly, nonatomic) long ttl;
@property (readonly, nonatomic) NSMutableArray<NSString *> *upDomainsList;
@property (readonly, nonatomic) NSMutableDictionary *upDomainsDic;

- (instancetype)init:(long)ttl
       upDomainsList:(NSMutableArray<NSString *> *)upDomainsList
        upDomainsDic:(NSMutableDictionary *)upDomainsDic;
- (QNZoneInfo *)buildInfoFromJson:(NSDictionary *)resp;

@end

@interface QNFixedZone : QNZone

/**
 *    zone 0 华东
 *
 *    @return 实例
 */
+ (instancetype)zone0;

/**
 *    zone 1 华北
 *
 *    @return 实例
 */
+ (instancetype)zone1;

/**
 *    zone 2 华南
 *
 *    @return 实例
 */
+ (instancetype)zone2;

/**
 *    zone Na0 北美
 *
 *    @return 实例
 */
+ (instancetype)zoneNa0;

/**
 *    zone As0 新加坡
 *
 *    @return 实例
*/
+ (instancetype)zoneAs0;

/**
 *    Zone初始化方法
 *
 *    @param upList     默认上传服务器地址列表
 *
 *    @return Zone实例
 */
- (instancetype)initWithupDomainList:(NSArray<NSString *> *)upList;

/**
 *    Zone初始化方法
 *
 *    @param upList     默认上传服务器地址列表
 *
 *    @return Zone实例
 */
+ (instancetype)createWithHost:(NSArray<NSString *> *)upList;

- (void)preQuery:(QNUpToken *)token
              on:(QNPrequeryReturn)ret;

- (NSString *)up:(QNUpToken *)token
         isHttps:(BOOL)isHttps
    frozenDomain:(NSString *)frozenDomain;
@end

@interface QNAutoZone : QNZone


- (NSString *)up:(QNUpToken *)token
         isHttps:(BOOL)isHttps
    frozenDomain:(NSString *)frozenDomain;

@end

@interface QNConfigurationBuilder : NSObject

/**
 *    默认上传服务器地址
 */
@property (nonatomic, strong) QNZone *zone;

/**
 *    断点上传时的分片大小
 */
@property (assign) UInt32 chunkSize;

/**
 *    如果大于此值就使用断点上传，否则使用form上传
 */
@property (assign) UInt32 putThreshold;

/**
 *    上传失败的重试次数
 */
@property (assign) UInt32 retryMax;

/**
 *    超时时间 单位 秒
 */
@property (assign) UInt32 timeoutInterval;

/**
 *    是否使用 https，默认为 YES
 */
@property (nonatomic, assign) BOOL useHttps;

@property (nonatomic, strong) id<QNRecorderDelegate> recorder;

@property (nonatomic, strong) QNRecorderKeyGenerator recorderKeyGen;

@property (nonatomic, strong) NSDictionary *proxy;

@property (nonatomic, strong) QNUrlConvert converter;


@property (assign) BOOL disableATS;

@end
