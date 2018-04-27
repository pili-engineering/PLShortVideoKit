//
//  TuSDKPFEditWipeAndFilterControllerBase.h
//  TuSDK
//
//  Created by Yanlin on 12/3/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKICSmudgeImageViewWrap.h"
#import "TuSDKICFilterSmudgeImageViewWrap.h"

/**
 *  滤镜涂抹控制器基类
 */
@interface TuSDKPFEditWipeAndFilterControllerBase : TuSDKCPImageResultController <TuSDKICSmudgeImageViewDelegate>

/**
 *  涂抹画布
 */
@property (nonatomic, readonly) UIView<TuSDKICSmudgeImageViewInterface> *smudgeView;

/**
 *  显示放大镜 (默认: true)
 */
@property (nonatomic, assign) BOOL displayMagnifier;

/**
 *  笔刷效果强度 (默认: 0.2, 范围为0 ~ 1，值为1时强度最高)
 */
@property (nonatomic, assign) CGFloat brushStrength;

/**
 *  放大区域预览图
 */
@property (nonatomic, readonly) UIImageView *zoomInPreviewImage;

/**
 *  当前笔刷大小
 */
@property (nonatomic, assign) NSUInteger currentBrushSize;

/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAction;

/**
 *  撤销上一步
 */
- (void)onUndoAction;

/**
 *  重做上一步
 */
- (void)onRedoAction;

/**
 *  按下显示原图按钮
 */
- (void)onOriginalActionStart;

/**
 *  放开显示原图按钮
 */
- (void)onOriginalActionEnd;

/**
 *  刷新撤销 / 重做 数据
 *
 *  @param undoCount 可以撤销的次数
 *  @param redoCount 可以重做的次数
 */
- (void)onRefreshStepStatesWithHistories:(NSUInteger)undoCount redoCount:(NSUInteger)redoCount;

/**
 *  涂抹动作改变
 *
 *  @param point  偏向上的涂抹位置
 *  @param viewPoint  视图上的涂抹位置
 *  @param width  画布宽度
 *  @param height 画布高度
 */
- (void)onSmudgeActionChanged:(CGPoint)point viewLocation:(CGPoint)viewPoint canvasWidth:(CGFloat)width canvasHeight:(CGFloat)height;

/**
 *  涂抹动作结束
 */
- (void)onSmudgeActionEnd;
@end
