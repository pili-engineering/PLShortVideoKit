//
//  PLSRangeMediaTools.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class PLSRangeMedia;


@interface PLSRangeMediaTools : NSObject

/**
 @abstract 根据PLSRangeMedia的选段信息，生成一个AVPlayerItem，将多段视频整个在一个AVPlayerItem中。
 
 @since      v1.10.0
 */
+ (AVPlayerItem *)playerItemWithRangeMedia:(NSArray<PLSRangeMedia *> *)rangeMedias;

@end
