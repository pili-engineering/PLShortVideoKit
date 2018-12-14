//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMESTREAMER_H__
#define __EASYAR_FRAMESTREAMER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_FrameStreamer_peek(easyar_FrameStreamer * This, /* OUT */ easyar_Frame * * Return);
bool easyar_FrameStreamer_start(easyar_FrameStreamer * This);
bool easyar_FrameStreamer_stop(easyar_FrameStreamer * This);
void easyar_FrameStreamer__dtor(easyar_FrameStreamer * This);
void easyar_FrameStreamer__retain(const easyar_FrameStreamer * This, /* OUT */ easyar_FrameStreamer * * Return);
const char * easyar_FrameStreamer__typeName(const easyar_FrameStreamer * This);

void easyar_CameraFrameStreamer__ctor(/* OUT */ easyar_CameraFrameStreamer * * Return);
bool easyar_CameraFrameStreamer_attachCamera(easyar_CameraFrameStreamer * This, easyar_CameraDevice * obj);
void easyar_CameraFrameStreamer_peek(easyar_CameraFrameStreamer * This, /* OUT */ easyar_Frame * * Return);
bool easyar_CameraFrameStreamer_start(easyar_CameraFrameStreamer * This);
bool easyar_CameraFrameStreamer_stop(easyar_CameraFrameStreamer * This);
void easyar_CameraFrameStreamer__dtor(easyar_CameraFrameStreamer * This);
void easyar_CameraFrameStreamer__retain(const easyar_CameraFrameStreamer * This, /* OUT */ easyar_CameraFrameStreamer * * Return);
const char * easyar_CameraFrameStreamer__typeName(const easyar_CameraFrameStreamer * This);
void easyar_castCameraFrameStreamerToFrameStreamer(const easyar_CameraFrameStreamer * This, /* OUT */ easyar_FrameStreamer * * Return);
void easyar_tryCastFrameStreamerToCameraFrameStreamer(const easyar_FrameStreamer * This, /* OUT */ easyar_CameraFrameStreamer * * Return);

#ifdef __cplusplus
}
#endif

#endif
