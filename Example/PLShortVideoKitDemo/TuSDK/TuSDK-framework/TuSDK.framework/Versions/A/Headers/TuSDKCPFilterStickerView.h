//
//  TuSDKCPFilterStickerView.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKICFilterImageViewWrap.h"
#import "TuSDKICMaskRegionView.h"
#import "TuSDKPFStickerView.h"


/**
 *  滤镜贴纸合并视图接口
 */
@protocol TuSDKCPFilterStickerViewInterface <NSObject>
/**
 *  区域视图
 */
@property (nonatomic, readonly) TuSDKICMaskRegionView *cutRegionView;

/**
 *  贴纸视图
 */
@property (nonatomic, readonly) TuSDKPFStickerView *stickerView;

/**
 *  滤镜视图
 */
@property (nonatomic, readonly) UIView<TuSDKICFilterImageViewInterface> *filterView;

/**
 *  更新布局
 */
- (void)needUpdateLayout;

/**
 *  设置图片
 *
 *  @param image 图片
 */
- (void)setImage:(UIImage *)image;

/**
 *  设置滤镜对象
 *
 *  @param filterWrap 滤镜对象
 */
- (void)setFilterWrap:(TuSDKFilterWrap *)filterWrap;

/**
 *  获取贴纸处理结果
 *
 *  @return stickerResults 贴纸处理结果
 */
- (NSArray *)stickerResults;
@end

/**
 *  滤镜贴纸合并视图
 */
@interface TuSDKCPFilterStickerView : UIView<TuSDKCPFilterStickerViewInterface>
{
    // 裁剪区域视图
    TuSDKICMaskRegionView *_cutRegionView;
    // 贴纸视图
    TuSDKPFStickerView *_stickerView;
    // 滤镜视图
    UIView<TuSDKICFilterImageViewInterface> *_filterView;
}

/**
 *  区域视图
 */
@property (nonatomic, readonly) TuSDKICMaskRegionView *cutRegionView;

/**
 *  贴纸视图
 */
@property (nonatomic, readonly) TuSDKPFStickerView *stickerView;

/**
 *  滤镜视图
 */
@property (nonatomic, readonly) UIView<TuSDKICFilterImageViewInterface> *filterView;
@end
