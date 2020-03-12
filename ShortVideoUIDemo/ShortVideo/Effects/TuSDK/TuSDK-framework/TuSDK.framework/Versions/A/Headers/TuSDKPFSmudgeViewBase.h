//
//  TuSDKPFSmudgeViewBase.h
//  TuSDK
//
//  Created by Yanlin on 12/2/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKICSmudgeImageViewWrap.h"

@interface TuSDKPFSmudgeViewBase : UIView

/**
 *  涂抹视图
 */
@property (nonatomic, readonly) UIView<TuSDKICSmudgeImageViewInterface> *smudgeWrap;

/**
 *  涂抹视图
 */
@property (nonatomic, readonly) UIView *sizeAnimView;

/**
 *  播放尺寸变化动画
 *
 *  @param scale    原缩放率
 *  @param newScale 新缩放率
 */
- (void)showBrushSizeAnim:(CGFloat)scale to:(CGFloat)newScale;

/**
 *  显示涂抹跟随光标
 *
 *  @param point 坐标点
 */
- (void)showBrushSizeCursor:(CGPoint)point;

/**
 *  隐藏涂抹跟随光标
 */
- (void)hideBrushSizeCursor;

@end
