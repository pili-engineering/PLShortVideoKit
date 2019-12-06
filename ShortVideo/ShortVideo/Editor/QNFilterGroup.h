//
//  QNFilterGroup.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/7/4.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLShortVideoKit/PLShortVideoKit.h"

@interface QNFilterGroup : NSObject

/**
 @abstract 所有滤镜的信息，NSDictionary 的 key 为 name，coverImagePath，colorImagePath，分别为一个滤镜的名称，封面，滤镜图片
 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *filtersInfo;

/**
 @abstract 当前使用的滤镜在滤镜组中的索引
 */
@property (nonatomic, assign) NSInteger filterIndex;

/**
 @abstract 当前使用的滤镜的颜色表图的路径
 */
@property (nonatomic, strong) NSString *colorImagePath;

/**
 @abstract 当前使用的滤镜
 */
@property (nonatomic, strong) PLSFilter *currentFilter;

/**
 @abstract 使用 inputImage 作为滤镜的封面图
 */
- (instancetype)initWithImage:(UIImage *)inputImage;


/** =================== 以下属性和方法为切换滤镜的时候使用的 ==============
 使用方式：
 step1. 设置 nextFilterIndex， FilterGroup 内部会根据 nextFilterIndex 创建好 nextFilter
 step2. 调用 processPixelBuffer:leftPercent:leftFilter:rightFilter
*/

/**
 @abstract 下一个要使用的滤镜在滤镜组中的索引
 */
@property (nonatomic, assign) NSInteger nextFilterIndex;

/**
 @abstract 下一个要使用的滤镜
 */
@property (nonatomic, strong) PLSFilter *nextFilter;

/**
 @abstract 从一个 filter 切换到另外一个 filter，将两个 filter 分别作用在图片的两边，给人一种对比效果
 */
- (CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef )originPixelBuffer
                           leftPercent:(float)leftPercent
                            leftFilter:(PLSFilter *)leftFilter
                           rightFilter:(PLSFilter *)rightFilter;
@end
