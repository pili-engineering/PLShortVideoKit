//
//  Downloader.h
//  EasyAR3D
//
//  Created by Qinsi on 9/20/16.
//
//  下载相关的工具类

#import <Foundation/Foundation.h>

@interface Downloader : NSObject

+ (NSString *)targetsPath;
+ (NSString *)packagesPath;
+ (NSString *)getLocalNameForURL:(NSString *)url;
+ (NSString *)getDownloadPath:(NSString *)path;
- (void)download:(NSString *) url to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err)) completionHandler
 progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;

@end
