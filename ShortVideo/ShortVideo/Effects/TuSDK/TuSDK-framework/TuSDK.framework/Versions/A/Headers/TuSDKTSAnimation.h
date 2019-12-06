//
//  TuSDKTSAnimation.h
//  TuSDK
//
//  Created by Clear Hu on 14/12/17.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - TuSDKTween
/**
 *  动画速度基类
 */
@interface TuSDKTween : NSObject
/**
 *  动画执行时间
 */
@property (nonatomic) NSTimeInterval duration;

/**
 *  动画速度基类
 *
 *  @return 动画速度基类
 */
+ (instancetype) tween;

/**
 *  计算当前速度值
 *
 *  @param time 当前时间 (0 <= time <= duration)
 *
 *  @return 当前速度值
 */
- (NSTimeInterval)computerWithTime:(NSTimeInterval)time;
@end

#pragma mark - TuSDKTweenQuad
/**
 *  Quadratic：二次方的缓动（t^2）
 */
@interface TuSDKTweenQuadEaseIn : TuSDKTween
@end

/**
 *  Quadratic：二次方的缓动（t^2）
 */
@interface TuSDKTweenQuadEaseOut : TuSDKTween
@end

/**
 *  Quadratic：二次方的缓动（t^2）
 */
@interface TuSDKTweenQuadEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenCubic
/**
 *  Cubic：三次方的缓动（t^3）
 */
@interface TuSDKTweenCubicEaseIn : TuSDKTween
@end

/**
 *  Cubic：三次方的缓动（t^3）
 */
@interface TuSDKTweenCubicEaseOut : TuSDKTween
@end

/**
 *  Cubic：三次方的缓动（t^3）
 */
@interface TuSDKTweenCubicEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenQuart
/**
 *  Quartic：四次方的缓动（t^4）
 */
@interface TuSDKTweenQuartEaseIn : TuSDKTween
@end

/**
 *  Quartic：四次方的缓动（t^4）
 */
@interface TuSDKTweenQuartEaseOut : TuSDKTween
@end

/**
 *  Quartic：四次方的缓动（t^4）
 */
@interface TuSDKTweenQuartEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenQuint
/**
 *  Quintic：五次方的缓动（t^5）
 */
@interface TuSDKTweenQuintEaseIn : TuSDKTween
@end

/**
 *  Quintic：五次方的缓动（t^5）
 */
@interface TuSDKTweenQuintEaseOut : TuSDKTween
@end

/**
 *  Quintic：五次方的缓动（t^5）
 */
@interface TuSDKTweenQuintEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenSine
/**
 *  Sinusoidal：正弦曲线的缓动（sin(t)）
 */
@interface TuSDKTweenSineEaseIn : TuSDKTween
@end

/**
 *  Sinusoidal：正弦曲线的缓动（sin(t)）
 */
@interface TuSDKTweenSineEaseOut : TuSDKTween
@end

/**
 *  Sinusoidal：正弦曲线的缓动（sin(t)）
 */
@interface TuSDKTweenSineEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenExpo
/**
 *  Exponential：指数曲线的缓动（2^t）
 */
@interface TuSDKTweenExpoEaseIn : TuSDKTween
@end

/**
 *  Exponential：指数曲线的缓动（2^t）
 */
@interface TuSDKTweenExpoEaseOut : TuSDKTween
@end

/**
 *  Exponential：指数曲线的缓动（2^t）
 */
@interface TuSDKTweenExpoEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenCirc
/**
 *  Circular：圆形曲线的缓动（sqrt(1-t^2)）
 */
@interface TuSDKTweenCircEaseIn : TuSDKTween
@end

/**
 *  Circular：圆形曲线的缓动（sqrt(1-t^2)）
 */
@interface TuSDKTweenCircEaseOut : TuSDKTween
@end

/**
 *  Circular：圆形曲线的缓动（sqrt(1-t^2)）
 */
@interface TuSDKTweenCircEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTweenElastic
/**
 *  Elastic：指数衰减的正弦曲线缓动
 */
@interface TuSDKTweenElastic : TuSDKTween{
    // 周期，可选参数
    float _period;
}
/**
 *  振幅，可选参数
 */
@property (nonatomic) float amplitude;
/**
 *  周期，可选参数
 */
@property (nonatomic) float period;
@end

/**
 *  Elastic：指数衰减的正弦曲线缓动
 */
@interface TuSDKTweenElasticEaseIn : TuSDKTweenElastic
@end

/**
 *  Elastic：指数衰减的正弦曲线缓动
 */
@interface TuSDKTweenElasticEaseOut : TuSDKTweenElastic
@end

/**
 *  Elastic：指数衰减的正弦曲线缓动
 */
@interface TuSDKTweenElasticEaseInOut : TuSDKTweenElastic
@end

#pragma mark - TuSDKTweenBack
/**
 *  超过范围的三次方缓动（(s+1)*t^3 - s*t^2）
 */
@interface TuSDKTweenBack : TuSDKTween
/**
 *  速度 (默认：1.70158)
 */
@property (nonatomic) float speed;
@end

/**
 *  超过范围的三次方缓动（(s+1)*t^3 - s*t^2）
 */
@interface TuSDKTweenBackEaseIn : TuSDKTweenBack
@end

/**
 *  超过范围的三次方缓动（(s+1)*t^3 - s*t^2）
 */
@interface TuSDKTweenBackEaseOut : TuSDKTweenBack
@end

/**
 *  超过范围的三次方缓动（(s+1)*t^3 - s*t^2）
 */
@interface TuSDKTweenBackEaseInOut : TuSDKTweenBack
@end

#pragma mark - TuSDKTweenBounce
/**
 *  Bounce：指数衰减的反弹缓动
 */
@interface TuSDKTweenBounceEaseIn : TuSDKTween
@end

/**
 *  Bounce：指数衰减的反弹缓动
 */
@interface TuSDKTweenBounceEaseOut : TuSDKTween
@end

/**
 *  Bounce：指数衰减的反弹缓动
 */
@interface TuSDKTweenBounceEaseInOut : TuSDKTween
@end

#pragma mark - TuSDKTSAnimation
@class TuSDKTSAnimation;
/**
 *  动画执行回调
 *
 *  @param anim 自定义动画对象
 *  @param step 步进结果 0-1
 */
typedef void (^TuSDKTSAnimationBlock)(TuSDKTSAnimation *anim, NSTimeInterval step);

/**
 *  自定义动画
 */
@interface TuSDKTSAnimation : NSObject

/**
 *  动画执行帧间隔时间 (默认: 0.01)
 */
@property (nonatomic) NSTimeInterval interval;

/**
 *  动画执行时间
 */
@property (nonatomic) NSTimeInterval duration;

/**
 *  动画速度基类
 */
@property (nonatomic, retain) TuSDKTween *tween;

/**
 *  动画执行回调
 */
@property (nonatomic, strong) TuSDKTSAnimationBlock block;

/**
 *  创建自定义动画
 *
 *  @param duration 动画执行时间 (单位:秒)
 *  @param block    动画回调
 *
 *  @return 自定义动画
 */
+ (TuSDKTSAnimation *)animWithDuration:(NSTimeInterval)duration
                                 block:(TuSDKTSAnimationBlock)block;

/**
 *  创建自定义动画
 *
 *  @param duration 动画执行时间 (单位:秒)
 *  @param tween    动画加速度
 *  @param block    动画回调
 *
 *  @return 自定义动画
 */
+ (TuSDKTSAnimation *)animWithDuration:(NSTimeInterval)duration
                                 tween:(TuSDKTween *)tween
                                 block:(TuSDKTSAnimationBlock)block;

/**
 *  动画开始
 */
- (void)start;

/**
 *  动画开始
 */
- (void)startWithBlock:(TuSDKTSAnimationBlock)block;

/**
 *  动画停止
 */
- (void)stop;

/**
 *  销毁
 */
- (void)destory;
@end
