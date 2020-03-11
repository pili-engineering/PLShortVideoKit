//
//  StickerPanelView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/20.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "BaseStickerPanelView.h"
#import "OverlayViewProtocol.h"

@class StickerPanelView, TuSDKPFStickerGroup;

@protocol StickerPanelViewDelegate <NSObject>
@optional

/**
 贴纸选中回调，若为在线贴纸，则在下载结束后回调

 @param stickerPanel 相机贴纸视图
 @param sticker 贴纸
 */
- (void)stickerPanel:(StickerPanelView *)stickerPanel didSelectSticker:(TuSDKPFStickerGroup *)sticker;

@end

/**
 贴纸面板，处理了贴纸数据显示、下载与选中回调
 */
@interface StickerPanelView : BaseStickerPanelView <OverlayViewProtocol>

/**
 触发者
 */
@property (nonatomic, weak) UIControl *sender;

/**
 相机贴纸视图代理
 */
@property (nonatomic, weak) id<StickerPanelViewDelegate> delegate;

@end
