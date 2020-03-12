//
//  TuSDKPFBrush.h
//  TuSDK
//
//  Created by Yanlin on 10/28/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKDataJson.h"
#import "TuSDKPFBrushSize.h"

/**
 *  笔刷类型
 */
typedef NS_ENUM(NSInteger, lsqBrushType)
{
    /**
     * 橡皮擦类
     */
    lsqBrushEraser = 1,
    /**
     * 马赛克类
     */
    lsqBrushMosaic = 2,
    /**
     * 印记类
     */
    lsqBrushStamp = 3,
    /**
     * 在线商场
     */
    lsqBrushOnline = 4,
};

/**
 *  笔刷旋转类型
 */
typedef NS_ENUM(NSInteger, lsqBrushRotateType)
{
    /**
     * 不旋转
     */
    lsqBrushRotateNone = 1,
    /**
     * 自动跟随轨迹
     */
    lsqBrushRotateAuto = 2,
    /**
     * 随机角度
     */
    lsqBrushRotateRandom = 3,
    /**
     * 限定范围随机角度
     */
    lsqBrushRotateLimitRandom = 4,
};

/**
 *  笔刷位置分布类型
 */
typedef NS_ENUM(NSInteger, lsqBrushPositionType)
{
    /**
     * 自动跟随轨迹
     */
    lsqBrushPositionAuto = 1,
    /**
     * 轨迹四周随机分级
     */
    lsqBrushPositionRandom = 2,
};

/**
 *  笔刷尺寸类型
 */
typedef NS_ENUM(NSInteger, lsqBrushSizeType)
{
    /**
     * 外部设置
     */
    lsqBrushSizeAuto = 1,
    /**
     * 随机大小
     */
    lsqBrushSizeRandom = 2,
};

/**
 *  笔刷对象
 */
@interface TuSDKPFBrush : TuSDKDataJson

/**
 * 笔刷ID
 */
@property (nonatomic)uint64_t brushId;

/**
 * 笔刷包ID
 */
@property (nonatomic) uint64_t groupId;

/**
 * 笔刷代号
 */
@property (nonatomic, retain) NSString *code;

/**
 * 笔刷名称
 */
@property (nonatomic, retain) NSString *name;

/**
 * 外部预览图
 */
@property (nonatomic, retain) NSString *thumb;

/**
 * 预览图文件名
 */
@property (nonatomic, copy) NSString *thumbKey;

/**
 * 笔刷文件名
 */
@property (nonatomic, copy) NSString *brushImageKey;

/**
 * 笔刷类型
 */
@property (nonatomic) lsqBrushType brushType;

/**
 * 涂抹时旋转方式
 */
@property (nonatomic) lsqBrushRotateType rotateType;

/**
 * 涂抹时位置分布方式
 */
@property (nonatomic) lsqBrushPositionType positionType;

/**
 * 涂抹时笔触粗细
 */
@property (nonatomic) lsqBrushSizeType sizeType;

/**
 * 笔刷配置参数
 */
@property (nonatomic, retain) NSDictionary *args;

/**
 * 是否为内置笔刷
 */
@property (nonatomic) BOOL isInternal;

/**
 *  笔刷图片
 */
@property (nonatomic, retain) UIImage *image;

/**
 *  笔刷对象
 *
 *  @return 笔刷对象
 */
+ (TuSDKPFBrush *)brushWithType:(lsqBrushType)type;

/**
 *  获取语言资源名称
 *
 *  @return 获取语言资源名称
 */
- (NSString *)nameKey;

/**
 * 复制笔刷配置选项
 *
 * @return 笔刷对象
 */
- (TuSDKPFBrush *)copy;

@end
