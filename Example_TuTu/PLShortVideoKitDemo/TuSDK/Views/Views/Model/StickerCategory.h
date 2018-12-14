//
//  StickerCategory.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TuSDKPFStickerGroup;

/**
 贴纸自定义分类模型
 */
@interface StickerCategory : NSObject

/**
 分类名称
 */
@property (nonatomic, copy) NSString *name;

/**
 分类贴纸
 */
@property (nonatomic, strong) NSArray<TuSDKPFStickerGroup *> *stickers;

/**
 读取本地贴纸，并从给定的 json 路径中读取生成贴纸分类列表

 @param jsonPath json 数据路径
 @return json 数据对应的贴纸
 */
+ (NSArray<StickerCategory *> *)stickerCategoriesWithJsonPath:(NSString *)jsonPath;

@end

#pragma mark - 支持的 json 配置格式

// 示例配置
// {
//     "categories":
//     [
//         {
//             "categoryName": "分类名称0", // 分类名称
//             "stickers": // 贴纸数组，支持本地贴纸和在线贴纸
//             [
//                 { // 在线贴纸示例，需配置 `name`、`id`、`previewImage`
//                     // 贴纸名称
//                     "name": "贴纸0",
//                     // 贴纸唯一 ID
//                     "id": "1024",
//                     "previewImage": "https://img.tusdk.com/api/stickerGroup/img?id=stickerID" // 贴纸预览图 URL
//                 },
//                 { // 本地贴纸配置示例，只需配置 `id`
//                     "id": "1048576" // 本地贴纸对应的 ID
//                 }
//             ]
//         },
//         { // 其他分类配置以此类推
//             "categoryName": "分类名称1",
//             "stickers":
//             [
//                 {
//                     "id": "2048"
//                 },
//                 {
//                     "id": "512"
//                 }
//             ]
//         }
//     ]
// }
