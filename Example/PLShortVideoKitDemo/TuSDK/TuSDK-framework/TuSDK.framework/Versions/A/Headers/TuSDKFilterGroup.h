//
//  TuSDKFilterGroup.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/18.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKDataJson.h"
#import "TuSDKAOFile.h"
#import "TuSDKFilterOption.h"

// 分组滤镜类型ID
const static int lsqGroupFilterTypeGeneral = 0;  // 普通滤镜
const static int lsqGroupFilterTypeMagic   = 1;  // 特效滤镜


/**
 *  滤镜分组
 */
@interface TuSDKFilterGroup : TuSDKDataJson
/**
 * 分组ID
 */
@property (nonatomic) uint64_t groupId;

/**
 * 文件对象
 */
@property (nonatomic, retain) NSString *file;

/**
 *  类型ID 0: 普通滤镜 1: 直播滤镜
 */
@property (nonatomic) NSUInteger categoryId;

/**
 *  分组中滤镜类型 0: 普通滤镜 1: 特效滤镜
 */
@property (nonatomic) NSUInteger groupFilterType;

/**
 * 验证方式 0：不绑定验证
 */
@property (nonatomic) NSUInteger validType;

/**
 * 效验码
 */
@property (nonatomic, retain) NSString *validKey;

/**
 * 分组代号
 */
@property (nonatomic, retain) NSString *code;

/**
 * 分组名称
 */
@property (nonatomic, retain) NSString *name;

/**
 * 分组封面
 */
@property (nonatomic, retain) NSString *thumb;

/**
 * 分组封面名称
 */
@property (nonatomic, retain) NSString *thumbKey;

/**
 * 默认选中滤镜ID
 */
@property (nonatomic) uint64_t defaultFilterId;

/**
 * 滤镜列表
 */
@property (nonatomic, retain) NSArray *filters;

/**
 * 滤镜分组颜色
 */
@property (nonatomic, retain) NSString *color;

/**
 *  是否禁止实时处理
 */
@property (nonatomic) BOOL disableRuntime;

/**
 *  SDK文件
 */
@property (nonatomic, retain) TuSDKAOFile *sdkFile;

/**
 *  是否为下载滤镜
 */
@property (nonatomic) BOOL isDownload;

/**
 * 复制滤镜分组
 *
 * @return copy
 */
- (TuSDKFilterGroup *)copy;

/**
 *  获取滤镜配置选项
 *
 *  @param filterID 滤镜ID
 *
 *  @return filterOption 滤镜配置选项
 */
- (TuSDKFilterOption *)filterOptionWithFilterID:(uint64_t)filterID;

/**
 *  默认选中的滤镜
 *
 *  @return defaultFilter 默认选中的滤镜
 */
- (TuSDKFilterOption *)defaultFilter;

/**
 *  获取语言资源名称
 *
 *  @return nameKey 获取语言资源名称
 */
- (NSString *)nameKey;

/**
 *  获取语言资源名称
 *
 *  @return 获取语言资源名称
 */
- (NSString *)getGroupName;

/**
 *  获取预览图名称
 *
 *  @return thumbKey 获取预览图名称
 */
- (NSString *)thumbKey;

/**
 *  获取默认选中的滤镜预览图名称
 *
 *  @return defaultFilterThumbKey 获取默认选中的滤镜预览图名称
 */
- (NSString *)defaultFilterThumbKey;
@end
