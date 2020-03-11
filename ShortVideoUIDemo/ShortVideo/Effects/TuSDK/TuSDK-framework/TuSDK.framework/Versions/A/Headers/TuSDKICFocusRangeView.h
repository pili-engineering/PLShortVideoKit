//
//  TuSDKICFocusRangeView.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/5.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKTSAVAudioPlayer+Extend.h"

/**
 *  相机聚焦选取视图委托
 */
@protocol TuSDKICFocusRangeViewProtocol <NSObject>
/**
 *  选中一个点
 *
 *  @param range 选取范围坐标
 */
- (void)onTuSDKICFocusRange:(CGRect)range;
@end

/**
 *  相机聚焦选取视图
 */
@interface TuSDKICFocusRangeView : UIView<TuSDKICFocusRangeViewProtocol>{
    // 动画选区视图
    UIView *_animaRangeView;
    // 最大选区视图 (style_default_camera_focus)
    UIImageView *_maxRangeView;
    // 结束选区视图 (style_default_camera_focus_ok)
    UIImageView *_endRangeView;
    // 光标 上
    UIView *_topCursor;
    // 光标 右
    UIView *_rightCursor;
    // 光标 下
    UIView *_bottomCursor;
    // 光标 左
    UIView *_leftCursor;
    // 音频播放对象
    AVAudioPlayer *_audioPlayer;
}
/**
 *  动画选区视图
 */
@property (nonatomic, readonly) UIView *animaRangeView;

/**
 *  最大选区视图 (style_default_camera_focus)
 */
@property (nonatomic, readonly) UIImageView *maxRangeView;

/**
 *  结束选区视图 (style_default_camera_focus_ok)
 */
@property (nonatomic, readonly) UIImageView *endRangeView;

/**
 *  光标 上
 */
@property (nonatomic, readonly) UIView *topCursor;

/**
 *  光标 右
 */
@property (nonatomic, readonly) UIView *rightCursor;

/**
 *  光标 下
 */
@property (nonatomic, readonly) UIView *bottomCursor;

/**
 *  光标 左
 */
@property (nonatomic, readonly) UIView *leftCursor;

/**
 *  光标样色 (默认: [UIColor whiteColor])
 */
@property (nonatomic, retain) UIColor *cursorColor;

/**
 *  音频播放对象
 */
@property (nonatomic, readonly) AVAudioPlayer *audioPlayer;

/**
 *  设置动画开始视图状态
 */
- (void)setStartAnimaViewStatus;

/**
 *  设置动画结束视图状态
 */
- (void)setEndAnimaViewStatus;
@end
