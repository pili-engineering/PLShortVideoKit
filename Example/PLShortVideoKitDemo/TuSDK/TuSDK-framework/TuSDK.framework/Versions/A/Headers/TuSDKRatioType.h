//
//  TuSDKRatioType.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/2.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  裁剪比例
 */
typedef NS_ENUM(NSInteger, lsqRatioType)
{
    /**
     *  原始比例
     */
    lsqRatioOrgin = 1,
    /**
     *  1:1比例
     */
    lsqRatio_1_1 = 1 << 1,
    
    /**
     * 2:3比例
     */
    lsqRatio_2_3 = 1 << 2,
    
    /**
     * 3:4比例
     */
    lsqRatio_3_4 = 1 << 3,
    
    /**
     * 9:16比例
     */
    lsqRatio_9_16 = 1 << 4,
    
    /**
     * 3:2比例
     */
    lsqRatio_3_2 = 1 << 5,
    
    /**
     * 4:3比例
     */
    lsqRatio_4_3 = 1 << 6,

    /**
     * 16:9比例
     */
    lsqRatio_16_9 = 1 << 7,
    
    /**
     * 所有比例
     */
    lsqRatioAll = lsqRatioOrgin | lsqRatio_1_1 | lsqRatio_2_3 | lsqRatio_3_4 | lsqRatio_9_16 | lsqRatio_3_2 | lsqRatio_4_3 | lsqRatio_16_9,
    /**
     * 默认比例
     */
    lsqRatioDefault = lsqRatioOrgin | lsqRatio_1_1 | lsqRatio_2_3 | lsqRatio_3_4 | lsqRatio_9_16,
};

/**
 *  裁剪比例
 */
@interface TuSDKRatioType : NSObject
/**
 *  比例类型默认5列表
 */
+ (NSArray *)lsqTuSDKRatioDefaultTypes;

/**
 *  比例类型列表全部
 */
+ (NSArray *)lsqTuSDKRatioAllTypes;

/**
 * 获取比例
 *
 * @param ratio 比例类型 RatioType
 *
 * @return ratioType
 */
+ (float)ratio:(lsqRatioType)ratioType;

/**
 * 通过比例获取相近比例类型
 *
 * @param radioType
 * @return ratio
 */
+ (lsqRatioType)radioType:(float)ratio;

/**
 * 检测列表中的比例数据是否合法
 *
 * @param ratioTypes
 * @return types
 */
+ (NSArray<NSNumber *> *)validRatioTypes:(NSArray<NSNumber *> *)types;

/**
 * 获取第一个比例类型
 *
 * @param ratioType
 * @return ratioType
 */
+ (lsqRatioType)firstRatioType:(lsqRatioType)ratioType;

/**
 * 获取第一个比例
 *
 * @param firstRatio
 * @return ratioType
 */
+ (float) firstRatio:(lsqRatioType) ratioType;

/**
 * 获取比例总数
 *
 * @param ratioCount
 * @return ratioType
 */
+ (NSInteger) ratioCount:(lsqRatioType)ratioType;

/**
 *  获取比例类型列表
 *
 *  @param ratioType 比例类型
 *
 *  @return ratioTypes 比例类型列表
 */
+ (NSArray *)ratioTypes:(lsqRatioType)ratioType;

/**
 * 下一个比例类型
 *
 * @param ratioType 比例类型集合
 *
 * @param currentType 当前比例类型
 *
 * @return currentType
 */
+ (lsqRatioType) nextRatioType:(lsqRatioType)ratioType
                   currentType:(lsqRatioType) currentType;

/**
 * 下一个比例类型
 *
 * @param ratioType 比例类型集合
 *
 * @param currentType 当前比例类型
 *
 * @param ignoreType 需要忽略的比例类型
 *
 * @return nextType
 */
+ (lsqRatioType) nextRatioType:(lsqRatioType)ratioType
                   currentType:(lsqRatioType) currentType
                    ignoreType:(lsqRatioType)ignoreType;

/**
 *  获取比例动作类型
 *
 *  @param ratioType 比例类型
 *
 *  @return ratioType 比例动作类型
 */
+ (NSInteger) componentTypeWithRatioType:(lsqRatioType)ratioType;
@end
