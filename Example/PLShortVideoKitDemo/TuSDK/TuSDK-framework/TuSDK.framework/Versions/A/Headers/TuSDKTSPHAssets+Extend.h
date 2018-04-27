//
//  TuSDKTSPHAssets+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 15/10/10.
//  Copyright © 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTSAsset.h"
@import Photos;

#pragma mark - TuSDKTSPHCachingImageManager
/**
 *  相册图片缓存管理器
 */
@interface TuSDKTSPHCachingImageManager : PHCachingImageManager
/**
 *  相册图片缓存管理器单例对象
 *
 *  @return 相册图片缓存管理器单例对象
 */
+ (instancetype)defaultManager;
@end

#pragma mark - PHAssetExtend
/**
 *  系统媒体资源扩展
 */
@interface PHAsset(PHAssetExtend)
/**
 *  获取指定媒体资源
 *
 *  @param localIdentifier 媒体资源标识
 *
 *  @return 指定媒体资源
 */
+ (PHAsset *)assetWithIdentifier:(NSString *)localIdentifier;
@end

#pragma mark - PHAssetCollectionExtend

/**
 *  系统相册组列表回调
 *
 *  @param groups 系统相册组列表
 */
typedef void (^TuSDKTSPHAssetCollectionGroupsBlock)(NSArray<PHAssetCollection *> *groups);

/**
 *  系统相册组
 */
@interface PHAssetCollection(PHAssetCollectionExtend)
/**
 *  获取照片相册
 *
 *  @return 系统相册组列表
 */
+ (NSArray<PHAssetCollection *> *)imageAlbums;

/**
 *  获取指定标题的相册
 *
 *  @param title 标题
 *
 *  @return 指定标题的相册
 */
+ (PHAssetCollection *)albumWithTitle:(NSString *)title;

/**
 *  照片数据列表
 *
 *  @return 照片数据列表
 */
- (PHFetchResult<PHAsset *> *)images;

/**
 *  根据NSSortDescriptor获取照片数据列表
 *
 *  @param sortDescriptors 排序描述数组
 *
 *  @return 照片数据列表
 */
- (PHFetchResult<PHAsset *> *)imagesWithSortDescriptors:(NSArray<NSSortDescriptor *> *) sortDescriptors;

/**
 *  图片总数
 *
 *  @return 图片总数
 */
- (NSUInteger)imagesCount;
@end

#pragma mark - PHPhotoLibraryExtend
/**
 *  保存图片数据到系统相册回调
 *
 *  @param asset PHAsset
 *  @param group PHAssetCollection
 *  @param error NSError
 */
typedef void (^TuSDKTSPHPhotoLibrarySaveWithImageCompletionBlock)(PHAsset *asset, PHAssetCollection *group, NSError *error);

/**
 *  系统相册对象
 */
@interface PHPhotoLibrary(PHPhotoLibraryExtend)
/**
 *  保存图片数据到系统相册
 *
 *  @param image                图片数据
 *  @param metadata             照片meta信息
 *  @param albumName            相册名称
 *  @param completionBlock      保存图片数据到系统相册回调
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL) saveWithImage:(UIImage *)image
              metadata:(NSDictionary *)metadata
               toAblum:(NSString *)albumName
       completionBlock:(TuSDKTSPHPhotoLibrarySaveWithImageCompletionBlock)completionBlock;

/**
 *  保存视频到系统相册
 *
 *  @param videoURL             图片数据
 *  @param albumName            相册名称
 *  @param completionBlock      保存图片数据到系统相册回调
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL) saveWithVideo:(NSURL *)videoURL
               toAblum:(NSString *)albumName
       completionBlock:(TuSDKTSPHPhotoLibrarySaveWithImageCompletionBlock)completionBlock;

@end
#pragma mark - TuSDKTSPHAsset
/**
 *  媒体资源对象
 */
@interface TuSDKTSPHAsset : NSObject<TuSDKTSAssetInterface>
/**
 *  初始化媒体资源对象
 *
 *  @param asset PHAsset
 *
 *  @return 媒体资源对象
 */
+ (instancetype)initWithPHAsset:(PHAsset *)asset;

/**
 *  媒体资源对象
 */
@property (nonatomic, readonly)PHAsset *asset;

@end

#pragma mark - TuSDKTSPHAssetsGroup
/**
 *  媒体资源组对象
 */
@interface TuSDKTSPHAssetsGroup : NSObject<TuSDKTSAssetsGroupInterface>
/**
 *  初始化媒体资源组对象
 *
 *  @param group ALAssetsGroup
 *
 *  @return 媒体资源组对象
 */
+ (instancetype)initWithPHAssetCollection:(PHAssetCollection *)group;

/**
 *  媒体资源组对象
 */
@property (nonatomic, readonly)PHAssetCollection *group;
@end
