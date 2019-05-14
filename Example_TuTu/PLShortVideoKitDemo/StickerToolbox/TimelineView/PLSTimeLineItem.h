//
//  PLSTimeLineItem.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2018/5/29.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLSTimeLineItemType){
    PLSTimeLineItemTypeDecal = 0,
    PLSTimeLineItemTypeDyImage,
    PLSTimeLineItemTypeGIFImage,
};

/**
 * timeline item 基础模型（适用于贴纸、字幕）
 */
@interface PLSTimeLineItem : NSObject

// 展示贴纸的 View
@property (nonatomic, weak) id target;
// 特效类型
@property (nonatomic, assign) PLSTimeLineItemType effectType;
// 开始时间
@property (nonatomic, assign) CGFloat startTime;
// 结束时间
@property (nonatomic, assign) CGFloat endTime;

@end


