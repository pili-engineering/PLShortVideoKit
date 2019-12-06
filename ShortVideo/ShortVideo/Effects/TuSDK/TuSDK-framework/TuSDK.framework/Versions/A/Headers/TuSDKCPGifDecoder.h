//
//  TuSDKCPGifDecoder.h
//  TuSDK
//
//  Created by Yanlin on 1/6/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKCPImageDecoder.h"

@interface TuSDKCPGifDecoder : TuSDKCPImageDecoder

/**
 *  解析图片数据
 *
 *  @param data  图片数据
 *  @param scale DPI缩放级别
 *
 *  @return data TuSDKCPGifDecoder对象
 */
+ (instancetype)decodeData:(NSData *)data scale:(CGFloat)scale;

/**
 *  Frame count
 */
@property (nonatomic, readonly) NSUInteger frameCount;

/**
 *  动画播放次数, 0表示无限循环
 */
@property (nonatomic, readonly) NSUInteger loopCount;

/**
 *  动画播放一次的总时长，单位: 秒
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 *  使用增量方式更新图片数据
 *
 *  @param data       图片数据
 *  @param stopAppend 是否停止添加数据
 *
 *  @return BOOL 操作是否成功
 */
- (BOOL)updateData:(NSData *)data stopAppend:(BOOL)stopAppend;

/**
 *  获取指定帧的对象
 *
 *  @param index            帧索引
 *  @param shouldDecodeData 是否解析数据
 *
 *  @return TuSDKCPImageFrame 对象
 */
- (TuSDKCPImageFrame *)frameAtIndex:(NSUInteger)index shouldDecodeData:(BOOL)shouldDecodeData;

/**
 *  获取指定帧的时长，单位: 秒
 *
 *  @param index 帧索引
 *
 *  @return NSTimeInterval 对象 帧时长
 */
- (NSTimeInterval)frameDurationAtIndex:(NSUInteger)index;

@end
