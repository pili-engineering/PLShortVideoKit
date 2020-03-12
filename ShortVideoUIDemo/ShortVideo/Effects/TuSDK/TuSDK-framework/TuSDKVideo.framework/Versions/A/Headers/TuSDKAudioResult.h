//
//  TuSDKAudioResult.h
//  TuSDKVideo
//
//  Created by wen on 27/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"


/**
 *  音频结果
 */
@interface TuSDKAudioResult : NSObject

/**
 *  临时音频文件路径
 */
@property (nonatomic, copy) NSString *audioPath;

/**
 *  音频时长
 */
@property (nonatomic, assign) CGFloat duration;

/**
 *  SDK处理结果
 *
 *  @return SDK处理结果
 */
+ (instancetype)result;

@end
