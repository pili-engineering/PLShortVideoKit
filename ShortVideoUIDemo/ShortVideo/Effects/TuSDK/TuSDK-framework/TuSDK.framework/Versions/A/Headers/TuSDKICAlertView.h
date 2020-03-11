//
//  TuSDKICAlertView.h
//  TuSDK
//
//  Created by Clear Hu on 15/10/11.
//  Copyright © 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  提示信息动作样式
 */
typedef NS_ENUM(NSInteger, TuSDKICAlertActionStyle){
    /**
     *  默认
     */
    TuSDKICAlertActionStyleDefault = 0,
    /**
     *  取消
     */
    TuSDKICAlertActionStyleCancel,
    /**
     *  强调
     */
    TuSDKICAlertActionStyleDestructive
};

/**
 *  提示信息样式
 */
typedef NS_ENUM(NSInteger, TuSDKICAlertStyle){
    /**
     *  下拉样式
     */
    TuSDKICAlertStyleActionSheet = 0,
    /**
     *  对话框样式
     */
    TuSDKICAlertStyleAlert
};

#pragma mark - TuSDKICAlertAction
@class TuSDKICAlertAction;

/**
 *  提示信息动作委托
 *
 *  @param action 提示信息动作
 */
typedef void(^TuSDKICAlertActionHandler)(TuSDKICAlertAction *action);
/**
 *  提示信息动作
 */
@interface TuSDKICAlertAction : NSObject
/**
 *  提示信息动作 (默认)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title
                        handler:(nullable TuSDKICAlertActionHandler)handler;

/**
 *  提示信息动作 (取消)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionCancelWithTitle:(nullable NSString *)title
                              handler:(nullable TuSDKICAlertActionHandler)handler;

/**
 *  提示信息动作 (强调)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionDestructiveWithTitle:(nullable NSString *)title
                                   handler:(nullable TuSDKICAlertActionHandler)handler;

/**
 *  提示信息动作
 *
 *  @param title   标题
 *  @param style   提示信息动作样式
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(TuSDKICAlertActionStyle)style
                        handler:(nullable TuSDKICAlertActionHandler)handler;

/**
 *  标题
 */
@property (nullable, nonatomic, readonly) NSString *title;
/**
 *  提示信息动作样式
 */
@property (nonatomic, readonly) TuSDKICAlertActionStyle style;
@end


#pragma mark - TuSDKICAlertView
/**
 *  提示信息视图
 */
@interface TuSDKICAlertView : NSObject

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param message    信息
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                        message:(nullable NSString *)message;

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                              title:(nullable NSString *)title
                            message:(nullable NSString *)message;

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller  控制器
 *  @param message     信息
 *  @param cancelTitle 取消按钮文字
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                        message:(nullable NSString *)message
                    cancelTitle:(nullable NSString *)cancelTitle;


/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller  控制器
 *  @param title       标题
 *  @param message     信息
 *  @param cancelTitle 取消按钮文字
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                          title:(nullable NSString *)title
                        message:(nullable NSString *)message
                    cancelTitle:(nullable NSString *)cancelTitle;

/**
 *  显示提示信息视图 (对话框样式，大于等于IOS7时显示系统设置按钮)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 */
+ (void)alertShowConfigWithController:(nullable UIViewController *)controller
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message;

/**
 *  提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 *
 *  @return message 提示信息视图
 */
+ (instancetype)alertWithController:(nullable UIViewController *)controller
                              title:(nullable NSString *)title
                            message:(nullable NSString *)message;

/**
 *  提示信息视图 (下拉样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 *
 *  @return message 提示信息视图
 */
+ (instancetype)actionSheetWithController:(nullable UIViewController *)controller
                                    title:(nullable NSString *)title
                                  message:(nullable NSString *)message;

/**
 *  添加提示信息动作
 *
 *  @param action 提示信息动作
 */
- (void)addAction:(TuSDKICAlertAction *)action;

/**
 *  显示提示信息视图
 */
- (void)show;

/**
 *  提示信息动作列表
 */
@property (nonatomic, readonly) NSArray<TuSDKICAlertAction *> *actions;
/**
 *  标题
 */
@property (nullable, nonatomic, copy) NSString *title;
/**
 *  信息
 */
@property (nullable, nonatomic, copy) NSString *message;

/**
 *  提示信息样式
 */
@property (nonatomic, readonly) TuSDKICAlertStyle preferredStyle;
@end

NS_ASSUME_NONNULL_END
