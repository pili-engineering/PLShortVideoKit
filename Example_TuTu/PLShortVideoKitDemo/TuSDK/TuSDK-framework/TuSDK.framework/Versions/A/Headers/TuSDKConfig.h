//
//  TuSDKConfig.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/31.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TuSDKFilterGroup.h"
#import "TuSDKPFStickerCategory.h"
#import "TuSDKPFBrushGroup.h"

#pragma mark - TuSDKPermission
/**
 *  SDK Permission
 */
@interface TuSDKPermission : TuSDKDataJson
/**
 *  level
 */
@property (nonatomic) NSInteger level;
/**
 *  no Power
 */
@property (nonatomic) BOOL noPower;
/**
 *  service Expire
 */
@property (nonatomic, retain) NSDate *serviceExpire;
/**
 *  resolution
 */
@property (nonatomic) NSInteger resolution;

/**
 * sticker Use Count
 */
@property (nonatomic) NSInteger stickerUseCount;

/**
 * local filter Count
 */
@property (nonatomic) NSInteger localFilterCount;

/**
 *  local sticker Count
 */
@property (nonatomic) NSInteger localStickerCount;

/**
 *  render filter thumb
 */
@property (nonatomic) BOOL renderFilterThumb;

/**
 *  smudge
 */
@property (nonatomic) BOOL smudgeEnabled;

/**
 *  smudge and filter
 */
@property (nonatomic) BOOL wipeFilterEnabled;

/**
 *  hdr
 */
@property (nonatomic) BOOL hdrFilterEnabled;

/**
 *  beauty Level
 */
@property (nonatomic) NSInteger beautyLevel;

/**
 *  userType
 */
@property (nonatomic) NSInteger userType;

/**
 *  video record
 */
@property (nonatomic) BOOL videoRecordEnabled;

/**
 *  config video duration
 */
@property (nonatomic) BOOL videoDurationEnabled;

/**
 *  video streaming
 */
@property (nonatomic) BOOL videoStreamEnabled;

/**
 *  video edit
 */
@property (nonatomic) BOOL videoEditEnabled;

/**
 *  face Local Marks
 */
@property (nonatomic) NSInteger faceLocalMarks;

/**
 *  face Local Image Support
 */
@property (nonatomic) BOOL faceLocalImageSupport;

/**
 *  face Local Video Support
 */
@property (nonatomic) BOOL faceLocalVideoSupport;

/**
 *  face Local Beauty support
 */
@property (nonatomic) BOOL faceLocalBeautySupport;

/**
 *  Filter API
 */
@property (nonatomic) BOOL filterAPIEnabled;

/**
 video record continuous support
 */
@property (nonatomic) BOOL videoRecordContinuousSupport;

/**
 video camera shot support
 */
@property (nonatomic) BOOL videoCameraShotSupport;

/**
 video camera sticker support
 */
@property (nonatomic) BOOL videoCameraStickerSupport;

/**
 video camera bitrate support
 */
@property (nonatomic) BOOL videoCameraBitrateSupport;

/**
 video editor music support
 */
@property (nonatomic) BOOL videoEditorMusicSupport;

/**
 video editor sticker support
 */
@property (nonatomic) BOOL videoEditorStickerSupport;

/**
 video editor filter support
 */
@property (nonatomic) BOOL videoEditorFilterSupport;

/**
 video editor bitrate support
 */
@property (nonatomic) BOOL videoEditorBitrateSupport;

/**
 video editor resolution support
 */
@property (nonatomic) BOOL videoEditorResolutionSupport;

/**
 video editor scene effects filter support
 */
@property (nonatomic) BOOL videoEditorSceneEffectsFilterSupport;

/**
 video editor particle effects filter support
 */
@property (nonatomic) BOOL videoEditorParticleEffectsFilterSupport;

/**
 video editor text effect support 文字特效
 @since 2.2.0
 */
@property (nonatomic) BOOL videoEditorTextEffectsSupport;

/**
 video editor comic effect support 漫画
 @since v3.0.1
 */
@property (nonatomic) BOOL videoEditorComicEffectsSupport;

/**
 音频变声权限
 @since v3.0.1
 */
@property (nonatomic) BOOL audioPitchEffectsSupport;

/**
 音频重采样权限
 @since v3.0.1
 */
@property (nonatomic) BOOL audioResampleEffectsSupport;

/**
 *  Filter list which could be used by FilterAPI
 */
@property (nonatomic) NSArray *filterAPIList;

@end

#pragma mark - TuSDKConfig
/**
 *  Sdk配置
 */
@interface TuSDKConfig : TuSDKDataJson
/**
 *  滤镜分组列表
 */
@property (nonatomic, retain) NSArray *filterGroups;

/**
 * 贴纸分类
 */
@property (nonatomic, retain) NSArray *stickerCategories;

/**
 * 贴纸配置列表
 */
@property (nonatomic, retain) NSArray *stickerGroups;

/**
 * 笔刷配置列表
 */
@property (nonatomic, retain) NSArray *brushGroups;

/**
 *  配置信息
 */
@property (nonatomic, copy) NSString * master;

/**
 *  配置信息列表
 */
@property (nonatomic, copy) NSDictionary * masters;

/**
 *  SDK Permission
 */
@property (nonatomic, retain) TuSDKPermission *permission;
@end
