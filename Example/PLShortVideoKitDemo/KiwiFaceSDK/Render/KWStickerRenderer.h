//
//  KWStickerRenderer.h
//  PLMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/11/14.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "KWRenderProtocol.h"
#import "GPUImage.h"

@class KWSticker;

/**
 Sticker rendering classes
 */
@interface KWStickerRenderer : GPUImageFilter <KWRenderProtocol, GPUImageInput>

typedef void(^StickerRendererPlayOverBlock)(void);

@property(nonatomic, copy) StickerRendererPlayOverBlock stickerRendererPlayOverBlock;

/**
 Need to draw the stickers
 */
@property(nonatomic, strong) KWSticker *sticker;

@property(nonatomic, copy) NSArray<NSArray *> *faces;

@property(nonatomic, copy) NSMutableArray<NSMutableDictionary *> *faceOtherInfos;

/**
 Whether the mirror
 */
@property(nonatomic, assign) BOOL isMirrored;

@end
