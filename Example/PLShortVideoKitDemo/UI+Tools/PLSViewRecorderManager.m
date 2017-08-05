//
//  ViewRecorderManager.m
//  PLShortVideoKitDemo
//
//  Created by lawder on 2017/7/13.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSViewRecorderManager.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#include <mach/mach_time.h>

static const NSInteger kPLSVideoFrameRate = 20;

@interface PLSViewRecorderManager ()<PLShortVideoRecorderDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) UIView *recordedView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) PLShortVideoRecorder *recorder;
@property (nonatomic, assign) BOOL isMicrophoneRunning;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) dispatch_queue_t       audioQueue;
@property (nonatomic, strong) AVCaptureSession *captureSession;


@end


static uint64_t getUptimeInNanosecondWithMachTime(uint64_t machTime) {
    static mach_timebase_info_data_t s_timebase_info = {0};
    
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
    
    return (uint64_t)((machTime * s_timebase_info.numer) / s_timebase_info.denom);
}


@implementation PLSViewRecorderManager

- (instancetype)initWithRecordedView:(UIView *)recordedView {
    self = [super init];
    if (self) {
        _recordedView = recordedView;
        [self setupRecorder];
        [self initMicrophoneSource];
    }
    
    return self;
}

- (void)setupRecorder {
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    videoConfiguration.videoFrameRate = kPLSVideoFrameRate;
    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    self.recorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration captureEnabled:NO];
    self.recorder.maxDuration = 120;
    self.recorder.delegate = self;
}

- (void)startRecording {
    [self.recorder deleteAllFiles];
    [self.recorder startRecording];
    [self startRecordTimer];
    [self openMicrophone];
}

- (void)stopRecording {
    [self.recorder stopRecording];
    [self stopRecordTimer];
    [self closeMicrophone];
}

- (void)cancelRecording {
    [self.recorder cancelRecording];
    [self stopRecordTimer];
    [self closeMicrophone];
}

- (void)dealloc {
    [self cancelRecording];
}

#pragma mark -- AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    [self.recorder writeSampleBuffer:sampleBuffer];
}


- (void)initMicrophoneSource {
    self.audioQueue = dispatch_queue_create("audioQueue", DISPATCH_QUEUE_SERIAL);
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    self.audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    
    if ([self.captureSession canAddInput:_audioDeviceInput]) {
        [self.captureSession addInput:_audioDeviceInput];
    }

    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioDataOutput setSampleBufferDelegate:self queue:self.audioQueue];
    
    if ([self.captureSession canAddOutput:self.audioDataOutput]) {
        [self.captureSession addOutput:self.audioDataOutput];
    }
    
    self.audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
}

- (void)openMicrophone {
    if (self.isMicrophoneRunning) {
        return;
    }
    dispatch_async(self.audioQueue, ^{
        [self.captureSession startRunning];
        self.isMicrophoneRunning = YES;
    });
}

- (void)closeMicrophone {
    if (!self.isMicrophoneRunning) {
        return;
    }
    dispatch_sync(self.audioQueue, ^{
        [self.captureSession stopRunning];
        self.isMicrophoneRunning = NO;
    });
}

#pragma mark - Timer

- (void)startRecordTimer {
    // 创建GCD定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 / kPLSVideoFrameRate * NSEC_PER_SEC, 0);
    
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        uint64_t hostTime = getUptimeInNanosecondWithMachTime(mach_absolute_time());
        CVPixelBufferRef pixelBuffer = [self createCVPixelBufferWithView:self.recordedView];
        [self.recorder writePixelBuffer:pixelBuffer timeStamp:CMTimeMake(hostTime, 1e9)];
        CVBufferRelease(pixelBuffer);
    });
    
    dispatch_resume(_timer);
}

- (void)stopRecordTimer {
    dispatch_source_cancel(_timer);
}

#pragma mark - Recorder Delegate

// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    AVAsset *asset = self.recorder.assetRepresentingAllFiles;
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewRecorderManager:didFinishRecordingToAsset:totalDuration:)]) {
        [self.delegate viewRecorderManager:self didFinishRecordingToAsset:asset totalDuration:totalDuration];
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);
    
    AVAsset *asset = self.recorder.assetRepresentingAllFiles;
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewRecorderManager:didFinishRecordingToAsset:totalDuration:)]) {
        [self.delegate viewRecorderManager:self didFinishRecordingToAsset:asset totalDuration:maxDuration];
    }
}

#pragma mark - others

- (CVPixelBufferRef)createCVPixelBufferWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             @{}, kCVPixelBufferIOSurfacePropertiesKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth([image CGImage]);
    CGFloat frameHeight = CGImageGetHeight([image CGImage]);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       [image CGImage]);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end
