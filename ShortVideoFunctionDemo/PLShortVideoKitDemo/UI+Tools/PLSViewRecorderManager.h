//
//  PLSViewRecorderManager.h
//  PLShortVideoKitDemo
//
//  Created by lawder on 2017/7/13.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PLSViewRecorderManager;

@protocol PLSViewRecorderManagerDelegate <NSObject>

@optional
- (void)viewRecorderManager:(PLSViewRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration;
@end

@interface PLSViewRecorderManager : NSObject

@property (weak, nonatomic) id<PLSViewRecorderManagerDelegate> delegate;

- (instancetype)initWithRecordedView:(UIView *)recordedView;

- (void)startRecording;

- (void)stopRecording;

- (void)cancelRecording;

@end
