//
//  TuSDKPFEditFilterGroupViewBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/9.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPGroupFilterBaseView.h"
#import "TuSDKFilterWrap.h"

/**
 *  图片编辑滤镜控制器滤镜栏视图基础类
 */
@interface TuSDKPFEditFilterGroupViewBase : TuSDKCPGroupFilterBaseView

/**
 *  设置配置视图参数
 *
 *  @param keys 参数
 */
- (void)setConfigViewParams:(NSArray *)keys;

/**
 *  显示配置视图
 *
 *  @param isShow 是否显示
 */
- (void)configViewShow:(BOOL)isShow;

/**
 *  取消设置
 */
- (void)handleCancelAction;

/**
 *  滤镜对象
 *
 *  @param filter 滤镜对象
 */
- (void)setFilter:(TuSDKFilterWrap *)filter;

/**
 *  请求渲染
 */
- (void)requestRender;

/**
 *  选中一个滤镜数据
 *
 *  @param data 滤镜数据
 *
 *  @return 是否允许继续执行
 */
- (BOOL)onFilterSelectedWithData:(TuSDKCPGroupFilterItem *)data;

/**
 *  获取滤镜参数
 *
 *  @param index 索引
 *
 *  @return 滤镜参数
 */
- (TuSDKFilterArg *)filterArgWithIndex:(NSUInteger)index;
@end
