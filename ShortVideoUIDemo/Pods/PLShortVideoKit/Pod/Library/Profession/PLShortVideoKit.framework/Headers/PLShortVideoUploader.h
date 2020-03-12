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

/*!
 @protocol PLShortVideoUploaderDelegate
 @brief 文件上传协议
 
 @since      v1.0.4
 */
@protocol PLShortVideoUploaderDelegate <NSObject>

@optional

/*!
 @method shortVideoUploader:uploadKeyuploadPercent:
 @abstract 上传进度回调
 @discussion 一个 PLShortVideoUploader 实例实现视频上传功能。
 
 @param uploader PLShortVideoUploader 实例
 @param uploadKey 上传的 key 值
 @param uploadPercent 上传进度
 
 @since      v1.0.4
 */
- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader uploadKey:(NSString * _Nullable)uploadKey uploadPercent:(float)uploadPercent;

/*!
 @method shortVideoUploader:completeInfo:uploadKey:resp:
 @abstract 上传结果回调
 
 @param uploader PLShortVideoUploader 实例
 @param info 上传完成信息
 @param uploadKey 上传的 key 值
 @param resp 上传完成的返回信息
 
 @since      v1.0.4
 */
- (void)shortVideoUploader:(PLShortVideoUploader * _Nonnull)uploader completeInfo:(PLSUploaderResponseInfo * _Nonnull)info uploadKey:(NSString * _Nonnull)uploadKey resp:(NSDictionary * _Nullable)resp;

@end

/*!
 @class PLShortVideoUploader
 @abstract 短视频录制的上传功能核心类。
 
 @discussion 一个 PLShortVideoUploader 实例实现段视频上传功能。
 */
@interface PLShortVideoUploader : NSObject

/*!
 @property cancelUpload
 @brief 取消／继续上传，YES 为取消上传，NO 为继续上传，默认为 NO
 
 @since      v1.0.4
 */
@property (nonatomic, assign, readonly, getter=isCancelUpload)BOOL cancelUpload;

/*!
 @property uploadPercent
 @brief 上传进度
 
 @since      v1.0.4
 */
@property (nonatomic, assign, readonly)float uploadPercent;

/*!
 @property uploadConfig
 @brief 上传配置参数
 @see   PLSUploaderConfiguration类
 
 @since      v1.0.4
 */
@property (nonatomic, strong, readonly)PLSUploaderConfiguration * _Nonnull uploadConfig;

/*!
 @property delegate
 @brief 代理对象，用于告知上传状态改变或其他行为，对象需实现 PLSUploadDelegate 协议
 
 @since v1.0.4
 */
@property (nonatomic, weak, nullable) id<PLShortVideoUploaderDelegate>  delegate;

/*!
 @method sharedUploader:
 @abstract   创建 PLShortVideoUploader 单例对象
 
 @return PLShortVideoUploader 实例
 
 @since      v1.0.4
 */
+ (instancetype _Nullable)sharedUploader:(PLSUploaderConfiguration * _Nonnull)config;

/*!
 @method initWithConfiguration:
 @abstract   初始化 PLShortVideoUploader
 
 @return PLShortVideoUploader 实例

 @since      v1.0.4
 */
- (instancetype _Nullable)initWithConfiguration:(PLSUploaderConfiguration * _Nonnull)config;

/*!
 @method uploadVideoFile:
 @abstract   上传视频文件
 
 @param videoPath 上传的视频文件存放地址
 
 @since      v1.0.4
 */
- (void)uploadVideoFile:(NSString * _Nonnull)videoPath;

/*!
 @method uploadVideoALAsset:
 @abstract   上传 ALAsset 类视频资源文件
 
 @param asset 上传的 ALAsset 视频文件
 
 @since      v1.0.5
 */
- (void)uploadVideoALAsset:(ALAsset * _Nonnull)asset;

/*!
 @method uploadVideoPHAsset:
 @abstract   上传 PHAsset 类视频资源文件
 
 @param asset 上传的 PHAsset 视频文件
 
 @since      v1.0.5
 */
- (void)uploadVideoPHAsset:(PHAsset * _Nonnull)asset;

/*!
 @method cancelUploadVidoFile
 @abstract   取消上传视频
 
 @since      v1.0.4
 */
- (void)cancelUploadVidoFile;

@end
