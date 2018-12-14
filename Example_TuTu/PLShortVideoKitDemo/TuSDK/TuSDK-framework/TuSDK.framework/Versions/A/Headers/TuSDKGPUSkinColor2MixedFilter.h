//
//  TuSDKGPUSkinColor2MixedFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/8/14.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"

/** 美图磨皮算法*/
@interface TuSDKGPUSkinColor2MixedFilter : TuSDKThreeInputFilter
/** 混合 (设值范围0.0-1.0，原图默认值为0.0，越大效果越强) */
@property(readwrite, nonatomic) CGFloat mixed;
/** The strength of the sharpening, from 0.0 on up, with a default of 1.0 */
@property(readwrite, nonatomic) CGFloat intensity;
/** 亮部细节 取值范围 [0-1.0] 值越小越亮 默认1.0 */
@property (nonatomic) CGFloat lightLevel;
/** 细节保留 取值范围 [0-1.0] 值越大细节越多 默认0.18 */
@property (nonatomic) CGFloat detailLevel;
@end
