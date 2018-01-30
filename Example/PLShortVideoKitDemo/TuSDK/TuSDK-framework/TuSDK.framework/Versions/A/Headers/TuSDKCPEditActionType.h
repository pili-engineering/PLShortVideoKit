//
//  TuSDKCPEditActionType.h
//  TuSDK
//
//  Created by Clear Hu on 15/4/25.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  图片编辑动作类型
 */
typedef NS_ENUM(NSInteger, lsqTuSDKCPEditActionType)
{
    /**
     * 未知动作
     */
    lsqTuSDKCPEditActionUnknow,
    /**
     * 裁剪动作
     */
    lsqTuSDKCPEditActionCuter,
    /**
     * 滤镜动作
     */
    lsqTuSDKCPEditActionFilter,
    /**
     * 贴纸动作
     */
    lsqTuSDKCPEditActionSticker,
    
    /**
     * 文字动作
     */
    lsqTuSDKCPEditActionText,

    /**
     * 美颜动作
     */
    lsqTuSDKCPEditActionSkin,
    /**
     * 涂抹动作
     */
    lsqTuSDKCPEditActionSmudge,
    /**
     * 调整动作
     */
    lsqTuSDKCPEditActionAdjust,
    /**
     * 模糊涂抹
     */
    lsqTuSDKCPEditActionWipeFilter,
    /**
     * 锐化动作
     */
    lsqTuSDKCPEditActionSharpness,
    /**
     * 晕角动作
     */
    lsqTuSDKCPEditActionVignette,
    /**
     * 景深动作
     */
    lsqTuSDKCPEditActionAperture,
    /**
     * 圣光动作
     */
    lsqTuSDKCPEditActionHolyLight,
    /**
     * HDR 动作
     */
    lsqTuSDKCPEditActionHDR,
    /**
     * 编辑动作
     */
    lsqTuSDKCPEditActionMultipleEdit,
    /**
     * 旋转和镜像动作
     */
    lsqTuSDKCPEditActionTurnAndMirror,
};

/**
 *  图片编辑动作类型
 */
@interface TuSDKCPEditActionType : NSObject
/**
 *  高级编辑功能模块列表
 *
 *  @return entryActionTypes 高级编辑功能模块列表
 */
+ (NSArray *)entryActionTypes;

/**
 *  多功能编辑功能模块列表
 *
 *  @return multipleActionTypes 多功能编辑功能模块列表
 */
+ (NSArray *)multipleActionTypes;
@end
