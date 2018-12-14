//
//  TuSDKColorMixCoverFilter.h
//  TuSDK
//
//  Created by Yanlin Qiu on 20/04/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/**
 * 颜色混合肌理滤镜
 *
 */
@interface TuSDKColorMixCoverFilter : TuSDKThreeInputFilter<TuSDKFilterParameterProtocol>

/**
 混合色表 (设值范围0.0-1.0，原图默认值为0.0，越大效果越强)
 */
@property (nonatomic) float mixed;

/**
 混合肌理 (设值范围0.0-1.0，原图默认值为0.0，越大效果越强)
 */
@property (nonatomic) float cover;

@end
