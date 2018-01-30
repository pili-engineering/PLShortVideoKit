//
//  TuSDKCPImageDecoder.h
//  TuSDK
//
//  Created by Yanlin on 1/7/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKCPImage.h"

#pragma mark - image functions

CG_EXTERN CGColorSpaceRef lasqueCGColorSpaceGetDeviceRGB();

CG_EXTERN CGImageRef lasqueCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay);

#pragma mark - UIImage extend

@interface UIImage (TuSDKImageCoder)

/**
 *  将图片解析为bitmap
 *
 *  @return UIImage对象
 */
- (instancetype)lasqueImageByDecoded;

/**
 *  是否不需要格式转换就可以直接显示
 */
@property (nonatomic, assign) BOOL lasque_isDecodedForDisplay;

@end

#pragma mark - TuSDKCPImageDecoder

/**
 *  图片解析基类
 */
@interface TuSDKCPImageDecoder : NSObject
{
    @protected
    
    // Image data
    NSData *_data;
    // Image Type
    lasqueImageType _type;
    // DPI 缩放级别
    CGFloat _scale;
    // Image width
    NSUInteger _width;
    // Image height
    NSUInteger _height;
    // Image orientation
    UIImageOrientation _orientation;
    // 数据加载完毕
    BOOL _dataCompleted;
}

/**
 *  Image data
 */
@property (nonatomic, readonly) NSData *data;

/**
 *  Image Type
 */
@property (nonatomic, readonly) lasqueImageType type;

/**
 *  DPI缩放级别
 */
@property (nonatomic, readonly) CGFloat scale;

/**
 *  Image width
 */
@property (nonatomic, readonly) NSUInteger width;

/**
 *  Image height
 */
@property (nonatomic, readonly) NSUInteger height;

/**
 *  图片方向
 */
@property (nonatomic, readonly) UIImageOrientation orientation;

/**
 *  数据是否已全部加载完毕
 */
@property (nonatomic, readonly) BOOL dataCompleted;

/**
 *  根据文件头检测图片类型
 *
 *  @param bytes 文件字节指针
 *
 *  @return imageType 图片类型
 */
- (lasqueImageType)getImageType:(const char *)bytes;

/**
 *  图片解析器支持的格式列表
 *
 *  @return supportedTypes 格式数组
 */
- (NSArray<NSNumber *> *)supportedTypes;

/**
 *  是否支持目标格式
 *
 *  @param type 图片格式
 *
 *  @return BOOL
 */
- (BOOL)validImageType:(lasqueImageType)type;

@end
