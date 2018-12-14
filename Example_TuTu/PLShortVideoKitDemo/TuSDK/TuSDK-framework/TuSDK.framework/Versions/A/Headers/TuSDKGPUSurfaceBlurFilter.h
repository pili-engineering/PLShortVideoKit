//
//  TuSDKGPUSurfaceBlurFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/5/25.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKGaussianBlurFiveRadiusFilter.h"


/** 表面模糊滤镜 */
@interface TuSDKGPUSurfaceBlurFilter : TuSDKGaussianBlurFiveRadiusFilter

/** 模糊阈值 取值范围 [0-0.2] 值越大越模糊 默认0.14 */
@property(nonatomic, readwrite) CGFloat thresholdLevel;

/** 最大模糊半径 */
@property(nonatomic, readonly) CGFloat maxBlursize;

/** 最大模糊阈值 */
@property(nonatomic, readonly) CGFloat maxThresholdLevel;

/** init On Performance*/
- (id)initOnPerformance;
@end
