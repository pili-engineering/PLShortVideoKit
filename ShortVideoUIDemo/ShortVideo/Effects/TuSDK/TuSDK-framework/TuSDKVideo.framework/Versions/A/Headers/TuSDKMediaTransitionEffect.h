//
//  TuSDKMediaTransitionEffect.h
//  TuSDKVideo
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"
#import "TuSDKMediaTransitionWrap.h"

NS_ASSUME_NONNULL_BEGIN

/**
 视频转场特效
 @since v3.4.1
 */
@interface TuSDKMediaTransitionEffect : TuSDKMediaEffectCore

/**
 初始化转场特效
 
 @since v3.4.1
 
 @param transitionType 转场类型
 @return 转场特效
 */
- (instancetype)initWithTransitionType:(TuSDKMediaTransitionType)transitionType;

/**
 初始化转场特效
 
 @since v3.4.1
 
 @param transitionType 转场类型
 @param timeRange    生效时间
 @return 转场特效
 */
- (instancetype)initWithTransitionType:(TuSDKMediaTransitionType)transitionType atTimeRange:(nullable TuSDKTimeRange *)timeRange;

/**
 当前转场类型
 @since v3.4.1
 */
@property (nonatomic, assign, readonly) TuSDKMediaTransitionType transitionType;

/**
 动画持续时长(单位毫秒): 默认1.0s, 即1.0*1000
 @since v3.4.1
 */
@property (nonatomic, assign) GLfloat animationDuration;

/**
 设置动画起始位置是否为帧间动画 YES：前后帧动画 NO：帧内动画
 
 @since v3.4.1
 */
@property (nonatomic, assign) BOOL interFrameAnim;

@end

NS_ASSUME_NONNULL_END
