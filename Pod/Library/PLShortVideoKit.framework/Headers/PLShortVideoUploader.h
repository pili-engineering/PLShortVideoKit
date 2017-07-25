//
//  PLShortVideoUploader.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/7.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSUploaderConfiguration.h"
#import "PLSUploaderResponseInfo.h"


@class PLShortVideoUploader;
@class ALAsset;
@class PHAsset;

@protocol PLShortVideoUploaderDelegate <NSObject>

@optional

/**
 @abstract 上传进度回调
 @discussion 一个 PLShortVideoUploader 实例实现段视频上传功能。
 
 @since      v1.0.4
 */
- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader uploadKey:(NSString * _Nullable)uploadKey uploadPercent:(float)uploadPercent;

/**
 @abstract 上传结果回调
 
 @since      v1.0.4
 */
- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader completeInfo:(PLSUploaderResponseInfo * _Nonnull)info uploadKey:(NSString * _Nonnull)uploadKey resp:(NSDictionary * _Nullable)resp;

@end

/**
 * @abstract 短视频录制的上传功能核心类。
 *
 * @discussion 一个 PLShortVideoUploader 实例实现段视频上传功能。
 */
@interface PLShortVideoUploader : NSObject

/**
 @brief 取消／继续上传，YES 为取消上传，NO 为继续上传，默认为 NO
 
 @since      v1.0.4
 */
@property (nonatomic, assign, readonly, getter=isCancelUpload)BOOL cancelUpload;

/**
 @brief 上传进度
 
 @since      v1.0.4
 */
@property (nonatomic, assign, readonly)float uploadPercent;

/**
 @brief 上传配置参数
 @see   PLSUploaderConfiguration类
 
 @since      v1.0.4
 */
@property (nonatomic, strong, readonly)PLSUploaderConfiguration * _Nonnull uploadConfig;

/**
 代理对象，用于告知上传状态改变或其他行为，对象需实现 PLSUploadDelegate 协议
 
 @since v1.0.4
 */
@property (nonatomic, weak, nullable) id<PLShortVideoUploaderDelegate>  delegate;

/**
 @abstract   创建 PLSUploaderConfiguration 单例对象
 
 @since      v1.0.4
 */
+ (instancetype _Nullable)sharedUploader:(PLSUploaderConfiguration * _Nonnull)config;

/**
 @abstract   初始化 PLShortVideoUploader
 
 @since      v1.0.4
 */
- (instancetype _Nullable)initWithConfiguration:(PLSUploaderConfiguration * _Nonnull)config;

/**
 @abstract   上传视频文件
 
 @since      v1.0.4
 */
- (void)uploadVideoFile:(NSString * _Nonnull)videoPath;

/**
 @abstract   上传 ALAsset 类视频资源文件
 
 @since      v1.0.5
 */
- (void)uploadVideoALAsset:(ALAsset * _Nonnull)asset;

/**
 @abstract   上传 PHAsset 类视频资源文件
 
 @since      v1.0.5
 */
- (void)uploadVideoPHAsset:(PHAsset * _Nonnull)asset;

/**
 @abstract   取消上传视频
 
 @since      v1.0.4
 */
- (void)cancelUploadVidoFile;

@end
