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

@end

@implementation PLSFilterGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorFilterArray = [[NSMutableArray alloc] init];
        _filtersInfo = [[NSMutableArray alloc] init];
        
        [self setFilterModeOn:YES];
    }
    return self;
}

- (PLSFilter *)currentFilter {
    return _colorFilterArray[_filterIndex];
}

- (void)setFilterModeOn:(BOOL)filterModeOn {
    [self loadFilters];
    
    if (_colorFilterArray) {
        [_colorFilterArray removeAllObjects];
    }
    
    // WARNINGS:
    // 为防止 dispatch_async 异步操作导致 _colorFilterArray 为空，进而导致 -[__NSArrayM objectAtIndex:] crash
    // 先给 _colorFilterArray 填充1个元素，该元素对应的滤镜为 normal
    NSString *colorImagePath = [_filtersInfo[0] objectForKey:@"colorImagePath"];
    PLSFilter *filter = [[PLSFilter alloc] initWithColorImagePath:colorImagePath];
    [_colorFilterArray addObject:filter];
    
    // 从 1 开始取元素直至 count - 1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 1; i < _filtersInfo.count; i++) {
            NSString *colorImagePath = [_filtersInfo[i] objectForKey:@"colorImagePath"];
            PLSFilter *filter = [[PLSFilter alloc] initWithColorImagePath:colorImagePath];
            [_colorFilterArray addObject:filter];
        }
    });
}

- (void)loadFilters {
    if (_filtersInfo) {
        [_filtersInfo removeAllObjects];
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
        
        NSDictionary *dic = @{
                              @"name"            : name,
                              @"dir"             : dir,
                              @"coverImagePath"  : coverImagePath,
                              @"colorImagePath"  : colorImagePath
                              };
        [_filtersInfo addObject:dic];
    }
    
}

- (void)dealloc {
    _colorFilterArray = nil;
    _filtersInfo = nil;
}

@end


