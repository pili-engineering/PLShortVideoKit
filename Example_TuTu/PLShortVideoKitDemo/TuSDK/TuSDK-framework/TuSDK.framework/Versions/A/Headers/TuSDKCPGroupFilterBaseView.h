//
//  TuSDKCPGroupFilterBaseView.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/19.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPGroupFilterBarBase.h"
#import "TuSDKCPSubtitlesView.h"

/**
 *  滤镜分组视图基类
 */
@interface TuSDKCPGroupFilterBaseView : UIView<TuSDKCPGroupFilterBarDelegate>
{
    @protected
    // 是否显示活动状态
    BOOL _enableShowActive;
}

/**
 *  滤镜分组元素类型
 */
@property (nonatomic) lsqGroupFilterAction action;

/**
 *  是否为隐藏状态
 */
@property (nonatomic) BOOL stateHidden;

/**
 *  行视图宽度
 */
@property (nonatomic)CGFloat cellWidth;

/**
 *  折叠视图宽度
 */
@property (nonatomic)CGFloat stackViewWidth;

/**
 *  滤镜组选择栏高度
 */
@property (nonatomic)CGFloat filterBarHeight;

/**
 *  滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
 */
@property (nonatomic, strong)Class groupTableCellClazz;

/**
 *  滤镜列表折叠视图类 (默认:TuSDKCPGroupFilterGroupCellBase, 需要继承 UITableViewCell<TuSDKCPGroupFilterItemCellInterface>)
 */
@property (nonatomic, strong) Class stackViewClazz;

/**
 *  滤镜列表行视图类 (默认:TuSDKCPGroupFilterItemCell, 需要继承 UITableViewCell<TuSDKCPGroupFilterItemCellInterface>)
 */
@property (nonatomic, strong)Class filterTableCellClazz;

/**
 *  滤镜组选择栏
 */
@property (nonatomic, readonly) UIView<TuSDKCPGroupFilterBarInterface> *filterBar;

/**
 *  滤镜标题视图
 */
@property (nonatomic, readonly) UIView<TuSDKCPSubtitlesViewInterface> *titleView;

/**
 *  需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
 */
@property (nonatomic, retain) NSArray * filterGroup;

/**
 *  是否保存最后一次使用的滤镜
 */
@property (nonatomic) BOOL saveLastFilter;

/**
 *  自动选择分组滤镜指定的默认滤镜
 */
@property (nonatomic) BOOL autoSelectGroupDefaultFilter;

/**
 *  是否允许选择列表
 */
@property (nonatomic) BOOL allowsSelection;

/**
 *  开启滤镜配置选项
 */
@property (nonatomic) BOOL enableFilterConfig;

/**
 *  开启无效果滤镜 (默认: 开启)
 */
@property (nonatomic) BOOL enableNormalFilter;

/**
 *  开启在线滤镜
 */
@property (nonatomic) BOOL enableOnlineFilter;

/**
 *  在线滤镜控制器类型 (需要继承 UIViewController,以及实现TuSDKCPFilterOnlineControllerInterface接口)
 */
@property (nonatomic) Class onlineControllerClazz;

/**
 *  视图控制器
 */
@property (nonatomic, assign) UIViewController *controller;

/**
 *  开启用户历史记录
 */
@property (nonatomic) BOOL enableHistory;

/**
 *  显示滤镜标题视图
 */
@property (nonatomic) BOOL displaySubtitles;

/**
 *  是否渲染滤镜封面 (使用设置的滤镜直接渲染，需要拥有滤镜列表封面设置权限，请访问TUTUCLOUD.com控制台)
 */
@property (nonatomic) BOOL isRenderFilterThumb;

/**
 *  自定义封面原图(使用设置的滤镜直接渲染，需要拥有滤镜列表封面设置权限，请访问TUTUCLOUD.com控制台)
 *
 *  @param image 自定义封面原图
 */
- (void)setThumbImage:(UIImage *)image;

/**
 *  通知显示标题
 *
 *  @param cell 滤镜分组元素视图
 *  @param mode 滤镜分组元素
 *
 *  @return BOOL  是否通知
 */
- (BOOL)notifyTitleWithCell:(UITableViewCell<TuSDKCPGroupFilterItemCellInterface> *)cell
                       mode:(TuSDKCPGroupFilterItem *)mode;

/**
 *  通知显示标题
 *
 *  @param mode 滤镜分组元素
 */
- (void)notifyTitleWithMode:(TuSDKCPGroupFilterItem *)mode;

/**
 *  加载滤镜分组
 */
- (void)loadFilters;

/**
 *  设置默认显示状态
 *
 *  @param isShow 是否显示
 */
- (void)setDefaultShowState:(BOOL)isShow;

/**
 *  退出删除状态
 */
- (void)exitRemoveState;
@end
