//
//  TuSDKFilterWrap.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/27.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLGPUImage.h"
#import "TuSDKFilterOption.h"
#import "TuSDKFilterParameter.h"
#import "TuSDKParticleFilterInterface.h"

/** 滤镜对象包装*/
@interface TuSDKFilterWrap : NSObject{
    SLGPUImageOutput <SLGPUImageInput> *_filter;
    SLGPUImageOutput <SLGPUImageInput> *_lastFilter;
}

/** 滤镜配置选项*/
@property (nonatomic, readonly, nullable) TuSDKFilterOption *opt;

/** 滤镜代号*/
@property (nonatomic, readonly, nullable) NSString *code;

/** 滤镜对象*/
@property (nonatomic, readonly, nullable) SLGPUImageOutput <SLGPUImageInput> *filter;

/** 最后一个滤镜*/
@property (nonatomic, readonly, nullable) SLGPUImageOutput <SLGPUImageInput> *lastFilter;

/** 滤镜配置选项*/
@property (nonatomic, readwrite, nullable) TuSDKFilterParameter *filterParameter;

/**
 *  初始化滤镜对象包装
 *
 *  @param opt 滤镜配置选项
 *
 *  @return opt 滤镜对象包装
 */
+ (nullable instancetype) initWithOpt:(nullable TuSDKFilterOption *)opt;

/**
 *  初始化滤镜对象包装
 *
 *  @param opt 滤镜配置选项
 *
 *  @return opt 滤镜对象包装
 */
- (nullable instancetype)initWithOpt:(nullable TuSDKFilterOption *)opt;

/** 提交滤镜配置选项*/
- (void)submitParameter;

/**
 切换滤镜
 @param filterCode 滤镜代号
 */
- (void)changeFilter:(nullable NSString *)filterCode;

/**
 改变option
 @param opt 滤镜配置选项
 */
- (void)changeOption:(nullable TuSDKFilterOption *)opt;

/** 添加输出*/
- (void)addTarget:(nullable id<SLGPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;

/** 删除输出*/
- (void)removeTarget:(nullable id<SLGPUImageInput>)targetToRemove;

/**
 *  绑定视频视图
 *
 *  @param view 视频视图
 */
- (void)bindWithCameraView:(nullable UIView <SLGPUImageInput> *)view;

/** 添加输入*/
- (void)addOrgin:(nullable SLGPUImageOutput *)newOrgin;

/** 删除输入*/
- (void)removeOrgin:(nullable SLGPUImageOutput *)newOrgin;

/** 处理材质*/
- (void)processImage;

/**
 *  旋转材质到图片方向
 *
 *  @param imageOrientation 图片方向
 */
- (void)rotationTextures:(UIImageOrientation)imageOrientation;

/**
 *  执行滤镜 并输出图形
 *
 *  @param image 输入图像
 *
 *  @return image 滤镜处理过的图像 (默认使用图像自身的方向属性)
 */
- (nullable UIImage *)processWithImage:(nullable UIImage *)image;

/**
 *  执行滤镜 并输出图形
 *
 *  @param image            输入图像
 *  @param imageOrientation 图像方向
 *
 *  @return image 滤镜处理过的图像
 */
- (nullable UIImage *)processWithImage:(nullable UIImage *)image orientation:(UIImageOrientation)imageOrientation;

/**
 *  是否为同一个滤镜代号
 *
 *  @param code 滤镜代号
 *
 *  @return BOOL 是否为同一个滤镜代号
 */
- (BOOL)isEqualCode:(nullable NSString *)code;

/**
 *  克隆滤镜对象包装
 *
 *  @return clone 滤镜对象包装
 */
- (nullable instancetype)clone;

/**
 销毁
 */
- (void)destroy;

@end
