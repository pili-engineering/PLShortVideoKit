//
//  TuSDKPFFilterOnlineControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPOnlineController.h"
#import "TuSDKCPGroupFilterItemCellBase.h"

/**
 *  在线滤镜控制器基础类
 */
@interface TuSDKPFFilterOnlineControllerBase : TuSDKCPOnlineController

/**
 *  滤镜栏类型
 */
@property (nonatomic) lsqGroupFilterAction action;

/** 选中对象ID */
- (void)onHandleSelectedWithID:(uint64_t)idt;

/** 选中对象ID */
- (void)onHandleDetailWithID:(uint64_t)idt;
@end
