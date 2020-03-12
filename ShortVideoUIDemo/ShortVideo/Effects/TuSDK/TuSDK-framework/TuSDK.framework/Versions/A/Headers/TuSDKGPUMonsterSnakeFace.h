//
//  TuSDKGPUMonsterSnakeFace.h
//  TuSDK
//
//  Created by hecc on 2018/8/16.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

#define TuSDKGPUMonsterSnakeFaceType 1
#define TuSDKGPUMonsterBigFaceType 2

@interface TuSDKGPUMonsterSnakeFace : TuSDKFilter<TuSDKFilterFacePositionProtocol>

/**
 设置类型（TuSDKGPUMonsterSnakeFaceType、TuSDKGPUMonsterBigFaceType），默认 TuSDKGPUMonsterSnakeFaceType
 */
@property (nonatomic) NSUInteger monsterFaceType;

@end
