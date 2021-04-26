//
//  PLSMVMovieComposition.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/9/17.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSImageMovie.h"

@interface PLSMVMovieComposition : PLSImageMovie

@property (readwrite, retain) AVComposition *compositon;
@property (readwrite, retain) AVVideoComposition *videoComposition;
@property (assign, nonatomic) CGSize videoSize;

- (id)initWithComposition:(AVComposition*)compositon
      andVideoComposition:(AVVideoComposition*)videoComposition;

@end
