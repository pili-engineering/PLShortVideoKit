//
//  TuSDKPFStickerGroup.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/20.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKPFSticker.h"
#import "TuSDKAOFile.h"

/**
 *  贴纸包
 */
@interface TuSDKPFStickerGroup : TuSDKDataJson
/**
 * 贴纸包ID
 */
@property (nonatomic) uint64_t idt;

/**
 * 贴纸分类ID
 */
@property (nonatomic) uint64_t categoryId;

/**
 * 文件对象
 */
@property (nonatomic, copy) NSString *file;

/**
 * 验证方式 0:不绑定验证 , 1:绑定开发者ID, 2:绑定用户ID
 */
@property (nonatomic) NSUInteger validType;

/**
 * 贴纸包校验码
 */
@property (nonatomic, copy) NSString *validKey;

/**
 * 贴纸包名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 贴纸包英文名称
 */
@property (nonatomic, copy) NSString *name_en;

/**
 * 贴纸包名称 会根据当前语言判断
 */
@property (nonatomic, copy) NSString *name_language;

/**
 * 预览视图文件名
 */
@property (nonatomic, copy) NSString *previewName;

/**
 * 贴纸列表
 */
@property (nonatomic, retain) NSArray *stickers;

/**
 *  SDK文件
 */
@property (nonatomic, retain) TuSDKAOFile *sdkFile;

/**
 *  是否为下载贴纸
 */
@property (nonatomic) BOOL isDownload;

/**
 *  复制
 *
 *  @return 贴纸包
 */
- (instancetype)copy;

/**
 *  获取贴纸数据
 *
 *  @param stickerId 贴纸数据ID
 *
 *  @return 贴纸数据
 */
- (TuSDKPFSticker *)stickerWithId:(uint64_t)stickerId;

/**
 动态贴纸是否依赖人脸特征

 @return
 */
- (BOOL)requireFaceFeature;

@end
