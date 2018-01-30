//
//  TuSDKMVStickerAudioEffectData.h
//  TuSDKVideo
//
//  Created by gh.li on 2017/5/2.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaStickerAudioEffectData.h"

@interface TuSDKMVStickerAudioEffectData : TuSDKMediaStickerAudioEffectData


/**
 初始化方法
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL stickerGroup:(TuSDKPFStickerGroup *)stickerGroup;

@end
