//
//  TuSDKGPULivePullInFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/12/11.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"
#import "TuSDKGPULiveTransitionFilterProtocol.h"


/**
 转场PullIn的类型
 @since v3.4.1
 */
typedef NS_ENUM(NSUInteger, TuSDKGPULivePullInFilterDirection) {
    /** 转场 - 右侧进入  @since v3.4.1 */
    TuSDKGPULivePullInFilterDirectionRight = 0,
    /** 转场 - 左侧进入  @since v3.4.1 */
    TuSDKGPULivePullInFilterDirectionLeft,
    /** 转场 - 顶部进入  @since v3.4.1 */
    TuSDKGPULivePullInFilterDirectionTop,
    /** 转场 - 底部进入  @since v3.4.1 */
    TuSDKGPULivePullInFilterDirectionBottom,

};


/**
 转场特效: 拉入
 
 @since 3.4.1
 */
@interface TuSDKGPULivePullInFilter : TuSDKFilter<TuSDKGPULiveTransitionFilterProtocol>


/**
 进入方向，默认右侧进入
 @since 3.4.1
 */
@property (nonatomic, assign) TuSDKGPULivePullInFilterDirection animationDirection;

@end
