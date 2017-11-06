//
//  JSONLoader.h
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//  加载JSON数据的工具类

#import <Foundation/Foundation.h>

@interface JSONLoader : NSObject

+ (void)loadFromURL:(NSString *)url completionHandler:(void (^)(NSDictionary *jso, NSError *err)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;

@end
