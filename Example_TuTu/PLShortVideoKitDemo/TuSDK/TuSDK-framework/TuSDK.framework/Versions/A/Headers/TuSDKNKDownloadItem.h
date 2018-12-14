//
//  TuSDKNKDownloadItem.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/23.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKDataJson.h"
/**
 *  下载类型
 */
typedef NS_ENUM(NSInteger, lsqDownloadTaskType)
{
    /**
     * 滤镜
     */
    lsqDownloadTaskTypeFilter,
    /**
     * 贴纸
     */
    lsqDownloadTaskTypeSticker,
    /**
     * 笔刷
     */
    lsqDownloadTaskTypeBrush,
};

/**
 *  下载状态
 */
typedef NS_ENUM(NSInteger, lsqDownloadTaskStatus)
{
    /**
     * 初始化状态
     */
    lsqDownloadTaskStatusInit,
    /**
     * 正在下载
     */
    lsqDownloadTaskStatusDowning = 10,
    /**
     * 正在下载完成
     */
    lsqDownloadTaskStatusDowned = 20,
    /**
     * 下载失败
     */
    lsqDownloadTaskStatusDownFailed = 30,
    /**
     * 取消处理
     */
    lsqDownloadTaskStatusCancel = 40,
    /**
     * 删除处理
     */
    lsqDownloadTaskStatusRemoved = 100,
};

/**
 *  在线命令动作
 */
typedef NS_ENUM(NSInteger, lsqOnlineCommandAction)
{
    /**
     * 未知动作
     */
    lsqOnlineCommandActionUnknown,
    /**
     * 默认动作
     */
    lsqOnlineCommandActionDefault,
    /**
     * 取消动作
     */
    lsqOnlineCommandActionCancel,
    /**
     * 选中动作
     */
    lsqOnlineCommandActionSelect,
    /**
     * 查看详细
     */
    lsqOnlineCommandActionDetail
};


/**
 *  下载对象
 */
@interface TuSDKNKDownloadItem : TuSDKDataJson<NSCoding>
/**
 * 资源ID
 */
@property (nonatomic) uint64_t idt;

/**
 * 资源key
 */
@property (nonatomic, copy) NSString *key;

/**
 * 下载状态
 */
@property (nonatomic) lsqDownloadTaskStatus status;

/**
 * 下载进度
 */
@property (nonatomic) CGFloat progress;

/**
 * 用户ID
 */
@property (nonatomic, copy) NSString *userId;

/**
 * 下载类型
 */
@property (nonatomic) lsqDownloadTaskType type;

/**
 * 文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  下载类型动作标识
 */
@property (nonatomic, readonly) NSString *typeAct;

/**
 *  文件ID
 */
@property (nonatomic, copy) NSString *fileId;

/**
 *  本地下载文件路径
 *
 *  @return 本地下载文件路径
 */
- (NSString *)localDownloadPath;

/**
 *  本地下载文件临时目录
 *
 *  @return 本地下载文件临时目录
 */
- (NSString *)localTempPath;

/**
 *  转为JSON数据
 *
 *  @return JSON数据
 */
- (NSDictionary *)jsonData;

/**
 *  状态改变数据
 *
 *  @return jsonStatusChangeData 状态改变数据
 */
- (NSString *)jsonStatusChangeData;

/**
 *  下载类型动作标识
 *
 *  @param type 下载类型动作
 *
 *  @return type 下载类型动作标识
 */
+ (NSString *)typeActWithType:(lsqDownloadTaskType)type;
@end
