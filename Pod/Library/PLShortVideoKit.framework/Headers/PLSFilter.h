//
//  PLSFilter.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/4/13.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PLSFilter : NSObject

/**
 @abstract 色彩图片的路径
 
 @since      v1.3.0
 */
@property (strong, nonatomic) NSString *colorImagePath;

/**
 @abstract 初始化滤镜实例
 
 @since      v1.3.0
 */
- (instancetype)init;

/**
 @abstract 使用色彩图片初始化滤镜实例
 
 @param colorImagePath    色彩图片的路径
 
 @since      v1.1.0
 */
- (instancetype)initWithColorImagePath:(NSString *)colorImagePath __deprecated;

/**
 @abstract 处理图像，加滤镜效果
 
 @param pixelBuffer    源图像数据
 
 @return 处理之后的 CVPixelBufferRef 滤镜图像

 @since      v1.1.0
 */
- (CVPixelBufferRef)process:(CVPixelBufferRef)pixelBuffer;

+ (UIImage *)applyFilter:(UIImage *)inputImage colorImagePath:(NSString *)colorImagePath;

@end
