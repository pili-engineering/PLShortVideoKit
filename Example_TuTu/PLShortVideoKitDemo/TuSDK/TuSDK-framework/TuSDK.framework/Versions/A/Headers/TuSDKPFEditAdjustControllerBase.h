//
//  TuSDKPFEditAdjustControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/7.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPFilterResultController.h"

/**
 *  颜色调整控制器基础类
 */
@interface TuSDKPFEditAdjustControllerBase : TuSDKCPFilterResultController
{
    @protected
    // 是否显示多功能调整
    BOOL _isMultiAdjust;
}

/**
 *  选中一个参数动作
 *
 *  @param btn 选中按钮
 */
- (void)onArgSelectedAction:(UIView *)btn;

/**
 *  获取当前选中动作
 *
 *  @return 当前动作索引
 */
- (NSUInteger)getCurrentAction;

/**
 *  设置配置视图隐藏状态
 *
 *  @param isHidden 是否隐藏
 */
- (void)setConfigViewHiddenState:(BOOL)isHidden;

/**
 *  配置返回无保存
 *
 *  @param view     参数配置视图
 */
- (void)onTuSDKCPParameterConfigBackNotSave:(UIView<TuSDKCPParameterConfigViewInterface> *)view;
@end
