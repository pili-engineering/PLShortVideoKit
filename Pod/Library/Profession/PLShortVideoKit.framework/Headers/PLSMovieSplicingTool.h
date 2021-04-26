//
//  PLSMovieSplicingTool.h
//  PLShortVideoKit
//
//  Created by 安浩雄 on 2018/11/13.
//  Copyright © 2018 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

/*!
 @class PLSMovieSplicingTool
 @brief 多个 AVAsset 拼接工具类
 */
@interface PLSMovieSplicingTool : NSObject

/*!
 @method splicingMultiMovie:compisition:slicingMode:videoSize:frameRate:
 @brief 将多个 AVAsset 拼接到一个 AVMutableComposition 中
 
 @param assets  待拼接的 AVAsset 数组，如果一个 AVAsset 实例中包含多个音频轨道或多个视频轨道，则只会使用第一个音频/视频轨道进行拼接，另外的轨道会被忽略
 @param composition 用于拼接的 AVMutableComposition 实例
 @param priorityType 拼接的偏好，主要是两个视频连接处处理，如无特殊需求，传 PLSComposerPriorityTypeSync. 具体的含义请查看 PLSComposerPriorityType
 @param videoSize 拼接之后，视频的宽高
 @param frameRate 拼接之后，视频的帧率。此参数只能降帧率，不能升帧率。比如参与拼接的视频一个是 10fps, 一个是 20fps，frameFate 设置为 15，那么会将 20 fps 的视频按照 15fps 来处理，10fps 的视频维持原帧率不变
 
 @see PLSComposerPriorityType
 */
+ (AVMutableVideoComposition *_Nullable)splicingMultiMovie:(NSArray <AVAsset *> * _Nonnull)assets
                                               compisition:(AVMutableComposition * _Nonnull)composition
                                               slicingMode:(PLSComposerPriorityType )priorityType
                                                 videoSize:(CGSize)videoSize
                                                 frameRate:(CGFloat)frameRate;
@end
