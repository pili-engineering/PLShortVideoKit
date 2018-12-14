//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Recorder : easyar_RefBase

+ (easyar_Recorder *) create;
- (void)setOutputFile:(NSString *)path;
- (void)setInputTexture:(void *)texPtr width:(int)width height:(int)height;
- (void)requestPermissions:(void (^)(easyar_PermissionStatus status, NSString * value))permissionCallback;
- (bool)open:(void (^)(easyar_RecordStatus status, NSString * value))statusCallback;
- (void)start;
- (void)updateFrame;
- (void)stop;
- (void)close;
- (bool)setProfile:(easyar_RecordProfile)profile;
- (void)setVideoSize:(easyar_RecordVideoSize)framesize;
- (void)setVideoBitrate:(int)bitrate;
- (void)setChannelCount:(int)count;
- (void)setAudioSampleRate:(int)samplerate;
- (void)setAudioBitrate:(int)bitrate;
- (void)setVideoOrientation:(easyar_RecordVideoOrientation)mode;
- (void)setZoomMode:(easyar_RecordZoomMode)mode;

@end
