//
//  PLSAudioVolumeView.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/6/5.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLSAudioVolumeView;

@protocol PLSAudioVolumeViewDelegate <NSObject>

@optional
- (void)audioVolumeView:(PLSAudioVolumeView *)volumeView movieVolumeChangedTo:(CGFloat)movieVolume musicVolumeChangedTo:(CGFloat)musicVolume;
@end

@interface PLSAudioVolumeView : UIView

@property (weak, nonatomic) id<PLSAudioVolumeViewDelegate> delegate;

- (id)initWithMovieVolume:(CGFloat)currentMovieVolume musicVolume:(CGFloat)currentMusicVolume;

- (void)showAtView:(UIView *)view;

@end
