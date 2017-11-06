//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_VideoPlayer : easyar_RefBase

+ (easyar_VideoPlayer *) create;
- (void)setVideoType:(easyar_VideoType)videoType;
- (void)setRenderTexture:(void *)texture;
- (void)open:(NSString *)path storageType:(easyar_StorageType)storageType callback:(void (^)(easyar_VideoStatus status))callback;
- (void)close;
- (bool)play;
- (bool)stop;
- (bool)pause;
- (bool)isRenderTextureAvailable;
- (void)updateFrame;
- (int)duration;
- (int)currentPosition;
- (bool)seek:(int)position;
- (easyar_Vec2I *)size;
- (float)volume;
- (bool)setVolume:(float)volume;

@end
