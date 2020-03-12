//
//  TuSDKGPUSkinColorFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/1.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/** 美白颜色滤镜*/
@interface TuSDKGPUSkinColorFilter : SLGPUImageFilterGroup<TuSDKFilterParameterProtocol, TuSDKFilterTexturesProtocol>

/** 皮肤平滑度（默认0.5， 0 - 1, 越大越平滑）*/
@property (nonatomic) CGFloat smoothing;

/** 混合 (设值范围0.0-1.0，原图默认值为0.0，越大效果越强)*/
@property(readwrite, nonatomic) CGFloat mixed;

@end
