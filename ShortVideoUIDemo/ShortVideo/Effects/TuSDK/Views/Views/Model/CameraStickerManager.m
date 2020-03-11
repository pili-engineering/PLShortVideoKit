//
//  CameraStickerManager.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/8/24.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CameraStickerManager.h"

@interface CameraStickerManager ()

@property (nonatomic, strong) NSArray<StickerCategory *> *stickerCategorys;

@end

@implementation CameraStickerManager

static id _sharedInstance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance commonInit];
    });
    return _sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [super allocWithZone:zone];
        }
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void)commonInit {}

- (void)reloadData {
    _stickerCategorys = nil;
}

#pragma mark - property

/**
 贴纸分类

 @return 贴纸的分类
 */
- (NSArray *)stickerCategorys {
    if (!_stickerCategorys) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"customStickerCategories" ofType:@"json"];
        _stickerCategorys = [StickerCategory stickerCategoriesWithJsonPath:jsonPath];
    }
    return _stickerCategorys;
}

@end
