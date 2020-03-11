//
//  TuSDKLiveStickerImage.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 16/11/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKPFSticker.h"
#import <CoreMedia/CoreMedia.h>

@interface TuSDKStickerAnimationItem : NSObject

- (instancetype)initWithTextueID:(GLuint)textureID imageWidth:(NSUInteger)imageWidth;

@property (nonatomic, readonly) NSUInteger imageWidth;

@property (nonatomic, readonly) GLuint textureID;
@end

/**
 *  处理智能贴纸素材，转为 GL Texture
 */
@interface TuSDKLiveStickerImage : NSObject

/**
 根据图片进行初始化

 @param image 图片
 
 @return TuSDKLiveStickerImage 实例
 */
+ (instancetype)initWithImage:(UIImage *)image;

/**
 *  当前贴纸对象
 */
@property (nonatomic, readonly) TuSDKPFSticker *currentSticker;

/**
 *  是否可用，在材质加载完毕后置为 YES
 */
@property (nonatomic, readonly) BOOL enabled;

/**
 *  是否处于使用状态
 */
@property (nonatomic, readonly) BOOL actived;

/**
 设置是否根据计时时间自动播放贴纸  默认为 YES 即，使用计时器自动更改贴纸index 
 */
@property (nonatomic, assign) BOOL isAutoplayStickers;

/**
 贴纸显示时间，当选择了某一段视频时，需要传入此参数进行贴纸帧和视频帧时间的校对
 */
@property (nonatomic) CMTime stickerShowTime;

/**
 *  更新智能贴纸素材
 *
 *  @param newSticker TuSDKPFSticker 对象
 *
 */
- (void)updateSticker:(TuSDKPFSticker *)newSticker;

/**
 *  移除贴纸
 */
- (void)removeSticker;

/**
 *  获取当前 Texture ID
 */
- (GLuint)getCurrentTextureID;

/**
 *  获取当前 Texture
 */
- (TuSDKStickerAnimationItem *)getCurrentTexture;

/**
 *  重置
 */
- (void)reset;

/**
 *  开始
 */
- (void)startStickerAnimation;

/**
 从贴纸的某一帧开始播放动画

 @param index 贴纸帧数
 */
- (void)playFromFrameIndex:(NSInteger)index;

/**
 根据视频帧的时间，改变对应的贴纸帧

 @param frameTime 视频帧的贴纸播放时间(注：当选中了贴纸区域时，frameTime = 视频时间 - 贴纸的开始时间)
 */
- (void)seekToFrameByTime:(CMTime)frameTime;

@end
