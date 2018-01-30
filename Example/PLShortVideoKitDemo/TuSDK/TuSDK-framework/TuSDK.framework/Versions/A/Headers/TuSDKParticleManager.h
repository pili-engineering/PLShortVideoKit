//
//  TuSDKParticleManager.h
//  TuSDK
//
//  Created by Clear Hu on 2017/12/23.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKParticleItem.h"

/** 粒子发射器永远存在 */
extern NSInteger const lsqParticleDurationInfinty;

/** 粒子的起始大小等于结束大小 */
extern NSInteger const lsqParticleStartSizeEqualToEndSize;

/** 粒子的起始半径等于结束半径 */
extern NSInteger const lsqParticleStartRadiusEqualToEndRadius;

/** 粒子系统*/
@interface TuSDKParticleManager : NSObject{

}
/** 配置文件名称*/
@property (readonly, nonatomic) TuSDKParticleConfig *config;
/** 是否激活*/
@property (readonly, nonatomic) BOOL isActive;
/** 是否暂停*/
@property (nonatomic) BOOL isPaused;
/** 材质大小*/
@property(readwrite, nonatomic) CGSize textureSize;

/** 初始化粒子系统*/
+ (id) initWithTotalParticles:(NSUInteger)numberOfParticles;
/** 初始化粒子系统 读取json配置文件*/
+ (id) initWithConfigFile:(NSString *)file;
/** 初始化粒子系统 读取json配置*/
+ (id) initWithJson:(NSString *)json;
/** 重置粒子管理器*/
- (void) resetWithTotalParticles:(NSUInteger)numberOfParticles;
/** 开始*/
- (void)start;
/** 停止*/
- (void)stop;
/** 更新数据 单位：秒*/
- (void)update:(CGFloat)dt;
/** 重置开始时间*/
- (void)updateWithNoTime;

/** 顶点一组总数 默认2*/
@property(readonly) GLint positionSize;
/** 粒子颜色一组总数 默认4*/
@property(readonly) GLint colorSize;
/** 粒子表现一组总数 默认2*/
@property(readonly) GLint appearSize;
/** 绘制粒子总数*/
- (NSInteger)drawTotal;
/** 粒子顶点数组 */
- (const GLfloat *)positions;
/** 粒子颜色数组 */
- (const GLfloat *)colors;
/** 粒子表现数组 */
- (const GLfloat *)appears;
@end
