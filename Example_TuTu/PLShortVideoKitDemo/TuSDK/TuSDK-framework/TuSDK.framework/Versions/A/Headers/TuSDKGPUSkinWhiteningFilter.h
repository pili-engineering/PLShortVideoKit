//
//  TuSDKSkinWhiteningFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/14.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/**
 *  美颜滤镜 （根据用户权限 加载不同滤镜组合 包括： 一键美颜、磨皮、美白、肤色、大眼、瘦脸）
 */
@interface TuSDKGPUSkinWhiteningFilter : SLGPUImageFilterGroup<TuSDKFilterParameterProtocol, TuSDKFilterTexturesProtocol, TuSDKFilterFacePositionProtocol>

@end
