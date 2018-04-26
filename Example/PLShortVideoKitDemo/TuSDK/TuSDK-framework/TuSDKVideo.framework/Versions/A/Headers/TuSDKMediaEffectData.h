//
//  TuSDKMediaEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTimeRange.h"


/**
 video 特效
 */
@interface TuSDKMediaEffectData : NSObject

/**
 * 时间范围
 */
@property (nonatomic,strong) TuSDKTimeRange *atTimeRange;


/**
 初始化方法
 */
- (instancetype)initEffectInfoWithTimeRange:(TuSDKTimeRange *)timeRange;


@end
