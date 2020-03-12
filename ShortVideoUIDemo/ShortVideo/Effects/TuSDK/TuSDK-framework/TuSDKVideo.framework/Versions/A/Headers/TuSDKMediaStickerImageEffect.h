//
//  TuSDKMediaStickerImageEffect.h
//  TuSDKVideo
//
//  Created by sprint on 2019/2/26.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"
#import "TuSDKVideoImport.h"

NS_ASSUME_NONNULL_BEGIN

/**
 图片贴纸特效
 @since v3.3.2
 */
@interface TuSDKMediaStickerImageEffect : TuSDKMediaEffectCore

/**
 初级滤镜code初始化
 
 @param stickerImage 贴纸组
 @param timeRange 触发时间

 @return TuSDKMediaGIFStickerEffect
 @since v3.3.2
 */
- (instancetype)initWithStickerImage:(TuSDK2DImageSticker *)stickerImage atTimeRange:(TuSDKTimeRange *_Nullable)timeRange;

/**
 初始化方法
 @param stickerImage UIImage
 @return TuSDKMediaTextEffectData
 @since v3.3.2
 */
- (instancetype)initWithStickerImage:(UIImage *)stickerImage center:(CGPoint)centerPercent degree:(CGFloat)degree designSize:(CGSize)designSize;

/**
 显示的本地贴纸数据
 @since v3.3.2
 */
@property (nonatomic,readonly) TuSDK2DImageSticker *stickerImage;

@end


NS_ASSUME_NONNULL_END
