//
//  CameraStickerManager.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/8/24.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StickerCategory.h"

/**
 相机贴纸管理单例
 */
@interface CameraStickerManager : NSObject

/**
 读取本地贴纸，并从约定的 customStickerCategories.json 中读取生成贴纸分类列表
 */
@property (nonatomic, strong, readonly) NSArray<StickerCategory *> *stickerCategorys;

/**
 贴纸管理器

 @return 贴纸管理器
 */
+ (instancetype)sharedManager;

/**
 清空数据，下次访问 stickerCategorys，重新载入数据
 */
- (void)reloadData;

@end
