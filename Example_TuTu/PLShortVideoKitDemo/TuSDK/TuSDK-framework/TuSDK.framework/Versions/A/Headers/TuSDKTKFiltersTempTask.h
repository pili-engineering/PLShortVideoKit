//
//  TuSDKTKFiltersTempTask.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/9.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import "TuSDKTKFiltersTaskBase.h"

/**
 *  滤镜临时预览效果列表任务
 */
@interface TuSDKTKFiltersTempTask : TuSDKTKFiltersTaskBase
/**
 *  是否取消任务
 */
@property (nonatomic, readonly) BOOL isCancelTask;

/**
 *  初始化
 *
 *  @param image 输入的图片
 *
 *  @return 滤镜临时预览效果列表任务
 */
+ (instancetype)initWithInputImage:(UIImage *)image;
@end
