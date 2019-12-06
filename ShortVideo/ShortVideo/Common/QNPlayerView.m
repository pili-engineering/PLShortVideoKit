//
//  QNPlayerView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/5/6.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNPlayerView.h"

@implementation QNPlayerView

- (AVPlayer *)player {
    return self.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player {
    self.playerLayer.player = player;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end
