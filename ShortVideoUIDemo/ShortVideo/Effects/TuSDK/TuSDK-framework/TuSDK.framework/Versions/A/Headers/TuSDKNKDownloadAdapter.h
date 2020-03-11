//
//  TuSDKNKDownloadAdapter.h
//  TuSDK
//
//  Created by Clear Hu on 15/5/21.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKTKImageViewTask.h"
#import "TuSDKNKDownloadManger.h"

/**
 *  资源下载适配器
 */
@interface TuSDKNKDownloadAdapter : TuSDKTKImageViewTask
{
    @protected
    /**
     *  已下载文件列表
     */
    NSMutableArray *_downloadeds;
    /**
     * 下载类型
     */
    lsqDownloadTaskType _downloadTaskType;
}

/**
 *  下载状态委托
 */
@property (nonatomic, weak) id<TuSDKNKDownloadMangerDelegate> downloadDelegate;

/**
 *  是否存在包ID
 *
 *  @param groupId 包ID
 *
 *  @return BOOL 是否存在包ID
 */
- (BOOL)containsWithGroupId:(uint64_t)groupId;

/**
 *  加载在线数据
 */
- (void)asyncLoadDownloadDatas;

#pragma mark - LocalCache
/**
 *  尝试从本地缓存获取任务数据
 */
- (void)tryLoadTaskDataWithCache;

/**
 *  尝试将任务数据保存到本地缓存
 */
- (void)trySaveTaskDataInCache;

#pragma mark - download
/**
 *  下载资源包
 *
 *  @param idt 资源包ID
 *  @param key 下载SN
 *  @param fileId 文件ID
 */
- (void)downloadWithIdt:(uint64_t)idt key:(NSString *)key fileId:(NSString *)fileId;

/**
 *  取消下载资源包
 *
 *  @param idt 资源包ID
 */
- (void)cancelDownloadWithIdt:(uint64_t)idt;

/**
 *  删除下载资源包
 *
 *  @param idt 资源包ID
 */
- (void)removeDownloadWithIdt:(uint64_t)idt;

/**
 *  删除下载包数据
 *
 *  @param idt 资源包ID
 */
- (void)removeDownloadDataWithIdt:(uint64_t)idt;

/**
 * 添加已下载完成数据
 *
 * @param item
 *            下载对象
 * @return BOOL 是否已加载
 */
- (BOOL)appenDownloaded:(TuSDKNKDownloadItem *)item;

/**
 *  是否正在下载某个资源
 
 *  @param idt  下载对象ID
 *
 *  @return true: 下载中
 */
- (BOOL)isDownloadingWithIdt:(uint64_t)idt;

/**
 *  获取所有包ID列表
 *
 *  @return allGroupID 所有包ID列表
 */
- (NSArray *)allGroupID;

/**
 *  获取所有json数据
 *
 *  @return json 数据
 */
- (NSString *)jsonAllData;
@end
