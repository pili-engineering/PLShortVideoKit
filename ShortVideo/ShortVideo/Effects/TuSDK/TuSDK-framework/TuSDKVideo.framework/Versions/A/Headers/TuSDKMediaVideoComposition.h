//
//  TuSDKMediaVideoComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/14.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaComposition.h"

NS_ASSUME_NONNULL_BEGIN

/**
视频合成项
 
@since v3.4.1
*/
@protocol TuSDKMediaVideoComposition <TuSDKMediaComposition>

/**
 该 Composition 输出的像素格式.
 
 @return 输出格式
 @since v3.4.1
 */
@property (nonatomic,readonly)OSType outputPixelFormatType;

/**
 画面输出方向
 
 @since v3.4.1
 */
@property (nonatomic,readonly) LSQGPUImageRotationMode outputRotation;

/**
 最佳输出尺寸
 
 @since v3.4.1
 */
@property (nonatomic,readonly)CGSize preferredOutputSize;


@end

NS_ASSUME_NONNULL_END
