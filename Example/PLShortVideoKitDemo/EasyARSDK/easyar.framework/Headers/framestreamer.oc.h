//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_FrameStreamer : easyar_RefBase

- (easyar_Frame *)peek;
- (bool)start;
- (bool)stop;

@end

@interface easyar_CameraFrameStreamer : easyar_FrameStreamer

+ (easyar_CameraFrameStreamer *) create;
- (bool)attachCamera:(easyar_CameraDevice *)obj;
- (easyar_Frame *)peek;
- (bool)start;
- (bool)stop;

@end
