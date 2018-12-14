//
//  TuSDKTSALAssets+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/28.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TuSDKTSAsset.h"

/**
 *  系统相册授权回调
 *
 *  @param error 是否返回错误信息
 */
typedef void (^ALAssetsLibraryAuthorBlock)(NSError *error);

/**
 *  获取系统相册列表回调
 *
 *  @param groups 系统相册列表
 *  @param error  是否返回错误信息
 */
typedef void (^ALAssetsLibraryGroupsBlock)(NSArray *groups, NSError *error);

/**
 *  获取相册封面回调
 *
 *  @param image CGImageRef对象
 */
typedef void (^ALAssetsLibraryPosterBlock)(CGImageRef image);

#pragma mark - ALAssetsLibraryExtend
// 系统相册帮助类
@interface ALAssetsLibrary(ALAssetsLibraryExtend)
/**
 *  是否用户已授权访问系统相册
 *
 *  @return 是否用户已授权访问系统相册
 */
+ (BOOL)lsqHasAuthor;

/**
 *  获取系统相册对象
 *
 *  @return 系统相册对象
 */
+ (ALAssetsLibrary *)lsqDefaultLibrary;

/**
 *  测试系统相册授权状态
 *
 *  @param authorBlock 系统相册授权回调
 */
+ (void)lsqTestLibraryAuthor:(ALAssetsLibraryAuthorBlock)authorBlock;

/**
 *  获取系统相册分组
 *
 *  @param groupsBlock 获取系统相册列表回调
 */
- (void)lsqGetGroupsWithBlock:(ALAssetsLibraryGroupsBlock)groupsBlock;

/**
 *  获取相册封面
 *
 *  @param posterBlock 获取相册封面回调
 */
- (void)lsqGetLibraryPosterWithBlock:(ALAssetsLibraryPosterBlock)posterBlock;
@end

#pragma mark - ALAssetsGroupExtend
@interface ALAssetsGroup(ALAssetsGroupExtend)
/**
 *  获取该组所有相片信息
 *
 *  @return 该组所有相片信息
 */
-(NSArray *)lsqGetAssetsAllphotos;

/**
 *  获取相册名称
 *
 *  @return 相册名称
 */
-(NSString *)lsqName;
@end

#pragma mark - ALAssetsGroupExtend
@interface ALAsset(ALAssetExtend)
/**
 *  获取路径
 *
 *  @return 路径
 */
- (NSURL *)lsqUrl;

/**
 *  获取方向
 *
 *  @return 方向
 */
- (ALAssetOrientation)lsqOrientation;

/**
 *  获取相片方向
 *
 *  @return 相片方向
 */
- (UIImageOrientation)lsqImageOrientation;

/**
 *  判断两个ALAsset路径是否相等
 *
 *  @param asset ALAsset
 *
 *  @return ALAsset路径是否相等
 */
- (BOOL)lsqIsEqualNSURLWith:(ALAsset *)asset;

/**
 *  根据路径获取元素在数组中的索引
 *
 *  @param assets 路径
 *
 *  @return 元素在数组中的索引
 */
- (NSInteger)lsqGetIndexByNSURLInArray:(NSArray *)assets;

/**
 *  获取缩略图 图片
 *
 *  @return 缩略图 图片
 */
- (UIImage *)lsqGetThumbnailImage;

/**
 *  获取缩略图 图片视图
 *
 *  @param frame 坐标长宽
 *
 *  @return 缩略图 图片视图
 */
- (UIImageView *)lsqGetThumbnailViewWithFrame:(CGRect)frame;

/**
 *  获取原始图片对象
 *
 *  @return 原始图片对象
 */
- (UIImage *)lsqFullResolutionImage;

/**
 *  获取屏幕大小图片对象
 *
 *  @return 屏幕大小图片对象
 */
- (UIImage *)lsqFullScreenImage;

/**
 *  照片原始宽高
 *
 *  @return 宽高
 */
- (CGSize)lsqFullResolutionImageSize;

/**
 *  获取图片原信息
 *
 *  @return 图片原信息
 */
- (NSDictionary *)lsqMetadata;
@end

#pragma mark - CustomPhotoAlbum
/**
 *  保存相片到系统相册回掉
 *
 *  @param asset 相片对象
 *  @param error 错误对象
 */
typedef void(^SaveImageCompletion)(ALAsset *asset, NSError* error);

/**
 *  保存相片到指定相册
 *
 *  @param group 相册对象
 *  @param asset 相片对象
 *  @param error 错误对象
 */
typedef void(^SaveImageAblumCompletion)(ALAssetsGroup *group, ALAsset *asset, NSError* error);

/**
 *  ALAssetsLibrary相册扩展
 */
@interface ALAssetsLibrary(CustomPhotoAlbum)
/**
 *  保存图片数据到系统相册
 *
 *  @param data            图片数据
 *  @param completionBlock 完成回掉
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveImageData:(NSData *)data
       completionBlock:(SaveImageCompletion)completionBlock;

/**
 *  保存图片数据到系统相册
 *
 *  @param data            图片数据
 *  @param metadata        照片meta信息
 *  @param completionBlock 完成回掉
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveImageData:(NSData *)data metadata:(NSDictionary *)metadata
       completionBlock:(SaveImageCompletion)completionBlock;

/**
 *  保存图片数据到指定相册
 *
 *  @param data            图片数据
 *  @param albumName       相册名称
 *  @param completionBlock 完成回掉
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveImageData:(NSData *)data toAblum:(NSString *)albumName
       completionBlock:(SaveImageCompletion)completionBlock;

/**
 *  保存图片数据到系统相册
 *
 *  @param data                 图片数据
 *  @param albumName            相册名称
 *  @param completionBlock      完成回掉
 *  @param ablumCompletionBlock 保存相片到指定相册
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveImageData:(NSData *)data toAblum:(NSString *)albumName
       completionBlock:(SaveImageCompletion)completionBlock
  ablumCompletionBlock:(SaveImageAblumCompletion)ablumCompletionBlock;

/**
 *  保存图片数据到系统相册
 *
 *  @param data                 图片数据
 *  @param metadata             照片meta信息
 *  @param albumName            相册名称
 *  @param completionBlock      相册名称
 *  @param ablumCompletionBlock 保存相片到指定相册
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveImageData:(NSData *)data metadata:(NSDictionary *)metadata
               toAblum:(NSString *)albumName
       completionBlock:(SaveImageCompletion)completionBlock
  ablumCompletionBlock:(SaveImageAblumCompletion)ablumCompletionBlock;

/**
 *  保存图片数据到系统相册
 *
 *  @param image                图片对象
 *  @param metadata             照片meta信息
 *  @param albumName            相册名称
 *  @param completionBlock      保存相片到系统相册回掉
 *  @param ablumCompletionBlock 保存相片到指定相册
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveImage:(UIImage *)image metadata:(NSDictionary *)metadata
           toAblum:(NSString *)albumName
   completionBlock:(SaveImageCompletion)completionBlock
ablumCompletionBlock:(SaveImageAblumCompletion)ablumCompletionBlock;

/**
 *  保存视频到系统相册
 *
 *  @param videoURL             视频文件
 *  @param albumName            相册名称
 *  @param completionBlock      保存完成
 *  @param ablumCompletionBlock 保存视频到指定相册
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL)lsqSaveVideo:(NSURL *)videoURL
           toAblum:(NSString *)albumName
   completionBlock:(SaveImageCompletion)completionBlock
ablumCompletionBlock:(SaveImageAblumCompletion)ablumCompletionBlock;

/**
 *  添加照片对象到指定相册
 *
 *  @param asset     照片对象
 *  @param albumName 相册名称
 *  @param ablumCompletionBlock 保存相片到指定相册
 */
- (void)lsqAddALAsset:(ALAsset *)asset toAblum:(NSString *)albumName ablumCompletionBlock:(SaveImageAblumCompletion)ablumCompletionBlock;
@end

#pragma mark - TuSDKTSALAsset
/**
 *  媒体资源对象
 */
@interface TuSDKTSALAsset : NSObject<TuSDKTSAssetInterface>
/**
 *  初始化媒体资源对象
 *
 *  @param asset ALAsset
 *
 *  @return 媒体资源对象
 */
+ (instancetype)initWithALAsset:(ALAsset *)asset;

/**
 *  媒体资源对象
 */
@property (nonatomic, readonly)ALAsset *asset;
@end

#pragma mark - TuSDKTSALAssetsGroup
/**
 *  媒体资源组对象
 */
@interface TuSDKTSALAssetsGroup : NSObject<TuSDKTSAssetsGroupInterface>
/**
 *  初始化媒体资源组对象
 *
 *  @param group ALAssetsGroup
 *
 *  @return 媒体资源组对象
 */
+ (instancetype)initWithALAssetsGroup:(ALAssetsGroup *)group;

/**
 *  媒体资源组对象
 */
@property (nonatomic, readonly)ALAssetsGroup *group;
@end