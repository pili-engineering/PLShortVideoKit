//
//  QNFilterGroup.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/7/4.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNFilterGroup.h"

@interface QNFilterGroup ()

@property (nonatomic, strong) NSMutableArray *colorFilterArray;

/**
 @abstract 将图片作为滤镜封面
 */
@property (nonatomic, strong) UIImage *coverImage;

@end

@implementation QNFilterGroup
@synthesize filterIndex = _filterIndex;
@synthesize colorImagePath = _colorImagePath;

- (void)dealloc {
    _colorFilterArray = nil;
    _filtersInfo = nil;
    self.currentFilter = nil;
}

- (void)setFilterIndex:(NSInteger)filterIndex {
    _filterIndex = filterIndex;
    _colorImagePath = _colorFilterArray[filterIndex];
    self.currentFilter.colorImagePath = _colorImagePath;
}

- (NSInteger)filterIndex {
    return _filterIndex;
}

- (NSString *)colorImagePath {
    return _colorImagePath;
}

- (void)setNextFilterIndex:(NSInteger)nextFilterIndex {
    _nextFilterIndex = nextFilterIndex;
    self.nextFilter.colorImagePath = _colorFilterArray[nextFilterIndex];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorFilterArray = [[NSMutableArray alloc] init];
        _filtersInfo = [[NSMutableArray alloc] init];
        self.currentFilter = [[PLSFilter alloc] init];
        self.nextFilter = [[PLSFilter alloc] init];
        
        [self setupFilter];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)inputImage {
    self = [super init];
    if (self) {
        self.coverImage = inputImage;

        _colorFilterArray = [[NSMutableArray alloc] init];
        _filtersInfo = [[NSMutableArray alloc] init];
        self.currentFilter = [[PLSFilter alloc] init];
        self.nextFilter = [[PLSFilter alloc] init];

        [self setupFilter];
    }
    return self;
}

- (void)setupFilter {
    [self loadFilters:self.coverImage];
}

- (void)loadFilters:(UIImage *)inputImage {
    if (_filtersInfo) {
        [_filtersInfo removeAllObjects];
    }
    
    if (_colorFilterArray) {
        [_colorFilterArray removeAllObjects];
    }
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *filtersPath = [bundlePath stringByAppendingString:@"/PLShortVideoKit.bundle/colorFilter"];
    NSString *jsonPath = [filtersPath stringByAppendingString:@"/plsfilters.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"load internal filters json error: %@", error);
    
    NSArray *array = [dicFromJson objectForKey:@"filters"];

    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *filter = array[i];
        NSString *name = [filter objectForKey:@"name"];
        NSString *dir = [filter objectForKey:@"dir"];
        NSString *coverImagePath = [filtersPath stringByAppendingString:[NSString stringWithFormat:@"/%@/thumb.png", dir]];
        NSString *colorImagePath = [filtersPath stringByAppendingString:[NSString stringWithFormat:@"/%@/filter.png", dir]];
        
        UIImage *coverImage;
        if (self.coverImage) {
            coverImage = [PLSFilter applyFilter:self.coverImage colorImagePath:colorImagePath];
        } else {
            coverImage = [NSNull null];
        }

        NSDictionary *dic = @{
                              @"name"            : name,
                              @"dir"             : dir,
                              @"coverImagePath"  : coverImagePath,
                              @"colorImagePath"  : colorImagePath,
                              @"coverImage"      : coverImage
                              };
        [_filtersInfo addObject:dic];
        [_colorFilterArray addObject:colorImagePath];
    }
}

- (CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)originPixelBuffer
                           leftPercent:(float)leftPercent
                            leftFilter:(PLSFilter *)leftFilter
                           rightFilter:(PLSFilter *)rightFilter {
    
    leftPercent = MIN(1.0, MAX(0, leftPercent));

    if (leftPercent < FLT_EPSILON) {
        return [rightFilter process:originPixelBuffer];
    } else if (1 - leftPercent < FLT_EPSILON) {
        return [leftFilter process:originPixelBuffer];
    }
    
    CVPixelBufferRef leftPixelBuffer = [leftFilter process:originPixelBuffer];
    
    /*!
     注意：这里需要拷贝 leftPixelBuffer，否则在 release 模式下，会出现 leftPixelBuffer = rightPixelBuffer 的情况，既就是:
     
     CVPixelBufferRef leftPixelBuffer = [leftFilter process:originPixelBuffer];
     CVPixelBufferRef rightPixelBuffer = [rightFilter process:originPixelBuffer];
     
     由于 PLSRenderEngine 内部有对 buffer 的重复利用，这两次执行返回的是同一个 buffer，因此，在获取到一个 buffer 之后，需要将
     数据拷贝出来，否则就被第二次执行给覆盖掉
     */
    CVPixelBufferRef leftPixelBufferCopy = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             @{}, kCVPixelBufferIOSurfacePropertiesKey,
                             nil];
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault, CVPixelBufferGetWidth(leftPixelBuffer), CVPixelBufferGetHeight(leftPixelBuffer), CVPixelBufferGetPixelFormatType(leftPixelBuffer), (__bridge CFDictionaryRef _Nullable)(options), &leftPixelBufferCopy);
    if (kCVReturnSuccess != result) {
        NSLog(@"create pixel buffer error");
        return originPixelBuffer;
    }
    CVPixelBufferLockBaseAddress(leftPixelBuffer, 0);
    CVPixelBufferLockBaseAddress(leftPixelBufferCopy, 0);
    
    size_t bytePerRow = CVPixelBufferGetBytesPerRow(leftPixelBuffer);
    
    char *leftAddress = CVPixelBufferGetBaseAddress(leftPixelBuffer);
    char *leftAddressCopy = CVPixelBufferGetBaseAddress(leftPixelBufferCopy);
    
    size_t height = CVPixelBufferGetHeight(leftPixelBuffer);
    memcpy(leftAddressCopy, leftAddress, height * bytePerRow);
    
    CVPixelBufferUnlockBaseAddress(leftPixelBuffer, 0);
    CVPixelBufferUnlockBaseAddress(leftPixelBufferCopy, 0);

    CVPixelBufferRef rightPixelBuffer = [rightFilter process:originPixelBuffer];
    
    // copy BGRA32 data
    CVReturn result1 = CVPixelBufferLockBaseAddress(originPixelBuffer, 0);
    CVReturn result2 = CVPixelBufferLockBaseAddress(leftPixelBufferCopy, 0);
    CVReturn result3 = CVPixelBufferLockBaseAddress(rightPixelBuffer, 0);
    
    if (kCVReturnSuccess != result1 || result1 != result2 || result1 != result3 ||
        CVPixelBufferGetHeight(originPixelBuffer) != CVPixelBufferGetHeight(leftPixelBufferCopy) ||
        CVPixelBufferGetWidth(originPixelBuffer) != CVPixelBufferGetWidth(leftPixelBufferCopy) ||
        CVPixelBufferGetWidth(originPixelBuffer) != CVPixelBufferGetWidth(rightPixelBuffer) ||
        CVPixelBufferGetHeight(originPixelBuffer) != CVPixelBufferGetHeight(rightPixelBuffer) ||
        CVPixelBufferGetBytesPerRow(originPixelBuffer) != CVPixelBufferGetBytesPerRow(leftPixelBufferCopy) ||
        CVPixelBufferGetBytesPerRow(originPixelBuffer) != CVPixelBufferGetBytesPerRow(rightPixelBuffer)) {
        
        NSLog(@"filter data error");
        
        CVPixelBufferUnlockBaseAddress(originPixelBuffer, 0);
        CVPixelBufferUnlockBaseAddress(leftPixelBufferCopy, 0);
        CVPixelBufferUnlockBaseAddress(rightPixelBuffer, 0);

        CVPixelBufferRelease(leftPixelBufferCopy);
        return originPixelBuffer;
    }
    
    size_t width = CVPixelBufferGetWidth(originPixelBuffer);
    bytePerRow = CVPixelBufferGetBytesPerRow(originPixelBuffer);
    size_t leftPixel = round(leftPercent * width);
    size_t rightPixel = width - leftPixel;
    
    
    leftAddressCopy = CVPixelBufferGetBaseAddress(leftPixelBufferCopy);
    char *originAddress = CVPixelBufferGetBaseAddress(originPixelBuffer);
    char *rightAddress = CVPixelBufferGetBaseAddress(rightPixelBuffer);
    height = CVPixelBufferGetHeight(originPixelBuffer);
    for (int i = 0; i < height; i ++) {
        memcpy(originAddress + i * bytePerRow, leftAddressCopy + i * bytePerRow, leftPixel * 4);
        memcpy(originAddress + i * bytePerRow + leftPixel * 4, rightAddress + i * bytePerRow + leftPixel * 4, rightPixel * 4);
    }
    
    CVPixelBufferUnlockBaseAddress(originPixelBuffer, 0);
    CVPixelBufferUnlockBaseAddress(leftPixelBufferCopy, 0);
    CVPixelBufferUnlockBaseAddress(rightPixelBuffer, 0);
    
    CVPixelBufferRelease(leftPixelBufferCopy);
    
    return originPixelBuffer;
}

@end


