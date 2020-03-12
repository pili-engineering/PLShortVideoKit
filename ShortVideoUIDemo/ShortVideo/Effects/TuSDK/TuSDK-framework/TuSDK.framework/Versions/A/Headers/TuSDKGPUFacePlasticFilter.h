//
//  TuSDKGPUFacePlasticFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/8/14.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/** 脸部整形滤镜 */
@interface TuSDKGPUFacePlasticFilter : TuSDKFilter<TuSDKFilterParameterProtocol, TuSDKFilterFacePositionProtocol>
/** 眼睛放大系数, from 0.0 on up, with a default of 1.0 */
@property(readwrite, nonatomic) CGFloat eyeEnlargeSize;
/** 瘦脸系数 (设值范围0.0-1.0，默认值为0.1，越大越瘦)*/
@property(readwrite, nonatomic) CGFloat chinSize;
/** 图片高宽比  height/width */
@property(readwrite, nonatomic) CGFloat screenRatio;
@end
