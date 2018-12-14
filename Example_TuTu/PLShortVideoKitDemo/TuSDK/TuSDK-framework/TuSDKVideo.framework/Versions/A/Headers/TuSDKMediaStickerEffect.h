//
//  TuSDKMediaStickerEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectCore.h"

/**
 video 贴纸特效
 */
@interface TuSDKMediaStickerEffect : TuSDKMediaEffectCore

/**
 初始化贴纸特效数据模型

 @param stickerGroup 贴纸对象
 @return TuSDKPFStickerGroup
 */
- (instancetype)initWithStickerGroup:(TuSDKPFStickerGroup *)stickerGroup;

/**
 初级滤镜code初始化
 
 @param stickerGroup 贴纸组
 @return TuSDKMediaStickerEffectData
 @since v3.0
 */
- (instancetype)initWithStickerGroup:(TuSDKPFStickerGroup *)stickerGroup atTimeRange:(TuSDKTimeRange *)timeRange;

/**
 贴纸数据
 */
@property (nonatomic,readonly,strong) TuSDKPFStickerGroup *stickerGroup;

/**
 设置是否开启大眼瘦脸 默认：NO
 @since      v3.0
 */
@property (nonatomic) BOOL enablePlastic;


@end
