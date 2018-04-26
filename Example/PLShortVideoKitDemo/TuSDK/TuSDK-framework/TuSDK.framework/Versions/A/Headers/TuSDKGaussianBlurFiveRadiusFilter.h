//
//  TuSDKGaussianBlurFiveRadiusFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/5.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"

/**
 *  GaussianBlurFiveRadius
 */
@interface TuSDKGaussianBlurFiveRadiusFilter : TuSDKTwoPassTextureSamplingFilter
/**
 *  模糊范围 (从0.0开始，数值越大越模糊)
 */
@property (nonatomic) CGFloat blurSize;
@end
