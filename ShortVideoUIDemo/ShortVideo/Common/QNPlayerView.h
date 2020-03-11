//
//  QNPlayerView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/5/6.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface QNPlayerView : UIView

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

@end

NS_ASSUME_NONNULL_END
