//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_CameraCalibration : easyar_RefBase

+ (easyar_CameraCalibration *) create;
- (easyar_Vec2I *)size;
- (easyar_Vec2F *)focalLength;
- (easyar_Vec2F *)principalPoint;
- (easyar_Vec4F *)distortionParameters;
- (int)rotation;
- (easyar_Matrix44F *)projectionGL:(float)nearPlane farPlane:(float)farPlane;

@end

@interface easyar_CameraDevice : easyar_RefBase

+ (easyar_CameraDevice *) create;
- (bool)start;
- (bool)stop;
- (void)requestPermissions:(void (^)(easyar_PermissionStatus status, NSString * value))permissionCallback;
- (bool)open:(int)camera;
- (bool)close;
- (bool)isOpened;
- (void)setHorizontalFlip:(bool)flip;
- (float)frameRate;
- (int)supportedFrameRateCount;
- (float)supportedFrameRate:(int)idx;
- (bool)setFrameRate:(float)fps;
- (easyar_Vec2I *)size;
- (int)supportedSizeCount;
- (easyar_Vec2I *)supportedSize:(int)idx;
- (bool)setSize:(easyar_Vec2I *)size;
- (float)zoomScale;
- (void)setZoomScale:(float)scale;
- (float)minZoomScale;
- (float)maxZoomScale;
- (easyar_CameraCalibration *)cameraCalibration;
- (bool)setFlashTorchMode:(bool)on;
- (bool)setFocusMode:(easyar_CameraDeviceFocusMode)focusMode;
- (easyar_Matrix44F *)projectionGL:(float)nearPlane farPlane:(float)farPlane;

@end
