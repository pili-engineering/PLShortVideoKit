//
//  PLSRangeMediaTools.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

@class PLSRangeMedia;

/*!
 @class PLSRangeMediaTools
 @brief 视频切割工具类
 
 @since      v1.10.0
 */
@interface PLSRangeMediaTools : NSObject

/*!
 @method playerItemWithRangeMedia:
 @abstract 根据PLSRangeMedia的选段信息，生成一个AVPlayerItem，将多段视频整合在一个AVPlayerItem中, 相当于
           [PLSRangeMediaTools playerItemWithRangeMedia:rangeMedias
                                              videoSize:CGSizeZero
                                               fillMode:PLSVideoFillModePreserveAspectRatioAndFill]
 @param rangeMedias 待拼接的视频文件
 
 @return 返回拼接之后的 AVPlayerItem 实例
 @since      v1.10.0
 */
+ (AVPlayerItem *)playerItemWithRangeMedia:(NSArray<PLSRangeMedia *> *)rangeMedias;

/*!
 @method playerItemWithRangeMedia:videoSize:videoSize;
 @abstract 根据PLSRangeMedia的选段信息，生成一个AVPlayerItem，将多段视频整合在一个AVPlayerItem中。
 
 @param    rangeMedias 视频源
 @param    videoSize   生成视频的宽高，如果为 CGSizeZero，将使用第一个视频的宽高作为生成视频的宽高
 @param    fillMode    如果 rangeMedias 的视频宽高比例和 videoSize 宽高比例不一样的时候，使用的填充模式
 
 @return 返回拼接之后的 AVPlayerItem 实例
 @since      v1.16.0
 */
+ (AVPlayerItem *)playerItemWithRangeMedia:(NSArray<PLSRangeMedia *> *)rangeMedias videoSize:(CGSize)videoSize fillMode:(PLSVideoFillModeType)fillMode;

@end
