//
//  TuSDKStickerText.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/2.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "TuSDKDataJson.h"

/**
 *  贴纸文字类型
 */
typedef NS_ENUM(NSInteger, lsqStickerTextType)
{
    /**
     * 默认文字类型
     */
    lsqStickerTextDefault = 1,
    /**
     * 时间信息 09:38
     */
    lsqStickerTextTime = 2,
    /**
     * 日期信息 29/05/2014
     */
    lsqStickerTextDate = 3,
    /**
     * 日期时间信息 29/05/2014 09:38
     */
    lsqStickerTextDateTime = 4,
    /**
     * 地理信息
     */
    lsqStickerTextLocal = 5,
    /**
     * 天气信息
     */
    lsqStickerTextWeather = 6,
};

/**
 *  贴纸文字
 */
@interface TuSDKPFStickerText : TuSDKDataJson
/**
 * 贴纸ID
 */
@property (nonatomic) uint64_t idt;

/**
 * 贴纸ID
 */
@property (nonatomic) uint64_t stickerId;

/**
 * 贴纸包ID
 */
@property (nonatomic) uint64_t groupId;

/**
 * 贴纸分类ID
 */
@property (nonatomic) uint64_t categoryId;

/**
 *  贴纸文字类型
 */
@property (nonatomic, readonly) lsqStickerTextType type;

/**
 * 文字信息
 */
@property (nonatomic, copy) NSString *text;

/**
 * 文字样式
 */
@property (nonatomic, copy) NSDictionary *textStyleDic;

/**
 * 文字颜色
 */
@property (nonatomic, retain) UIColor *color;

/**
 * 文字阴影颜色
 */
@property (nonatomic, retain) UIColor *shadowColor;

/**
 * 文字大小 (单位:SP)
 */
@property (nonatomic) CGFloat size;

/**
 * 文字区域位置长宽百分比信息
 */
@property (nonatomic) CGRect rect;

/**
 * 文字区域长宽信息
 */
@property (nonatomic) CGSize rectSize;

/**
 * 文字对齐方式 (0:左对齐, 1:居中对齐, 2:右对齐)
 */
@property (nonatomic) NSTextAlignment alignment;

/**
 * 文字区域生成的图片，优先使用图片，为nil 时，使用参数进行绘制
 */
@property (nonatomic) UIImage *textImage;

/**
 *  贴纸文字对象
 *
 *  @return 贴纸文字对象
 */
+ (instancetype)textWithType:(lsqStickerTextType)type;

/**
 *  复制数据
 *
 *  @return 贴纸文字
 */
- (instancetype) copy;
@end
