//
//  TuSDKTransitionWrap.h
//  TuSDKVideo
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 TuSDK. All rights reserved.
//


#import "TuSDKVideoImport.h"

NS_ASSUME_NONNULL_BEGIN

/**
 转场类型
 @since v3.4.1
 */
typedef NS_ENUM(NSUInteger,TuSDKMediaTransitionType) {
    /** 转场 - 淡入  @since v3.4.1 */
    TuSDKMediaTransitionTypeFadeIn = 0,
    /** 转场 - 飞入  @since v3.4.1 */
    TuSDKMediaTransitionTypeFlyIn,
    /** 转场 - 拉入--右侧进入  @since v3.4.1 */
    TuSDKMediaTransitionTypePullInRight,
    /** 转场 - 拉入--左侧进入  @since v3.4.1 */
    TuSDKMediaTransitionTypePullInLeft,
    /** 转场 - 拉入--顶部进入  @since v3.4.1 */
    TuSDKMediaTransitionTypePullInTop,
    /** 转场 - 拉入--底部进入  @since v3.4.1 */
    TuSDKMediaTransitionTypePullInBottom,
    /** 转场 - 散步进入  @since v3.4.1 */
    TuSDKMediaTransitionTypeSpreadIn,
    /** 转场 - 闪光灯  @since v3.4.1 */
    TuSDKMediaTransitionTypeFlashLight,
    /** 转场 - 翻页  @since v3.4.1 */
    TuSDKMediaTransitionTypeFlip,
    /** 转场 - 聚焦-小到大  @since v3.4.1 */
    TuSDKMediaTransitionTypeFocusOut,
    /** 转场 - 聚焦-大到小 @since v3.4.1 */
    TuSDKMediaTransitionTypeFocusIn,
    /** 转场 - 叠起 @since v3.4.1 */
    TuSDKMediaTransitionTypeStackUp,
    /** 转场 - 缩放 @since v3.4.1 */
    TuSDKMediaTransitionTypeZoom
};

/**
 转场
 @since v3.4.1
 */
@interface TuSDKMediaTransitionWrap : TuSDKFilterWrap

/**
 初始化转场特效wrap
 
 @since v3.4.1
 
 @param transitionType 转场类型
 @return 转场特效wrap
 */
- (instancetype)initWithTransitionType:(TuSDKMediaTransitionType)transitionType;

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
 动画起始位置是否为帧间动画 YES：前后帧动画 NO：帧内动画
 
 @since v3.4.1
 */
@property (nonatomic, assign) BOOL interFrameAnim;

@end

NS_ASSUME_NONNULL_END
