//
//  TuSDKNKDownloadTask.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/23.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKNKDownloadItem.h"

@class TuSDKNKDownloadTask;

/**
 *  下载任务委托
 */
@protocol TuSDKNKDownloadTaskDelegate <NSObject>
/**
 *  下载任务状态改变
 *
 *  @param task   下载任务
 *  @param status 下载状态
 */
- (void)downloadTask:(TuSDKNKDownloadTask *)task changedStatus:(lsqDownloadTaskStatus)status;
@end

/**
 *  下载任务
 */
@interface TuSDKNKDownloadTask : NSObject
/**
 *  下载对象
 */
@property (nonatomic, readonly) TuSDKNKDownloadItem *item;

/**
 *  下载任务委托
 */
@property (nonatomic, weak) id<TuSDKNKDownloadTaskDelegate> delegate;
/**
 *  初始化 下载任务
 *
 *  @param item 下载对象
 *
 *  @return item 下载任务
 */
+ (instancetype)initWithItem:(TuSDKNKDownloadItem *)item;

/**
 *  是否匹配任务
 *
 *  @param type 下载类型
 *  @param idt  下载资源ID
 *
 *  @return BOOL 是否匹配任务
 */
- (BOOL)isEqual:(lsqDownloadTaskType)type idt:(uint64_t)idt;

/**
 *  是否允许执行任务
 *
 *  @return canRunTask 是否允许执行任务
 */
- (BOOL)canRunTask;

/**
 *  开始任务
 */
- (void)start;

/**
 *  清理数据
 */
- (void)clear;

/**
 *  取消任务
 */
- (void)cancel;
@end
