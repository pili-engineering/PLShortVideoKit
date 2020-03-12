//
//  PLSClipAudioView.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/6/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@class PLSClipAudioView;

@protocol PLSClipAudioViewDelegate <NSObject>

@optional
- (void)clipAudioView:(PLSClipAudioView *)clipAudioView musicTimeRangeChangedTo:(CMTimeRange)musicTimeRange;
@end

@interface PLSClipAudioView : UIView

@property (weak, nonatomic) id<PLSClipAudioViewDelegate> delegate;

- (id)initWithMuiscURL:(NSURL *)url timeRange:(CMTimeRange)currentMusicTimeRange;

- (void)showAtView:(UIView *)view;

@end
