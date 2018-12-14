//
//  TuSDKNKDownloadManger.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/23.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKNKDownloadItem.h"

@class TuSDKNKDownloadManger;

/**
 *  下载管理器委托
 */
@protocol TuSDKNKDownloadMangerDelegate <NSObject>

/**
 *  下载状态改变
 *
 *  @param manager 下载管理器
 *  @param item    下载对象
 *  @param status  下载状态
 */
- (void)downloadManger:(TuSDKNKDownloadManger *)manager
                  item:(TuSDKNKDownloadItem *)item
         changedStatus:(lsqDownloadTaskStatus)status;
@end

/**
 *  下载管理器
 */
@interface TuSDKNKDownloadManger : NSObject

/**
 *  下载管理器
 *
 *  @return manager 下载管理器
 */
+ (instancetype)manager;

/**
 *  添加下载管理器委托
 *
 *  @param delegate 下载管理器委托
 */
- (void)appenDelegate:(id<TuSDKNKDownloadMangerDelegate>)delegate;

/**
 *  删除下载管理器委托
 *
 *  @param delegate 下载管理器委托
 */
- (void)removeDelegate:(id<TuSDKNKDownloadMangerDelegate>)delegate;

/**
 *  添加任务
 *
 *  @param type 下载类型
 *  @param idt  下载对象ID
 *  @param key  下载对象KEY
 *  @param fileId 文件ID
 */
- (void)appenTaskWithType:(lsqDownloadTaskType)type idt:(uint64_t)idt key:(NSString *)key fileId:(NSString *)fileId;

/**
 *  是否正在下载某个资源
 *
 *  @param type 下载类型
 *  @param idt  下载对象ID
 *
 *  @return true: 下载中
 */
- (BOOL)isDownloadingWithType:(lsqDownloadTaskType)type idt:(uint64_t)idt;

/**
 *  取消任务
 *
 *  @param type 下载类型
 *  @param idt  下载对象ID
 *
 *  @return BOOL 是否取消任务
 */
- (BOOL)cancelTaskWithType:(lsqDownloadTaskType)type idt:(uint64_t)idt;

/**
 *  获取所有json数据
 *
 *  @param type 下载类型
 *  @param ids  已下载ID列表
 *
 *  @return json数据
 */
- (NSString *)jsonAllDataWithType:(lsqDownloadTaskType)type downloadedIds:(NSArray *)ids;
@end
