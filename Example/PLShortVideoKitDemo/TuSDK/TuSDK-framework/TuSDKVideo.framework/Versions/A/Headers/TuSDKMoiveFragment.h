//
//  TuSDKMoive.h
//  TuSDKVideo
//
//  Created by gh.li on 2017/3/31.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <UIKit/UIKit.h>

#import "TuSDKTimeRange.h"

@interface TuSDKMoiveFragment : NSObject

-(instancetype)initWithMoviePath:(NSString *)path atTimeRange:(TuSDKTimeRange *) timeRange;

// 视频文件地址
@property (nonatomic,copy) NSString *moviePath;
// 视频Asset 优先使用Asset
@property (nonatomic,strong) AVURLAsset *movieAsset;
// 视频片段所在时间
@property (nonatomic,strong) TuSDKTimeRange *atTimeRange;

- (BOOL) clearMovieFile;

- (AVCaptureVideoOrientation) movieOrientation;

@end
