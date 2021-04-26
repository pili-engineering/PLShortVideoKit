//
//  GPUImageMovieComposition.h
//  Givit
//
//  Created by Sean Meiners on 2013/01/25.
//
//

#import "PLSGPUImageMovie.h"

@interface PLSGPUImageMovieComposition : PLSGPUImageMovie

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
