//
//  TuSDKGPUTfmEdgeFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2018/11/4.
//  Copyright © 2018 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"

NS_ASSUME_NONNULL_BEGIN
// 动漫边缘
@interface TuSDKGPUTfmEdgeFilter : TuSDKFilter
@property(readwrite, nonatomic) CGFloat edgeStrength;
@end

NS_ASSUME_NONNULL_END
