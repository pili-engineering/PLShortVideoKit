//
//  TuSDKPFStickerResult.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/2.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKPFSticker.h"

/**
 *  贴纸结果
 */
@interface TuSDKPFStickerResult : NSObject
/**
 * 居中位置信息
 */
@property (nonatomic) CGRect center;

/**
 * 旋转度数
 */
@property (nonatomic) float degree;

/**
 * 贴纸元素
 */
@property (nonatomic, retain) TuSDKPFSticker *sticker;

/**
 *  初始化贴纸结果
 *
 *  @param sticker 贴纸元素
 *  @param center  居中位置信息
 *  @param degree  旋转度数
 *
 *  @return 贴纸结果
 */
+ (instancetype)initWithSticker:(TuSDKPFSticker *)sticker center:(CGRect)center degree:(float)degree;
@end
