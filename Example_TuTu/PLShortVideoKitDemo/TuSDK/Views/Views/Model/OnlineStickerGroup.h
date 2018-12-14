//
//  OnlineStickerGroup.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/27.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TuSDKFramework.h"

/**
 在线贴纸模型
 */
@interface OnlineStickerGroup : TuSDKPFStickerGroup

/**
 预览图 URL
 */
@property (nonatomic, copy) NSString *previewImage;

/**
 贴纸名称
 */
@property (nonatomic, copy) NSString *name;

/**
 贴纸 ID（stickerID）
 */
@property (nonatomic, assign) uint64_t idt;

@end
