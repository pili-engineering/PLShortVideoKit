//
//  TuSDKGPULightGlareFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/17.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/**
 *  眩光混合
 */
@interface TuSDKGPULightGlareFilter : TuSDKTwoInputFilter<TuSDKFilterParameterProtocol>
/**
 *  混合 (设值范围0.0-1.0)
 */
@property(readwrite, nonatomic) CGFloat mix;
@end
