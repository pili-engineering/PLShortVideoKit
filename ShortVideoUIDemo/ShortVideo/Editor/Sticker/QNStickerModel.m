//
//  QNStickerModel.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/28.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNStickerModel.h"


@interface QNStickerModel ()

@property (nonatomic, strong, readwrite) UIColor *randomColor;

@end

@implementation QNStickerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        uint32_t value = arc4random() % 8;
        if (0 == value) {
            self.randomColor = UIColor.magentaColor;
        } else if (1 == value) {
            self.randomColor = UIColor.grayColor;
        } else if (2 == value) {
            self.randomColor = UIColor.orangeColor;
        } else if (3 == value) {
            self.randomColor = UIColor.blueColor;
        } else if (4 == value) {
            self.randomColor = UIColor.greenColor;
        } else if (5 == value) {
            self.randomColor = UIColor.brownColor;
        } else if (6 == value) {
            self.randomColor = UIColor.cyanColor;
        } else if (7 == value) {
            self.randomColor = UIColor.yellowColor;
        }
        
        CGFloat r = 0;
        CGFloat g = 0;
        CGFloat b = 0;
        [self.randomColor getRed:&r green:&g blue:&b alpha:NULL];
        self.randomColor = [UIColor colorWithRed:r green:g blue:b alpha:.9];
        self.oneLoopDuration = kCMTimeZero;
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setPath:(NSString *)path {
    _path = path;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, nil);
    if (!imageSource) return;
    
    CGFloat totalDuration = 0;
    size_t imageCount = CGImageSourceGetCount(imageSource);
    
    for (int i = 0; i < imageCount; i ++) {
        
        CFDictionaryRef cfDic = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
        NSDictionary *properties = (__bridge NSDictionary *)cfDic;
        float frameDuration = [[[properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary]
                                objectForKey:(__bridge NSString *) kCGImagePropertyGIFUnclampedDelayTime] doubleValue];
        if (frameDuration < (1e-6)) {
            frameDuration = [[[properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary]
                              objectForKey:(__bridge NSString *) kCGImagePropertyGIFDelayTime] doubleValue];
        }
        if (frameDuration < (1e-6)) {
            frameDuration = 0.1;//如果获取不到，就默认 frameDuration = 0.1s
        }
        CFRelease(cfDic);
        totalDuration += frameDuration;
    }
    
    CFRelease(imageSource);
    
    self.oneLoopDuration = CMTimeMake(totalDuration * 1000, 1000);
    
    NSLog(@"ONE loop duration = %f", totalDuration);
}

@end
