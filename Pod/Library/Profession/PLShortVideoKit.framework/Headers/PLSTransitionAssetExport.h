//
//  PLSTransitionAssetExport.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSTransition.h"
#import "PLSImageSetting.h"
#import "PLSTextSetting.h"

/*!
 @class PLSTransitionAssetExport
 @brief 转场动画导出类
 */
@interface PLSTransitionAssetExport : NSObject

/*!
 @property scale
 @brief 设置背景视频和生成的视频的大小比例，用来调整文字或者图片在背景视屏中的相对位置和大小
 */
@property (nonatomic, assign) CGFloat scale;

- (void)addText:(PLSTextSetting *)textSetting transition:(NSArray<PLSTransition *> *)transitions;

- (void)addImage:(PLSImageSetting *)imageSetting transition:(NSArray<PLSTransition *> *)transitions;

- (void)startWithAsset:(AVAsset *)asset
                outURL:(NSURL *)outURL
          outPixelSize:(CGSize)outSize
         totalDuration:(float)duration
             frameRate:(float)frameRate
       backgroundColor:(UIColor *)backgroundColor
              progress:(void(^)(float progress))progressBlock
              complete:(void(^)(bool isSucceed, NSError *error))completeBlock;

- (void)cancelExport;

@end
