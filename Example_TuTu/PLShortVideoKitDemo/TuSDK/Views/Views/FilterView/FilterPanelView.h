//
//  FilterListView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewProtocol.h"
#import "ParametersAdjustView.h"
#import "FilterPanelProtocol.h"

@interface FilterPanelView : UIView <OverlayViewProtocol, FilterPanelProtocol>

/**
 触发者
 */
@property (nonatomic, weak) UIControl *sender;

/**
 滤镜代号
 */
@property (nonatomic, copy) NSArray<NSString *> *codes;

/**
 选中的滤镜代号
 */
@property (nonatomic, copy) NSString *selectedFilterCode;

@property (nonatomic, weak) id<FilterPanelDelegate> delegate;
@property (nonatomic, weak) id<CameraFilterPanelDataSource> dataSource;


@end
