//
//  TuSDKPFStickerOnlineControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPOnlineController.h"
#import "TuSDKPFSticker.h"

/**
 *  在线贴纸选择控制器委托基础类
 */
@interface TuSDKPFStickerOnlineControllerBase : TuSDKCPOnlineController
/** 选中对象 */
- (void)onHandleSelectedWithSticker:(TuSDKPFSticker *)sticker;

/** 选中对象ID */
- (void)onHandleDetailWithID:(uint64_t)idt;
@end
