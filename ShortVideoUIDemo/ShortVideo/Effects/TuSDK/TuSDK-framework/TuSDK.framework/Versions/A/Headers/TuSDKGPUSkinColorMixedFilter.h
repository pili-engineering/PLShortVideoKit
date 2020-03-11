//
//  TuSDKGPUSkinColorMixedFilter.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 24/11/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//


#import "TuSDKFilterAdapter.h"

/**
 *  肤色调整，在美颜滤镜中使用
 */
@interface TuSDKGPUSkinColorMixedFilter : TuSDKThreeInputFilter

/** The strength of the sharpening, from 0.0 on up, with a default of 1.0 */
@property(readwrite, nonatomic) CGFloat intensity;

/** 亮部细节 取值范围 [0-1] 值越大细节越少 默认0.22 */
@property (nonatomic) CGFloat lightLevel;

/** 细节保留 取值范围 [0-1] 值越大细节越多 默认0.7 */
@property (nonatomic) CGFloat detailLevel;

/** 开启皮肤检测 0关闭， 大于0开启*/
- (void)setEnableSkinColorDetection:(CGFloat)newValue;

@end
