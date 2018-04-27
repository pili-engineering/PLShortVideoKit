//
//  TuSDKPFEditFilterControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKICFilterImageViewWrap.h"

/**
 *  图片编辑滤镜控制器基础类
 */
@interface TuSDKPFEditFilterControllerBase : TuSDKCPImageResultController

/**
 *  图片视图
 */
@property (nonatomic, readonly) UIView<TuSDKICFilterImageViewInterface> *imageView;

/**
 *  是否仅返回滤镜，不返回处理图片
 */
@property (nonatomic) BOOL onlyReturnFilter;
/**
 *  当前所使用的滤镜
 */
@property (nonatomic, retain) TuSDKFilterWrap *filterWrap;

/**
 *  通知滤镜配置视图
 */
- (void)notifyFilterConfigView;

/**
 *  选中一个滤镜
 *
 *  @param filterName 滤镜名称
 *  @return BOOL 是否成功切换滤镜
 */
- (BOOL)onSelectedFilterCode:(NSString *)code;

/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAtion;
@end
