//
//  QNMusicPickerView.h
//  QNShortVideoDemo
//
//  Created by hxiongan on 2018/8/29.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNMusicModel.h"

// 音乐选取类
@class QNMusicPickerView;
@protocol QNMusicPickerViewDelegate<NSObject>

@optional
- (void)musicViewCancelButtonClick:(QNMusicPickerView *)musicPickerView;
- (void)musicPickerView:(QNMusicPickerView *)musicPickerView didEndPickerWithMusic:(QNMusicModel *)model;

@end

@interface QNMusicPickerView : UIView

@property (nonatomic, weak) id<QNMusicPickerViewDelegate> delegate;
@property (nonatomic, assign) CGFloat minMusicSelectDuration;// default 2.0s
@property (nonatomic, readonly) CGFloat minViewHeight;
@property (nonatomic, readonly) UILabel *titleLabel;


// isNeedNullModel 为 YES 的时候，会提供一个 "无音乐" cell
- (instancetype)initWithFrame:(CGRect)frame needNullModel:(BOOL)isNeedNullModel;

- (void)startAudioPlay;

- (void)stopAudioPlay;

@end
