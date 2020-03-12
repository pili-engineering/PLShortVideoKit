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

/*!
 @protocol PLSTransitionMakerDelegate
 @brief 转场动画制作协议
 
 @since      v1.10.0
 */
@protocol PLSTransitionMakerDelegate
<
NSObject
>
@optional

/*!
 @method transitionMakerPreviewEnd:
 @abstract 预览结束会回调
 
 @param transitionMaker PLSTransitionMaker 实例
 
 @since      v1.10.0
 */
- (void)transitionMakerPreviewEnd:(PLSTransitionMaker *)transitionMaker;

/*!
 @method transitionMaker:exportMediaSucceed:
 @abstract 文字转视频成功回调，
 
 @param transitionMaker PLSTransitionMaker 实例
 @param outURL 存放导出视频的url
 
 @since      v1.10.0
 */
- (void)transitionMaker:(PLSTransitionMaker *)transitionMaker exportMediaSucceed:(NSURL *)outURL;

/*!
 @method transitionMaker:exportMediaFailed:
 @abstract 文字转视频失败回调
 
 @param transitionMaker PLSTransitionMaker 实例
 @param error 导出视频错误信息
 
 @since      v1.10.0
 */
- (void)transitionMaker:(PLSTransitionMaker *)transitionMaker exportMediaFailed:(NSError *)error;

@end


/*!
 @class PLSTransitionMaker
 @brief 转场动画制作类
 
 @since      v1.10.0
 */
@interface PLSTransitionMaker : NSObject

/*!
 @property outPixelSize
 @brief 生成视频的宽高，建议和背景视频宽高比例保持一致. must set
 
 @since      v1.10.0
 */
@property (nonatomic, assign) CGSize outPixelSize;

/*!
 @property outFrameRate
 @brief 生成视频的帧率，= 0时，将使用背景视频的frameRate
 
 @since      v1.10.0
 */
@property (nonatomic, assign) float outFrameRate;

/*!
 @property backgroundColor
 @brief 生成视频底色, default: nil
 
 @since      v1.10.0
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/*!
 @property totalDuration
 @brief 视频总时长, default: 2.5s
 
 @since      v1.10.0
 */
@property (nonatomic, assign) double totalDuration;

/*!
 @property delegate
 @brief 代理
 
 @since      v1.10.0
 */
@property (nonatomic, weak) id<PLSTransitionMakerDelegate> delegate;

/*!
 @property exportProgressBlock
 @brief 生成视频进度 block 回调
 
 @since      v1.10.0
 */
@property (copy, nonatomic) void(^exportProgressBlock)(CGFloat progress);

/*!
 @property preview
 @brief 预览view
 
 @since      v1.10.0
 */
@property (nonatomic, readonly) UIView *preview;

/*!
 @property backgroundVideoURL
 @brief 背景视频的URL（提供一个纯白或纯黑的视频作为文字的背景）
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *backgroundVideoURL;

/*!
 @property outputVideoURL
 @brief 最终生成的视频的存放URL
 
 @since      v1.10.0
 */
@property (nonatomic, strong) NSURL *outputVideoURL;

/*!
 @method addText:
 @abstract 添加PLSTextSetting
 
 @param textSetting 要添加的实例
 
 @return 返回唯一的resourceID编号，后面更新此textSetting的时候，带上返回的编号
 @since      v1.10.0
 */
- (NSInteger)addText:(PLSTextSetting *)textSetting;

/*!
 @method addImage:
 @abstract 添加PLSImageSetting
 
 @param imageSetting 要添加的实例
 
 @return 返回唯一的resourceID编号，后面更新此imageSetting的时候，带上返回的编号
 @since      v1.10.0
 */
- (NSInteger)addImage:(PLSImageSetting *)imageSetting;

/*!
 @method addTransition:resourceID:
 @abstract 添加PLSTransition到知道资源
 
 @param transition 要添加的动画
 @param resourceID 动画作用的资源编号
 
 @since      v1.10.0
 */
- (void)addTransition:(PLSTransition *)transition resourceID:(NSInteger)resourceID;

/*!
 @method updateTextWithResourceID:newTextSetting:
 @abstract 更新textsetting
 
 @param resourceID  更新的PLSTextSetting编号
 @param textSetting 新的PLSTextSetting实例，如果为nil，则执行删除resourceID操作
 
 @since      v1.10.0
 */
- (void)updateTextWithResourceID:(NSInteger)resourceID newTextSetting:(PLSTextSetting *)textSetting;

/*!
 @method updateImageWithResourceID:newImageSetting:
 @abstract 更新imageSetting
 
 @param resourceID      更新的PLSImageSetting编号
 @param imageSetting    新的PLSImageSetting实例,如果为nil，则执行删除resourceID操作
 
 @since      v1.10.0
 */
- (void)updateImageWithResourceID:(NSInteger)resourceID newImageSetting:(PLSImageSetting *)imageSetting;

/*!
 @method removeAllResource
 @abstract 删除所有文字和图片
 
 @since      v1.10.0
 */
- (void)removeAllResource;

/*!
 @method play
 @abstract 播放
 
 @since      v1.10.0
 */
- (void)play;

/*!
 @method stop
 @abstract 停止播放
 
 @since      v1.10.0
 */
- (void)stop;

/*!
 @method startMaking
 @abstract 开始制作视频
 
 @since      v1.10.0
 */
- (void)startMaking;

/*!
 @method cancelMaking
 @abstract 取消视频制作
 
 @since      v1.10.0
 */
- (void)cancelMaking;

@end
