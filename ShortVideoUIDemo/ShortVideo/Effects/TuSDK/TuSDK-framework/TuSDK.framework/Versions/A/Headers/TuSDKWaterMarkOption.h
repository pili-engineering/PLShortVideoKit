//
//  TuSDKWaterMarkOption.h
//  TuSDK
//
//  Created by Yanlin on 5/18/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  水印位置
 */
typedef NS_ENUM(NSInteger, lsqWaterMarkPosition)
{
    
    // 注：修改该枚举时，请注意，保证1~4之间为逆时针方向，改枚举的数值尽量不要修改，在 TuSDKVideoDataOutputBase 类 setWaterMarkPosition 方法中调整水印位置用到，通过数值和 视频方向进行了转换计算；若有修改 请注意需对应修改改计算
    
    /**
     *  左下角
     */
    lsqWaterMarkBottomLeft = 1,
    
    /**
     *  右下角
     */
    lsqWaterMarkBottomRight = 2,
    
    /**
     *  右上角
     */
    lsqWaterMarkTopRight = 3,

    /**
     *  左上角
     */
    lsqWaterMarkTopLeft = 4,
    

    /**
     *  居中
     */
    lsqWaterMarkCenter = 5,

    
    
};

/**
 *  水印文本位置： 文本 + 图片 | 图片 + 文本
 */
typedef NS_ENUM(NSInteger, lsqMarkTextPosition)
{
    /**
     *  左边
     */
    lsqMarkTextPositionLeft = 1,
    /**
     *  右边
     */
    lsqMarkTextPositionRight = 1 << 1,
};


/**
 *  水印配置
 */
@interface TuSDKWaterMarkOption : NSObject

/**
 *  水印位置 (默认: lsqWaterMarkBottomRight)
 */
@property (nonatomic, assign) lsqWaterMarkPosition markPosition;

/**
 *  水印文字
 */
@property (nonatomic) NSString *markText;

/**
 *  水印图片
 */
@property (nonatomic, retain) UIImage *markImage;

/**
 *  水印距离图片边距 (默认: 6dp)
 */
@property (nonatomic) CGFloat markMargin;

/**
 *  文字和图片顺序 (仅当图片和文字都非空时生效，默认: 文字在右)
 */
@property (nonatomic) lsqMarkTextPosition markTextPosition;

/**
 *  文字和图片间距 (默认: 2dp)
 */
@property (nonatomic) CGFloat markTextPadding;

/**
 * 文字大小 (默认: 24 SP)
 */
@property (nonatomic) CGFloat markTextSize;

/**
 *  文字背景色 (默认:[UIColor whiteColor])
 */
@property (nonatomic, retain) UIColor *markTextColor;

/**
 *  文字阴影颜色 (默认:[UIColor grayColor])
 */
@property (nonatomic, retain) UIColor *markTextShadowColor;

/**
 *  水印是否可用
 *
 *  @return BOOL
 */
- (BOOL)isValid;

@end
