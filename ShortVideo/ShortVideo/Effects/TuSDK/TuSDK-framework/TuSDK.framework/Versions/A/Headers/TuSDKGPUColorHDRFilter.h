//
//  TuSDKGPUColorHDRFilter.h
//  TuSDK
//
//  Created by Yanlin Qiu on 12/04/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

extern NSUInteger const lsqHistClipXNum;

extern NSUInteger const lsqHistClipYNum;

extern CGFloat const lsqHistLimit;

@interface TuSDKGPUColorHDRFilter : TuSDKThreeInputFilter<TuSDKFilterParameterProtocol>

/**
 强度 (默认 0.5, 0 - 1, 越大越强)
 */
@property (nonatomic) float strength;

@end
