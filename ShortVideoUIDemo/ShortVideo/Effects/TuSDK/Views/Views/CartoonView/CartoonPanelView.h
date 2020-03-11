//
//  CartoonPanelView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewProtocol.h"
#import "ParametersAdjustView.h"
#import "FilterPanelProtocol.h"

@protocol CartoonPanelDelegate;

@interface CartoonPanelView : UIView <OverlayViewProtocol>

/**
 触发者
 */
@property (nonatomic, weak) UIControl *sender;


@property (nonatomic, weak) id<CartoonPanelDelegate> delegate;

@end


/**
 滤镜面板回调代理
 */
@protocol CartoonPanelDelegate <NSObject>
@optional

/**
 漫画选中回调
 
 @param cartoonPanel 漫画视图
 @param code 漫画代号
 */
- (void)cartoonPanel:(CartoonPanelView *)cartoonPanel didSelectedCartoonCode:(NSString *)code;

@end
