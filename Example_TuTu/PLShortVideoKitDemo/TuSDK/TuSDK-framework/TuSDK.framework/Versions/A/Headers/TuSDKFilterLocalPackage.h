//
//  TuSDKFilterLocalPackage.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/26.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterOption.h"
#import "TuSDKFilterGroup.h"
#import "TuSDKConfig.h"
#import "TuSDKNKDownloadItem.h"

/**
 *  默认滤镜代号
 */
extern NSString * const lsqNormalFilterCode;

#pragma mark - TuSDKFilterConfigDelegate
/**
 *  原生滤镜配置委托
 */
@protocol TuSDKFilterConfigDelegate <NSObject>
/**
 *  滤镜初始化完成
 */
- (void)onTuSDKFilterConfigInited;
@end

#pragma mark - TuSDKFilterLocalPackageDelegate
@class TuSDKFilterLocalPackage;

/**
 *  本地滤镜包委托
 */
@protocol TuSDKFilterLocalPackageDelegate <NSObject>

/**
 *  本地滤镜包下载状态改变
 *
 *  @param manager 本地滤镜包
 *  @param item    下载对象
 *  @param status  下载状态
 */
- (void)filterManager:(TuSDKFilterLocalPackage *)manager
                 item:(TuSDKNKDownloadItem *)item
        changedStatus:(lsqDownloadTaskStatus)status;
@end

#pragma mark - TuSDKFilterLocalPackage
/**
 *  原生滤镜配置
 */
@interface TuSDKFilterLocalPackage : NSObject

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
@property (nonatomic, weak) id<TuSDKFilterConfigDelegate> initDelegate;

/**
 *  原生滤镜配置
 *
 *  @param config Sdk配置
 *
 *  @return config 原生滤镜配置
 */
+ (instancetype)initWithConfig:(TuSDKConfig *)config;

/**
 *  原生滤镜配置
 *
 *  @return package 原生滤镜配置
 */
+ (instancetype)package;

/**
 *  添加本地滤镜包委托
 *
 *  @param delegate 本地滤镜包委托
 */
- (void)appenDelegate:(id<TuSDKFilterLocalPackageDelegate>)delegate;

/**
 *  删除本地滤镜包委托
 *
 *  @param delegate 本地滤镜包委托
 */
- (void)removeDelegate:(id<TuSDKFilterLocalPackageDelegate>)delegate;

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
 *  @return option 滤镜选项配置 (如果未找到对应选项，返回默认滤镜)
 */
- (TuSDKFilterOption *)optionWithCode:(NSString *)code;

/**
 *  验证滤镜代号
 *
 *  @param filterCodes 滤镜代号列表
 *
 *  @return codes 滤镜名称
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
 *  @return groupID 滤镜组名称键
 */
- (NSString *)groupNameKeyWithGroupID:(uint64_t)groupID;

/**
 *  滤镜组类型
 *
 *  @param groupID 滤镜组ID
 *
 *  @return groupID 滤镜组类型
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
 根据滤镜组id获取滤镜分组
 
 @param groupID 滤镜组id
 @return TuSDKFilterGroup
 */
- (TuSDKFilterGroup *)groupWithGroupID:(uint64_t)groupID;

/**
 根据 SDK 类型获取滤镜分组
 
 @param ationScen SDK 类型获取滤镜分组
 @return 分组列表
 */
- (NSArray<TuSDKFilterGroup *> *)groupsByAtionScen:(lsqAtionScenSDKType)ationScen;

/**
 *  获取滤镜组默认滤镜代号
 *
 *  @param group 滤镜分组
 *
 *  @return group 滤镜组默认滤镜代号
 */
- (NSString *)defaultFilterCodeWithGroup:(TuSDKFilterGroup *)group;

/**
 *  加载材质列表
 *
 *  @param code 滤镜代号
 *
 *  @return code 材质列表
 */
- (NSArray *)loadTexturesWithCode:(NSString *)code;

/**
 *  加载材质列表
 *
 *  @param codes 滤镜代号列表
 *
 *  @return codes 材质列表
 */
- (NSArray *)loadInternalTextures:(NSArray *)codes;

/**
 *  通过选项配置初始化滤镜
 *
 *  @param option 滤镜选项配置
 *
 *  @return option 获取滤镜实例
 */
- (SLGPUImageOutput <SLGPUImageInput> *)filterWithOption:(TuSDKFilterOption *)option;
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

/**
 *  取消加载图片
 *
 *  @param imageView 图片视图
 */
- (void)cancelLoadImage:(UIImageView *)imageView;

/**
 *  下载贴纸
 *
 *  @param idt 贴纸ID
 *  @param key 下载SN
 *  @param fileId 文件ID
 */
- (void)downloadWithIdt:(uint64_t)idt key:(NSString *)key fileId:(NSString *)fileId;

/**
 *  取消下载贴纸
 *
 *  @param idt 贴纸ID
 */
- (void)cancelDownloadWithIdt:(uint64_t)idt;

/**
 *  删除下载贴纸
 *
 *  @param idt 贴纸ID
 */
- (void)removeDownloadWithIdt:(uint64_t)idt;

/**
 *  获取所有json数据
 *
 *  @return json 数据
 */
- (NSString *)jsonAllData;
@end
