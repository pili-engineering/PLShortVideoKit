//
//  TuSDKCPFilterOnlineControllerInterface.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPGroupFilterItemCellBase.h"

@protocol TuSDKCPFilterOnlineControllerInterface;

#pragma mark - TuSDKCPFilterOnlineControllerDelegate
/**
 *  在线滤镜选择控制器委托
 */
@protocol TuSDKCPFilterOnlineControllerDelegate <NSObject>
/**
 *  选中一个滤镜对象
 *
 *  @param controller 在线滤镜选择控制器
 *  @param groupId    滤镜组ID
 */
- (void)onTuSDKStickerOnline:(UIViewController<TuSDKCPFilterOnlineControllerInterface> *)controller
             selectedGroupId:(uint64_t)groupId;
@end

#pragma mark - TuSDKCPFilterOnlineControllerInterface
/**
 *  在线滤镜控制器接口
 */
@protocol TuSDKCPFilterOnlineControllerInterface <NSObject>

/**
 *  在线滤镜选择控制器委托
 */
@property (nonatomic, weak) id<TuSDKCPFilterOnlineControllerDelegate> delegate;

/**
 *  滤镜栏类型
 */
@property (nonatomic) lsqGroupFilterAction action;

/**
 *  详细数据ID
 */
@property (nonatomic) uint64_t detailDataId;
@end
