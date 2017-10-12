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
        
        [self setFilterModeOn:YES];
    }
    return self;
}

- (void)setFilterModeOn:(BOOL)filterModeOn {
    [self loadFilters];
    
    if (_colorFilterArray) {
        [_colorFilterArray removeAllObjects];
    }
    
    for (int i = 0; i < _filtersInfo.count; i++) {
        NSString *colorImagePath = [_filtersInfo[i] objectForKey:@"colorImagePath"];
        [_colorFilterArray addObject:colorImagePath];
    }
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
    self.currentFilter = nil;
}

@end


