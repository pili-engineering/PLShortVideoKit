//
//  TuSDKGIFImageEncoder.h
//  TuSDKVideo
//
//  Created by bqlin on 2018/8/7.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 GIF 图像编码类，用于 GIF 编码与保存。
 
 @since v3.0
 */
@interface TuSDKGIFImageEncoder : NSObject

/// 循环次数，0 则为无限循环
@property (nonatomic, assign) NSUInteger loopCount;

/**
 添加图像到编码器
 
 @param image UIImage 图像
 @param duration 该图像的帧时长，传递 0 则忽略该参数。
 */
- (void)addImage:(UIImage *)image duration:(NSTimeInterval)duration;

/**
 添加图像数据到编码器
 
 @param data 图像数据
 @param duration 该图像的帧时长，传递 0 则忽略该参数。
 */
- (void)addImageWithData:(NSData *)data duration:(NSTimeInterval)duration;

/**
 添加图像文件路径到编码器
 
 @param path 图像文件路径
 @param duration 该图像的帧时长，传递 0 则忽略该参数。
 */
- (void)addImageWithFile:(NSString *)path duration:(NSTimeInterval)duration;

/**
 对添加的图像进行编码并返回结果数据
 
 @return 结果图像数据，若出错则返回 nil。
 */
- (NSData *)encode;

/**
 对添加的图像进行编码，并写入到指定路径
 
 @param path 结果文件路径，如果存在，则覆盖。
 @return 是否写入成功
 */
- (BOOL)encodeToFile:(NSString *)path;

@end
