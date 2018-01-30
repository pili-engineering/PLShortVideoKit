//
//  TuSDKPFCameraFilterGroupViewBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/9.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPGroupFilterBaseView.h"

/**
 *  相机滤镜视图基础类
 */
@interface TuSDKPFCameraFilterGroupViewBase : TuSDKCPGroupFilterBaseView
/**
 *  等待拍照状态激活秒 (默认：3秒)
 */
@property (nonatomic) CGFloat captureActivateWait;

/**
 *  选择一个滤镜组
 *
 *  @return 是否选中
 */
- (BOOL)onGroupFilterSelectedWithItem:(TuSDKCPGroupFilterItem *)item capture:(BOOL)capture;
@end