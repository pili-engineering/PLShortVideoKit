//
//  TuSDKMediaEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTimeRange.h"
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffect.h"

/**
 特效数据模型继承类
 */
@interface TuSDKMediaEffectCore : NSObject <TuSDKMediaEffect,NSCopying>
{
    @protected
    /** 特效类型 */
    NSUInteger _effectType;
    /** 特效wrap 可能为空 */
    TuSDKFilterWrap *_filterWrap;
    BOOL _isApplyed;
}


/**
 初始化方法
 */
- (instancetype)initWithTimeRange:(TuSDKTimeRange *)timeRange effectType:(NSUInteger)type;


@end
