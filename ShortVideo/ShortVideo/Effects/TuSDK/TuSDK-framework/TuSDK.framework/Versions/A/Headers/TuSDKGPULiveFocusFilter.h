//
//  TuSDKGPULiveFocusFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/12/11.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"
#import "TuSDKGPULiveTransitionFilterProtocol.h"

/**
 转场特效: 聚焦
 
 @since 3.4.1
 */
@interface TuSDKGPULiveFocusFilter : TuSDKFilter<TuSDKGPULiveTransitionFilterProtocol>


/**
 扩张方式: [0 从里往外扩张] [1 从外往里收缩], 默认为0
 @since 3.4.1
 */
@property (nonatomic, assign) NSInteger animationFocusMode;

@end
