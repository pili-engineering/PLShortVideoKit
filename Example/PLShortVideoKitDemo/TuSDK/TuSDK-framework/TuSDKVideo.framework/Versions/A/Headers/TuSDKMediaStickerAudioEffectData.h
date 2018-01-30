//
//  TuSDKMediaStickerAudioEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectData.h"


/**
 video MV 特效
 */
@interface TuSDKMediaStickerAudioEffectData : TuSDKMediaEffectData

/**
 本地音频地址
*/
@property (nonatomic,readonly,copy) NSURL *audioURL;

/**
 贴纸数据
 */
@property (nonatomic,readonly,strong) TuSDKPFStickerGroup *stickerGroup;

/**
 音频音量
 */
@property (nonatomic, assign) CGFloat audioVolume;


/**
 初始化方法
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL stickerGroup:(TuSDKPFStickerGroup *)stickerGroup;


@end
