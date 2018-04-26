//
//  TuSDKRecordVideoMode.h
//  TuSDKVideo
//
//  Created by wen on 2018/2/6.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  组件错误类型
 */
typedef NS_ENUM(NSInteger, lsqRecordError)
{
    /** 未知 */
    lsqRecordVideoErrorUnknow,
    
    /** 存储空间不足 */
    lsqRecordVideoErrorNotEnoughSpace,
    
    /** 小于最小录制时长 */
    lsqRecordVideoErrorLessMinDuration,
    
    /** 大于最大录制时长 */
    lsqRecordVideoErrorMoreMaxDuration,
    
    /** 文件保存失败 */
    lsqRecordVideoErrorSaveFailed,
};


/**
 录制状态
 */
typedef NS_ENUM(NSInteger,lsqRecordState)
{
    /** 正在录制 */
    lsqRecordStateRecording,
    
    /** 录制完成 */
    lsqRecordStateRecordingCompleted,
    
    /** 正在保存 */
    lsqRecordStateSaveing,
    
    /** 保存完成 */
    lsqRecordStateSaveingCompleted,
    
    /** 正在合并视频 */
    lsqRecordStateMerging,
    
    /** 已暂停 */
    lsqRecordStatePaused,
    
    /** 已取消 */
    lsqRecordStateCanceled,
};


/**
 录制模式
 */
typedef NS_ENUM(NSInteger,lsqRecordMode)
{
    /** 正常模式 */
    lsqRecordModeNormal,
    
    /** 续拍模式 */
    lsqRecordModeKeep,
};


/**
 录制速度模式
 */
typedef NS_ENUM(NSInteger,lsqSpeedMode)
{
    /** 标准模式 */
    lsqSpeedMode_Normal,
    
    /** 快速模式 */
    lsqSpeedMode_Fast1,
    
    /** 极快模式 */
    lsqSpeedMode_Fast2,
    
    /** 慢速模式 */
    lsqSpeedMode_Slow1,
    
    /** 极慢模式 */
    lsqSpeedMode_Slow2,
};




