//
//  TuSDKMediaParticleEffectData.h
//  TuSDKVideo
//
//  Created by wen on 2018/1/31.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKMediaEffectCore.h"

/**
 粒子特效
 */
@interface TuSDKMediaParticleEffect : TuSDKMediaEffectCore

/**
 构建粒子特效实例
 
 @param effectsCode 粒子特效code
 @param timeRange 生效时间
 @return TuSDKMediaParticleEffectData
 */
-(instancetype)initWithEffectsCode:(NSString *)effectsCode atTimeRange:(TuSDKTimeRange *)timeRange;

/**
 构建粒子特效实例
 
 @param effectsCode 粒子特效code
 @return TuSDKMediaParticleEffectData
 */
- (instancetype)initWithEffectsCode:(NSString *)effectsCode;

/**
 特效code
 */
@property (nonatomic,copy,readonly) NSString * effectsCode;

/**
 特效的大小 0 ~ 1   0：原始默认大小  1：最大放大倍数后的大小
 */
@property (nonatomic, assign) CGFloat particleSize;

/**
 特效的颜色
 */
@property (nonatomic, strong) UIColor *particleColor;

/**
 轨迹记录数组
 */
@property (nonatomic,strong) NSMutableDictionary<NSValue *,NSValue *> *recordPathDic;


@end

#pragma mark ParticleEmitPosition

@interface TuSDKMediaParticleEffect (ParticleEmitPosition)

/**
 更新当前正在添加的粒子特效的发射器位置
 
 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 @since      v3.0
 */
- (void)updateParticleEmitPosition:(CGPoint)point withCurrentTime:(CMTime)time;
/**
 更新粒子特效的发射器位置
 
 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 @since      v3.0
 */
- (void)updateParticleEmitPosition:(CGPoint)point;

/**
 判断某一时刻是否有对应的轨迹点
 
 @param time 时间
 @return YES：该时刻有对应的轨迹点
 @since      v3.0
 */
- (BOOL)hasPointWithTime:(CMTime)time;

/**
 获得某一时刻对应的轨迹点  无对应点时返回 (0,0)
 
 @param time 时间
 @return 触发的坐标点
 */
- (CGPoint)getPointWithTime:(CMTime)time;

/**
 获得某一时刻对应的粗略轨迹点  无对应点时返回 (0,0)
 
 @param time 当前时间
 @return 触发的坐标点
 @since      v3.0
 */
- (CGPoint)getPointWithRoughTime:(CMTime)time;

@end
