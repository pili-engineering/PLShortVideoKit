//
//  JSONLoader.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//  

#import "JSONLoader.h"

@implementation JSONLoader


/**
 通过URL加载JSON数据，并将json数据序列化，把jso字典信息传给completionHandler

 @param url - 请求地址
 @param completionHandler - 加载成功后的操作，将序列化之后的jso作为block的传入参数；其中ARID方式可以通过jso构造出SPARApp对象，通过该对象得到manifestURL，去加载资源；preloadID方式可以通过jso构造出一个SPARApp对象数组，通过数组里的对象下载资源，当下载完成后，会把SPARApp对象数组作为block的传入参数，遍历SPARApp对象数组，通过easyAR找出和扫描图对应的targetDesc，通过targetDesc去得到SPARApp对象，拿到manifestURL，去加载资源。
 @param progressHandler - 下载进度的操作，没有调用block
 */
+ (void)loadFromURL:(NSString *)url completionHandler:(void (^)(NSDictionary *jso, NSError *err)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
#pragma unused(progressHandler)

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }

            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode != 200) {
                    NSError *error = [NSError errorWithDomain:@"Non-200 status" code:statusCode userInfo:nil];
                    completionHandler(nil, error);
                }
            }

            NSError *err;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (err) {
                completionHandler(nil, error);
                return;
            }
            completionHandler(res, nil);
        }];

    [task resume];
}

@end
