//
//  TuSDKGPUTfmDogFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2018/11/5.
//  Copyright © 2018 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"

NS_ASSUME_NONNULL_BEGIN
// 动漫矢量场
@interface TuSDKGPUTfmDogFilter : TuSDKThreeInputFilter
@property(nonatomic) CGFloat tau;
@property(nonatomic) CGFloat sigma;
@property(nonatomic) CGFloat phi;
@property(nonatomic) CGFloat stepLength;
@end

NS_ASSUME_NONNULL_END
