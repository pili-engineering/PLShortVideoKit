//
//  PLSImageMovieComposition.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/9/27.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSImageMovie.h"

@interface PLSImageMovieComposition : PLSImageMovie

@property (readwrite, retain) AVComposition *compositon;
@property (readwrite, retain) AVVideoComposition *videoComposition;
@property (readwrite, retain) AVAudioMix *audioMix;
@property (assign, nonatomic) CGSize videoSize;

// add by hxiongan 2018-10-29
@property(nonatomic, assign) double sampleRate;
@property(nonatomic, assign) int outputChannel;
@property(nonatomic, assign) AudioChannelLayoutTag outputChannelLayout;

- (id)initWithComposition:(AVComposition*)compositon
      andVideoComposition:(AVVideoComposition*)videoComposition
              andAudioMix:(AVAudioMix*)audioMix;

@end
