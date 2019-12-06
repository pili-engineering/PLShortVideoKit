//
//  TuSDKCPSubtitlesView.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/19.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  滤镜字幕视图接口
 */
@protocol TuSDKCPSubtitlesViewInterface <NSObject>
/**
 *  设置标题
 *
 *  @param title    主标题
 *  @param subTitle 子标题
 */
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end

/**
 *  滤镜字幕视图
 */
@interface TuSDKCPSubtitlesView : UIView<TuSDKCPSubtitlesViewInterface>{
    // 主标题视图
    UILabel *_titleView;
    // 子标题视图
    UILabel *_subTitleView;
}
/**
 *  主标题视图
 */
@property (nonatomic, readonly) UILabel *titleView;

/**
 *  子标题视图
 */
@property (nonatomic, readonly) UILabel *subTitleView;
@end
