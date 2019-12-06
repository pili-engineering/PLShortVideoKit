//
//  TuSDKGPUSkinNaturalFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2018/12/14.
//  Copyright © 2018 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

NS_ASSUME_NONNULL_BEGIN
/** 自然磨皮 */
@interface TuSDKGPUSkinNaturalFilter : SLGPUImageFilterGroup<TuSDKFilterParameterProtocol>
/** 皮肤平滑度（默认0.5， 0 - 1, 越大越平滑） */
@property (nonatomic) CGFloat smoothing;
/** 白皙（默认0.0， 0 - 1, 越大越白皙） */
@property (nonatomic) CGFloat fair;
/** 红润（默认0.0， 0 - 1, 越大越红润） */
@property (nonatomic) CGFloat ruddy;
@end

NS_ASSUME_NONNULL_END
