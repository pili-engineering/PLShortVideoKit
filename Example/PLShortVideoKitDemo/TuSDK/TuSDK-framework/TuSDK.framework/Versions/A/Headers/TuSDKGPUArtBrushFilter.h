//
//  TuSDKGPUArtBrushFilter.h
//  TuSDK
//
//  Created by Clear Hu on 16/1/4.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import "GPUImageImport.h"
#import "TuSDKFilterParameter.h"
/**
 *  ArtBrush
 */
@interface TuSDKGPUArtBrushFilter : GPUImageFilterGroup<TuSDKFilterParameterProtocol, TuSDKFilterTexturesProtocol>
/**
 *  混合 (设值范围0.0-1.0)
 */
@property(readwrite, nonatomic) CGFloat mix;
@end
