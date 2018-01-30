//
//  TuSDKCPOnlineController.h
//  TuSDK
//
//  Created by Clear Hu on 15/5/21.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKCPViewController.h"
#import "TuSDKICWebView.h"
#import "TuSDKNKDownloadItem.h"

#pragma mark - TuSDKCPOnlineView
/**
 *  在线资源选择视图
 */
@interface TuSDKCPOnlineView : UIView
{
@protected
    //Web视图
    TuSDKICWebView *_webView;
}
/**
 *  Web视图
 */
@property (nonatomic, readonly)TuSDKICWebView *webView;
@end

#pragma mark - TuSDKCPOnlineController
/**
 *  在线资源控制器
 */
@interface TuSDKCPOnlineController : TuSDKCPViewController<TuSDKICWebViewDelegate>
/**
 *  Web视图
 */
@property (nonatomic, readonly) TuSDKICWebView *webView;

/**
 *  视图类 (默认:TuSDKCPOnlineView, 需要继承 TuSDKCPOnlineView)
 */
@property (nonatomic, strong) Class viewClazz;

/**
 *  详细数据ID
 */
@property (nonatomic) uint64_t detailDataId;

/**
 *  在线资源类型
 */
@property (nonatomic, copy) NSString *onlineType;

/**
 *  url参数
 */
@property (nonatomic, copy) NSString *args;

/**
 *  获取页面加载完成写入数据
 *
 *  @return pageFinishedData 页面加载完成写入数据
 */
- (NSString *)pageFinishedData;

/**
 *  下载动作
 *
 *  @param args 请求参数
 */
- (void)handleDownload:(NSArray *)args;

/**
 *  取消动作
 *
 *  @param args 请求参数
 */
- (void)handleCancel:(NSArray *)args;

/**
 *  选中动作
 *
 *  @param args 请求参数
 */
- (void)handleSelected:(NSArray *)args;

/**
 *  开启详细
 *
 *  @param args 请求参数
 */
- (void)handleDetail:(NSArray *)args;

/**
 *  下载资源
 *
 *  @param idt 资源ID
 *  @param key 下载SN
 *  @param fileId 文件ID
 */
- (void)onResourceDownloadWithIdt:(uint64_t)idt key:(NSString *)key fileId:(NSString *)fileId;

/**
 *  取消下载资源
 *
 *  @param idt 资源ID
 */
- (void)onResourceCancelDownloadWithIdt:(uint64_t)idt;

/**
 *  通知在线数据
 *
 *  @param item 在线数据
 */
- (void)notifyOnlineWithDownloadItem:(TuSDKNKDownloadItem *)item;
@end
