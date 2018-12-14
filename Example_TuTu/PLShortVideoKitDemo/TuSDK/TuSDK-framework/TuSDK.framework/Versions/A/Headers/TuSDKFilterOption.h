//
//  TuSDKFilterOption.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/26.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLGPUImage.h"
#import "TuSDKDataJson.h"

#pragma mark - RuntimeTextureDelegate

@protocol RuntimeTextureDelegate<NSObject>

/**
 运行时材质委托
 */
-(NSArray<SLGPUImagePicture *> *)getRunTimeTextures;

@end

/**
 *  滤镜配置选项
 */
@interface TuSDKFilterOption : TuSDKDataJson

/**
 * 滤镜ID
 */
@property (nonatomic)uint64_t filterId;

/**
 * 分组ID
 */
@property (nonatomic) uint64_t groupId;

/**
 * 滤镜代号
 */
@property (nonatomic, retain) NSString *code;

/**
 *  滤镜名称
 */
@property (nonatomic, retain) NSString *name;

/**
 * 滤镜封面
 */
@property (nonatomic, retain) NSString *thumb;

/**
 * 滤镜封面名称
 */
@property (nonatomic, retain) NSString *thumbKey;

/**
 * 滤镜类型
 */
@property (nonatomic) NSUInteger filterType;

/**
 * 滤镜颜色
 */
@property (nonatomic, retain) NSString *color;

/**
 *  滤镜材质列表
 */
@property (nonatomic, retain) NSArray *textures;

/**
 *  材质需要保持和输入图片相同的大小与方向
 */
@property (nonatomic) BOOL texturesKeepInput;

/**
 * 是否允许调节参数
 */
@property (nonatomic) BOOL canDefinition;

/**
 * 加密级别
 */
@property (nonatomic) NSUInteger encryptType;

/**
 *  滤镜配置参数
 */
@property (nonatomic, retain) NSDictionary *args;

/**
 *  滤镜参数列表
 */
@property (nonatomic, strong) NSDictionary *argList;

/**
 *  vertex
 */
@property (nonatomic, copy) NSString *vertex;

/**
 *  fragment
 */
@property (nonatomic, copy) NSString *fragment;

/**
 *  滤镜版本
 */
@property (nonatomic) NSUInteger version;

/**
 *  是否禁止实时处理
 */
@property (nonatomic) BOOL disableRuntime;

/**
 * 是否为内置滤镜
 */
@property (nonatomic) BOOL isInternal;

/**
 *  内置滤镜材质列表
 */
@property (nonatomic, retain) NSArray *internalTextures;

/**
 运行时材质委托
 */
@property (nonatomic, weak) id<RuntimeTextureDelegate> runtimeTextureDelegate;

/**
 * 复制滤镜配置选项
 *
 * @return copy
 */
- (TuSDKFilterOption *)copy;

/**
 * 获取滤镜实例
 *
 * @return getFilter
 */
- (SLGPUImageOutput <SLGPUImageInput> *)getFilter;

/**
 *  获取语言资源名称
 *
 *  @return 获取语言资源名称
 */
- (NSString *)getFilterName;

/**
 *  获取预览图名称
 *
 *  
 */
- (NSString *)thumbKey;
@end



#pragma mark - TuSDKSkinFilterOption

/**
 *  美颜滤镜选项
 */
@interface TuSDKSkinFilterOption : TuSDKFilterOption

@end
