//
//  TuSDKMediaEffectSync.h
//  TuSDKVideo
//
//  Created by sprint on 17/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

@protocol TuSDKMediaEffectTimeline;
@protocol TuSDKMediaEffectSyncDelegate;

/**
 特效同步器. 根据特效时间筛选指定特效
 
 @since v3.0.1
 */
@protocol TuSDKMediaEffectSync <NSObject>

@required

/**
 时间轴
 
 @since v3.0.1
 */
@property (nonatomic,weak) id<TuSDKMediaEffectTimeline> timeline;

/**
 同步器委托
 
 @since v3.0.1
 */
@property (nonatomic,weak) id<TuSDKMediaEffectSyncDelegate> delegate;

/**
 验证当前同步器否支持该特效类型
 @param effectType 特效类型
 @return true/false
 @since  v3.0.1
 */
- (BOOL)isSupportedMediaEffectType:(NSUInteger)effectType;

/**
 同步特效数据
 
 @param timeline 当前时间轴 timeline
 @param time 当前时间
 @since v3.0.1
 */
- (void)syncMediaEffects:(id<TuSDKMediaEffectTimeline>)timeline atTime:(CMTime)time;

/**
 通知同步器将要添加特效
 
 @param effect 将要添加的数据
 @since v3.0.1
 */
- (void)syncWillAddMediaEffect:(id<TuSDKMediaEffect>)effect;

/**
 通知同步器特效数据已添加
 
 @param effect 已添加的特效
 @since v3.0.1
 */
- (void)syncDidAddMediaEffect:(id<TuSDKMediaEffect>)effect;

/**
 同步特效数据被移除事件

 @param effects 被移除的特效数据
 @since v3.0.1
 */
- (void)syncDidRemoveMediaEffects:(NSArray<id<TuSDKMediaEffect>> *)effects;

/**
 重置并清空资源
 
 @since v3.0.1
 */
- (void)reset;

@end


/**
 TuSDKMediaEffectSyncDelegate
 
 @sinc v3.0.1
 */
@protocol TuSDKMediaEffectSyncDelegate <NSObject>

@optional

/**
 当前正在应用的特效
 
 @param sync 同步器
 @param mediaEffectData 正在预览特效
 @since v3.0.1
 */
- (void)mediaEffectSync:(id<TuSDKMediaEffectSync>)sync didApplyingMediaEffect:(id<TuSDKMediaEffect>)mediaEffectData;


/**
 特效被移除通知
 
 @param sync 同步器
 @param mediaEffects 被移除的特效列表
 @since v3.0.1
 */
- (void)mediaEffectSync:(id<TuSDKMediaEffectSync>)sync didRemoveMediaEffects:(NSArray<id<TuSDKMediaEffect>> *) mediaEffects;

@end

