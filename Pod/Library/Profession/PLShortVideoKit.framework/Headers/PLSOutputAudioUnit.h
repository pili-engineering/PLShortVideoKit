//
//  PLSOutputAudioUnit.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/5/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class PLSOutputAudioUnit;

/*!
 @protocol PLSOutputAudioUnitDelegate
 @brief 音频采集协议
 */
@protocol PLSOutputAudioUnitDelegate <NSObject>

/*!
 @method outputAudioUnit:didGetAudioBuffer:audioTiameStamp:
 @brief 音频编码之前的回调.
 
 @param audioUnit 实例.
 @param ioData 音频数据.
 @param audioTimeStamp 音频帧对应的时间戳.
 */
- (void)outputAudioUnit:(PLSOutputAudioUnit *__nonnull)audioUnit
      didGetAudioBuffer:(AudioBufferList *__nonnull)ioData
        audioTiameStamp:(const AudioTimeStamp *__nonnull)audioTimeStamp;
@end

/*!
 @class PLSOutputAudioUnit
 @brief 音频采集，AudioUnit 实现
 */
@interface PLSOutputAudioUnit : NSObject

/*!
 @property delegate
 @brief 回调代理
 */
@property (nonatomic, weak) id<PLSOutputAudioUnitDelegate> delegate;

/*!
 @method initWithCaptureFormat:
 @brief 初始化方法
 
 @param captureAsbd 音频采集参数.
 
 @return 实例
 */
- (id)initWithCaptureFormat:(AudioStreamBasicDescription * __nonnull)captureAsbd;

/*!
 @method start
 @brief 开始采集
 */
- (void)start;

/*!
 @method stop
 @brief 停止 / 暂停采集
 */
- (void)stop;

@end
