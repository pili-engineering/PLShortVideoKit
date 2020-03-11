//
//  TuSDKGPUArtBrushFilter.h
//  TuSDK
//
//  Created by Clear Hu on 16/1/4.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import "SLGPUImage.h"
#import "TuSDKFilterParameter.h"
#import "TuSDKFilterOption.h"

/**
 *  ArtBrush
 */
@interface TuSDKGPUArtBrushFilter : SLGPUImageFilterGroup<TuSDKFilterParameterProtocol, TuSDKFilterTexturesProtocol>
/**
 *  混合 (设值范围0.0-1.0)
 */
@property(readwrite, nonatomic) CGFloat mix;

/**
 *  初始化
 *
 *  @param option TuSDKFilterOption
 *
 *  @return instancetype
 */
- (instancetype)initWithOption:(TuSDKFilterOption *)option;

@end
