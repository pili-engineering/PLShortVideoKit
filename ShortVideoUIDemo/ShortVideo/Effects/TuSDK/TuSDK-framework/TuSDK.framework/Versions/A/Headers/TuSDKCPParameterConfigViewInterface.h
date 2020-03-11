//
//  TuSDKCPParameterConfigViewInterface.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/7.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TuSDKCPParameterConfigViewInterface;

/**
 *  参数配置视图委托
 */
@protocol TuSDKCPParameterConfigDelegate <NSObject>
/**
 *  参数数据改变
 *
 *  @param view     参数配置视图
 *  @param index    参数索引
 *  @param progress 百分比进度
 */
- (void)onTuSDKCPParameterConfig:(UIView<TuSDKCPParameterConfigViewInterface> *)view
                 changeWithIndex:(NSUInteger)index
                        progress:(CGFloat)progress;

/**
 *  读取参数值
 *
 *  @param view  参数配置视图
 *  @param index 参数索引
 *
 *  @return parameterConfig 参数值
 */
- (CGFloat)onTuSDKCPParameterConfig:(UIView<TuSDKCPParameterConfigViewInterface> *)view
                     valueWithIndex:(NSUInteger)index;

/**
 *  重置参数
 *
 *  @param view  参数配置视图
 *  @param index 参数索引
 */
- (void)onTuSDKCPParameterConfig:(UIView<TuSDKCPParameterConfigViewInterface> *)view
                  resetWithIndex:(NSUInteger)index;
@end

/**
 *  参数配置视图接口
 */
@protocol TuSDKCPParameterConfigViewInterface <NSObject>
/**
 *  参数配置视图委托
 */
@property (nonatomic, weak) id<TuSDKCPParameterConfigDelegate> delegate;
/**
 *  跳到指定百分比
 *
 *  @param progress 百分比进度
 */
- (void)seekWithProgress:(CGFloat)progress;

/**
 *   设置参数列表
 *
 *  @param params 参数列表
 *  @param index  选中索引
 */
- (void)setParams:(NSArray *)params selectedIndex:(NSUInteger)index;
@end
