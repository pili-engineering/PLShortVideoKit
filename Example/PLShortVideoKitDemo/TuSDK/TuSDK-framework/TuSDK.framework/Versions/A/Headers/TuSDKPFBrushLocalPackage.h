//
//  TuSDKPFBrushLocalPackage.h
//  TuSDK
//
//  Created by Yanlin on 10/27/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKConfig.h"
#import "TuSDKPFBrush.h"
#import "TuSDKNKDownloadItem.h"

/**
 *  橡皮擦笔刷代号
 */
extern NSString * const lsqEraserBrushCode;

#pragma mark - TuSDKPFBrushConfigDelegate

@class TuSDKPFBrushLocalPackage;

/**
 *  原生笔刷配置委托
 */
@protocol TuSDKPFBrushLocalPackageDelegate <NSObject>
/**
 *  本地笔刷包下载状态改变
 *
 *  @param manager 本地笔刷包
 *  @param item    下载对象
 *  @param status  下载状态
 */
- (void)brushManager:(TuSDKPFBrushLocalPackage *)manager
                item:(TuSDKNKDownloadItem *)item
       changedStatus:(lsqDownloadTaskStatus)status;
@end

#pragma mark - TuSDKPFBrushLocalPackage
/**
 *  本地笔刷配置
 */
@interface TuSDKPFBrushLocalPackage : NSObject

/**
 *  本地笔刷包
 *
 *  @return package 本地笔刷包
 */
+ (instancetype)package;

/**
 *  本地笔刷包
 *
 *  @param config Sdk配置
 *
 *  @return config 本地笔刷包
 */
+ (instancetype)initWithConfig:(TuSDKConfig *)config;

/**
 *  原生笔刷代号列表
 */
@property (nonatomic, readonly) NSArray *codes;

/**
 *  是否已初始化
 */
@property (nonatomic, readonly) BOOL isInited;

#pragma mark - delegate

/**
 *  添加本地笔刷包委托
 *
 *  @param delegate 本地笔刷包委托
 */
- (void)appenDelegate:(id<TuSDKPFBrushLocalPackageDelegate>)delegate;

/**
 *  删除本地笔刷包委托
 *
 *  @param delegate 本地笔刷包委托
 */
- (void)removeDelegate:(id<TuSDKPFBrushLocalPackageDelegate>)delegate;

/**
 *  获取橡皮擦笔刷对象
 *
 *  @return 笔刷对象 (如果未找到对应选项，返回默认配置)
 */
- (TuSDKPFBrush *)eraserBrush;

/**
 *  获取笔刷对象
 *
 *  @param code 笔刷代号
 *
 *  @return 笔刷对象 (如果未找到对应选项，返回默认配置)
 */
- (TuSDKPFBrush *)brushWithCode:(NSString *)code;

/**
 *  验证笔刷代号
 *
 *  @param codes 笔刷代号列表
 *
 *  @return 笔刷名称
 */
- (NSArray *)verifyCodes:(NSArray *)codes;

/**
 *  获取指定名称的笔刷列表
 *
 *  @param codes 笔刷代号列表
 *
 *  @return 笔刷列表
 */
- (NSArray *)brushWithCodes:(NSArray *)codes;

#pragma mark - imageLoad
/**
 *  加载笔刷预览图片
 *
 *  @param brush     笔刷对象
 *  @param imageView 图片视图
 */
- (void)loadThumbWithBrush:(TuSDKPFBrush *)brush imageView:(UIImageView *)imageView;

/**
 *  取消加载图片
 *
 *  @param imageView 图片视图
 */
- (void)cancelLoadImage:(UIImageView *)imageView;

/**
 *  加载笔刷数据
 *
 *  @param brush  笔刷对象
 *
 *  @return  是否加载贴纸数据对象
 */
- (BOOL)loadBrushData:(TuSDKPFBrush *)brush;

#pragma mark - download
/**
 *  下载笔刷
 *
 *  @param idt 笔刷ID
 *  @param key 下载SN
 *  @param fileId 文件ID
 */
- (void)downloadWithIdt:(uint64_t)idt key:(NSString *)key fileId:(NSString *)fileId;

/**
 *  取消下载笔刷
 *
 *  @param idt 笔刷ID
 */
- (void)cancelDownloadWithIdt:(uint64_t)idt;

/**
 *  删除下载笔刷
 *
 *  @param idt 笔刷ID
 */
- (void)removeDownloadWithIdt:(uint64_t)idt;

/**
 *  获取所有json数据
 *
 *  @return json数据
 */
- (NSString *)jsonAllData;


@end
