//
//  TuSDKGPUMonsterFace.h
//  TuSDK
//
//  Created by hecc on 2018/8/16.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

#define TuSDKGPUMonsterFaceThickLipsType 1
#define TuSDKGPUMonsterPapayaFaceType 2
#define TuSDKGPUMonsterSmallEyesType 3

@interface TuSDKGPUMonsterFace : TuSDKFilter<TuSDKFilterFacePositionProtocol>

/**
 设置类型（TuSDKGPUMonsterFaceThickLipsType、TuSDKGPUMonsterPapayaFaceType、TuSDKGPUMonsterSmallEyesType），默认 TuSDKGPUMonsterFaceThickLipsType
 */
@property (nonatomic) NSUInteger monsterFaceType;

@end
