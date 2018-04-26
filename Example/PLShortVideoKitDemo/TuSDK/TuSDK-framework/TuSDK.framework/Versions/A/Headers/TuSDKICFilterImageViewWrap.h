//
//  TuSDKICFilterImageViewWrap.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/7.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKFilterWrap.h"
#import "TuSDKGPUSmartView.h"
#import "TuSDKICGPUImageView.h"

#pragma mark - TuSDKICFilterImageViewInterface
/**
 *  Filter Image View Interface
 */
@protocol TuSDKICFilterImageViewInterface <NSObject>
/**
 *  开启触摸时显示原图效果
 */
@property (nonatomic) BOOL enableTouchCleanFilter;

/**
 *  显示的图片
 */
- (void)setImage:(UIImage *)image;

/**
 *  滤镜包装
 */
- (void)setFilterWrap:(TuSDKFilterWrap *)filterWrap;

/**
 *  请求渲染图片
 */
- (void)requestRender;

/**
 *  更新布局
 */
- (void)needUpdateLayout;
@end

#pragma mark - TuSDKICFilterImageViewWrap
/**
 *  滤镜显示视图包装
 */
@interface TuSDKICFilterImageViewWrap : UIView<TuSDKICFilterImageViewInterface>

@end

#pragma mark - TuSDKICFilterVideoViewWrap
/**
 *  滤镜视频显示视图包装
 */
@interface TuSDKICFilterVideoViewWrap : UIView
/**
 *  GPU智能视图
 */
@property (nonatomic, readonly) TuSDKGPUSmartView *view;
@end

#pragma mark - TuSDKICFilterMovieViewWrap
/**
 *  视频显示视图包装
 */
@interface TuSDKICFilterMovieViewWrap : UIView
/**
 *  GPU视图
 */
@property (nonatomic, readonly) TuSDKICGPUImageView *view;

/**
 *  裁剪区域范围，均以比例表示：{{offsetX/allWidth,offsetY/allHeight}，{sizeWidth/allWidth,sizeHeight/allHeight}}
 */
@property (nonatomic, assign) CGRect cropRect;
@end
