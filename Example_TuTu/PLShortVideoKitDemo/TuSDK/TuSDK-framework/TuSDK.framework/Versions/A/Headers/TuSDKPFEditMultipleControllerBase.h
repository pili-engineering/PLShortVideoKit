//
//  TuSDKPFEditMultipleControllerBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKCPEditActionType.h"
#import "TuSDKWaterMarkOption.h"

/**
 *  多功能图像编辑控制器基础类
 */
@interface TuSDKPFEditMultipleControllerBase : TuSDKCPImageResultController
{
    @protected
    // 历史记录
    NSMutableArray *_histories;
    // 丢弃的记录
    NSMutableArray *_brushies;
}
/**
 *  最大输出图片边长 (默认:0, 不限制图片宽高)
 */
@property (nonatomic) NSUInteger limitSideSize;

/**
 *  最大输出图片按照设备屏幕 (默认:true, 如果设置了LimitSideSize, 将忽略LimitForScreen)
 */
@property (nonatomic) BOOL limitForScreen;

/**
 *  视频视图显示比例类型 (默认:lsqRatioDefault, 如果设置cameraViewRatio > 0, 将忽略ratioType)
 */
@property (nonatomic) lsqRatioType ratioType;

/**
 *  视图显示比例类型列表 ( 优先级 ratioTypeList > ratioType, 默认：lsqTuSDKRatioDefaultTypes)
 *
 *  设置 NSNumber 型数组来控制显示的按钮顺序， 例如:
 *	@[@(lsqRatioOrgin), @(lsqRatio_1_1), @(lsqRatio_2_3), @(lsqRatio_3_4)]
 *
 */
@property (nonatomic) NSArray<NSNumber *> *ratioTypeList;

/**
 *  是否禁用操作步骤记录
 */
@property (nonatomic) BOOL disableStepsSave;

/**
 *  功能模块列表 lsqTuSDKCPEditActionType (默认全部加载, [TuSDKCPEditActionType multipleActionTypes])
 */
@property (nonatomic, retain) NSArray *modules;

/**
 *  显示的图片
 */
@property (nonatomic, retain) UIImage *displayImage;

/**
 *  获取当前可用比例列表
 */
- (NSArray<NSNumber *> *)getRatioTypes;

/**
 *  异步加载输入图片
 *
 *  @return 异步加载输入图片
 */
- (UIImage *)asyncLoadImage;

/**
 *  刷新操作步骤状态
 */
- (void)refreshStepStates;

/***
 * 刷新操作步骤状态
 *
 * @param histories
 *            历史记录数
 * @param brushies
 *            丢弃的记录数
 */
- (void)onRefreshStepStatesWithHistories:(NSUInteger)histories brushies:(NSUInteger)brushies;

/**
 *  刷新自动较色按钮状态
 *
 *  @param enable 是否可用
 */
- (void)onRefreshAutoAdjustButtonEnable:(BOOL)enable;

/**
 *  获取最后执行的步骤
 *
 *  @return 最后执行的步骤
 */
- (NSString *)lastStepTemp;

/**
 *  添加一条操作
 *
 *  @param temp 操作文件路径
 */
- (void)appendHistory:(NSString *)temp;

/**
 *  操作记录后退
 */
- (void)onStepPreviewAction;

/**
 *  操作记录前进
 */
- (void)onStepNextAction;

/**
 *  自动校色按钮动作
 */
- (void)onAutoAdjustAction;

/**
 *  开启响应处理控制器
 *
 *  @param btn 入口按钮
 */
- (void)onEditWithAction:(UIButton *)btn;

/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAtion;
@end
