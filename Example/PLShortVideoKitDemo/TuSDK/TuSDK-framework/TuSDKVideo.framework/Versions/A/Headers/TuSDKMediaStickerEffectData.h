//
//  TuSDKMediaStickerEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectData.h"

/**
 video 贴纸特效
 */
@interface TuSDKMediaStickerEffectData : TuSDKMediaEffectData

/**
 贴纸数据
 */
@property (nonatomic,readonly,strong) TuSDKPFStickerGroup *stickerGroup;


/**
 初始化方法
 */
- (instancetype)initWithStickerGroup:(TuSDKPFStickerGroup *)stickerGroup;

@end
