//
//  KWStickerDownloadManager.m
//  PLMediaStreamingKitDemo
//
//  Created by jacoy on 17/1/20.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import "KWStickerDownloadManager.h"
#import "KWSticker.h"
#import "SSZipArchive.h"
#import "KWStickerManager.h"
#import "KWConst.h"

@interface KWStickerDownloader : NSObject<SSZipArchiveDelegate,NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic,copy) void (^successedBlock)(KWSticker *,NSInteger,KWStickerDownloader *);

@property (nonatomic,copy) void (^failedBlock)(KWSticker *,NSInteger,KWStickerDownloader *);

@property (nonatomic,strong)KWSticker *sticker;

@property (nonatomic,strong)NSURL *url;

@property (nonatomic,assign)NSInteger index;


- (instancetype)initWithSticker:(KWSticker *)sticker url:(NSURL *)url index:(NSInteger)index;

- (void)downloadSuccessed:(void(^)(KWSticker *sticker,NSInteger index,KWStickerDownloader *downloader))success failed:(void(^)(KWSticker *sticker,NSInteger index,KWStickerDownloader *downloader))failed;

@end


@implementation KWStickerDownloader


- (instancetype)initWithSticker:(KWSticker *)sticker url:(NSURL *)url index:(NSInteger)index
{
    if (self = [super init]) {
        
        self.sticker = sticker;
        self.index = index;
        self.url = url;
    }
    
    return self;
}

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        
    }
    return _session;
}

- (void)downloadSuccessed:(void(^)(KWSticker *sticker,NSInteger index,KWStickerDownloader *downloader))success failed:(void(^)(KWSticker *sticker,NSInteger index,KWStickerDownloader *downloader))failed
{
    
        [[self.session downloadTaskWithURL:self.url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                failed(self.sticker,self.index,self);
            }else{
                self.successedBlock = success;
                self.failedBlock = failed;
                // unzip
                [SSZipArchive unzipFileAtPath:location.path toDestination:[[KWStickerManager sharedManager]getStickerPath] delegate:self];
                
            }
        }]resume];
    
    
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


#pragma mark - Unzip complete callback

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath
{
    // update sticker's download config
    [[KWStickerManager sharedManager] updateConfigJSON];
    
    NSString *dir = [NSString stringWithFormat:@"%@/%@/",[[KWStickerManager sharedManager]getStickerPath],self.sticker.stickerName];
    NSURL *url = [NSURL fileURLWithPath:dir];
    
    NSString *s = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img.jpeg"];
    
    
    [KWSticker updateStickerAfterDownload:self.sticker DirectoryURL:url sucess:^(KWSticker *sucessSticker) {
        
        self.successedBlock(sucessSticker,self.index,self);
        
    } fail:^(KWSticker *failSticker) {
        
        self.failedBlock(failSticker,self.index,self);
        
    }];
    
}

@end


@interface KWStickerDownloadManager()

/**
 *   操作缓冲池
 */
@property (nonatomic, strong) NSMutableDictionary *downloadCache;

@end


@implementation KWStickerDownloadManager

+ (instancetype)sharedInstance
{
    static id _sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [KWStickerDownloadManager new];
    });
    
    return _sharedManager;
}

- (NSMutableDictionary *)downloadCache {
    if (_downloadCache == nil) {
        _downloadCache = [[NSMutableDictionary alloc] init];
    }
    return _downloadCache;
}


- (void)downloadSticker:(KWSticker *)sticker index:(NSInteger)index withAnimation:(void(^)(NSInteger index))animating successed:(void(^)(KWSticker *sticker,NSInteger index))success failed:(void(^)(KWSticker *sticker,NSInteger index))failed
{
    NSString *zipName = [NSString stringWithFormat:@"%@.zip",sticker.stickerName];
    
    NSURL *downloadUrl = sticker.downloadURL;
    
    if (sticker.sourceType == KWStickerSourceTypeFromKW) {
        
        downloadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KWStickerDownloadBaseURL,zipName]];
    }
    
    // 判断是否存在对应的下载操作
    if(self.downloadCache[downloadUrl] != nil) {
        return;
    }
    
    animating(index);
    
    KWStickerDownloader *downloader = [[KWStickerDownloader alloc]initWithSticker:sticker url:downloadUrl index:index];
    
    
    [self.downloadCache setObject:downloader forKey:downloadUrl];

    [downloader downloadSuccessed:^(KWSticker *sticker, NSInteger index,KWStickerDownloader *downloader) {

        [self.downloadCache removeObjectForKey:downloadUrl];
        downloader = nil;
        success(sticker,index);

    } failed:^(KWSticker *sticker, NSInteger index,KWStickerDownloader *downloader) {
        
        [self.downloadCache removeObjectForKey:downloadUrl];
        downloader = nil;
        failed(sticker,index);

    }];

}


- (void)downloadStickers:(NSArray *)stickers withAnimation:(void(^)(NSInteger index))animating successed:(void(^)(KWSticker *sticker,NSInteger index))success failed:(void(^)(KWSticker *sticker,NSInteger index))failed
{

    for (KWSticker *sticker in stickers) {
        if (sticker.isDownload == NO && sticker.downloadState == KWStickerDownloadStateDownoadNot) {
            sticker.downloadState = KWStickerDownloadStateDownoading;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self downloadSticker:sticker index:[stickers indexOfObject:sticker] withAnimation:^(NSInteger index) {
                    
                    animating([stickers indexOfObject:sticker]);
                    
                } successed:^(KWSticker *sticker, NSInteger index) {
                    success(sticker,index);

                } failed:^(KWSticker *sticker, NSInteger index) {
                    failed(sticker,index);

                }];
                
                
            });
        }
    }
    
    
}


@end
