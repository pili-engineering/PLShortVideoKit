//
//  TuSDKPFEditSmudgeControllerBase.h
//  TuSDK
//
//  Created by Yanlin on 10/27/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKPFBrushManager.h"
#import "TuSDKICSmudgeImageViewWrap.h"

#pragma mark - TuSDKPFEditBrushControllerBase
/**
 *  涂抹编辑控制器基础类
 */
@interface TuSDKPFEditSmudgeControllerBase : TuSDKCPImageResultController <TuSDKICSmudgeImageViewDelegate>

/**
 *  当前所使用的笔刷
 */
@property (nonatomic, retain) TuSDKPFBrush *brush;

/**
 *  涂抹画布
 */
@property (nonatomic, readonly) UIView<TuSDKICSmudgeImageViewInterface> *smudgeView;

/**
 *  选中一个笔刷
 *
 *  @param code         笔刷代号
 *
 *  @return 是否成功切换
 */
- (BOOL)selectBrushCode:(NSString *)code;

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
