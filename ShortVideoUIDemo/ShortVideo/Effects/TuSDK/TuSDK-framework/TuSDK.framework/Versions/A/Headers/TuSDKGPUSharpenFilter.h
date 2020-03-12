//
//  TuSDKGPUSharpenFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/4/29.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "SLGPUImage.h"
#import "TuSDKFilterParameter.h"

/**
 *  锐化滤镜
 */
@interface TuSDKGPUSharpenFilter : SLGPUImageSharpenFilter<TuSDKFilterParameterProtocol>

@end
