//
//  TuSDKMediaAssetToComposition.h
//  TuSDKVideo
//
//  Created by sprint on 10/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "TuSDKMediaAsset.h"

/**
 资产切片
 @since v3.0.1
 */
@interface TuSDKMediaAssetComposition : NSObject

/**
 初始化资产切片对象

 @param mediaAsset 输入的资产信息

 @since v3.0.1
 */
- (instancetype)initWithMediaAsset:(TuSDKMediaAsset *_Nonnull)mediaAsset;

/**
 输入的资产信息
 @since v3.0.1
 */
@property (nonatomic,readonly)TuSDKMediaAsset * _Nonnull inputMediaAsset;

/**
 输出宽高 默认：原资产宽高
 @since v3.0.1
 */
@property (nonatomic)CGSize outputSize;

/**
 输出的资产信息
 @since v3.0.1
 */
@property (nonatomic,readonly)AVAsset *outputAsset;

/**
 输出变换
 @since v3.0.1
 */
@property (nonatomic)CGAffineTransform outputTransform;

/**
 根据 outputSize 及 mediaAsset 信息自动生成 videoComposition 信息.
 videoComposition 将包含视频缩放，视频旋转，居中裁剪等指令。
 
 @since v3.0.1
 */
@property (nonatomic,readonly)AVMutableVideoComposition *videoComposition;

@end
