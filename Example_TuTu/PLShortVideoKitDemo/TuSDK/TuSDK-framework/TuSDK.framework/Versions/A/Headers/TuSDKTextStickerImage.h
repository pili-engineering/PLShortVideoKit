//
//  TuSDKTextStickerImage.h
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
@interface TuSDKTextStickerImage : NSObject

/**
 根据图片进行初始化
 @param  image 图片
 @return TuSDKLiveStickerImage 实例
 @since  v2.2.0
 */
- (instancetype)initWithStickerImage:(UIImage *)stickerImage;

/**
 编辑贴纸时屏幕大小
 @since v2.2.0
 */
@property (nonatomic) CGSize designScreenSize;

/**
 当前贴纸对象
 @since v2.2.0
 */
@property (nonatomic,strong,readonly) UIImage *image;

/**
 贴纸显示位置
 @since v2.2.0
 */
@property (nonatomic,assign) CGRect centerRect;

/**
 是否可用，在材质加载完毕后置为 YES
 @since v2.2.0
 */
@property (nonatomic,assign) BOOL enabled;

/**
 当前图片的纹理ID
 @since v2.2.0
 */
@property (nonatomic,assign,readonly) GLuint currentTextureID;

/**
 当前文字贴纸的旋转角度
 @since v2.2.0
 */
@property (nonatomic,assign) float degree;


/**
 当前文字贴纸的中心点坐标
 @since v2.2.0
 */
@property (nonatomic,assign) CGRect center;

/**
 获取UIImage的纹理Id
 @return  纹理Id
 @since   v2.2.0
 */
- (GLuint)currentTextureID;

/**
 * 离屏渲染重置Textured
 @since v2.2.0
 */
- (void)reset;

@end
