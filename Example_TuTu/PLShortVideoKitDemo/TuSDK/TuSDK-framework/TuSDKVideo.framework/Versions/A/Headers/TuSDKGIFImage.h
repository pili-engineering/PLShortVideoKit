//
//  TuSDKGIFImage.h
//  TuSDKVideo
//
//  Created by bqlin on 2018/8/7.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 GIF 图像解码显示类
 继承于 UIImage，其保存了 GIF 的全部数据。
 
 UIImage 重写的方法保持了与 UIImage 的逻辑，若用于显示 GIF 动图，请使用 `+gifImageName:` 方法。
 
 @since v3.0
 */
@interface TuSDKGIFImage : UIImage

#pragma mark - UIImage 方法重写

+ (instancetype)imageNamed:(NSString *)name;
+ (instancetype)imageWithContentsOfFile:(NSString *)path;
+ (instancetype)imageWithData:(NSData *)data;
+ (instancetype)imageWithData:(NSData *)data scale:(CGFloat)scale;

#pragma mark -

/// 动图原始数据
@property (nonatomic, strong, readonly) NSData *animatedImageData;

/// 动图帧数量
@property (nonatomic, assign, readonly) NSUInteger animatedImageFrameCount;

/// 动图循环次数，0 则为无限循环
@property (nonatomic, assign, readonly) NSUInteger animatedImageLoopCount;

/**
 返回给定索引的帧图像。
 该方法可能在后台线程调用。

 @param index 帧图像索引
 @return UIImage 图像
 */
- (UIImage *)animatedImageFrameAtIndex:(NSUInteger)index;

/**
 返回给定索引的帧时长。

 @param index 帧图像索引
 @return 帧时长
 */
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;

/**
 使用 TuSDKGifImage 解码 GIF，并返回动图 UIImage 对象。
 该方法在解码 GIF 后，会释放解码器，以达到最小内存占用。

 @param name GIF 名称，可使用 `+imageNamed:` 一致的用法传入 GIF 的文件名称。
 @return UIImage 对象
 */
+ (UIImage *)gifImageName:(NSString *)name;

/**
 使用 TuSDKGifImage 解码 GIF，并在主队列回调中返回动图 UIImage 对象。
 用户可把该方法放在自己管理的队列中进行多线程解码。
 该方法在解码 GIF 后，会释放解码器，以达到最小内存占用。

 @param name GIF 名称，可使用 `+imageNamed:` 一致的用法传入 GIF 的文件名称。
 @param firstFrameImageCompletion 首帧图像对象主队列回调
 @param animatedImageCompletion 动图对象主队列回调
 */
+ (void)requestGifImageWithName:(NSString *)name firstFrameImageCompletion:(void (^)(UIImage *firstFrameImage))firstFrameImageCompletion animatedImageCompletion:(void (^)(UIImage *animatedImage))animatedImageCompletion;

@end
