//
//  PLSSourceAccessProtocol.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTypeDefines.h"

/*!
 @protocol PLSSourceAccessProtocol
 @brief 采集设备授权协议
 */
@protocol PLSSourceAccessProtocol <NSObject>

@required

/*!
 @method deviceAuthorizationStatus
 @brief 获取当前设备(相机 / 麦克风)的授权状态
 
 @return 当前设备(相机 / 麦克风)的授权状态
 */
+ (PLSAuthorizationStatus)deviceAuthorizationStatus;

/*!
 @method requestDeviceAccessWithCompletionHandler:
 @brief 请求当前设备(相机 / 麦克风)的访问权限
 
 @param handler 授权结果回调
 */
+ (void)requestDeviceAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

@end
