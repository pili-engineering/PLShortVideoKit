//
//  TuSDKPaintDrawViewWrap.h
//  TuSDK
//
//  Created by tutu on 2019/5/27.
//  Copyright © 2019 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TuSDKPFPaintBezierPath.h"
#import "TuSDKPFBrush.h"


/**
 *  涂鸦绘制视图的通用属性
 *  @since v3.1.0
 */

@protocol TuSDKCPPaintDrawViewInterface <NSObject>


/**
 设置笔刷对象
 @since v3.1.0
 @param color 笔刷对象
 */
- (void)setPaintColor:(NSString *)color;


/**
 设置笔刷粗细级别
 
 @since v3.1.0
 @param mBrushSize 粗细级别
 */
- (void)setPaintSize:(lsqBrushSize)mBrushSize;


/**
 笔刷缩放， 1 < brushSize <= 3
 
 @since v3.1.0
 @param mScaleBrushSize 缩放大小
 */
- (void)setPaintScaleBrushSize:(CGFloat)mScaleBrushSize;


/**
 两点间的最小距离， 0 < brushSize < 20 默认10
 
 @since v3.1.0
 @param minDistance 最小距离
 */
- (void)setPaintMinDistance:(CGFloat)minDistance;


/**
 撤销上一步
 @since v3.1.0
 */
- (void)undo;


/**
 重做上一步
 @since v3.1.0
 */
- (void)redo;


/**
 是否可以撤销上一步
 @since v3.1.0
 @return YES 可以撤销上一步
 */
- (BOOL)canUndo;


/**
 是否可以重做上一步
 @since v3.1.0
 @return YES 可以重做
 */
- (BOOL)canRedo;

/**
 *  合成最终效果图
 *  @since v3.1.0
 *  @param source 原图
 */
- (UIImage *)getCanvasImage:(UIImage *)source;
@end



/**
 *  涂鸦绘制视图代理
 *  @since v3.1.0
 */
@protocol TuSDKCPPaintDrawViewDelegate <NSObject>

@optional
/**
 *  涂抹动作结束
 *  @since v3.1.0
 */
- (void)onPaintDrawEnd;
@end



/**
 *  涂鸦绘制视图
 *  @since v3.1.0
 */
@interface TuSDKPaintDrawViewBase : UIView <TuSDKCPPaintDrawViewInterface>

@property (nonatomic, weak) id<TuSDKCPPaintDrawViewDelegate> delegate;

/**
 *  默认撤销的最大次数 (默认: 5)
 *  @since v3.1.0
 */
@property (nonatomic, assign) NSUInteger maxUndoCount;



/**
 *  单元格宽度 50
 *  @since v3.1.0
 */
@property (nonatomic) NSUInteger brushBarCellWidth;

/**
 *  单元格高度: 默认80
 *  @since v3.1.0
 */
@property (nonatomic) NSUInteger brushBarHeight;

/**
 *  显示的图片
 *  @since v3.1.0
 */
- (void)setImage:(UIImage *)image;


/**
 是否显示原图
 @since v3.1.0
 @param isShow yes ---展示原图，no---展示涂鸦后的图片
 */
- (void)showOriginImage:(BOOL)isShow;

/**
 *  更新布局
 *  @since v3.1.0
 */
- (void)needUpdateLayout;

/**
 *  清理内存
 *  @since v3.1.0
 */
- (void)destroy;
@end




/**
 真正的涂鸦视图
 @since v3.1.0
 */
@interface TuSDKCPPaintDrawDisplayView : UIView <TuSDKCPPaintDrawViewInterface>


/**
 涂鸦回调代理
 @since v3.1.0
 */
@property (nonatomic, weak) id<TuSDKCPPaintDrawViewDelegate> delegate;

/**
 *  默认撤销的最大次数 (默认: 5)
 *  @since v3.1.0
 */
@property (nonatomic, assign) NSUInteger maxUndoCount;

/**
 笔刷缩放
 @since v3.1.0
 */
@property (nonatomic, assign) CGFloat mBrushScaleSize;

/**
 * 笔刷绘制时，上一点与下一点的距离最小满足多大时，才进行绘制
 * 默认 10，范围（0-20）过小时绘制慢时会有锯齿，过大时，绘制就会出现断层
 * @since v3.1.0
 */
@property (nonatomic, assign) CGFloat minDistance;

@end

