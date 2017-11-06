//
//  Downloader.m
//  EasyAR3D
//
//  Created by Qinsi on 9/20/16.
//
//  

#import "Downloader.h"
#import "Auth.h"
#import "SPARUtil.h"

@interface Downloader () <NSURLSessionDownloadDelegate>
@property (nonatomic, copy) void (^completionHandler)(NSError *error);
/**
 设置进度条的blcok
 */
@property (nonatomic, copy) void (^progressHandler)(NSString *taskName, float progress);

/**
 加载本地数据的url
 */
@property (nonatomic, retain) NSURL *targetURL;
@end

@implementation Downloader

static NSString *kTaskName = @"Download";
static NSString *kPackagesPath = @"packages";
static NSString *kTargetsPath = @"targets";

/**
 返回字符串"packages"
 */
+ (NSString *)packagesPath {
    return kPackagesPath;
}

/**
 返回字符串"targets"
 */
+ (NSString *)targetsPath {
    return kTargetsPath;
}

/**
 返回加密之后的文件名
 
 @param url  - 本地文件名
 return 加密后的文件名
 */
+ (NSString *)getLocalNameForURL:(NSString *)url {
    return [Auth sha1Hex:url];
}


/**
 返回support路径下的某一个目录的全路径

 @param path - 路径名
 @return Support目录下的某一个目录的全路径
 */
+ (NSString *)getDownloadPath:(NSString *)path {
    NSString *dir = [SPARUtil getSupportDirectory];
    NSString *targetPath = [dir stringByAppendingPathComponent:path];
    [SPARUtil ensureDirectory:targetPath];
    return targetPath;
}

/**
 下载操作,将下载文件移到指定目录

 @param url - 下载的url
 @param dst - 文件的目标路径
 @param force - Yes：判断文件是否存在，如果存在则将文件删除；No：文件存在时则不下载该文件
 @param completionHandler - 下载完成将出错信息作为block的传入参数
 @param progressHandler - 可以得到下载的进度，设置UI的进度
 */
- (void)download:(NSString *) url to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err)) completionHandler progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    bool fileExists = [fm fileExistsAtPath:dst];
    if (fileExists) {
        if (!force) {
            completionHandler(nil);
            return;
        }
        [fm removeItemAtPath:dst error:&error];
        if (error) {
            completionHandler(error);
            return;
        }
    }
    NSString *path = [dst stringByDeletingLastPathComponent];
    // 文件的上一级路径是否存在
    bool pathExists = [fm fileExistsAtPath:path];
    if (!pathExists) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            completionHandler(error);
            return;
        }
    }
    self.targetURL = [NSURL fileURLWithPath:dst];
    self.completionHandler = completionHandler;
    self.progressHandler = progressHandler;
    
    if ([url hasPrefix:@"assets://"]) {//add by liugang
        [self copyFileAsync:url dest:dst];
    }else{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:self
                                                         delegateQueue:nil];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url]];
        [task resume];
    }
}

/**
 将文件复制到目标路径

 @param sourceAssertPath - 原路径
 @param destPath - 目标路径
 */
- (void)copyFileAsync:(NSString*)sourceAssertPath dest:(NSString*)destPath{
    __weak Downloader * weak_self = self;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //load your data here.
        UInt64 recordTime2 = [[NSDate date] timeIntervalSince1970]*1000;
        __strong Downloader * strong_self = weak_self;

        //  assert://aaa.dmg
        NSString* fn;
        NSString* ofType;
        if ([sourceAssertPath hasPrefix:@"assets://"]) {
            NSRange range = NSMakeRange(@"assets://".length, sourceAssertPath.length-@"assets://".length);
            NSString* temp=[sourceAssertPath substringWithRange:range];
            range = [temp rangeOfString:@"."];
            if (range.location != NSNotFound){
                fn=[temp substringToIndex:range.location];
                ofType=[temp substringFromIndex:range.location+1];
            }
        }
        NSString* sourcePath =[[NSBundle mainBundle] pathForResource:fn ofType:ofType];
        NSFileManager*fileManager =[NSFileManager defaultManager];
        NSError*error;
      //  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
      //  NSString* destPath= [[paths firstObject] stringByAppendingPathComponent:@"genymotion.dmg"];
        NSLog(@"%@", destPath);
        //[ViewController ensureDirectory:[paths firstObject] ];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        
        UInt64 endTime2 = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"gcd copy file cost %llu ms",endTime2-recordTime2);
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI in main thread.
            strong_self.completionHandler(error);
        });
    });
   
    UInt64 endTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSLog(@"copy file cost %llu ms",endTime-recordTime);
}

#pragma mark -NSURLSessionDownloadDelegate
/**
 下载过程中调用，将taskName和下载进度传给progressHandler

 @param session - 会话
 @param downloadTask - 下载任务
 @param bytesWritten - 已经写入的数据
 @param totalBytesWritten - 下载过的字节大小
 @param totalBytesExpectedToWrite - 要下载文件全部字节大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
#pragma unused (session, downloadTask, bytesWritten)
    float prog = totalBytesWritten / (float)totalBytesExpectedToWrite;
    if (totalBytesExpectedToWrite < 0) {
        prog = 0;
    }
    self.progressHandler(kTaskName, prog);
}



/**
  当下载完成时调用，能够处理下载出错时的情况，URLSession:downloadTask:didFinishDownloadingToURL:之后调用，将错误信息传给completionHandler

 @param session - 会话
 @param task - 任务
 @param error - 错误信息
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
#pragma unused (session, task)
    if (error) {
        self.completionHandler(error);
        [session finishTasksAndInvalidate];
    }
}

#pragma mark -NSURLSessionTaskDelegate
/**
 下载操作完成调用，将文件移到指定的目录 targer.url，将错误信息传给completionHandler
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
#pragma unused (session, downloadTask)
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm moveItemAtURL:location toURL:self.targetURL error:&error];
    self.completionHandler(error);
    [session finishTasksAndInvalidate];
}

@end
