//
//  TuSDKMediaParticleEffectData.h
//  TuSDKVideo
//
//  Created by wen on 2018/1/31.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKMediaEffectData.h"

/**
 粒子特效
 */
@interface TuSDKMediaParticleEffectData : TuSDKMediaEffectData

/**
 特效code
 */
@property (nonatomic, copy) NSString * effectsCode;

/**
 特效的大小 0 ~ 1   0：原始默认大小  1：最大放大倍数后的大小
 */
@property (nonatomic, assign) CGFloat particleSize;

/**
 特效的颜色
 */
@property (nonatomic, strong) UIColor *particleColor;

/**
 特效设置是否有效  YES:有效    -   结束时间 <= 开始时间 或 特效code不存在 则被认为是无效设置
 */
@property (nonatomic, assign, readonly) BOOL isValid;

/**
 轨迹记录数组
 */
@property (nonatomic, strong) NSMutableDictionary<NSValue *,NSValue *> *recordPathDic;


/**
 更新当前正在添加的粒子特效的发射器位置
 
 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 */
- (void)updateParticleEmitPosition:(CGPoint)point withCurrentTime:(CMTime)time;

/**
 判断某一时刻是否有对应的轨迹点

 @param time 时间
 @return YES：该时刻有对应的轨迹点
 */
- (BOOL)hasPointWithTime:(CMTime)time;

/**
 获得某一时刻对应的轨迹点  无对应点时返回 (0,0)

 @param time 时间
 @return 时间对应的点
 */
- (CGPoint)getPointWithTime:(CMTime)time;

/**
 克隆一个新的粒子特效对象
 
 @return 返回新的相同内容的粒子特效对象
 */
- (TuSDKMediaParticleEffectData *)clone;

@end
