//
//  TuSDKParticleExamples.h
//  TuSDK
//
//  Created by Clear Hu on 2017/12/24.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKParticleManager.h"
/** 发布后全部注释 **/
@interface TuSDKParticleExamples : NSObject
/** 返回需要的粒子效果*/
+ (id)indexWith:(NSUInteger)index total:(NSUInteger)numberOfParticles;
@end

#pragma mark - TuSDKParticleFire
/** 火焰粒子*/
@interface TuSDKParticleFire : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleFireworks
/** 烟火粒子*/
@interface TuSDKParticleFireworks : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleSun
/** 太阳粒子*/
@interface TuSDKParticleSun : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleGalaxy
/** 银河粒子*/
@interface TuSDKParticleGalaxy : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleFlower
/** 花瓣粒子*/
@interface TuSDKParticleFlower : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleMeteor
/** 流星粒子*/
@interface TuSDKParticleMeteor : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleSpiral
/** 螺旋粒子*/
@interface TuSDKParticleSpiral : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleExplosion
/** 爆炸粒子*/
@interface TuSDKParticleExplosion : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleSmoke
/** 烟雾粒子*/
@interface TuSDKParticleSmoke : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleSnow
/** 雪花粒子*/
@interface TuSDKParticleSnow : TuSDKParticleManager

@end

#pragma mark - TuSDKParticleRain
/** 下雨粒子*/
@interface TuSDKParticleRain : TuSDKParticleManager

@end
