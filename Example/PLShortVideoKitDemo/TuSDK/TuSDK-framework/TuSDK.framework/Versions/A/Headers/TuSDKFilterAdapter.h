//
//  TuSDKFilterAdapter.h
//  TuSDK
//
//  Created by Clear Hu on 15/5/21.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKNKDownloadAdapter.h"
#import "TuSDKFilterOption.h"
#import "TuSDKFilterGroup.h"
#import "TuSDKConfig.h"
#import "GPUImageImport.h"

@protocol TuSDKFilterConfigDelegate;

/**
 *  滤镜适配器
 */
@interface TuSDKFilterAdapter : TuSDKNKDownloadAdapter
/**
 *  原生滤镜代号列表
 */
@property (nonatomic, readonly) NSArray *codes;

/**
 *  滤镜分组列表
 */
@property (nonatomic, readonly) NSArray *groups;

/**
 *  是否已初始化
 */
@property (nonatomic, readonly) BOOL isInited;

/**
 *  原生滤镜配置委托
 */
@property (nonatomic, weak) id<TuSDKFilterConfigDelegate> delegate;

/**
 *  原生滤镜配置
 *
 *  @param config Sdk配置
 *
 *  @return config 原生滤镜配置
 */
+ (instancetype)initWithConfig:(TuSDKConfig *)config;

#pragma mark - datas
/**
 *  默认滤镜选项
 *
 *  @return normalOption 默认滤镜选项
 */
- (TuSDKFilterOption *)normalOption;

/**
 *  获取滤镜选项配置
 *
 *  @param code 滤镜代号
 *
 *  @return filterOption 滤镜选项配置 (如果未找到对应选项，返回默认滤镜)
 */
- (TuSDKFilterOption *)optionWithCode:(NSString *)code;

/**
 *  验证滤镜代号
 *
 *  @param filterCodes 滤镜代号列表
 *
 *  @return  codes 滤镜名称
 */
- (NSArray *)verifyCodes:(NSArray *)codes;

/**
 *  获取指定名称的滤镜列表
 *
 *  @param codes 滤镜代号列表
 *
 *  @return codes 滤镜列表
 */
- (NSArray *)optionsWithCodes:(NSArray *)codes;

/**
 *  获取滤镜组
 *
 *  @param group 滤镜分组
 *
 *  @return group 滤镜列表
 */
- (NSArray *)optionsWithGroup:(TuSDKFilterGroup *)group;

/**
 *  滤镜组名称键
 *
 *  @param groupID 滤镜组ID
 *
 *  @return groupNameKey 滤镜组名称键
 */
- (NSString *)groupNameKeyWithGroupID:(uint64_t)groupID;

/**
 *  滤镜组类型
 *
 *  @param groupID 滤镜组ID
 *
 *  @return groupType 滤镜组类型
 */
- (NSUInteger)groupTypeWithGroupID:(uint64_t)groupID;

/**
 *  分组中的滤镜类型
 *
 *  @param groupID 滤镜组ID
 *
 *  @return 滤镜类型
 */
- (NSUInteger)groupFilterTypeWithGroupID:(uint64_t)groupID;

/**
 *  获取滤镜组默认滤镜代号
 *
 *  @param group 滤镜分组
 *
 *  @return defaultFilterCode 滤镜组默认滤镜代号
 */
- (NSString *)defaultFilterCodeWithGroup:(TuSDKFilterGroup *)group;

/**
 *  加载材质列表
 *
 *  @param code 滤镜代号
 *
 *  @return textures 材质列表
 */
- (NSArray *)loadTexturesWithCode:(NSString *)code;

/**
 *  加载材质列表
 *
 *  @param codes 滤镜代号列表
 *
 *  @return codes  材质列表
 */
- (NSArray *)loadInternalTextures:(NSArray *)codes;

/**
 *  通过选项配置初始化滤镜
 *
 *  @param option 滤镜选项配置
 *
 *  @return filterOption 获取滤镜实例
 */
- (GPUImageOutput <GPUImageInput> *)filterWithOption:(TuSDKFilterOption *)option;
#pragma mark - imageLoad
/**
 *  加载滤镜组预览图
 *
 *  @param view 图片视图
 *  @param group 滤镜分组
 */
- (void)loadGroupThumbWithImageView:(UIImageView *)view group:(TuSDKFilterGroup *)group;

/**
 *  加载滤镜组默认滤镜预览图
 *
 *  @param view 图片视图
 *  @param group 滤镜分组
 */
- (void)loadGroupDefaultFilterThumbWithImageView:(UIImageView *)view group:(TuSDKFilterGroup *)group;

/**
 *  加载滤镜组默认滤镜预览图
 *
 *  @param view 图片视图
 *  @param option 滤镜配置选项
 */
- (void)loadFilterThumbWithImageView:(UIImageView *)view option:(TuSDKFilterOption *)option;
@end
#pragma mark - TuSDKFilterExtend
@interface GPUImageFilter(TuSDKFilterExtend)
- (void)setMatrix4fArray:(GLfloat *)matrix forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
@end
#pragma mark - TuSDKFilter
@interface TuSDKFilter: GPUImageFilter
/** 缩放大小 (默认为1.0，数值越小性能越高) */
@property (nonatomic) CGFloat scale;
@end

#pragma mark - TuSDKTwoInputFilter
@interface TuSDKTwoInputFilter: GPUImageTwoInputFilter
/** 缩放大小 (默认为1.0，数值越小性能越高) */
@property (nonatomic) CGFloat scale;
@end

#pragma mark - TuSDKThreeInputFilter
@interface TuSDKThreeInputFilter: GPUImageThreeInputFilter
/** 缩放大小 (默认为1.0，数值越小性能越高) */
@property (nonatomic) CGFloat scale;
@end

#pragma mark - TuSDKTwoPassTextureSamplingFilter
@interface TuSDKTwoPassTextureSamplingFilter : GPUImageTwoPassTextureSamplingFilter
/** 缩放大小 (默认为1.0，数值越小性能越高) */
@property (nonatomic) CGFloat scale;
@end
