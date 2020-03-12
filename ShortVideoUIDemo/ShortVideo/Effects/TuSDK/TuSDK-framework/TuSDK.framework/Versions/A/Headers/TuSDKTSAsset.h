//
//  TuSDKTSAsset.h
//  TuSDK
//
//  Created by Clear Hu on 15/10/10.
//  Copyright © 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#pragma mark - TuSDKTSAssetInterface

/**
 *  远程图片下载进度回调
 *
 *  @param image    UIImage
 *  @param progress double
 *  @param error    NSError
 */
typedef void (^TuSDKTSAssetProgressBlock)(UIImage *image, double progress, NSError *error);

/**
 *  媒体资源对象接口
 */
@protocol TuSDKTSAssetInterface <NSObject>

/**
 *  媒体资源PHAsset对象  注：相册中用来获取asset对象，判断是否为GIF类型
 */
@property (nonatomic, readonly) PHAsset *asset;

/**
 *  本地标识
 */
@property (nonatomic, readonly) NSString *localIdentifier;

/**
 *  创建时间
 */
@property (nonatomic, readonly) NSDate *creationDate;

/**
 *  获取相片方向
 */
@property (nonatomic, readonly) UIImageOrientation imageOrientation;

/**
 *  获取缩略图 图片
 */
@property (nonatomic, readonly) UIImage *thumbnailImage;

/**
 异步获取缩略图
 */
- (void)requestThumbnailImageWithCompletion:(void (^)(UIImage *thumbnailImage))completion;

/**
 *  获取屏幕大小图片对象
 */
@property (nonatomic, readonly) UIImage *fullScreenImage;

/**
 *  获取原始图片对象
 */
@property (nonatomic, readonly) UIImage *fullResolutionImage;

/**
 *  照片原始宽高
 */
@property (nonatomic, readonly) CGSize fullResolutionImageSize;

/**
 *  获取图片原信息
 */
@property (nonatomic, readonly) NSDictionary *metadata;

/**
 *  异步获取原始图片对象
 *
 *  @param block 回调
 *
 */
- (void)asyncFullResolutionImage:(TuSDKTSAssetProgressBlock)block;

/**
 *  取消加载相册图片
 */
- (void)cancelLoadFullResolutionImage;

/**
 *  加载相册图片
 *
 *  @param size      希望输出地相片长宽
 *  @param completed 图片加载完成
 */
- (void)loadImageWithPixelSize:(CGSize)size completed:(void (^)(UIImage * result))completed;

/**
 *  取消加载相册图片
 *
 *  @param size      希望输出地相片长宽
 */
- (void)cancelLoadImageWithPixelSize:(CGSize)size;

@end

#pragma mark - TuSDKTSAssetsGroupInterface
/**
 *  排序字段
 */
typedef NS_ENUM(NSInteger, lsqAssetSortKeyType)
{
    /**
     * 根据创建时间排序
     */
    lsqAssetSortKeyCreateDate = 0,
    /**
     * 根据修改时间排序（iOS8.0及以上可用）
     */
    lsqAssetSortKeyModificationDate = 1,
    /**
     * 默认顺序，与系统相册所有照片排序一致
     */
    lsqAssetSortKeyDefault,
};

/**
 *  媒体资源组对象接口
 */
@protocol TuSDKTSAssetsGroupInterface <NSObject>
/**
 *  是否为相机胶卷(all photos)
 */
@property (nonatomic, readonly) BOOL userLibrary;

/**
 *  相册标题
 */
@property (nonatomic, readonly) NSString *title;

///**
// *  获取该组所有相片信息
// */
//@property (nonatomic, readonly) NSArray<TuSDKTSAssetInterface> *allPhotos;

/**
 *  包含相片总数
 */
@property (nonatomic, readonly) NSUInteger count;

/**
 *  相册封面图片
 */
@property (nonatomic, readonly) UIImage *posterImage;

/**
 * 根据指定的排序字段 获取该组所有相片信息
 *
 *  @param sortKeyType 排序类型
 *  @param ascending 排序方式（升序/降序）
 *  @return 该组所有相片信息
 */
-(NSArray<TuSDKTSAssetInterface> *) allPhotosWithSortKeyType:(lsqAssetSortKeyType) sortKeyType ascending:(BOOL) ascending;

/**
 *  获取该组所有相片信息 （默认根据创建时间排序）
 *
 *  @return 该组所有相片信息
 */
-(NSArray<TuSDKTSAssetInterface> *) allPhotos;

@end

#pragma mark - TuSDKTSAssetsManager
/**
 *  系统相册授权错误
 */
typedef NS_ENUM(NSInteger, lsqAssetsAuthorizationError){
    /**
     *  未定义
     */
    lsqAssetsAuthorizationErrorNotDetermined = 0,
    /**
     *  限制访问
     */
    lsqAssetsAuthorizationErrorRestricted,
    /**
     *  拒绝访问
     */
    lsqAssetsAuthorizationErrorDenied
};
/**
 *  系统相册授权回调
 *
 *  @param error 是否返回错误信息
 */
typedef void (^TuSDKTSAssetsManagerAuthorBlock)(NSError *error);

/**
 *  获取系统相册列表回调
 *
 *  @param groups 系统相册列表
 *  @param error  是否返回错误信息
 */
typedef void (^TuSDKTSAssetsManagerGroupsBlock)(NSArray<TuSDKTSAssetsGroupInterface> *groups, NSError *error);

/**
 *  保存相片到系统相册回掉
 *
 *  @param asset 相片对象
 *  @param error 错误对象
 */
typedef void (^TuSDKTSAssetsManagerSaveImageCompletion)(id<TuSDKTSAssetInterface> asset, NSError* error);

/**
 *  保存相片到指定相册
 *
 *  @param group 相册对象
 *  @param asset 相片对象
 *  @param error 错误对象
 */
typedef void (^TuSDKTSAssetsManagerSaveImageAblumCompletion)(id<TuSDKTSAssetsGroupInterface> group, id<TuSDKTSAssetInterface> asset, NSError* error);

/**
 *  媒体资源管理对象
 */
@interface TuSDKTSAssetsManager : NSObject
/**
 *  媒体资源管理对象
 *
 *  @return 媒体资源管理对象
 */
+ (TuSDKTSAssetsManager *)sharedAssetsManager;

/**
 *  是否用户已授权访问系统相册
 *
 *  @return 是否用户已授权访问系统相册
 */
+ (BOOL)hasAuthor;

/**
 *  是否未决定授权
 *
 *  @return 是否未决定授权
 */
+ (BOOL)notDetermined;

/**
 *  获取系统相册加载错误信息
 *
 *  @param error 错误信息
 *
 *  @return 返回详细信息
 */
+ (NSString *)assetsGroupsLoadFailure:(NSError *)error;

/**
 *  显示系统相册加载错误信息警告
 *
 *  @param controller 控制器
 *  @param error      错误信息
 */
+ (void)showAlertWithController:(UIViewController *)controller loadFailure:(NSError *)error;

/**
 *  获取相册访问失败信息
 *
 *  @return 相册访问失败信息
 */
+ (NSString *)accessFailedInfo;

/**
 *  测试系统相册授权状态
 *
 *  @param authorBlock 系统相册授权回调
 */
+ (void)testLibraryAuthor:(TuSDKTSAssetsManagerAuthorBlock)authorBlock;

/**
 *  获取系统相册分组
 *
 *  @param groupsBlock 获取系统相册列表回调
 */
+ (void)imageAlbumsWithBlock:(TuSDKTSAssetsManagerGroupsBlock)groupsBlock;

/**
 *  保存图片数据到系统相册
 *
 *  @param image                图片数据
 *  @param compress             图片压缩比
 *  @param metadata             照片meta信息
 *  @param albumName            相册名称
 *  @param completionBlock      相册名称
 *  @param ablumCompletionBlock 保存相片到指定相册
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL) saveWithImage:(UIImage *)image
              compress:(CGFloat)compress
              metadata:(NSDictionary *)metadata
               toAblum:(NSString *)albumName
       completionBlock:(TuSDKTSAssetsManagerSaveImageCompletion)completionBlock
  ablumCompletionBlock:(TuSDKTSAssetsManagerSaveImageAblumCompletion)ablumCompletionBlock;

/**
 *  保存视频到系统相册
 *
 *  @param videoURL             视频文件
 *  @param albumName            相册名称
 *  @param completionBlock      相册名称
 *  @param ablumCompletionBlock 保存相片到指定相册
 *
 *  @return 是否允许操作系统相册
 */
+ (BOOL) saveWithVideo:(NSURL *)videoURL
               toAblum:(NSString *)albumName
       completionBlock:(TuSDKTSAssetsManagerSaveImageCompletion)completionBlock
  ablumCompletionBlock:(TuSDKTSAssetsManagerSaveImageAblumCompletion)ablumCompletionBlock;
@end
