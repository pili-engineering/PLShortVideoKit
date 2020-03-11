//
//  TuSDKPFStickerLocalControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPViewController.h"
#import "TuSDKPFStickerGroup.h"

/**
 *  本地贴纸选择控制器基础类
 */
@interface TuSDKPFStickerLocalControllerBase : TuSDKCPViewController
/**
 * 贴纸分类列表
 */
@property (nonatomic, retain) NSArray *categories;

/**
 *  删除一组贴纸
 *
 *  @param group 贴纸分组对象
 */
- (void)removeWithStickerGroup:(TuSDKPFStickerGroup *)group;

/**
 *  重新加载贴纸
 */
- (void)reloadStickers;
@end
