//
//  TuSDKParticleFilterInterface.h
//  TuSDK
//
//  Created by wen on 2018/1/29.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  粒子特效配置选项协议
 */
@protocol TuSDKParticleFilterProtocol <NSObject>

/**
 更新粒子发射器位置

 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 */
- (void)updateParticleEmitPosition:(CGPoint)point;

/**
 更新粒子特效材质大小 0~1
 
 @param size 粒子特效材质大小
 @since      v2.0
 */
- (void)updateParticleEmitSize:(CGFloat)size;

/**
 更新 下一次添加的 粒子特效颜色  注：对当前正在添加或已添加的粒子不生效
 
 @param color 粒子特效颜色
 @since      v2.0
 */
- (void)updateParticleEmitColor:(UIColor *)color;


///**    暂时先不使用 
// 设置是否激活
//
// @param active 是否激活 YES：激活  默认：YES
// */
//- (void)setActive:(BOOL)active;

/**
 设置是否启用自动播放模式

 @param enableAutoplayMode 是否启动自动播放 YES：自动播放粒子 默认：YES
 */
- (void)enableAutoplayMode:(BOOL)enableAutoplayMode;

@end

