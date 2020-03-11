//
//  TuSDKStickerCategory.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/2.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKPFStickerGroup.h"

/**
 *  贴纸分类扩展类型
 */
typedef NS_ENUM(NSInteger, lsqStickerCategoryExtendType)
{
    /**
     *  未知扩展
     */
    lsqStickerCategoryExtendUnknow,
    /**
     * 全部
     */
    lsqStickerCategoryExtendAll = 1,
    /**
     * 常用
     */
    lsqStickerCategoryExtendHistory = 2,
};

/**
 *  贴纸分类类型
 */
typedef NS_ENUM(NSInteger, lsqStickerCategoryType)
{
    /**
     * 智能贴纸
     */
    lsqStickerCategorySmart = 0,
    /**
     * 普通贴纸
     */
    lsqStickerCategoryOther = 1,
};

/**
 *  贴纸分类
 */
@interface TuSDKPFStickerCategory : TuSDKDataJson
/**
 * 贴纸分类ID
 */
@property (nonatomic) uint64_t idt;

/**
 * 贴纸分类名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 贴纸数据列表
 */
@property (nonatomic, retain) NSArray *datas;

/**
 *  贴纸分类扩展类型
 */
@property (nonatomic) lsqStickerCategoryExtendType extendType;

/**
 *  贴纸分类
 *
 *  @return 贴纸分类
 */
+ (instancetype)category;

/**
 *  贴纸分类
 *
 *  @return 贴纸分类
 */
+ (instancetype)categoryWithIdt:(uint64_t)idt title:(NSString *)title;

/**
 * 添加分类数据
 *
 * @param group 贴纸包
 */
- (void)appendGroup:(TuSDKPFStickerGroup *) group;

/**
 *  插入分类数据到第一个
 *
 *  @param group 贴纸包
 */
- (void)insertFirstWithGroup:(TuSDKPFStickerGroup *) group;

/**
 *  删除一个贴纸包
 *
 *  @param idt 贴纸包ID
 *
 *  @return 被删除的贴纸包
 */
- (TuSDKPFStickerGroup *)removeGroupWithID:(uint64_t)idt;

/**
 *  复制数据
 *
 *  @return 贴纸分类
 */
- (instancetype) copy;
@end
