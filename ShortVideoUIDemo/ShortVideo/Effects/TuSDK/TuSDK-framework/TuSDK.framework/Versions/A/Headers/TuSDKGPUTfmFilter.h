//
//  TuSDKGPUTfmFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2018/11/7.
//  Copyright © 2018 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

NS_ASSUME_NONNULL_BEGIN

// 矢量漫画效果
@interface TuSDKGPUTfmFilter : SLGPUImageFilterGroup<TuSDKFilterParameterProtocol, TuSDKFilterTexturesProtocol>

@end

NS_ASSUME_NONNULL_END
