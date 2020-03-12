//
//  TuSDKICEmptyView.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/6.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  空数据视图
 */
@interface TuSDKICEmptyView : UIView
{
    /**
     *  图标视图
     */
    UIImageView *_iconView;
    /**
     *  标题视图
     */
    UILabel *_titleView;
}

/**
 *  图标视图
 */
@property (nonatomic, readonly) UIImageView *iconView;
/**
 *  标题视图
 */
@property (nonatomic, readonly) UILabel *titleView;
/**
 *  初始化视图
 */
- (void)lsqInitView;

/**
 *  重置位置大小
 *
 *  @param frame 重置位置大小
 */
- (void)resetFrame:(CGRect)frame;
@end