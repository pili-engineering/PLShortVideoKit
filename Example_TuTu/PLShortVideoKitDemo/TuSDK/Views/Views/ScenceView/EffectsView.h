//
//  EffectsView.h
//  TuSDKVideoDemo
//
//  Created by wen on 13/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectsDisplayView.h"

@class EffectsView;

// 特效栏事件代理
@protocol EffectsViewEventDelegate <NSObject>

/**
 选中了一个特效 触发编辑

 @param effectsView 特效视图
 @param effectCode 特效代号
 */
- (void)effectsView:(EffectsView *)effectsView didSelectMediaEffectCode:(NSString *)effectCode;

/**
 结束选中的特效
 */
- (void)effectsView:(EffectsView *)effectsView didDeSelectMediaEffectCode:(NSString *)effectCode;

@end


@interface EffectsView : UIView

// 滤镜事件的代理
@property (nonatomic, weak) id<EffectsViewEventDelegate> effectEventDelegate;
// 视频处理的当前位置 0~1
@property (nonatomic, assign) CGFloat progress;
// effectCode
@property (nonatomic, strong) NSArray<NSString *> * effectsCode;

// 时间条展示view
@property (nonatomic, strong) EffectsDisplayView *displayView;


@end


