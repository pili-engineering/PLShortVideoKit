//
//  TuSDKCPFilterResultController.h
//  TuSDK
//
//  Created by Clear Hu on 15/4/29.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKCPImageResultController.h"
#import "TuSDKICFilterImageViewWrap.h"
#import "TuSDKCPParameterConfigViewInterface.h"

#pragma mark - TuSDKCPFilterResultViewInterface
/**
 *  滤镜处理结果控制器视图接口
 */
@protocol TuSDKCPFilterResultViewInterface <NSObject>
/**
 *  Filter Image View
 */
@property (nonatomic, readonly) UIView<TuSDKICFilterImageViewInterface> *imageView;
/**
 *  参数配置视图
 */
@property (nonatomic, readonly) UIView<TuSDKCPParameterConfigViewInterface> *configView;
@end

#pragma mark - TuSDKPFEditSkinControllerDelegate
@class TuSDKCPFilterResultController;
/**
 *  滤镜处理结果控制器委托
 */
@protocol TuSDKCPFilterResultControllerDelegate <TuSDKCPComponentErrorDelegate>
/**
 *  图片编辑完成
 *
 *  @param controller 图片编辑控制器
 *  @param result 处理结果
 */
- (void)onTuSDKFilterResult:(TuSDKCPFilterResultController *)controller result:(TuSDKResult *)result;
@optional
/**
 *  图片编辑完成  (异步方法)
 *
 *  @param controller 图片编辑控制器
 *  @param result 处理结果
 *  @return BOOL 是否截断默认处理逻辑 (默认: NO, 设置为YES时使用自定义处理逻辑)
 */
- (BOOL)onAsyncTuSDKFilterResult:(TuSDKCPFilterResultController *)controller result:(TuSDKResult *)result;
@end

#pragma mark - TuSDKCPFilterResultController
/**
 *  滤镜处理结果控制器
 */
@interface TuSDKCPFilterResultController : TuSDKCPImageResultController<TuSDKCPParameterConfigDelegate>
{
    @protected
    // 默认样式视图
    UIView<TuSDKCPFilterResultViewInterface> *_defaultStyleView;
}

/**
 *  默认样式视图 (如果覆盖 buildDefaultStyleView 方法，实现了自己的视图，defaultStyleView == nil)
 */
@property (nonatomic, readonly) UIView<TuSDKCPFilterResultViewInterface> *defaultStyleView;

/**
 *  控制器委托
 */
@property (nonatomic, weak) id<TuSDKCPFilterResultControllerDelegate> delegate;

/**
 *  视图类 (需要实现 TuSDKCPFilterResultViewInterface 接口)
 */
@property (nonatomic, strong) Class viewClazz;

/**
 *  滤镜包装
 */
- (void)setFilterWrap:(TuSDKFilterWrap *)filterWrap;

/** 获取滤镜配置参数 */
- (TuSDKFilterParameter *)getFilterPrarameter;
/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAtion;

/**
 *  异步处理图片
 *
 *  @param result 异步处理图片
 */
- (void)asyncEditWithResult:(TuSDKResult *)result;

/**
 *  请求渲染视图
 */
- (void)requestRender;

/**
 刷新滤镜参数视图
 */
- (void)refreshConfigView;

@end
