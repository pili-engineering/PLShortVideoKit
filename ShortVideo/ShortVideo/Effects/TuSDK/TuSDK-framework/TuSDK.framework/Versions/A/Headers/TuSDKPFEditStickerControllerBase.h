//
//  TuSDKPFEditStickerControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKICMaskRegionView.h"
#import "TuSDKPFStickerView.h"

/**
 *  图片编辑贴纸选择控制器基础类
 */
@interface TuSDKPFEditStickerControllerBase : TuSDKCPImageResultController
/**
 *  裁剪区域视图
 */
@property (nonatomic, readonly) TuSDKICMaskRegionView *cutRegionView;
/**
 *  贴纸视图
 */
@property (nonatomic, readonly) TuSDKPFStickerView *stickerView;

/**
 *  添加贴纸数据
 *
 *  @param sticker 贴纸数据
 */
- (void)appendSticker:(TuSDKPFSticker *)sticker;

/**
 *  添加贴纸
 *
 *  @param stickerImage 贴纸图片 (PNG格式)
 */
- (void)appendStickerImage:(UIImage *) stickerImage;

/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAtion;

@end
