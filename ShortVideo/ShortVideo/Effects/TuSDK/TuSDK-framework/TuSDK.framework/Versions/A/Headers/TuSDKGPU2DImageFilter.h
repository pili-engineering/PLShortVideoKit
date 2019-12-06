//
//  TuSDKGPUText2DFilter.h
//  TuSDK
//
//  Created by tutu on 2018/6/8.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKFilterAdapter.h"
#import "TuSDK2DImageSticker.h"

/**
 GIF贴纸
 @since v3.3.2
 */
@interface TuSDKGPU2DImageFilter : TuSDKFilter

/**
 贴纸纹理管理对象
 @since v3.3.2
 */
@property (nonatomic,strong) TuSDK2DImageSticker *stickerImage;

/**
 设置显示区域和视图比例
 @param displayRect 显示区域
 @param ratio 画面尺寸
 @since v3.3.2
 */
- (void)setDisplayRect:(CGRect)displayRect withRatio:(CGFloat)ratio;


@end

