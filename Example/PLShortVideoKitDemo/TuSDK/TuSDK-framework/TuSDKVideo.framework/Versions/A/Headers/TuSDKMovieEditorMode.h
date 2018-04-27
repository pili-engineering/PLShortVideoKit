//
//  TuSDKMovieEditorMode.h
//  TuSDKVideo
//
//  Created by wen on 2018/2/9.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  TuSDKMovieEditor状态
 */
typedef NS_ENUM(NSInteger, lsqMovieEditorStatus)
{
    //  未知
    lsqMovieEditorStatusUnknow,
    // 加载失败
    lsqMovieEditorStatusLoadFailed,
    // 加载完成
    lsqMovieEditorStatusLoaded,
    // 正在播放
    lsqMovieEditorStatusPreviewing,
    // 正在录制
    lsqMovieEditorStatusRecording,
    // 录制完成
    lsqMovieEditorStatusRecordingCompleted,
    // 录制失败
    lsqMovieEditorStatusRecordingFailed,
    // 取消录制
    lsqMovieEditorStatusRecordingCancelled,
    // 预览完成
    lsqMovieEditorStatusPreviewingCompleted,
    // 暂停预览
    lsqMovieEditorStatusPreviewingPause,
};

/**
 *  TuSDKMovieEditor生效的特效类型(滤镜、场景特效、粒子特效)  注：编辑视频时，特效只能单独使用
 */
typedef NS_ENUM(NSInteger, lsqMovieEditorEfficientEffectMode)
{
    // 默认模式 最后设置的特效将会生效
    lsqMovieEditorEfficientEffectModeDefault,
    // 滤镜生效
    lsqMovieEditorEfficientEffectModeFilter,
    // 场景特效生效
    lsqMovieEditorEfficientEffectModeSceneEffect,
    // 粒子特效生效
    lsqMovieEditorEfficientEffectModeParticleEffect,
};

/**
 录制中特效添加模式  包含：场景特效、粒子特效
 */
typedef NS_ENUM(NSInteger,lsqMovieEditorEffectMode)
{
    // 场景特效
    lsqMovieEditorEffectMode_Scene,
    // 粒子特效
    lsqMovieEditorEffectMode_Particle,
};



