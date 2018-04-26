//
//  TuSDKPFEditTurnAndCutViewControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKICTouchImageView.h"

/**
 *  旋转和裁剪视图控制器基础类
 */
@interface TuSDKPFEditTurnAndCutViewControllerBase : TuSDKCPImageResultController
/**
 *  图片编辑视图 (旋转，缩放)
 */
@property (nonatomic, readonly) UIView<TuSDKICTouchImageViewInterface> *imageView;

/**
 *  需要裁剪的长宽
 */
@property (nonatomic) CGSize cutSize;

/**
 *  选中一个滤镜
 *
 *  @param filterName 滤镜名称
 *  @return BOOL 是否成功切换滤镜
 */
- (BOOL)onSelectedFilterCode:(NSString *)code;

/**
 *  滤镜图片处理完成
 *
 *  @param image 滤镜图片处理完成
 */
- (void)processedFilter:(UIImage *)image;

/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAtion;
@end
