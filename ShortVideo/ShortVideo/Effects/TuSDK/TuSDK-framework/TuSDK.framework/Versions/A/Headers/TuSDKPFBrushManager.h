//
//  TuSDKPFBrushManager.h
//  Mosaic
//
//  Created by Yanlin on 10/26/15.
//  Copyright © 2015 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFBrush.h"
#import "TuSDKConfig.h"

#pragma mark - TuSDKPFBrushManager
/**
 *  笔刷管理器
 */
@interface TuSDKPFBrushManager : NSObject

/**
 *  笔刷管理器
 *
 *  @return 笔刷管理器
 */
+ (instancetype) manager;

/**
 *  笔刷管理器
 *
 *  @param config Sdk配置
 *
 *  @return 笔刷管理器
 */
+ (instancetype)initWithConfig:(TuSDKConfig *)config;

/**
 *  是否已初始化
 */
@property (nonatomic, readonly) BOOL isInited;

/**
 *  笔刷代号列表
 */
@property (nonatomic, readonly) NSArray *brushCodes;

/**
 *  获取笔刷对象
 *
 *  @param code 笔刷代号
 *
 *  @return 笔刷对象
 */
- (TuSDKPFBrush *)brushWithCode:(NSString *)code;

@end
