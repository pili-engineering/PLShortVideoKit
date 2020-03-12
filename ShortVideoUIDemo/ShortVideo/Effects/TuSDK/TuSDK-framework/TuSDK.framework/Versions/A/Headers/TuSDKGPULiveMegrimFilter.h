//
//  TuSDKGPULiveMegrimFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/12/11.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/** Live Megrim Filter*/
@interface TuSDKGPULiveMegrimFilter : SLGPUImageFilterGroup

/**
 启用隔离滤镜
 @since 2.2.0
 */
- (void)enableSeprarate;

/**
 *  初始化
 *
 *  @param option TuSDKFilterOption
 *
 *  @return instancetype
 */
- (instancetype)initWithOption:(TuSDKFilterOption *)option;
@end
