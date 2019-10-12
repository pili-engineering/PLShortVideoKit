//
//  PLScreenRecorderManager.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2019/3/28.
//  Copyright © 2019年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLScreenRecorderManager.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#include <mach/mach_time.h>
#import <ReplayKit/ReplayKit.h>

@interface PLScreenRecorderManager ()<PLShortVideoRecorderDelegate, RPScreenRecorderDelegate>

@property (nonatomic, strong) PLShortVideoRecorder *shortVideoRecorder;
@property (nonatomic, weak) RPScreenRecorder *screenRecorder;

@end


@implementation PLScreenRecorderManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupShortRecorder];
        [self setupScreenRecorder];
    }
    return self;
}

- (void)setupShortRecorder {
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    videoConfiguration.videoFrameRate = 60;
    videoConfiguration.videoSize = CGSizeMake(720, 1280);
    videoConfiguration.averageVideoBitRate = 3500 * 1000;
    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    self.shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration captureEnabled:NO];
    self.shortVideoRecorder.maxDuration = 120;
    self.shortVideoRecorder.delegate = self;
    self.shortVideoRecorder.backgroundMonitorEnable = NO;
}

- (void)setupScreenRecorder {
    self.screenRecorder = [RPScreenRecorder sharedRecorder];
    self.screenRecorder.microphoneEnabled = YES;
}

- (void)startRecording {
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        
        [weakSelf.screenRecorder startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
            if (RPSampleBufferTypeVideo == bufferType) {
                [weakSelf.shortVideoRecorder writePixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer) timeStamp:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            } else if (RPSampleBufferTypeAudioMic == bufferType){
                [weakSelf.shortVideoRecorder writeSampleBuffer:sampleBuffer];
            }
        } completionHandler:^(NSError * _Nullable error) {
            if (error) {
                if ([NSThread isMainThread]) {
                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
                    [weakSelf.shortVideoRecorder deleteAllFiles];
                    [weakSelf.shortVideoRecorder startRecording];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakSelf.delegate respondsToSelector:@selector(screenRecorderManager:errorOccur:)]) {
                            [weakSelf.delegate screenRecorderManager:weakSelf errorOccur:error];
                        }
                        [weakSelf cancelRecording];
                    });
                }
            } else {
//                dispatch_sync(dispatch_get_main_queue(), ^{
                    // 注意： [shortVideoRecorder startRecording] 需要再主线程中执行，不然拍的时长会不正确
                if ([NSThread isMainThread]) {
                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
                    [weakSelf.shortVideoRecorder deleteAllFiles];
                    [weakSelf.shortVideoRecorder startRecording];
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
                        [weakSelf.shortVideoRecorder deleteAllFiles];
                        [weakSelf.shortVideoRecorder startRecording];
                    });
                }
                   
//
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)stopRecording {
    if (@available(iOS 11.0, *)) {
        [self.screenRecorder stopCaptureWithHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"screenRecorder stop error: %@", error);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    [self.shortVideoRecorder stopRecording];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)cancelRecording {
    if (@available(iOS 11.0, *)) {
        [self.screenRecorder stopCaptureWithHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"screenRecorder stop error: %@", error);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    NSLog(@"cancel");
    [self.shortVideoRecorder cancelRecording];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidEnterBackground:(id)sender {
    [self stopRecording];
}

- (void)dealloc {
    [self cancelRecording];
    NSLog(@"dealloc: %@", self.description);
}

#pragma mark - Recorder Delegate

// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    AVAsset *asset = self.shortVideoRecorder.assetRepresentingAllFiles;
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenRecorderManager:didFinishRecordingToAsset:totalDuration:)]) {
        [self.delegate screenRecorderManager:self didFinishRecordingToAsset:asset totalDuration:totalDuration];
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);
    if (@available(iOS 11.0, *)) {
        [self.screenRecorder stopCaptureWithHandler:^(NSError * _Nullable error) {}];
    } else {
        // Fallback on earlier versions
    }
    AVAsset *asset = self.shortVideoRecorder.assetRepresentingAllFiles;
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenRecorderManager:didFinishRecordingToAsset:totalDuration:)]) {
        [self.delegate screenRecorderManager:self didFinishRecordingToAsset:asset totalDuration:maxDuration];
    }
}

@end

