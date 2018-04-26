//
//  TuSDKTSALAssetsGrouped.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/1.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTSAsset.h"

/**
 *  相片创建时间倒序分组
 */
@interface TuSDKTSALAssetsGroupedCTD : NSObject{
    @protected
    /**
     *  相片列表
     */
    NSArray<TuSDKTSAssetInterface> *_assets;

    /**
     *  分组列表
     */
    NSMutableArray *_sections;

    /**
     *  分组数据
     */
    NSMutableArray<NSMutableArray<TuSDKTSAssetInterface> *> *_items;
}

/**
 *  照片总数
 */
@property (nonatomic, readonly) NSUInteger count;

/**
 *  分组列表
 */
@property (nonatomic, readonly) NSArray *sections;

/**
 *  分组数据
 */
@property (nonatomic, readonly) NSArray<NSArray<TuSDKTSAssetInterface> *> *items;
/**
 *  创建相片时间分组
 *
 *  @param assetsGroup 相册组
 *
 *  @return 相册组相片时间分组
 */
+ (instancetype)groupedWithAssetsGroup:(id<TuSDKTSAssetsGroupInterface>)group;

/**
 *  创建相片时间分组
 *
 *  @param assets 相片列表
 *
 *  @return 相册组相片时间分组
 */
+ (instancetype)groupedWithAssets:(NSArray<TuSDKTSAssetInterface> *)assets;

/**
 *  获取组内有多少行数据
 *
 *  @param section 组索引
 *  @param limit   每行最多允许个数
 *
 *  @return 组内有多少行数据
 */
- (NSUInteger)countRowInSection:(NSInteger)section withLimit:(NSUInteger)limit;

/**
 *  获取组内行数据
 *
 *  @param indexPath 表格索引
 *  @param limit     每行最多允许个数
 *
 *  @return 组内行数据
 */
- (NSArray<TuSDKTSAssetInterface> *)rowDatasIndexPath:(NSIndexPath *)indexPath withLimit:(NSUInteger)limit;
@end
