//
//  PLSPlayerView.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/2.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

@interface PLSPlayerView : UIView
@property AVPlayer *player;
@property (readonly) AVPlayerLayer *playerLayer;
@end
