//
//  TuSDKMediaStickerAudioEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectCore.h"
#import "TuSDKMediaStickerEffect.h"
#import "TuSDKMediaAudioEffect.h"

/**
 video MV 特效
 */
@interface TuSDKMediaStickerAudioEffect : TuSDKMediaEffectCore 

/**
 初始化MV特效
 
 @param audioURL 音效地址
 @param stickerGroup 贴纸组
 @return TuSDKMediaStickerAudioEffectData
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL stickerGroup:(TuSDKPFStickerGroup *)stickerGroup;

/**
 初始化MV特效
 
 @param audioURL 音效地址
 @param stickerGroup 贴纸组
 @param timeRange 时间区间
 @return TuSDKMediaStickerAudioEffectData
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL stickerGroup:(TuSDKPFStickerGroup *)stickerGroup atTimeRange:(TuSDKTimeRange *)timeRange;


/**
 本地音频地址
*/
@property (nonatomic,readonly) TuSDKMediaAudioEffect *audioEffect;

/**
 贴纸数据
 */
@property (nonatomic,strong,readonly) TuSDKMediaStickerEffect *stickerEffect;

/**
 音频音量
 */
@property (nonatomic, assign) CGFloat audioVolume;


@end
