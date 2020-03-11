//
//  TuSDKPFStickerFactory.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/9.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  贴纸工厂
 */
@interface TuSDKPFStickerFactory : NSObject
/**
 *  合并贴纸
 *
 *  @param stickers 贴纸列表
 *  @param image    源图
 *
 *  @return 合并贴纸后的图片
 */
+ (UIImage *)megerStickers:(NSArray *)stickers image:(UIImage *)image;
@end
