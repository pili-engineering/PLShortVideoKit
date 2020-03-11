//
//  CameraBeautyPanelView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewProtocol.h"
#import "FilterPanelProtocol.h"

@interface CameraBeautyPanelView : UIView <OverlayViewProtocol, FilterPanelProtocol>

/// 触发者
@property (nonatomic, weak) UIControl *sender;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, weak) id<FilterPanelDelegate> delegate;
@property (nonatomic, weak) id<CameraFilterPanelDataSource> dataSource;

@end
