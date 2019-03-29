//
//  PLSFilter.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/4/13.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @class PLSFilter
 @brief 滤镜处理类
 
 @since      v1.3.0
 */
@interface PLSFilter : NSObject

/*!
 @property colorImagePath
 @abstract 色彩图片的路径
 
 @since      v1.3.0
 */
@property (strong, nonatomic) NSString *colorImagePath;

/*!
 @method init
 @abstract 初始化滤镜实例
 
 @return PLSFilter 实例
 @since      v1.3.0
 */
- (instancetype)init;

/*!
 @method initWithColorImagePath:
 @abstract 使用色彩图片初始化滤镜实例
 
 @param colorImagePath    色彩图片的路径
 
 @return PLSFilter 实例
 @since      v1.1.0
 */
- (instancetype)initWithColorImagePath:(NSString *)colorImagePath __deprecated;

/*!
 @method process:
 @abstract 处理图像，加滤镜效果
 
 @param pixelBuffer    源图像数据
 
 @return 处理之后的 CVPixelBufferRef 滤镜图像

 @since      v1.1.0
 */
- (CVPixelBufferRef)process:(CVPixelBufferRef)pixelBuffer;

/*!
 @method applyFilter:colorImagePath:
 @abstract 处理图像，加滤镜效果
 
 @param inputImage 待处理图片
 @param colorImagePath 滤镜资源文件路径
 
 @return 处理之后的 UIImage 滤镜图像
 
 @since      v1.1.0
 */
+ (UIImage *)applyFilter:(UIImage *)inputImage colorImagePath:(NSString *)colorImagePath;

@end
