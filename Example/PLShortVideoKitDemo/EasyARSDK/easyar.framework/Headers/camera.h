//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CAMERA_H__
#define __EASYAR_CAMERA_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_CameraCalibration__ctor(/* OUT */ easyar_CameraCalibration * * Return);
easyar_Vec2I easyar_CameraCalibration_size(const easyar_CameraCalibration * This);
easyar_Vec2F easyar_CameraCalibration_focalLength(const easyar_CameraCalibration * This);
easyar_Vec2F easyar_CameraCalibration_principalPoint(const easyar_CameraCalibration * This);
easyar_Vec4F easyar_CameraCalibration_distortionParameters(const easyar_CameraCalibration * This);
int easyar_CameraCalibration_rotation(const easyar_CameraCalibration * This);
easyar_Matrix44F easyar_CameraCalibration_projectionGL(easyar_CameraCalibration * This, float nearPlane, float farPlane);
void easyar_CameraCalibration__dtor(easyar_CameraCalibration * This);
void easyar_CameraCalibration__retain(const easyar_CameraCalibration * This, /* OUT */ easyar_CameraCalibration * * Return);
const char * easyar_CameraCalibration__typeName(const easyar_CameraCalibration * This);

void easyar_CameraDevice__ctor(/* OUT */ easyar_CameraDevice * * Return);
bool easyar_CameraDevice_start(easyar_CameraDevice * This);
bool easyar_CameraDevice_stop(easyar_CameraDevice * This);
void easyar_CameraDevice_requestPermissions(easyar_CameraDevice * This, easyar_FunctorOfVoidFromPermissionStatusAndString permissionCallback);
bool easyar_CameraDevice_open(easyar_CameraDevice * This, int camera);
bool easyar_CameraDevice_close(easyar_CameraDevice * This);
bool easyar_CameraDevice_isOpened(easyar_CameraDevice * This);
void easyar_CameraDevice_setHorizontalFlip(easyar_CameraDevice * This, bool flip);
float easyar_CameraDevice_frameRate(const easyar_CameraDevice * This);
int easyar_CameraDevice_supportedFrameRateCount(const easyar_CameraDevice * This);
float easyar_CameraDevice_supportedFrameRate(const easyar_CameraDevice * This, int idx);
bool easyar_CameraDevice_setFrameRate(easyar_CameraDevice * This, float fps);
easyar_Vec2I easyar_CameraDevice_size(const easyar_CameraDevice * This);
int easyar_CameraDevice_supportedSizeCount(const easyar_CameraDevice * This);
easyar_Vec2I easyar_CameraDevice_supportedSize(const easyar_CameraDevice * This, int idx);
bool easyar_CameraDevice_setSize(easyar_CameraDevice * This, easyar_Vec2I size);
float easyar_CameraDevice_zoomScale(const easyar_CameraDevice * This);
void easyar_CameraDevice_setZoomScale(easyar_CameraDevice * This, float scale);
float easyar_CameraDevice_minZoomScale(const easyar_CameraDevice * This);
float easyar_CameraDevice_maxZoomScale(const easyar_CameraDevice * This);
void easyar_CameraDevice_cameraCalibration(const easyar_CameraDevice * This, /* OUT */ easyar_CameraCalibration * * Return);
bool easyar_CameraDevice_setFlashTorchMode(easyar_CameraDevice * This, bool on);
bool easyar_CameraDevice_setFocusMode(easyar_CameraDevice * This, easyar_CameraDeviceFocusMode focusMode);
easyar_Matrix44F easyar_CameraDevice_projectionGL(easyar_CameraDevice * This, float nearPlane, float farPlane);
void easyar_CameraDevice__dtor(easyar_CameraDevice * This);
void easyar_CameraDevice__retain(const easyar_CameraDevice * This, /* OUT */ easyar_CameraDevice * * Return);
const char * easyar_CameraDevice__typeName(const easyar_CameraDevice * This);

#ifdef __cplusplus
}
#endif

#endif
