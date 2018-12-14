//
//  TuSDKMediaEffectTypes.h
//  TuSDKVideo
//
//  Created by sprint on 18/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 特效数据类型

 - TuSDKMediaEffectDataTypeFilter: 滤镜特效
 - TuSDKMediaEffectDataTypeAudio: 音频特效
 - TuSDKMediaEffectDataTypeSticker: 贴纸特效
 - TuSDKMediaEffectDataTypeStickerAudio: 贴纸+音效
 - TuSDKMediaEffectDataTypeScene: 场景特效
 - TuSDKMediaEffectDataTypeParticle: 粒子特效
 - TuSDKMediaEffectDataTypeStickerText: 字幕贴纸特效
 - TuSDKMediaEffectDataTypeComic : 漫画特效
 */
typedef NS_ENUM(NSUInteger,TuSDKMediaEffectDataType)
{
    TuSDKMediaEffectDataTypeFilter = 0,
    TuSDKMediaEffectDataTypeAudio ,
    TuSDKMediaEffectDataTypeSticker,
    TuSDKMediaEffectDataTypeStickerAudio,
    TuSDKMediaEffectDataTypeScene,
    TuSDKMediaEffectDataTypeParticle,
    TuSDKMediaEffectDataTypeStickerText,
    TuSDKMediaEffectDataTypeComic
};
