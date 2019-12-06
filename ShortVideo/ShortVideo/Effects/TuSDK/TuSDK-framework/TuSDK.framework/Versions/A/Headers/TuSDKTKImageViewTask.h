//
//  TuSDKTKImageViewTask.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/18.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  图片视图任务加载方式
 */
typedef NS_ENUM(NSInteger, lsqImageViewTaskWareLoadType)
{
    /**
     *  从内存加载
     */
    lsqImageViewTaskWareLoadMomery,
    /**
     *  从文件加载
     */
    lsqImageViewTaskWareLoadDisk,
    
    /**
     * 创建加载
     */
    lsqImageViewTaskWareLoadBuild,
};

#pragma mark - TuSDKTKImageViewTaskWare
/**
 *  图片视图任务包装
 */
@interface TuSDKTKImageViewTaskWare : NSObject
/**
 *  图片视图
 */
@property (nonatomic, assign) UIImageView * imageView;

/**
 *  是否任务已取消
 */
@property (nonatomic, readonly) BOOL isCancel;

/**
 *  初始化图片视图任务包装
 *
 *  @param imageView 图片视图
 *
 *  @return 图片视图任务包装
 */
+ (instancetype)initWithImageView:(UIImageView *)imageView;

/**
 *  缓存名称
 *
 *  @return 缓存名称
 */
- (NSString *)cacheKey;

/**
 *  取消任务
 */
- (void)cancel;

/**
 *  是否为相同的视图
 *
 *  @param imageView 图片视图
 *
 *  @return 是否为相同的视图
 */
- (BOOL)isEqualView:(UIImageView *)imageView;

/**
 *  图片加载完成
 *
 *  @param image    图片对象
 *  @param loadType 图片视图任务加载方式
 */
- (void)imageLoaded:(UIImage *)image loadType:(lsqImageViewTaskWareLoadType)loadType;
@end


#pragma mark - TuSDKTKImageViewTask
/**
 *  图片视图任务
 */
@interface TuSDKTKImageViewTask : NSObject
/**
 *  重置任务列表
 */
- (void)resetQueues;

/**
 *  异步加载图片
 *
 *  @param ware 图片视图任务包装
 *
 *  @return 图片
 */
- (UIImage *)asyncTaskLoadImageWithWare:(TuSDKTKImageViewTaskWare *)ware;

/**
 *  取消加载图片
 *
 *  @param imageView 图片视图
 */
- (void)cancelLoadImage:(UIImageView *)imageView;

/**
 *  加载图片
 *
 *  @param ware 图片视图任务包装
 */
- (void)loadImageWithWare:(TuSDKTKImageViewTaskWare *)ware;
@end
