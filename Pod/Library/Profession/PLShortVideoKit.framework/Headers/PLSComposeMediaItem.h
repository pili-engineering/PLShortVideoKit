//
//  PLSComposeMediaItem.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/10/29.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

/*!
 @class     PLSComposeMediaItem
 @brief     图片视频混排媒体信息类
 
 @since      v1.16.0
 */
@interface PLSComposeMediaItem : NSObject

#pragma mark - Common property

/*!
 @property  mediaType
 @brief     媒体文件类型.
 
 @since      v1.16.0
 */
@property (assign, nonatomic) PLSMediaType mediaType;

/*!
 @property  url
 @brief     媒体文件存放地址。普通图片、视频和 GIF 都可以使用 url 传递
 
 @since      v1.16.0
 */
@property (strong, nonatomic) NSURL *_Nullable url;

/*!
 @property transitionDuration
 @brief 显示媒体前，产生转场动画持续的时长，默认为 1.0，即 1 秒. 如果 transitionDuration 的值大于媒体总时长的一半，则将使用媒体总时长的一半作为转场动画的时长.仅当属性  disableTransition 为 NO 时生效
 
 @since      v3.2.0
 */
@property (assign, nonatomic) NSTimeInterval transitionDuration;

/*!
 @property  transitionType
 @brief     媒体文件的转场特效，默认是淡入淡出
 
 @since      v3.2.0
 */
@property (assign, nonatomic) PLSTransitionType transitionType;

#pragma mark - Video property

/*!
 @property  asset
 @brief     如果当前媒体文件是视频，asset 和 url 同时有值的情况下，将使用 asset，忽略 url
 
 @since      v1.16.0
 */
@property (strong, nonatomic) AVAsset *_Nullable asset;

/*!
 @property  timeRange
 @brief     如果当前媒体文件是视频，选取视频片段，未设置时默认为 kCMTimeRangeZero，将使用整个视频；设置具体值时长不为 0 且时长小于等于总时长时，则按照设置的起始点位置使用，大于总时长将使用整个视频
 
 @since      v3.1.0
 */
@property (assign, nonatomic) CMTimeRange timeRange;

#pragma mark - Image property

/*!
 @property  image
 @brief     如果当前媒体文件是图片，image 和 url 同时有值的情况下，将使用 image，忽略 url
 
 @since      v1.16.0
 */
@property (strong, nonatomic) UIImage *_Nullable image;

/*!
 @property  imageDuration
 @brief     图片转换为视频的时长,默认为3.0，即3秒；建议大于2秒
 
 @since      v1.16.0
 */
@property (assign, nonatomic) CGFloat imageDuration;


#pragma mark - GIF property

/*!
 @property  gifImageData
 @brief     如果当前媒体文件是 GIF，gifImageData 和 url 同时有值的情况下，将使用 gifImageData，忽略 url
            注意：GIF 资源不能通过 UIImage 来传递
 
 @since      v1.16.0
 */
@property (strong, nonatomic) NSData * _Nullable gifImageData;

/*!
 @property  loopCount
 @brief     如果当前媒体文件是 GIF，则代表 GIF 转为视频的时候，GIF 循环播放的次数. 默认：1，即不做循环
            如果当前媒体文件不是 GIF，则 loopCount 不会被使用
 
 @since      v1.16.0
 */
@property (assign, nonatomic) NSInteger loopCount;

@end

