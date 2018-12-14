//
//  ViewSlider.h
//  ControllerSlider
//
//  Created by bqlin on 2018/6/14.
//  Copyright © 2018年 bqlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewSliderDataSource, ViewSliderDelegate;

@interface ViewSlider : UIView

@property (nonatomic, weak) IBOutlet id<ViewSliderDataSource> dataSource;

@property (nonatomic, weak) IBOutlet id<ViewSliderDelegate> delegate;

/**
 当前视图
 */
@property (nonatomic, strong, readonly) UIView *currentView;

/**
 选中索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 引用手势滑动切换
 */
@property (nonatomic, assign) BOOL disableSlide;

@end

@protocol ViewSliderDataSource <NSObject>

- (NSInteger)numberOfViewsInSlider:(ViewSlider *)slider;

- (UIView *)viewSlider:(ViewSlider *)slider viewAtIndex:(NSInteger)index;

@end

@protocol ViewSliderDelegate <NSObject>

- (void)viewSlider:(ViewSlider *)slider switchingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

- (void)viewSlider:(ViewSlider *)slider didSwitchToIndex:(NSInteger)index;

- (void)viewSlider:(ViewSlider *)slider didSwitchBackIndex:(NSInteger)index;

@end

