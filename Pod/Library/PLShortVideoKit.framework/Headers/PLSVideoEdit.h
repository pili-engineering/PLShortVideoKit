//
//  PLSVideoEdit.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLSVideoEdit : NSObject

/**
 @brief 编辑封面
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) UIImage *editPosterImage;

/**
 @brief 编辑预览图片
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) UIImage *editPreviewImage;

/**
 @brief 编辑视频的输出路径
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) NSURL *editFinalURL;

/**
 @brief 编辑视频
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) AVAsset *editAsset;

/**
 @brief 编辑数据
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) NSDictionary *editData;

/**
 @brief 视频时间
 
 @since      v1.7.0
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 @brief 初始化
 
 @since      v1.7.0
 */
- (instancetype)initWithEditAsset:(AVAsset *)editAsset editFinalURL:(NSURL *)editFinalURL data:(NSDictionary *)data;

@end
