//
//  TuSDK2DImageSticker.h
//  TuSDK
//
//  Created by songyf on 2018/6/5.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLGPUImage.h"

/**
 文字/图片贴纸数据包装
 @since v2.2.0
 */
@interface TuSDK2DImageSticker : NSObject

/**
 根据图片进行初始化
 @param  stickerImage 图片
 @return TuSDKLiveStickerImage 实例
 @since  v2.2.0
 */
- (instancetype)initWithStickerImage:(UIImage *)stickerImage;

/**
 当前贴纸对象
 
 @since v2.2.0
 */
@property (nonatomic,strong,readonly) UIImage *image;

/**
 编辑贴纸时屏幕大小
 
 @since v2.2.0
 */
@property (nonatomic) CGSize designScreenSize;

/**
 当前文字贴纸相对于 designScreenSize 中心点坐标百分比
 
 @since v2.2.0
 */
@property (nonatomic,assign) CGPoint centerPercent;

/**
 绘制的图片大小
 
 @since v3.3.2
 */
@property (nonatomic) CGSize imageSize;

/**
 当前文字贴纸的旋转角度
 
 @since v2.2.0
 */
@property (nonatomic,assign) float degree;

/**
 当前图片的纹理ID
 @since v2.2.0
 */
@property (nonatomic,assign,readonly) GLuint currentTextureID;

/**
 * 离屏渲染重置Textured
 @since v2.2.0
 */
- (void)reset;

@end
