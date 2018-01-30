//
//  TuSDKTSAVAudioPlayer+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/5.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
/**
 *  音频设备扩展
 */
@interface AVAudioPlayer(TuSDKTSAVAudioPlayerExtend)
/**
 *  播放音频文件
 *
 *  @param path 音频文件路径
 *
 *  @return 音频播放对象
 */
+ (instancetype)lsqPlayerWithFilePath:(NSString *)path;
@end
