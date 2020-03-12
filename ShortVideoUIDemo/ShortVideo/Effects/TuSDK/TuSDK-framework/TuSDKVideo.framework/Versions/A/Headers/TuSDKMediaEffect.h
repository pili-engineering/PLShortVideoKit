//
//  TuSDKMediaEffect.h
//  TuSDKVideo
//
//  Created by sprint on 17/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectTypes.h"
#import "TuSDKTimeRange.h"
#import "TuSDKMediaEffectParameterProtocol.h"

/**
 特效数据接口
 
 @since v3.0.1
 */
@protocol TuSDKMediaEffect <NSObject,NSCopying,TuSDKMediaEffectParameterProtocol>

/**
 * 时间范围
 */
@property (nonatomic,strong) TuSDKTimeRange *atTimeRange;

/**
 特效类型
 */
@property (nonatomic,readonly) NSUInteger effectType;

/**
 特效 TuSDKFilterWrap
 */
@property (nonatomic,readonly) TuSDKFilterWrap *filterWrap;

/**
 特效设置是否有效
 */
@property (nonatomic, assign, readonly) BOOL isValid;

/**
 * 标记当前特效是否正在应用中
 * 开发者不应修改该标识
 */
@property (nonatomic) BOOL isApplyed;

/**
 当前特效是否正在编辑中
 */
@property (nonatomic) BOOL isEditing;

/**
 判断当前是否可以应用特效
 
 @param time 帧时间
 @return true/false
 @since v3.0.1
 */
- (BOOL)canApplyAtTime:(CMTime)time;

/**
 销毁特效数据
 */
- (void)destory;



@end
