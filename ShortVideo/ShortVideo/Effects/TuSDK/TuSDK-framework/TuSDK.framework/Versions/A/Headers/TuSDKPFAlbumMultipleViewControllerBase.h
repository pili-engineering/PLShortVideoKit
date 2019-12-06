//
//  TuSDKPFAlbumMultipleViewControllerBase.h
//  TuSDK
//
//  Created by Yanlin on 10/23/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPViewController.h"

@interface TuSDKPFAlbumMultipleViewControllerBase : TuSDKCPViewController

/**
 *  系统相册列表
 */
@property (nonatomic, retain) NSArray<TuSDKTSAssetsGroupInterface> *groups;

/**
 *  需要自动跳转到相册组名称
 */
@property (nonatomic, copy) NSString *skipAlbumName;

/**
 *  通知获取一个相册组
 *
 *  @param group 相册组
 */
- (void)notifySelectedGroup:(id<TuSDKTSAssetsGroupInterface>)group;

/**
 *  创建多选相册默认样式视图 (如需创建自定义视图，请覆盖该方法，并创建自己的视图类)
 */
- (void)buildAlbumMultipleView;

/**
 *  通知相册读取错误信息
 *
 *  @param error 错误信息
 */
- (void)notifyError:(NSError *)error;
@end
