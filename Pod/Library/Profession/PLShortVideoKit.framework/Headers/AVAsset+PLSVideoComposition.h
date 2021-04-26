//
//  AVAsset+PLSVideoComposition.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/7/10.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (PLSVideoComposition)

- (AVVideoComposition *)fixVideoOrientation;

@end
