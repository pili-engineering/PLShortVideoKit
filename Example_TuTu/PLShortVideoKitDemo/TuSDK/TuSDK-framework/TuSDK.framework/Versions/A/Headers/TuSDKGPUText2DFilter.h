//
//  TuSDKGPUText2DFilter.h
//  TuSDK
//
//  Created by tutu on 2018/6/8.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKFilterAdapter.h"
#import "TuSDKTextStickerImage.h"

/**
 2D 文字贴纸
 @since v2.2.0
 */
@interface TuSDKGPUText2DFilter : TuSDKFilter
/**
 文字贴纸纹理管理对象
 @since v2.2.0
 */
@property (nonatomic,strong) TuSDKTextStickerImage *text2DStickerImage;

/**
 设置显示区域和视图比例
 @param displayRect 显示区域
 @param ratio 画面尺寸
 @since v2.2.0
 */
- (void)setDisplayRect:(CGRect)displayRect withRatio:(CGFloat)ratio;


@end

