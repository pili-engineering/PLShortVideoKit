//
//  TuSDKMediaEffectTimeline.h
//  TuSDKVideo
//
//  Created by sprint on 17/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffect.h"
#import "TuSDKMediaEffectSync.h"

/**
 时间特效时间轴. 对特效数据进行管理
 @since v3.0.1
 */
@protocol TuSDKMediaEffectTimeline  <NSObject>

/**
 特效同步器
 
 @since 3.0.1
 */
@property (nonatomic)id<TuSDKMediaEffectSync> sync;

/**
 验证当前时间轴是否支持该特效类型
 @param mediaEffectType 特效类型
 @return true/false
 @since  v3.0.1
 */
-(BOOL)isSupportedMediaEffectType:(NSUInteger)mediaEffectType;

/**
 添加一个多媒体特效。该方法不会自动设置触发时间.
 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 
 @param mediaEffect 特效数据
 @since  v3.0.1
 */
- (BOOL)addMediaEffect:(__kindof id<TuSDKMediaEffect>)mediaEffect;

/**
 移除特效数据
 
 @param mediaEffect 特效数据
 @since  v3.0.1
 */
- (void)removeMediaEffect:(__kindof id<TuSDKMediaEffect>)mediaEffect;

/**
 移除指定类型的特效信息
 
 @param effectType 特效类型
 @since  v3.0.1
 */
- (void)removeMediaEffectsWithType:(NSUInteger)effectType;

/**
 移除所有特效数据
 
 @since  v3.0.1
 */
- (void)removeAllMediaEffect;

/**
 获取指定类型的特效信息

 @param effectType 特效数据类型
 @return 特效列表
 @since  v3.0.1
 */
- (NSArray<__kindof id<TuSDKMediaEffect>> *)mediaEffectsWithType:(NSUInteger)effectType;

/**
 获取所有特效
 
 @return NSArray<id<TuSDKMediaEffect> *
 @since      v3.0.1
 */
- (NSArray<__kindof id<TuSDKMediaEffect>> *)mediaEffects;

/**
 验证在 time 处是否存在指定类型的特效

 @param time 特效时间
 @param effectType 特效类型
 @return true/false
 */
- (BOOL)hasEffectAtTime:(CMTime)time forEffectType:(NSUInteger)effectType;

/**
 播放指定位置的特效
 
 @param time 帧时间
 @since v3.0.1
 */
- (void)syncTime:(CMTime)time;

/**
 销毁特效
 @since      v2.2.0
 */
- (void)destory;


@end


