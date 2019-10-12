//
//  PLSStickerOverlayView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/8/19.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSStickerView.h"

@class PLSStickerOverlayView;

@protocol PLSStickerOverlayViewDelegate <NSObject>

/**
 点击当前贴图的关闭按钮回调

 @param stickerOverlayView PLSStickerOverlayView 实例
 @param stickerView 被点击的贴图
 */
- (void)stickerOverlayView:(PLSStickerOverlayView *_Nonnull)stickerOverlayView didClickClose:(PLSStickerView *_Nonnull)stickerView;

/**
 当前贴图被移除后的回调

 @param stickerOverlayView PLSStickerOverlayView 实例
 @param sticker 被移除的贴图
 @param currentSticker 被移除贴图的前一个贴图
 */
- (void)stickerOverlayView:(PLSStickerOverlayView *_Nonnull)stickerOverlayView didRemovedSticker:(PLSStickerView *_Nonnull)sticker currentSticker:(PLSStickerView *_Nullable)currentSticker;

/**
 已加载的某贴图被点击选中的回调

 @param stickerOverlayView PLSStickerOverlayView 实例
 @param sticker 被点击的贴图
 @param tap 点击手势本身
 */
- (void)stickerOverlayView:(PLSStickerOverlayView *_Nonnull)stickerOverlayView didTapSticker:(PLSStickerView *_Nonnull)sticker tap:(UITapGestureRecognizer*_Nonnull)tap;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 * 贴纸的位置
 */
typedef NS_ENUM(NSInteger, PositionMode){
    PositionMode_All_Center,     // 垂直居中 + 水平居中
    PositionMode_Ver_Center,     // 垂直居中
    PositionMode_Hor_Center,     // 水平居中
    PositionMode_Top,            // 顶部
    PositionMode_Bottom,         // 底部
    PositionMode_Left,           // 左边
    PositionMode_Right,          // 右边
};


@interface PLSStickerOverlayView : UIView

@property (nonatomic, assign) id<PLSStickerOverlayViewDelegate>delegate;
@property (nonatomic, assign) PositionMode positionMode; // 操作当前 sticker 的位置模式
@property (nonatomic, strong, readonly) UIView *layoutView;
@property (nonatomic, strong) PLSStickerView *currentSticker;
@property (nonatomic, strong, readonly) NSArray *stickersArray;

/**
 PLSStickerOverlayView 初始化方法

 @param frame 位置
 @param layoutView 需要显示的父视图
 @return PLSStickerOverlayView 实例
 */
- (instancetype)initWithFrame:(CGRect)frame layoutView:(UIView *)layoutView;

/**
 添加贴图

 @param sticker 需要添加的贴图
 @param positionMode 添加后显示的位置
 */
- (void)addSticker:(PLSStickerView *)sticker positionMode:(PositionMode)positionMode;

/**
 取消当前的贴图，执行后将触发回调 - (void)stickerOverlayView:(PLSStickerOverlayView *_Nonnull)stickerOverlayView didRemovedSticker:(PLSStickerView *_Nonnull)sticker currentSticker:(PLSStickerView *_Nullable)currentSticker;
 */
- (void)cancelCurrentSticker;

/**
 移除当前 overlayView 上所有的贴图
 */
- (void)clearAllStickers;

@end

NS_ASSUME_NONNULL_END
