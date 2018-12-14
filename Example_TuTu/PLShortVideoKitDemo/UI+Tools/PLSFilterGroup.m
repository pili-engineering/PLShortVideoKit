//
//  PLSFilterGroup.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/7/4.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSFilterGroup.h"

@interface PLSFilterGroup ()

@property (strong, nonatomic) NSMutableArray *colorFilterArray;

/**
 @abstract 将图片作为滤镜封面
 */
@property (strong, nonatomic) UIImage *coverImage;

@end

@implementation PLSFilterGroup
@synthesize filterIndex = _filterIndex;
@synthesize colorImagePath = _colorImagePath;

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

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorFilterArray = [[NSMutableArray alloc] init];
        _filtersInfo = [[NSMutableArray alloc] init];
        self.currentFilter = [[PLSFilter alloc] init];
        
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

- (void)dealloc {
    _colorFilterArray = nil;
    _filtersInfo = nil;
    self.currentFilter = nil;
}

@end


