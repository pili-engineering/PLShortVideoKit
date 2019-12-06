//
//  TuSDKMediaTextEffectData.h
//  TuSDKVideo
//
//  Created by songyf on 2018/6/5.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectCore.h"

/**
 文字贴图数据类
 @since v2.2.0
 */
@interface TuSDKMediaTextEffect : TuSDKMediaEffectCore

/**
 初始化方法
 @param stickerText TuSDKPFStickerText
 @return TuSDKMediaTextEffectData
 @since v2.2.0
 */
- (instancetype)initWithStickerText:(TuSDKPFStickerText *)stickerText center:(CGRect)center degree:(CGFloat)degree designSize:(CGSize)designSize;

/**
 初始化方法
 @param stickerImage UIImage
 @return TuSDKMediaTextEffectData
 @since v2.2.0
 */
- (instancetype)initWithStickerImage:(UIImage *)stickerImage center:(CGRect)centerPercent degree:(CGFloat)degree designSize:(CGSize)designSize;

/**
 文字贴纸数据
 @since v2.2.0
 */
@property (nonatomic,strong,readonly) TuSDK2DImageSticker *textStickerImage;

@end
