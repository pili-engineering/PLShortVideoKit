//
//  TuSDKTKFilterImageWare.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/9.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - TuSDKTKFilterTaskResult
/**
 *  滤镜任务处理结果
 */
@interface TuSDKTKFilterTaskResult : NSObject
/**
 *  处理过的图片
 */
@property (nonatomic, retain) UIImage *image;
/**
 *  滤镜名称
 */
@property (nonatomic, copy) NSString *filterName;
@end


#pragma mark - TuSDKTKFilterImageWare
/**
 *  滤镜任务图片视图包装
 */
@interface TuSDKTKFilterImageWare : NSObject
/**
 *  图片视图
 */
@property (nonatomic, assign) UIImageView *imageView;

/**
 *  滤镜名称
 */
@property (nonatomic, copy) NSString *filterName;

/**
 *  初始化
 *
 *  @param view 图片视图
 *  @param name 滤镜名称
 *
 *  @return 滤镜任务图片视图包装
 */
+ (instancetype)initWithImageView:(UIImageView *)view filterName:(NSString *)name;

/**
 *  是否为相同的视图
 *
 *  @param view 视图
 *
 *  @return 是否为相同的视图
 */
- (BOOL)isEqualView:(UIImageView *)view;

/**
 *  设置图片结果
 *
 *  @param result 滤镜任务处理结果
 *
 *  @return 是否设置图片
 */
- (BOOL)setImageResult:(TuSDKTKFilterTaskResult *)result;
@end
