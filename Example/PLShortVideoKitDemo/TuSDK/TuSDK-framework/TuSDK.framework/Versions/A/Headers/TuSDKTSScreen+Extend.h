//
//  TuSDKTSScreen+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/1.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - args
/**
 *  状态栏高度
 */
extern CGFloat const lsq_STATES_BAR_HEIGHT;

/**
 *  导航栏高度
 */
extern CGFloat const lsq_NAV_BAR_HEIGHT;

/**
 *  TAB栏高度
 */
extern CGFloat const lsq_TAB_BAR_HEIGHT;


#pragma mark - TuSDKTSScreenExtend
/**
 *  屏幕属性扩展
 */
@interface UIScreen(TuSDKTSScreenExtend)
/**
 *  屏幕宽高
 *
 *  @return size 屏幕宽高
 */
+ (CGSize)size;

/**
 *  屏幕像素密度
 *
 *  @return  scale 屏幕像素密度
 */
+ (CGFloat)scale;

/**
 *  屏幕宽高
 *
 *  @return sizePixies 屏幕宽高 (像素单位)
 */
+ (CGSize)sizePixies;

/**
 *  屏幕宽度
 *
 *  @return width 屏幕宽度
 */
+ (CGFloat)width;

/**
 *  屏幕高度
 *
 *  @return height 屏幕高度
 */
+ (CGFloat)height;

/**
 *  最小边与最大边屏幕比例
 *
 *  @return minScreenRatio 最小边与最大边屏幕比例
 */
+ (CGFloat)minScreenRatio;

/**
 *  最小视图高度
 *
 *  @return minViewHeight 最小视图高度 (去除状态栏，导航栏，Tab栏高度)
 */
+ (CGFloat)minViewHeight;

/**
 *  最小视图自动高度
 *
 *  @return minViewAutoHeight 最小视图自动高度 (小于IOS7时去除状态栏，导航栏，Tab栏高度高度，大于等于IOS7时为全屏高度)
 */
+ (CGFloat)minViewAutoHeight;

/**
 *  中等视图高度
 *
 *  @return midViewHeight 中等视图高度 (去除状态栏，导航栏高度)
 */
+ (CGFloat)midViewHeight;

/**
 *  中等视图自动高度
 *
 *  @return midViewAutoHeight 中等视图自动高度 (小于IOS7时去除状态栏，导航栏高度，大于等于IOS7时为全屏高度)
 */
+ (CGFloat)midViewAutoHeight;

/**
 *  排除状态栏高度
 *
 *  @return excludeStatusBarHeight 排除状态栏高度
 */
+ (CGFloat)excludeStatusBarHeight;

/**
 *  排除状态栏自动高度
 *
 *  @return excludeStatusBarAutoHeight 排除状态栏自动高度 (小于IOS7时去除状态栏高度，大于等于IOS7时为全屏高度)
 */
+ (CGFloat)excludeStatusBarAutoHeight;

/**
 *  全屏视图时Y坐标
 *
 *  @return topIfStatusBarLayout 全屏视图时Y坐标 (大于等于IOS7时返回状态栏高度, 否则返回0)
 */
+ (CGFloat)topIfStatusBarLayout;

/**
 *  全屏视图时Y坐标
 *
 *  @return topIfStatusNavgationBarLayout 全屏视图时Y坐标 (大于等于IOS7时返回状态栏和导航栏高度, 否则返回0)
 */
+ (CGFloat)topIfStatusNavgationBarLayout;

/**
 *  全屏视图时Y坐标
 *
 *  @return topIfNavgationBarLayout 全屏视图时Y坐标 (大于等于IOS7时返回导航栏高度, 否则返回0)
 */
+ (CGFloat)topIfNavgationBarLayout;

/**
 *  导航栏高度
 *
 *  @return navgationBarHeight 导航栏高度
 */
+ (CGFloat)navgationBarHeight;

/**
 *  是否为Retina屏幕
 *
 *  @return 是否为Retina屏幕
 */
+ (BOOL) hasRetinaDisplay;
@end

#ifndef TuSDKTSScreenExtend_Define
#define TuSDKTSScreenExtend_Define
/**
 *  屏幕宽度
 *
 *  @return 屏幕宽度
 */
#define lsqScreenWidth            [UIScreen width]

/**
 *  屏幕高度
 *
 *  @return 屏幕高度
 */
#define lsqScreenHeight           [UIScreen height]

/**
 *  最小视图高度 (去除状态栏，导航栏，Tab栏高度)
 */
#define lsqMinViewHeight          [UIScreen minViewHeight]

/**
 *  最小视图自动高度 (小于IOS7时去除状态栏，导航栏，Tab栏高度高度，大于等于IOS7时为全屏高度)
 */
#define lsqMinViewAutoHeight      [UIScreen minViewAutoHeight]

/**
 *  中等视图高度 (去除状态栏，导航栏高度)
 */
#define lsqMidViewHeight          [UIScreen midViewHeight]

/**
 *  中等视图自动高度 (小于IOS7时去除状态栏，导航栏高度，大于等于IOS7时为全屏高度)
 */
#define lsqMidViewAutoHeight      [UIScreen midViewAutoHeight]

/**
 *  排除状态栏高度
 */
#define lsqExcludeStatusBarHeight       [UIScreen excludeStatusBarHeight]

/**
 *  排除状态栏自动高度 (小于IOS7时去除状态栏高度，大于等于IOS7时为全屏高度)
 */
#define lsqExcludeStatusBarAutoHeight   [UIScreen excludeStatusBarAutoHeight]

/**
 *  全屏视图时Y坐标 (大于等于IOS7时返回状态栏高度, 否则返回0)
 */
#define lsqTopIfStatusBarLayout          [UIScreen topIfStatusBarLayout]
#endif
