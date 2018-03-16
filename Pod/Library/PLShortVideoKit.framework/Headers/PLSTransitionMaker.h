//
//  PLSTransitionMaker.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/1/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSImageSetting.h"
#import "PLSTextSetting.h"
#import "PLSTransition.h"

#define INVALID_RESOURCEID (0)

@class PLSTransitionMaker;
@protocol PLSTransitionMakerDelegate
<
NSObject
>
@optional

/**
 @abstract 预览结束会回调
 
 @since      v1.10.0
 */
- (void)transitionMakerPreviewEnd:(PLSTransitionMaker *)transitionMaker;

/**
 @abstract 文字转视频成功回调，
 @param outURL 存放导出视频的url
 
 @since      v1.10.0
 */
- (void)transitionMaker:(PLSTransitionMaker *)transitionMaker exportMediaSucceed:(NSURL *)outURL;

/**
 @abstract 文字转视频失败回调
 @param error 导出视频错误信息
 
 @since      v1.10.0
 */
- (void)transitionMaker:(PLSTransitionMaker *)transitionMaker exportMediaFailed:(NSError *)error;

@end



@interface PLSTransitionMaker : NSObject

/**
 @brief 生成视频的宽高，建议和背景视频宽高比例保持一致. must set
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGSize outPixelSize;

/**
 @brief 生成视频的帧率，= 0时，将使用背景视频的frameRate
 
 @since      v1.10.0
 */
@property (nonatomic, assign) float outFrameRate;

/**
 @brief 生成视频底色, default: nil
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 @brief 视频总时长, default: 2.5s
 
 @since      v1.10.0
 */
@property (nonatomic, assign) double totalDuration;

/**
 @brief 代理
 
 @since      v1.10.0
 */
@property (nonatomic, weak) id<PLSTransitionMakerDelegate> delegate;

/**
 @brief 生成视频进度 block 回调
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^exportProgressBlock)(CGFloat progress);

/**
 @brief 预览view
 
 @since      v1.10.0
 */
@property (nonatomic, readonly) UIView *preview;

/**
 @brief 背景视频的URL（提供一个纯白或纯黑的视频作为文字的背景）
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *backgroundVideoURL;

/**
 @brief 最终生成的视频的存放URL
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *outputVideoURL;

/**
 @abstract 添加PLSTextSetting
 @param textSetting 要添加的实例
 
 @return 返回唯一的resourceID编号，后面更新此textSetting的时候，带上返回的编号
 @since      v1.10.0
 */
- (NSInteger)addText:(PLSTextSetting *)textSetting;

/**
 @abstract 添加PLSImageSetting
 @param imageSetting 要添加的实例
 
 @return 返回唯一的resourceID编号，后面更新此imageSetting的时候，带上返回的编号
 @since      v1.10.0
 */
- (NSInteger)addImage:(PLSImageSetting *)imageSetting;

/**
 @abstract 添加PLSTransition到知道资源
 @param transition 要添加的动画
 @param resourceID 动画作用的资源编号
 
 @since      v1.10.0
 */
- (void)addTransition:(PLSTransition *)transition resourceID:(NSInteger)resourceID;

/**
 @abstract 更新textsetting
 @param resourceID  更新的PLSTextSetting编号
 @param textSetting 新的PLSTextSetting实例，如果为nil，则执行删除resourceID操作
 
 @since      v1.10.0
 */
- (void)updateTextWithResourceID:(NSInteger)resourceID newTextSetting:(PLSTextSetting *)textSetting;

/**
 @abstract 更新imageSetting
 @param resourceID      更新的PLSImageSetting编号
 @param imageSetting    新的PLSImageSetting实例,如果为nil，则执行删除resourceID操作
 
 @since      v1.10.0
 */
- (void)updateImageWithResourceID:(NSInteger)resourceID newImageSetting:(PLSImageSetting *)imageSetting;

/**
 @abstract 删除所有文字和图片
 
 @since      v1.10.0
 */
- (void)removeAllResource;

/**
 @abstract 播放
 
 @since      v1.10.0
 */
- (void)play;

/**
 @abstract 停止播放
 
 @since      v1.10.0
 */
- (void)stop;

/**
 @abstract 开始制作视频
 
 @since      v1.10.0
 */
- (void)startMaking;

/**
 @abstract 取消视频制作
 
 @since      v1.10.0
 */
- (void)cancelMaking;

@end
