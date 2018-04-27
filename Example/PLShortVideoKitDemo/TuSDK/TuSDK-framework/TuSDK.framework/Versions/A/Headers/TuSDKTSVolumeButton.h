//
//  TuSDKTSVolumeButton.h
//  TuSDK
//
//  Created by Yanlin on 6/13/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  音量事件回调
 *
 *  @param isVolumeUpPressed 音量 + 按钮按下
 */
typedef void (^TuSDKTSVolumeButtonBlock)(BOOL isVolumeUpPressed);

/**
 *  侦听系统音量按钮
 */
@interface TuSDKTSVolumeButton : NSObject

/**
 *  音量事件回调Block
 */
@property (nonatomic, copy) TuSDKTSVolumeButtonBlock volumeBlock;

/**
 *  开始侦听音量键
 */
- (void)startListenVolumeButtonEvents;

/**
 *  停止侦听音量键
 */
- (void)stopListenVolumeButtonEvents;

@end