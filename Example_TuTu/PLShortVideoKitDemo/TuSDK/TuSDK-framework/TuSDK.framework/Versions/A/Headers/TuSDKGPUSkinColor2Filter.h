//
//  TuSDKGPUSkinColor2Filter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/8/14.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/** 类美图磨皮算法 */
@interface TuSDKGPUSkinColor2Filter : SLGPUImageFilterGroup<TuSDKFilterParameterProtocol, TuSDKFilterTexturesProtocol>
/** 皮肤平滑度（默认0.5， 0 - 1, 越大越平滑） */
@property (nonatomic) CGFloat smoothing;
/** 混合 (设值范围0.0-1.0，原图默认值为0.0，越大效果越强) */
@property(readwrite, nonatomic) CGFloat mixed;

@end
