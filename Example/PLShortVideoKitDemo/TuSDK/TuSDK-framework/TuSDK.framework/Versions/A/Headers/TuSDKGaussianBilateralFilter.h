//
//  TuSDKGaussianBilateralFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/8/27.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKGaussianBlurFiveRadiusFilter.h"
/** Bilateral Filter */
@interface TuSDKGaussianBilateralFilter : TuSDKGaussianBlurFiveRadiusFilter

/** A normalization factor for the distance between central color and sample color. */
@property(nonatomic, readwrite) CGFloat distanceNormalizationFactor;

/** 权重类别 [0.0 为原始双边，1.0 为仿花椒版美颜 */
@property(nonatomic, readwrite) CGFloat bilateralWeightType;

/**init On Performance*/
- (id)initOnPerformance;
@end
