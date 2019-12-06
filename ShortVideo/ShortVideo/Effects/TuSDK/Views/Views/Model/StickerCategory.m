//
//  StickerCategory.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "StickerCategory.h"
#import "OnlineStickerGroup.h"

static NSString * const kStickerIdKey = @"id";
static NSString * const kStickerNameKey = @"name";
static NSString * const kStickerPreviewImageKey = @"previewImage";
static NSString * const kStickerCategoryNameKey = @"categoryName";
static NSString * const kStickerCategoryStickersKey = @"stickers";
static NSString * const kStickerCategoryCategoriesKey = @"categories";

@interface StickerCategory ()

@end

@implementation StickerCategory

/**
 加载 json 数据中的贴纸

 @param jsonPath json 数据路径
 @return 贴纸
 */
+ (NSArray *)stickerCategoriesWithJsonPath:(NSString *)jsonPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:jsonPath]) {
        return nil;
    }
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:0 error:&error];
    if (error) {
        NSLog(@"sticker categories error: %@", error);
        return nil;
    }
    
    // 获取本地所有贴纸，并创建索引字典
    NSArray<TuSDKPFStickerGroup *> *allLocalStickers = [[TuSDKPFStickerLocalPackage package] getSmartStickerGroups];
    NSMutableDictionary *localStickerDic = [NSMutableDictionary dictionary];
    for (TuSDKPFStickerGroup *sticker in allLocalStickers) {
        localStickerDic[@(sticker.idt)] = sticker;
    }
    
    // 遍历 categories 字段的数组，其每个元素是字典
    NSArray *jsonCategories = jsonDic[kStickerCategoryCategoriesKey];
    NSMutableArray *stickerCategories = [NSMutableArray array];
    for (NSDictionary *categoryDic in jsonCategories) {
        StickerCategory *stickerCategory = [[StickerCategory alloc] init];
        stickerCategory.name = categoryDic[kStickerCategoryNameKey];
        
        // 通过 idt 进行筛选，若本地存在该贴纸，则使用本地的贴纸对象；否则为在线贴纸
        NSMutableArray *stickers = [NSMutableArray array];
        for (NSDictionary *stickerDic in categoryDic[kStickerCategoryStickersKey]) {
            NSInteger idt = [stickerDic[kStickerIdKey] integerValue];
            TuSDKPFStickerGroup *sticker = localStickerDic[@(idt)];
            if (sticker) {
                [stickers addObject:sticker];
            } else {
                OnlineStickerGroup *onlineSticker = [[OnlineStickerGroup alloc] init];
                sticker = onlineSticker;
                onlineSticker.idt = idt;
                onlineSticker.previewImage = stickerDic[kStickerPreviewImageKey];
                onlineSticker.name = stickerDic[kStickerNameKey];
                [stickers addObject:sticker];
            }
        }
        
        stickerCategory.stickers = stickers.copy;
        [stickerCategories addObject:stickerCategory];
    }
    return stickerCategories.copy;
}

@end
