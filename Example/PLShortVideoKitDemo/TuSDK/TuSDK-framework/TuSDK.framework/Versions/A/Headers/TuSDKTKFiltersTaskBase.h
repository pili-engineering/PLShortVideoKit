//
//  TuSDKTKFiltersTaskBase.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/9.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TuSDKTKFilterImageWare.h"

#pragma mark - TuSDKTKFiltersTaskInterface
/**
 *  滤镜任务接口
 */
@protocol TuSDKTKFiltersTaskInterface <NSObject>
/**
 *  输入滤镜名称
 */
@property (nonatomic, retain) NSArray *filerNames;

/**
 *  输入图片
 */
@property (nonatomic, retain) UIImage *inputImage;

/**
 *  任务是否已完成
 */
@property (nonatomic, readonly) BOOL taskCompleted;

/**
 *  是否渲染封面 (使用设置的滤镜直接渲染，需要拥有滤镜列表封面设置权限，请访问TUTUCLOUD.com控制台)
 */
@property (nonatomic) BOOL isRenderFilterThumb;

/**
 *  开始执行任务
 */
- (void)start;

/**
 *  重置滤镜列表
 */
- (void)resetQueues;

/**
 *  添加滤镜代号
 *
 *  @param code 滤镜代号
 */
- (void)appendFilterCode:(NSString *)code;

/**
 *  加载图片
 *
 *  @param view 图片视图
 *  @param name 滤镜名称
 */
- (void)loadImageWithView:(UIImageView *)view filterName:(NSString *)name;

/**
 *  取消加载图片
 *
 *  @param view 图片视图
 */
- (void)cancelLoadImageWithView:(UIImageView *)view;
@end

#pragma mark - TuSDKTKFiltersTaskBase
/**
 *  滤镜任务基类
 */
@interface TuSDKTKFiltersTaskBase : NSObject<TuSDKTKFiltersTaskInterface>
/**
 *  输入图片
 */
@property (nonatomic, retain) UIImage *inputImage;
/**
 *  预览图根路径
 */
@property (nonatomic, retain) NSString *sampleRootPath;

/**
 *  异步创建单独的滤镜文件
 *
 *  @param name 滤镜名称
 */
- (void)asyncBuildWithFilterName:(NSString *)name;
@end
