//
//  QNConfiguration.m
//  QiniuSDK
//
//  Created by bailong on 15/5/21.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import "QNConfiguration.h"
#import "QNResponseInfo.h"
#import "QNSessionManager.h"
#import "QNSystem.h"
#import "QNUpToken.h"

const UInt32 kQNBlockSize = 4 * 1024 * 1024;


@implementation QNConfiguration

+ (instancetype)build:(QNConfigurationBuilderBlock)block {
    QNConfigurationBuilder *builder = [[QNConfigurationBuilder alloc] init];
    block(builder);
    return [[QNConfiguration alloc] initWithBuilder:builder];
}

- (instancetype)initWithBuilder:(QNConfigurationBuilder *)builder {
    if (self = [super init]) {

        _chunkSize = builder.chunkSize;
        _putThreshold = builder.putThreshold;
        _retryMax = builder.retryMax;
        _timeoutInterval = builder.timeoutInterval;

        _recorder = builder.recorder;
        _recorderKeyGen = builder.recorderKeyGen;

        _proxy = builder.proxy;

        _converter = builder.converter;

        _disableATS = builder.disableATS;
        
        _zone = builder.zone;

        _useHttps = builder.useHttps;
    }
    return self;
}

@end

@implementation QNConfigurationBuilder

- (instancetype)init {
    if (self = [super init]) {
        _zone = [[QNAutoZone alloc] init];
        _chunkSize = 2 * 1024 * 1024;
        _putThreshold = 4 * 1024 * 1024;
        _retryMax = 3;
        _timeoutInterval = 60;

        _recorder = nil;
        _recorderKeyGen = nil;

        _proxy = nil;
        _converter = nil;

        if (hasAts() && !allowsArbitraryLoads()) {
            _disableATS = NO;
        } else {
            _disableATS = YES;
        }

        _useHttps = YES;
    }
    return self;
}

@end

@implementation QNZoneInfo

- (instancetype)init:(long)ttl
       upDomainsList:(NSMutableArray<NSString *> *)upDomainsList
        upDomainsDic:(NSMutableDictionary *)upDomainsDic {
    if (self = [super init]) {
        _ttl = ttl;
        _upDomainsList = upDomainsList;
        _upDomainsDic = upDomainsDic;
    }
    return self;
}

- (QNZoneInfo *)buildInfoFromJson:(NSDictionary *)resp {
    long ttl = [[resp objectForKey:@"ttl"] longValue];
    NSDictionary *up = [resp objectForKey:@"up"];
    NSDictionary *acc = [up objectForKey:@"acc"];
    NSDictionary *src = [up objectForKey:@"src"];
    NSDictionary *old_acc = [up objectForKey:@"old_acc"];
    NSDictionary *old_src = [up objectForKey:@"old_src"];
    NSArray *urlDicList = [[NSArray alloc] initWithObjects:acc, src, old_acc, old_src, nil];
    NSMutableArray *domainList = [[NSMutableArray alloc] init];
    NSMutableDictionary *domainDic = [[NSMutableDictionary alloc] init];
    //main
    for (int i = 0; i < urlDicList.count; i++) {
        if ([[urlDicList[i] allKeys] containsObject:@"main"]) {
            NSArray *mainDomainList = urlDicList[i][@"main"];
            for (int i = 0; i < mainDomainList.count; i++) {
                [domainList addObject:mainDomainList[i]];
                [domainDic setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:mainDomainList[i]];
            }
        }
        //backup
        if ([[urlDicList[i] allKeys] containsObject:@"backup"]) {
            NSArray *mainDomainList = urlDicList[i][@"backup"];
            for (int i = 0; i < mainDomainList.count; i++) {
                [domainList addObject:mainDomainList[i]];
                [domainDic setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:mainDomainList[i]];
            }
        }
    }

    return [[QNZoneInfo alloc] init:ttl upDomainsList:domainList upDomainsDic:domainDic];
}

- (void)frozenDomain:(NSString *)domain {
    NSTimeInterval secondsFor10min = 10 * 60;
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsFor10min];
    [self.upDomainsDic setObject:tomorrow forKey:domain];
}

@end

@implementation QNZone

- (instancetype)init {
    self = [super init];
    return self;
}

- (NSArray<NSString *> *)upDomainList:(NSString *)token {
    return self.upDomainList;
}

- (NSString *)upHost:(QNZoneInfo *)zoneInfo
             isHttps:(BOOL)isHttps
          lastUpHost:(NSString *)lastUpHost {
    NSString *upHost = nil;
    NSString *upDomain = nil;

    // frozen domain
    if (lastUpHost) {
        NSString *upLastDomain = nil;
        if (isHttps) {
            upLastDomain = [lastUpHost substringFromIndex:8];
        } else {
            upLastDomain = [lastUpHost substringFromIndex:7];
        }
        [zoneInfo frozenDomain:upLastDomain];
    }

    //get backup domain
    for (NSString *backupDomain in zoneInfo.upDomainsList) {
        NSDate *frozenTill = zoneInfo.upDomainsDic[backupDomain];
        NSDate *now = [NSDate date];
        if ([frozenTill compare:now] == NSOrderedAscending) {
            upDomain = backupDomain;
            break;
        }
    }
    if (upDomain) {
        [zoneInfo.upDomainsDic setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:upDomain];
    } else {
        //reset all the up host frozen time
        for (NSString *domain in zoneInfo.upDomainsList) {
            [zoneInfo.upDomainsDic setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:domain];
        }
        if (zoneInfo.upDomainsList.count > 0) {
            upDomain = zoneInfo.upDomainsList[0];
        }
    }

    if (upDomain) {
        if (isHttps) {
            upHost = [NSString stringWithFormat:@"https://%@", upDomain];
        } else {
            upHost = [NSString stringWithFormat:@"http://%@", upDomain];
        }
    }
    return upHost;
}

- (NSString *)up:(QNUpToken *)token
         isHttps:(BOOL)isHttps
    frozenDomain:(NSString *)frozenDomain {
    return nil;
}

- (void)preQuery:(QNUpToken *)token
              on:(QNPrequeryReturn)ret {
    ret(0);
}

@end

@interface QNFixedZone () {
    NSString *server;
    NSMutableDictionary *cache;
    NSLock *lock;
}

@end

@implementation QNFixedZone

- (instancetype)initWithupDomainList:(NSArray<NSString *> *)upList {
    if (self = [super init]) {
        self.upDomainList = upList;
        self.zoneInfo = [self createZoneInfo:upList];
    }

    return self;
}

+ (instancetype)createWithHost:(NSArray<NSString *> *)upList {
    return [[QNFixedZone alloc] initWithupDomainList:upList];
}

+ (instancetype)zone0 {
    static QNFixedZone *z0 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static const NSArray<NSString *> *uplist = nil;
        if (!uplist) {
            uplist = [[NSArray alloc] initWithObjects:@"upload.qiniup.com", @"upload-nb.qiniup.com",
                                                      @"upload-xs.qiniup.com", @"up.qiniup.com",
                                                      @"up-nb.qiniup.com", @"up-xs.qiniup.com",
                                                      @"upload.qbox.me", @"up.qbox.me", nil];
            z0 = [QNFixedZone createWithHost:(NSArray<NSString *> *)uplist];
        }
    });
    return z0;
}

+ (instancetype)zone1 {
    static QNFixedZone *z1 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static const NSArray<NSString *> *uplist = nil;
        if (!uplist) {
            uplist = [[NSArray alloc] initWithObjects:@"upload-z1.qiniup.com", @"up-z1.qiniup.com",
                                                      @"upload-z1.qbox.me", @"up-z1.qbox.me", nil];
            z1 = [QNFixedZone createWithHost:(NSArray<NSString *> *)uplist];
        }
    });
    return z1;
}

+ (instancetype)zone2 {
    static QNFixedZone *z2 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static const NSArray<NSString *> *uplist = nil;
        if (!uplist) {
            uplist = [[NSArray alloc] initWithObjects:@"upload-z2.qiniup.com", @"upload-gz.qiniup.com",
                                                      @"upload-fs.qiniup.com", @"up-z2.qiniup.com",
                                                      @"up-gz.qiniup.com", @"up-fs.qiniup.com",
                                                      @"upload-z2.qbox.me", @"up-z2.qbox.me", nil];
            z2 = [QNFixedZone createWithHost:(NSArray<NSString *> *)uplist];
        }
    });
    return z2;
}

+ (instancetype)zoneNa0 {
    static QNFixedZone *zNa0 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static const NSArray<NSString *> *uplist = nil;
        if (!uplist) {
            uplist = [[NSArray alloc] initWithObjects:@"upload-na0.qiniup.com", @"up-na0.qiniup.com",
                                                      @"upload-na0.qbox.me", @"up-na0.qbox.me", nil];
            zNa0 = [QNFixedZone createWithHost:(NSArray<NSString *> *)uplist];
        }
    });
    return zNa0;
}

+ (instancetype)zoneAs0 {
    static QNFixedZone *zAs0 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static const NSArray<NSString *> *uplist = nil;
        if (!uplist) {
            uplist = [[NSArray alloc] initWithObjects:@"upload-as0.qiniup.com", @"up-as0.qiniup.com",
                                                      @"upload-as0.qbox.me", @"up-as0.qbox.me", nil];
            zAs0 = [QNFixedZone createWithHost:(NSArray<NSString *> *)uplist];
        }
    });
    return zAs0;
}

- (void)preQuery:(QNUpToken *)token
              on:(QNPrequeryReturn)ret {
    ret(0);
}

- (QNZoneInfo *)createZoneInfo:(NSArray<NSString *> *)upDomainList {
    NSMutableDictionary *upDomainDic = [[NSMutableDictionary alloc] init];
    for (NSString *upDomain in upDomainList) {
        [upDomainDic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:upDomain];
    }
    QNZoneInfo *zoneInfo = [[QNZoneInfo alloc] init:86400 upDomainsList:(NSMutableArray<NSString *> *)upDomainList upDomainsDic:upDomainDic];
    return zoneInfo;
}

- (NSString *)up:(QNUpToken *)token
         isHttps:(BOOL)isHttps
    frozenDomain:(NSString *)frozenDomain {

    if (self.zoneInfo == nil) {
        return nil;
    }
    return [super upHost:self.zoneInfo isHttps:isHttps lastUpHost:frozenDomain];
}
@end

@implementation QNAutoZone {
    NSString *server;
    NSMutableDictionary *cache;
    NSLock *lock;
    QNSessionManager *sesionManager;
}

- (instancetype)init{
    if (self = [super init]) {
        server = @"https://uc.qbox.me";
        cache = [NSMutableDictionary new];
        lock = [NSLock new];
        sesionManager = [[QNSessionManager alloc] initWithProxy:nil timeout:10 urlConverter:nil];
    }
    return self;
}

- (NSString *)up:(QNUpToken *)token
         isHttps:(BOOL)isHttps
    frozenDomain:(NSString *)frozenDomain {
    NSString *index = [token index];
    [lock lock];
    QNZoneInfo *info = [cache objectForKey:index];
    [lock unlock];
    if (info == nil) {
        return nil;
    }
    return [super upHost:info isHttps:isHttps lastUpHost:frozenDomain];
}

- (void)preQuery:(QNUpToken *)token
              on:(QNPrequeryReturn)ret {
    if (token == nil) {
        ret(-1);
    }
    [lock lock];
    QNZoneInfo *info = [cache objectForKey:[token index]];
    [lock unlock];
    if (info != nil) {
        ret(0);
        return;
    }

    //https://uc.qbox.me/v2/query?ak=T3sAzrwItclPGkbuV4pwmszxK7Ki46qRXXGBBQz3&bucket=if-pbl
    NSString *url = [NSString stringWithFormat:@"%@/v2/query?ak=%@&bucket=%@", server, token.access, token.bucket];
    [sesionManager get:url withHeaders:nil withCompleteBlock:^(QNResponseInfo *info, NSDictionary *resp) {
        if (!info.error) {
            QNZoneInfo *info = [[[QNZoneInfo alloc] init] buildInfoFromJson:resp];
            if (info == nil) {
                ret(kQNInvalidToken);
            } else {
                [lock lock];
                [cache setValue:info forKey:[token index]];
                [lock unlock];
                ret(0);
            }
        } else {
            ret(kQNNetworkError);
        }
    }];
}

@end
