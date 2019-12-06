//
//  TuSDKPFBrushGroup.h
//  TuSDK
//
//  Created by Yanlin on 10/28/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import "TuSDKAOFile.h"
#import "TuSDKPFBrush.h"
/**
 *  笔刷包
 */
@interface TuSDKPFBrushGroup : TuSDKDataJson
/**
 * 笔刷包ID
 */
@property (nonatomic) uint64_t idt;

/**
 * 文件对象
 */
@property (nonatomic, copy) NSString *file;

/**
 * 验证方式 0:不绑定验证 , 1:绑定开发者ID, 2:绑定用户ID
 */
@property (nonatomic) NSUInteger validType;

/**
 * 笔刷包校验码
 */
@property (nonatomic, copy) NSString *validKey;

/**
 * 笔刷包名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 笔刷列表
 */
@property (nonatomic, retain) NSArray *brushes;

/**
 *  SDK文件
 */
@property (nonatomic, retain) TuSDKAOFile *sdkFile;

/**
 *  是否为下载笔刷
 */
@property (nonatomic) BOOL isDownload;

/**
 *  复制
 *
 *  @return 笔刷包
 */
- (instancetype)copy;

/**
 *  获取笔刷对象
 *
 *  @param brushId 笔刷数据ID
 *
 *  @return 笔刷对象
 */
- (TuSDKPFBrush *)brushWithId:(uint64_t)brushId;
@end
