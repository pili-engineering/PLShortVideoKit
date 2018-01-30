//
//  TuSDKICViewController.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/28.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKProgressHUD.h"
#import "TuSDKTSCATransition+Extend.h"

/**
 *  控制器基础类
 */
@interface TuSDKICViewController : UIViewController{
    @protected
    /**
     *  页面是否已经返回 | 通过这个标记可以在viewDidDisappear里面确认销毁该控制器
     */
    BOOL _isBacked;
}

/**
 *  系统版本大于7时，滚动视图位置置顶到状态栏
 */
@property (nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets;

/**
 *  转场动画
 */
@property (nonatomic,retain) TuSDKTSCControllerTrans *transAnim;

/**
 *  设置导航栏左边按钮
 *
 *  @param title  标题
 *  @param action 动作
 */
- (void)navLeftButtonWithTitle:(NSString *)title action:(SEL)action;

/**
 *  设置导航栏左边按钮
 *
 *  @param title  标题
 *  @param color  标题颜色
 *  @param action 动作
 */
-(void)navLeftButtonWithTitle:(NSString *)title textColor:(UIColor *)color action:(SEL)action;

/**
 *  设置导航栏右边按钮
 *
 *  @param title  标题
 *  @param action 动作
 */
- (void)navRightButtonWithTitle:(NSString *)title action:(SEL)action;

/**
 *  设置导航栏右边按钮
 *
 *  @param title  标题
 *  @param color  标题颜色
 *  @param action 动作
 */
-(void)navRightButtonWithTitle:(NSString *)title textColor:(UIColor *)color action:(SEL)action;

/**
 *  设置导航栏左边取消按钮
 */
- (void)setNavLeftCancelButton;

/**
 *  设置导航栏左边取消按钮
 *
 *  @param color  文字颜色
 */
- (void)setNavLeftCancelButtonWithColor:(UIColor *)color;

/**
 *  设置导航栏右边取消按钮
 */
- (void)setNavRightCancelButton;

/**
 *  设置导航栏右边取消按钮和文本颜色
 *
 *  @param color  文字颜色
 */
- (void)setNavRightCancelButtonWithColor:(UIColor *)color;

/**
 *  取消按钮响应事件
 */
- (void)cancelAction;

/**
 *  创建自定义返回按钮
 */
- (void)setBackButton;

/**
 *  显示进度提示信息
 *
 *  @param status 信息
 */
- (void)showHubWithStatus:(NSString *)status;

/**
 * 显示进度信息
 *
 * @param progress
 *            进度, 0 ~ 1
 * @param status
 *            信息
 */
-(void)showHubProgress:(float)progress withStatus:(NSString *)status;

/**
 *  显示进度提示成功信息
 *
 *  @param status 信息
 */
- (void)showHubSuccessWithStatus:(NSString *)status;

/**
 *  显示进度提示失败信息
 *
 *  @param status 信息
 */
- (void)showHubErrorWithStatus:(NSString *)status;

/**
 *  关闭进度提示
 */
- (void)dismissHub;
@end


#pragma mark - TuSDKViewControllerExtend
/**
 *  扩展控制器方法
 */
@interface UIViewController(TuSDKICViewControllerExtend)
/**
 *  初始化控制器
 *
 *  @return controller 控制器
 */
+ (instancetype)controller;

/**
 *  导航级数
 */
- (NSInteger)navCount;

/**
 *  返回前一页 使用动画
 */
- (void)backActionHadAnimated;

/**
 *  返回前一页
 *
 *  @param animated 是否使用动画
 */
- (void)backActionWithAnimated:(BOOL)animated;

/**
 *  返回前一页
 *
 *  @param anim 自定义动画
 */
- (void)backActionWithAnim:(CAAnimation *)anim;

/**
 *  取消模态控制器 使用动画
 */
- (void)dismissModalViewControllerAnimated;

/**
 *  取消模态控制器 使用动画
 *
 *  @param anim 自定义动画
 */
- (void)dismissModalViewControllerWithAnim:(CAAnimation *)anim;

/**
 *  取消控制器 使用动画
 *
 *  @param anim       自定义动画
 *  @param completion 结束回调
 */
- (void)dismissViewControllerWithAnim:(CAAnimation *)anim completion:(void (^)(void))completion;

/**
 *  弹出一个视图控制器
 *
 *  @param viewController 视图控制器
 *  @param animated       是否使用动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  Push控制器
 *
 *  @param viewController 视图控制器
 *  @param anim           自定义动画
 */
- (void)pushViewController:(UIViewController *)viewController anim:(CAAnimation *)anim;

/**
 *  退出一个视图控制器
 *
 *  @param animated 是否使用动画
 *
 *  @return controller 返回退出的视图控制器
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

/**
 *  退出一个视图控制器
 *
 *  @param anim 自定义动画
 *
 *  @return controller 返回退出的视图控制器
 */
- (UIViewController *)popViewControllerWithAnim:(CAAnimation *)anim;

/**
 *  退出到指定的控制器视图
 *
 *  @param viewController 指定的控制器视图
 *  @param animated       是否使用动画
 *
 *  @return controller 返回退出的视图控制器列表
 */
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  退出到指定的控制器视图
 *
 *  @param viewController 指定的控制器视图
 *  @param anim       自定义动画
 *
 *  @return controller 返回退出的视图控制器列表
 */
- (NSArray *)popToViewController:(UIViewController *)viewController anim:(CAAnimation *)anim;

/**
 *  弹出到第一个视图控制器
 *
 *  @param animated 是否使用动画
 *
 *  @return controller 返回退出的视图控制器列表
 */
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  弹出到第一个视图控制器
 *
 *  @param anim 自定义动画
 *
 *  @return controller 返回退出的视图控制器列表
 */
- (NSArray *)popToRootViewControllerWithAnim:(CAAnimation *)anim;

/**
 *  弹出一个带导航的模态窗口
 *
 *  @param controller 控制器
 *  @param animated   是否使用动画
 */
- (void)presentModalNavigationController:(UIViewController *)controller animated:(BOOL)animated;

/**
 *  弹出一个带导航的模态窗口
 *
 *  @param controller 控制器
 *  @param animated   是否使用动画
 *  @param hiddenNav  是否隐藏导航栏
 */
- (void)presentModalNavigationController:(UIViewController *)controller animated:(BOOL)animated hiddenNav:(BOOL)hiddenNav;

/**
 *  弹出一个带导航的模态窗口
 *
 *  @param controller 控制器
 *  @param anim   自定义动画
 */
- (void)presentModalNavigationController:(UIViewController *)controller anim:(CAAnimation *)anim;

/**
 *  弹出一个带导航的模态窗口
 *
 *  @param controller 控制器
 *  @param anim   自定义动画
 *  @param hiddenNav  是否隐藏导航栏
 */
- (void)presentModalNavigationController:(UIViewController *)controller anim:(CAAnimation *)anim hiddenNav:(BOOL)hiddenNav;

/**
 *  设置全屏
 *
 *  @param wantFull 是否全屏
 */
- (void)setFullScreenLayout:(BOOL)wantFull;

/**
 *  设置状态隐藏状态
 *
 *  @param hidden    是否隐藏
 *  @param animation 使用动画
 */
- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

/**
 *  设置状态隐藏状态，没有动画
 *
 *  @param hidden    是否隐藏
 */
- (void)setStatusBarHidden:(BOOL)hidden;

/**
 *  设置导航栏是否隐藏 (不使用动画)
 *
 *  @param isHidden 是否隐藏导航栏
 */
- (void)setNavigationBarHidden:(BOOL)isHidden;

/**
 *  设置导航栏是否隐藏
 *
 *  @param isHidden 是否隐藏导航栏
 *  @param animated 是否使用动画
 */
- (void)setNavigationBarHidden:(BOOL)isHidden animated:(BOOL)animated;

/**
 *  控制器即将销毁
 */
- (void)controllerWillDestory;
@end
