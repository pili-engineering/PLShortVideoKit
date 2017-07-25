//
//  KWStickerManager.m
//  KWMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/10/13.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "KWPresentStickerManager.h"

@implementation KWPresentStickerManager
{
    dispatch_queue_t _ioQueue;
    NSString *_stickerPath;
    NSMutableArray * _stickerNames;
    NSMutableArray *stickers_json;
}

+ (instancetype)sharedManager
{
    static id _stickersManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stickersManager = [KWPresentStickerManager new];
    });
    
    return _stickersManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("com.sobrr.stickers", DISPATCH_QUEUE_SERIAL);
        _stickerPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"stickers"];
        
        //To determine whether there stickers folder, if it does not exist, create a folder
        if (![[NSFileManager defaultManager]fileExistsAtPath:_stickerPath]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:_stickerPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
    }
    return self;
}


- (void)loadStickersWithCompletion:(void(^)(NSMutableArray<KWSticker *> *stickers))completion
{
    dispatch_async(_ioQueue, ^{
        
        if ([self getStickersFromJson]){
            
            completion(stickers_json);
            
        }
        
    });
}

//Update the download information for all stickers
- (void)updateConfigJSON
{
    
    NSDictionary *oldDict = [NSDictionary dictionaryWithContentsOfFile:[_stickerPath stringByAppendingPathComponent:@"stickers_gift.json"]];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc]init];
    NSMutableArray * newArr = [[NSMutableArray alloc]init];
    NSArray *oldArr = [oldDict objectForKey:@"stickers"];
    for (NSDictionary *itemDict in oldArr) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        dic[@"name"] = [itemDict valueForKey:@"name"];
        dic[@"dir"] = [itemDict valueForKey:@"dir"];
        dic[@"category"] = [itemDict valueForKey:@"category"];
        dic[@"thumb"] = [itemDict valueForKey:@"thumb"];
        dic[@"voiced"] = [itemDict valueForKey:@"voiced"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[_stickerPath stringByAppendingPathComponent:[itemDict valueForKey:@"dir"]]]) {
            
            dic[@"downloaded"] = [NSNumber numberWithBool:YES];
        }else{
            
            dic[@"downloaded"] = [NSNumber numberWithBool:NO];
            
        }
        
        [newArr addObject:dic];
        
        
    }
    
    newDict[@"stickers"] = newArr;
    
    [newDict writeToFile:[_stickerPath stringByAppendingPathComponent:@"stickers_gift.json"] atomically:NO];
    
    
}


- (BOOL)getStickersFromJson
{
    BOOL isLoadSuccess = NO;
    
    // Read the config file in the resource directory
    NSString *configPath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"stickers_gift.json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:configPath isDirectory:NULL]) {
        NSLog(@"The general configuration file for the sticker in the resource directory does not exist");
        return isLoadSuccess;
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *oldDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || !oldDict) {
        NSLog(@"Resource directory under the general configuration file to read the stickers failed:%@",error);
        return isLoadSuccess;
    }
    
    //Copy the config file in the resource directory to the stickers folder in the document directory
    [oldDict writeToFile:[_stickerPath stringByAppendingPathComponent:@"stickers_gift.json"] atomically:NO];
    
    
    //拷贝本地贴纸到沙盒
    NSString *localPath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"stickers"];
    
    NSArray *dirArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath error:NULL];
    for (NSString *stickerName in dirArr) {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[_stickerPath stringByAppendingPathComponent:stickerName]]) {

            [[NSFileManager defaultManager] copyItemAtPath:[localPath stringByAppendingPathComponent:stickerName] toPath:[_stickerPath stringByAppendingPathComponent:stickerName] error:NULL];
            
        }
    }
    
     //Update the sticker download information first
    [self updateConfigJSON];
    
    NSDictionary *newDict = [NSDictionary dictionaryWithContentsOfFile:[_stickerPath stringByAppendingPathComponent:@"stickers_gift.json"]];
    
    NSArray *newArr = [newDict objectForKey:@"stickers"];
    
    
    
    stickers_json = [NSMutableArray arrayWithCapacity:newArr.count];
    
    
    //删除stickers.json中不存在的贴纸
    NSMutableArray *stickerNames = [NSMutableArray arrayWithCapacity:newArr.count];

    for (NSDictionary *itemDict in newArr) {
        [stickerNames addObject:[itemDict valueForKey:@"name"]];
    }
    [stickerNames addObject:@"stickers_gift.json"];
    
//    NSArray *existsFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_stickerPath error:NULL];

//    for (NSString *stickerName in existsFile) {
//        if (![stickerNames containsObject:stickerName]) {
//            NSLog(@"delete:%@",stickerName);
//            [[NSFileManager defaultManager] removeItemAtPath:[_stickerPath stringByAppendingPathComponent:stickerName] error:NULL];
//        }
//    }
    
    
    //遍历json返回sticker数组
    for (NSDictionary *itemDict in newArr) {
        
        NSString *dir = [NSString stringWithFormat:@"%@/%@/",localPath,[itemDict valueForKey:@"dir"]];
        NSURL *url = [NSURL fileURLWithPath:dir];
        
        KWSticker *sticker = [[KWSticker alloc]initWithName:[itemDict valueForKey:@"name"] thumbName:[itemDict valueForKey:@"thumb"] download:[[itemDict valueForKey:@"downloaded"] boolValue] DirectoryURL:url];
        
        if (sticker) {
            [stickers_json addObject:sticker];
        }
    }
    
    isLoadSuccess = YES;
    return isLoadSuccess;
}


- (NSString *)getStickerPath
{
    return _stickerPath;
}

@end
