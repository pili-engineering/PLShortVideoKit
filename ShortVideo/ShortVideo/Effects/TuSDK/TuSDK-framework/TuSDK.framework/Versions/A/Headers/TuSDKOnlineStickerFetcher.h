//
//  TuSDKStickerFetcher.h
//  TuSDK
//
//  Created by gh.li on 2017/7/25.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKPFStickerGroup.h"
#import "TuSDKNKDownloadItem.h"

@class TuSDKOnlineStickerFetcher;

#pragma mark - TuSDKOnlineStickerFetcherDelegate

/*
 * 委托对象
 */
@protocol TuSDKOnlineStickerFetcherDelegate <NSObject>

/*
 * 请求失败
 */
- (void)onFetchFailed;

/*
 * 获取到贴纸分组信息
 */
- (void)onFetchCompleted:(NSArray<TuSDKPFStickerGroup *> *)groups;


@end

#pragma mark - TuSDKOnlineStickerFetcher

/**
 * 获取在线贴纸数据
 */
@interface TuSDKOnlineStickerFetcher : NSObject

/*
 * 委托对象
 */
@property (nonatomic,weak) id<TuSDKOnlineStickerFetcherDelegate> delegate;

/**
 *  从服务器获取贴纸组列表
 *
 *  @param cursor  贴纸分组id 不为nil时将查询该分组id之后的贴纸数据（可实现分页查询）
 *  @param isSmart 是否获取智能贴纸 true:只查询智能贴纸 false:只查询普通贴纸
 */
- (void)fetchStickGroupsWithCursor:(uint64_t)cursor isSmart:(BOOL)isSmart;


@end
