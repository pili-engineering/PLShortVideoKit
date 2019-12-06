//
//  TuSDKMediaCompositionImageSource.h
//  TuSDKVideo
//
//  Created by sprint on 2019/4/24.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaVideoComposition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 媒体合成数据 Image 数据源
 
 @since v3.4.1
 */
@interface TuSDKMediaImageComposition : NSObject <TuSDKMediaVideoComposition>

/**
 根据 UIImage 初始化 Composition
 
 @param image 合成项
 @return TuSDKMediaImageSampleBufferComposition
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 输入的图片数据
 
 @since v3.4.1
 */
@property (nonatomic,readonly)UIImage *image;

/**
 设置或获取帧间隔. 默认：CMTimeMake(1, 30) 该参数会音效输出帧率
 
 @since v3.4.1
 */
@property (nonatomic)CMTime frameInterval;

/**
 最大输出持续时间 默认: CMTimeMakeWithSeconds(1, USEC_PER_SEC)
 
 @return 输出持续时间
 @since v3.4.1
 */
@property (nonatomic)CMTime maxOutputDuration;


@end

NS_ASSUME_NONNULL_END
