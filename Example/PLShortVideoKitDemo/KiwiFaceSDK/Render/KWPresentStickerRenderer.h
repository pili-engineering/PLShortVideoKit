//
//  KWPresentStickerRenderer.h
//  KiwiFaceSDK
//
//  Created by sobrr on 2017/2/15.
//  Copyright © 2017年 PLMediaStreamingSDK. All rights reserved.
//

#import "KWRenderProtocol.h"
#import "GPUImage.h"

@class KWSticker;

@interface KWPresentStickerRenderer : GPUImageFilter<KWRenderProtocol, GPUImageInput>

typedef void(^PresentStickerRendererPlayOverBlock)(void);


@property (nonatomic, copy) PresentStickerRendererPlayOverBlock presentStickerRendererPlayOverBlock;

/**
 Need to draw the stickers
 */
@property (nonatomic, strong) KWSticker *sticker;


/**
 Whether the mirror
 */
@property (nonatomic, assign) BOOL isMirrored;

@property (nonatomic, copy) NSArray<NSArray *> *faces;

@property (nonatomic, assign) BOOL needTrackData;


@end
