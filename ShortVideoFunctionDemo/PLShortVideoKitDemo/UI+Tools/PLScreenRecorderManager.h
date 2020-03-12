//
//  PLScreenRecorderManager.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2019/3/28.
//  Copyright © 2019年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PLScreenRecorderManager;

@protocol PLScreenRecorderManagerDelegate <NSObject>

@optional
- (void)screenRecorderManager:(PLScreenRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration;
- (void)screenRecorderManager:(PLScreenRecorderManager *)manager errorOccur:(NSError *)error;
@end

@interface PLScreenRecorderManager : NSObject

@property (weak, nonatomic) id<PLScreenRecorderManagerDelegate> delegate;

- (void)startRecording;

- (void)stopRecording;

- (void)cancelRecording;

@end

NS_ASSUME_NONNULL_END
