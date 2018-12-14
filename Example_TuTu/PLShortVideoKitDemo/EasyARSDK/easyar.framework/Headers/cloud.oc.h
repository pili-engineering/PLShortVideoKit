//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/framefilter.oc.h"

@interface easyar_CloudRecognizer : easyar_FrameFilter

+ (easyar_CloudRecognizer *) create;
- (void)open:(NSString *)server appKey:(NSString *)appKey appSecret:(NSString *)appSecret callback_open:(void (^)(easyar_CloudStatus status))callback_open callback_recognize:(void (^)(easyar_CloudStatus status, NSArray<easyar_Target *> * targets))callback_recognize;
- (bool)close;
- (bool)attachStreamer:(easyar_FrameStreamer *)obj;
- (bool)start;
- (bool)stop;

@end
