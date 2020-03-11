//
//  QNHttpManager.m
//  QiniuSDK
//
//  Created by bailong on 14/10/1.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "QNAsyncRun.h"
#import "QNConfiguration.h"
#import "QNResponseInfo.h"
#import "QNSessionManager.h"
#include "QNSystem.h"
#import "QNUserAgent.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

@interface QNProgessDelegate : NSObject <NSURLSessionDataDelegate>
@property (nonatomic, strong) QNInternalProgressBlock progressBlock;
@property (nonatomic, strong) NSURLSessionUploadTask *task;
@property (nonatomic, strong) QNCancelBlock cancelBlock;
- (instancetype)initWithProgress:(QNInternalProgressBlock)progressBlock;
@end

static NSURL *buildUrl(NSString *host, NSNumber *port, NSString *path) {
    port = port == nil ? [NSNumber numberWithInt:80] : port;
    NSString *p = [[NSString alloc] initWithFormat:@"http://%@:%@%@", host, port, path];
    return [[NSURL alloc] initWithString:p];
}

static BOOL needRetry(NSHTTPURLResponse *httpResponse, NSError *error) {
    if (error != nil) {
        return error.code < -1000;
    }
    if (httpResponse == nil) {
        return YES;
    }
    int status = (int)httpResponse.statusCode;
    return status >= 500 && status < 600 && status != 579;
}

@implementation QNProgessDelegate
- (instancetype)initWithProgress:(QNInternalProgressBlock)progressBlock {
    if (self = [super init]) {
        _progressBlock = progressBlock;
    }

    return self;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {

    if (_progressBlock) {
        _progressBlock(totalBytesSent, totalBytesExpectedToSend);
    }
    if (_cancelBlock && _cancelBlock()) {
        [_task cancel];
    }
}

@end

@interface QNSessionManager ()
@property UInt32 timeout;
@property (nonatomic, strong) QNUrlConvert converter;
@property bool noProxy;
@property (nonatomic, strong) NSDictionary *proxyDict;
@property (nonatomic, strong) NSOperationQueue *delegateQueue;
@end

@implementation QNSessionManager

- (instancetype)initWithProxy:(NSDictionary *)proxyDict
                      timeout:(UInt32)timeout
                 urlConverter:(QNUrlConvert)converter {
    if (self = [super init]) {
        if (proxyDict != nil) {
            _noProxy = NO;
            _proxyDict = proxyDict;
        } else {
            _noProxy = YES;
        }
        _delegateQueue = [[NSOperationQueue alloc] init];
        _timeout = timeout;
        _converter = converter;
    }

    return self;
}

- (instancetype)init {
    return [self initWithProxy:nil timeout:60 urlConverter:nil];
}

+ (QNResponseInfo *)buildResponseInfo:(NSHTTPURLResponse *)response
                            withError:(NSError *)error
                         withDuration:(double)duration
                         withResponse:(NSData *)body
                             withHost:(NSString *)host
                               withIp:(NSString *)ip {
    QNResponseInfo *info;

    if (response) {
        int status = (int)[response statusCode];
        NSDictionary *headers = [response allHeaderFields];
        NSString *reqId = headers[@"X-Reqid"];
        NSString *xlog = headers[@"X-Log"];
        NSString *xvia = headers[@"X-Via"];
        if (xvia == nil) {
            xvia = headers[@"X-Px"];
        }
        if (xvia == nil) {
            xvia = headers[@"Fw-Via"];
        }
        info = [[QNResponseInfo alloc] init:status withReqId:reqId withXLog:xlog withXVia:xvia withHost:host withIp:ip withDuration:duration withBody:body];
    } else {
        info = [QNResponseInfo responseInfoWithNetError:error host:host duration:duration];
    }
    return info;
}

- (void)sendRequest:(NSMutableURLRequest *)request
  withCompleteBlock:(QNCompleteBlock)completeBlock
  withProgressBlock:(QNInternalProgressBlock)progressBlock
    withCancelBlock:(QNCancelBlock)cancelBlock
         withAccess:(NSString *)access {
    __block NSDate *startTime = [NSDate date];
    NSString *domain = request.URL.host;
    NSString *u = request.URL.absoluteString;
    NSURL *url = request.URL;
    NSArray *ips = nil;
    if (_converter != nil) {
        url = [[NSURL alloc] initWithString:_converter(u)];
        request.URL = url;
        domain = url.host;
    }
    [self sendRequest2:request withCompleteBlock:completeBlock withProgressBlock:progressBlock withCancelBlock:cancelBlock withIpArray:ips withIndex:0 withDomain:domain withRetryTimes:3 withStartTime:startTime withAccess:access];
}

- (void)sendRequest2:(NSMutableURLRequest *)request
   withCompleteBlock:(QNCompleteBlock)completeBlock
   withProgressBlock:(QNInternalProgressBlock)progressBlock
     withCancelBlock:(QNCancelBlock)cancelBlock
         withIpArray:(NSArray *)ips
           withIndex:(int)index
          withDomain:(NSString *)domain
      withRetryTimes:(int)times
       withStartTime:(NSDate *)startTime
          withAccess:(NSString *)access {
    NSURL *url = request.URL;
    __block NSString *ip = nil;
    if (ips != nil) {
        ip = [ips objectAtIndex:(index % ips.count)];
        NSString *path = url.path;
        if (path == nil || [@"" isEqualToString:path]) {
            path = @"/";
        }
        url = buildUrl(ip, url.port, path);
        [request setValue:domain forHTTPHeaderField:@"Host"];
    }
    request.URL = url;
    [request setTimeoutInterval:_timeout];
    [request setValue:[[QNUserAgent sharedInstance] getUserAgent:access] forHTTPHeaderField:@"User-Agent"];
    [request setValue:nil forHTTPHeaderField:@"Accept-Language"];
    if (progressBlock == nil) {
        progressBlock = ^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        };
    }
    QNInternalProgressBlock progressBlock2 = ^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
    };
    __block QNProgessDelegate *delegate = [[QNProgessDelegate alloc] initWithProgress:nil];
    delegate.progressBlock = progressBlock2;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (_proxyDict) {
        configuration.connectionProxyDictionary = _proxyDict;
    }
    __block NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:delegate delegateQueue:_delegateQueue];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        double duration = [[NSDate date] timeIntervalSinceDate:startTime];
        QNResponseInfo *info;
        NSDictionary *resp = nil;
        if (_converter != nil && _noProxy && (index + 1 < ips.count || times > 0) && needRetry(httpResponse, error)) {
            [self sendRequest2:request withCompleteBlock:completeBlock withProgressBlock:progressBlock withCancelBlock:cancelBlock withIpArray:ips withIndex:index + 1 withDomain:domain withRetryTimes:times - 1 withStartTime:startTime withAccess:access];
            return;
        }
        if (error == nil) {
            info = [QNSessionManager buildResponseInfo:httpResponse withError:nil withDuration:duration withResponse:data withHost:domain withIp:ip];
            if (info.isOK) {
                NSError *tmp;
                resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&tmp];
            }
        } else {
            info = [QNSessionManager buildResponseInfo:httpResponse withError:error withDuration:duration withResponse:data withHost:domain withIp:ip];
        }
        delegate.task = nil;
        delegate.cancelBlock = nil;
        delegate.progressBlock = nil;
        completeBlock(info, resp);
        [session finishTasksAndInvalidate];
    }];
    delegate.task = uploadTask;
    delegate.cancelBlock = cancelBlock;
    [uploadTask resume];
}

- (void)multipartPost:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
         withFileName:(NSString *)key
         withMimeType:(NSString *)mime
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock
           withAccess:(NSString *)access {
    NSURL *URL = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"POST";
    NSString *boundary = @"werghnvt54wef654rjuhgb56trtg34tweuyrgf";
    request.allHTTPHeaderFields = @{
        @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
    };
    NSMutableData *postData = [[NSMutableData alloc] init];
    for (NSString *paramsKey in params) {
        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", boundary, paramsKey];
        [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];

        id value = [params objectForKey:paramsKey];
        if ([value isKindOfClass:[NSString class]]) {
            [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        } else if ([value isKindOfClass:[NSData class]]) {
            [postData appendData:value];
        }
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\nContent-Type:%@\r\n\r\n", boundary, @"file", key, mime];
    [postData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = postData;
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];

    [self sendRequest:request withCompleteBlock:completeBlock withProgressBlock:progressBlock withCancelBlock:cancelBlock
               withAccess:access];
}

- (void)post:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock
           withAccess:(NSString *)access {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    if (headers) {
        [request setAllHTTPHeaderFields:headers];
    }
    [request setHTTPMethod:@"POST"];
    if (params) {
        [request setValuesForKeysWithDictionary:params];
    }
    [request setHTTPBody:data];
    QNAsyncRun(^{
        [self sendRequest:request
            withCompleteBlock:completeBlock
            withProgressBlock:progressBlock
              withCancelBlock:cancelBlock
                   withAccess:access];
    });
}

- (void)get:(NSString *)url
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(QNCompleteBlock)completeBlock {
    QNAsyncRun(^{
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];

        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSData *s = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resp = nil;
            QNResponseInfo *info;
            if (error == nil) {
                info = [QNSessionManager buildResponseInfo:httpResponse withError:nil withDuration:0 withResponse:s withHost:@"" withIp:@""];
                if (info.isOK) {
                    NSError *jsonError;
                    id unMarshel = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    if (jsonError) {
                        info = [QNSessionManager buildResponseInfo:httpResponse withError:jsonError withDuration:0 withResponse:s withHost:@"" withIp:@""];
                    } else if ([unMarshel isKindOfClass:[NSDictionary class]]) {
                        resp = unMarshel;
                    }
                }
            } else {
                info = [QNSessionManager buildResponseInfo:httpResponse withError:error withDuration:0 withResponse:s withHost:@"" withIp:@""];
            }

            completeBlock(info, resp);
        }];
        [dataTask resume];

    });
}

@end

#endif
