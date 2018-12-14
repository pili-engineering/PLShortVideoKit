//
//  TuSDKTSAudio.h
//  TuSDKVideo
//
//  Created by wen on 19/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "TuSDKTimeRange.h"

/**
 音频数据实体类
 */
@interface TuSDKTSAudio : NSObject

// 本地音频地址
@property (nonatomic, strong) NSURL *audioURL;
// asset
@property (nonatomic, strong) AVURLAsset *asset;
// 音轨
@property (nonatomic, strong) AVAssetTrack *audioTrack;
// 音频片段所在时间, 默认 整个音频的时间范围
@property (nonatomic,strong) TuSDKTimeRange *atTimeRange;

// 整个音频的时间范围
@property (nonatomic,strong) TuSDKTimeRange *audioTimeRange;

// 裁切
@property (nonatomic,strong) TuSDKTimeRange *catTimeRange;
// 音量设置
@property (nonatomic,assign) CGFloat audioVolume;


- (instancetype)initWithAudioURL:(NSURL *)audioURL;

- (instancetype)initWithAsset:(AVURLAsset *)asset;


// 删除改URL下的音乐文件
- (BOOL)clearAudioFile;



@end
