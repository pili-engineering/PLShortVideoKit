//
//  KWSticker.m
//  KWMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/10/14.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "KWSticker.h"

#include <OpenGLES/ES2/gl.h>

@interface KWStickerItem ()

@property (nonatomic, strong) UIImage *currentFrame;


/**
counter
 */

@property (nonatomic) NSTimeInterval interval;

@end

@implementation KWStickerItem
{
    NSArray *_imageFileURLs;
//    NSMutableDictionary *_imagesDict;
    
    GLuint *_textureArr;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.type = [[dict objectForKey:@"type"] intValue];
        self.trigerType = [[dict objectForKey:@"trigerType"] intValue];
        
        self.itemDir = [dict objectForKey:@"frameFolder"];
        self.count = [[dict objectForKey:@"frameNum"] intValue];
        self.duration = [[dict objectForKey:@"frameDuration"] doubleValue] / 1000.;
        self.width = [[dict objectForKey:@"frameWidth"] floatValue];
        self.height = [[dict objectForKey:@"frameHeight"] floatValue];
        
        self.position = [[dict objectForKey:@"facePos"] intValue];
        self.alignPos = [[dict objectForKey:@"alignPos"] intValue];
        
        self.scaleWidthOffset = [[dict objectForKey:@"scaleWidthOffset"] floatValue];
        self.scaleHeightOffset = [[dict objectForKey:@"scaleHeightOffset"] floatValue];
        self.scaleXOffset = [[dict objectForKey:@"scaleXOffset"] floatValue];
        self.scaleYOffset = [[dict objectForKey:@"scaleYOffset"] floatValue];
        
        self.accumulator = 0.;
        self.currentFrameIndex = 0;
        self.loopCountdown = NSIntegerMax;
        //        selfalloc.interval = self.duration / self.count;
    }
    
    return self;
}

- (UIImage *)currentFrame
{
    return [self _imageAtIndex:self.currentFrameIndex];
}

- (UIImage *)nextImageForInterval:(NSTimeInterval)interval
{
    if (self.loopCountdown == 0) {
        return self.currentFrame;
    }
    
    self.currentFrameIndex = [self _nextFrameIndexForInterval:interval];
    
    return [self _imageAtIndex:self.currentFrameIndex];
}

- (NSUInteger)_nextFrameIndexForInterval:(NSTimeInterval)interval
{
    
    
    // This is where FLAnimatedImage loads the GIF

    NSUInteger nextFrameIndex = self.currentFrameIndex;
    self.accumulator += interval;
    
//    if (self.isLastItem && self.loopCountdown == 0) {
//        
//        if (interval > (self.count -1) * self.duration) {
//            if (self.stickerItemPlayOver) {
//                self.stickerItemPlayOver();
//            }
//        }
//        //                    NSLog(@"self.isLastItem:%d",self.isLastItem);
//    }
    
    
    while (self.accumulator > self.duration) {
        self.accumulator -= self.duration;
        nextFrameIndex++;
        if (nextFrameIndex >= self.count) {
            // If we've looped the number of times that this animated image describes, stop looping.
            self.loopCountdown--;
            
            if (self.loopCountdown == 0) {
                if (self.isLastItem && self.stickerItemPlayOver) {
                        self.stickerItemPlayOver();
                }
                nextFrameIndex = self.count - 1;
//                self.accumulator = 0;
//                nextFrameIndex = 0;
                break;
            } else {
                nextFrameIndex = 0;
            }
        }
    }
    
    return nextFrameIndex;
}

- (UIImage *)_imageAtIndex:(NSUInteger)index
{
    if (_imageFileURLs.count <= 0) {
        [self _loadImages];
    }
    
    return [UIImage imageWithContentsOfFile:[[_imageFileURLs objectAtIndex:index] path]];
}

- (void)_loadImages
{
    NSURL *diskCacheURL = [NSURL fileURLWithPath:self.itemDir isDirectory:YES];
    NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLNameKey];
    
    // First get the cache file related properties
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:diskCacheURL
                                                                 includingPropertiesForKeys:resourceKeys
                                                                                    options:NSDirectoryEnumerationSkipsSubdirectoryDescendants  | NSDirectoryEnumerationSkipsHiddenFiles
                                                                               errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
                                                                                   NSLog(@"error: %@", error);
                                                                                   return NO;
                                                                               }];
    
    NSMutableDictionary *imageFiles = [NSMutableDictionary dictionary];
    
    //Traverse all the files in the directory
    for (NSURL *fileURL in fileEnumerator) {
        NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
        if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
            continue;
        }
        
        [imageFiles setObject:resourceValues forKey:fileURL];
    }
    
    _imageFileURLs = [imageFiles keysSortedByValueWithOptions:NSSortConcurrent
                                              usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                  return [obj1[NSURLNameKey] compare:obj2[NSURLNameKey] options:NSNumericSearch];
                                              }];
}

- (GLuint)_textureWithImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    NSAssert(imageRef, @"Failed to load image.");
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    GLubyte *imageData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(imageData, width, height, 8, width * 4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(spriteContext);
    
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    free(imageData);
    
    return texture;
}

- (GLuint)_textureAtIndex:(NSUInteger)index
{
    if (_textureArr == NULL) {
        _textureArr = malloc(sizeof(GLuint) * self.count);
        if (_textureArr == NULL) {
            // 分配内存失败
            return 0;
        }
        
        for (int i = 0; i < self.count; i++) {
            _textureArr[i] = 0;
        }
    }
    
    GLuint texture = _textureArr[index];
    if (texture == 0) {
        texture = [self _textureWithImage:[self _imageAtIndex:index]];
        _textureArr[index] = texture;
    }
    
    return texture;
}

- (GLuint)nextTextureForInterval:(NSTimeInterval)interval
{
    self.currentFrameIndex = [self _nextFrameIndexForInterval:interval];
    
    return [self _textureAtIndex:self.currentFrameIndex];
}

- (void)deleteTextures
{
    if (_textureArr) {
        glDeleteTextures((GLsizei)self.count, _textureArr);
        free(_textureArr);
        _textureArr = NULL;
    }
}

- (void)dealloc
{
    [self deleteTextures];
}


@end


@implementation KWSticker

- (instancetype)initWithName:(NSString *)name thumbName:(NSString *)thumb download:(BOOL)download DirectoryURL:(NSURL *)dirurl
{
    if (self = [super init]) {
        if (self.playStickerCount == 0) {
            self.playStickerCount = NSIntegerMax;
        }
        
        _stickerName = name;
        _stickerIcon = thumb;
        _isDownload = download;
        _downloadState = KWStickerDownloadStateDownoadNot;
        _stickerDir = nil;
        _stickerSound = nil;
        _items = nil;
        //Unloaded items do not initialize items, stickerDir, stickerSound, and so on
        if (download == YES) {
            NSString *dir = dirurl.path;
            _stickerDir = dir;
            _downloadState = KWStickerDownloadStateDownoadDone;
            NSString *configFile = [dir stringByAppendingPathComponent:@"config.json"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:configFile isDirectory:NULL]) {
                [KWSticker resetSticker:self];
                return self;
            }
            
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfFile:configFile];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([dict objectForKey:@"soundName"]) {
                _stickerSound = dict[@"soundName"];
            }
            if (error || !dict) {
                _isDownload = NO;
                return self;
            }
            
            NSArray *itemsDict = [dict objectForKey:@"itemList"];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemsDict.count];
            
            NSInteger itemsFrameNum = 0;
            KWStickerItem *itemCopy;
            for (NSDictionary *itemDict in itemsDict) {
                KWStickerItem *item = [[KWStickerItem alloc] initWithJSONDictionary:itemDict];
                
                
                if (item.count >= itemsFrameNum) {
                    itemsFrameNum = item.count;
                    itemCopy = item;
                }
                item.itemDir = [_stickerDir stringByAppendingPathComponent:item.itemDir];
                item.loopCountdown = self.playStickerCount;
                NSArray *dirArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:item.itemDir error:NULL];
                NSInteger fileCount = dirArr.count;
                
                for (NSString *fileName in dirArr) {
                    if (![fileName hasSuffix:@".png"]) {
                        fileCount --;
                    }
                }
                
                //Check the sticker file for missing stickers
                if (fileCount != [[itemDict objectForKey:@"frameNum"] intValue]) {
                    [KWSticker resetSticker:self];
//                    break;
                    return self;
                }
                
                [items addObject:item];
            }
            itemCopy.isLastItem = YES;
            
            _items = items;
            
        }
    }
    return self;
}

-(void)setSourceType:(KWStickerSourceType)sourceType
{
    _sourceType = sourceType;
    if (sourceType == KWStickerSourceTypeFromKW) {
        // if you want to use Kiwi's downloadURL, you donot need to do anything
        _downloadURL = nil;
    }else if(sourceType == KWStickerSourceTypeFromLocal){
        
        // you can set your own downURL here
        _downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://在这拼接下载的URL%@.zip",_stickerName]];
    }
    
}

+ (void)updateStickerAfterDownload:(KWSticker *)sticker DirectoryURL:(NSURL *)dirurl sucess:(void(^)(KWSticker *))sucessed fail:(void(^)(KWSticker *))failed
{
    if (sticker.playStickerCount == 0) {
        sticker.playStickerCount = NSIntegerMax;
    }
    
    sticker.isDownload = YES;
    NSString *dir = dirurl.path;
    sticker.stickerDir = dir;
    NSString *configFile = [dir stringByAppendingPathComponent:@"config.json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configFile isDirectory:NULL]) {
        [self resetSticker:sticker];
        failed(sticker);
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:configFile];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([dict objectForKey:@"soundName"]) {
        sticker.stickerSound = dict[@"soundName"];
    }
    if (error || !dict) {
        [self resetSticker:sticker];
        failed(sticker);
    }
    
    NSArray *itemsDict = [dict objectForKey:@"itemList"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemsDict.count];
    
    NSInteger itemsFrameNum = 0;
    KWStickerItem *itemCopy;
    for (NSDictionary *itemDict in itemsDict) {
        KWStickerItem *item = [[KWStickerItem alloc] initWithJSONDictionary:itemDict];
        if (item.count >= itemsFrameNum) {
            itemsFrameNum = item.count;
            itemCopy = item;
        }
        item.itemDir = [sticker.stickerDir stringByAppendingPathComponent:item.itemDir];
        item.loopCountdown = sticker.playStickerCount;
        NSArray *dirArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:item.itemDir error:NULL];
        NSInteger fileCount = dirArr.count;
        
        for (NSString *fileName in dirArr) {
            if (![fileName hasSuffix:@".png"]) {
                fileCount --;
            }
        }
        
        //Check the sticker file for missing stickers
        if (fileCount != [[itemDict objectForKey:@"frameNum"] intValue]) {
            
            [self resetSticker:sticker];
            failed(sticker);
            
            break;
        }
        
        
        [items addObject:item];
    }
    itemCopy.isLastItem = YES;
    sticker.items = items;
    
    sucessed(sticker);
}

- (void)setPlayCount:(NSUInteger)count
{
    self.playStickerCount = count;
    for (KWStickerItem *item in _items) {
        item.loopCountdown = count;
        if (count == 0) {
            item.accumulator = 0;
            item.currentFrameIndex = 0;
        }
    }
}

+ (void)resetSticker:(KWSticker *)sticker
{
    [[NSFileManager defaultManager] removeItemAtPath:sticker.stickerDir error:NULL];
    sticker.stickerDir = nil;
    sticker.downloadState = KWStickerDownloadStateDownoadNot;
    sticker.isDownload = NO;
    sticker.stickerSound = nil;
    sticker.items = nil;
    
}

- (void)dealloc
{
    for (KWStickerItem *item in _items) {
        [item deleteTextures];
    }
    _items = nil;
}

@end

