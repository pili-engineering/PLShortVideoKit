//
//  TuSDKVideoImageExtractor.h
//  TuSDKVideo
//
//  Created by gh.li on 17/3/13.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void(^TuSDKVideoImageExtractorBlock)(NSArray<UIImage *> *_Nullable frameImages);
typedef void(^TuSDKVideoImageExtractorStepImageBlock)(UIImage *_Nonnull frameImage, NSUInteger index);

/**
 * 视频缩略图提取器
 */
@interface TuSDKVideoImageExtractor : NSObject

/**
 创建 TuSDKVideoImageExtractor

 @return TuSDKVideoImageExtractor
 */
+ (TuSDKVideoImageExtractor * _Nonnull)createExtractor;

/**
 视频资源
 
 @since v1.0.0
 */
@property (nonatomic, strong, nullable) AVAsset *videoAsset;

/**
 一组视频资源
 
 @since v3.1.0
 */
@property (nonatomic, strong, nullable) NSArray<AVAsset *> *videoAssets;

/**
 输入的视频地址
 
 @since v1.0.0
 */
@property (nonatomic, copy, nullable) NSURL *videoPath;

/**
 指定视频轨道图像提取指令，仅为单个视频时有效
 
 @since v3.0.1
 */
@property (nonatomic, copy, nullable) AVVideoComposition *videoComposition;


/**
 提取的视频帧数，自动根据视频长度均匀获取 (mExtractFrameCount 和 mExtractFrameInterval 都设置时 优先使用mExtractFrameCount)
 
 @since v1.0.0
 */
@property (nonatomic, assign) NSUInteger extractFrameCount;

/**
 提取帧的时间间隔 (单位：s) 张数不固定
 
 @since v1.0.0
 */
@property (nonatomic, assign) CGFloat extractFrameTimeInterval;

/**
 输出的图片尺寸，不设置则按视频宽高比例计算
 注意：要得到清晰图像，需要宽高分别乘以 [UIScreen mainScreen].scale。
 */
@property (nonatomic, assign) CGSize outputMaxImageSize;

/**
 是否需要精确时间帧获取图片, 默认NO
 
 @since 2.2.0
 */
@property (nonatomic, assign) BOOL isAccurate;

/**
 同步提取视频帧
 
 @return 视频帧数据列表
 */
- (NSArray<UIImage *> * _Nullable)extractImageList;

/**
 异步获取视频缩略图
 
 @param handler 所有缩略图获取完成后处理器
 @since v1.0.0
 */
- (void)asyncExtractImageList:(TuSDKVideoImageExtractorBlock _Nonnull)handler;

/**
 异步获取视频缩略图

 @param handler 获取到每帧缩略图时的处理回调
 @since v1.0.0
 */
- (void)asyncExtractImageWithHandler:(TuSDKVideoImageExtractorStepImageBlock _Nonnull)handler;

/**
 同步获取指定时间的视频帧
 
 @param time 帧所在时间
 @return 视频帧
 */
- (UIImage * _Nullable)frameImageAtTime:(CMTime)time;

@end
