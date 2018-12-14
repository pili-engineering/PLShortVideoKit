//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMEFILTER_H__
#define __EASYAR_FRAMEFILTER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

bool easyar_FrameFilter_attachStreamer(easyar_FrameFilter * This, easyar_FrameStreamer * obj);
bool easyar_FrameFilter_start(easyar_FrameFilter * This);
bool easyar_FrameFilter_stop(easyar_FrameFilter * This);
void easyar_FrameFilter__dtor(easyar_FrameFilter * This);
void easyar_FrameFilter__retain(const easyar_FrameFilter * This, /* OUT */ easyar_FrameFilter * * Return);
const char * easyar_FrameFilter__typeName(const easyar_FrameFilter * This);

#ifdef __cplusplus
}
#endif

#endif
